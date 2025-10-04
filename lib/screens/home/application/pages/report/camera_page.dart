import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../service/bill_tracking/bill_tracking_service.dart';
import '../../../../../utils/location/location_cache.dart';
import '../../../../../utils/location/location_provider.dart';
import '../../../../../utils/location/location_snapshot.dart';

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({required this.title, super.key});
  final String title;
  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  double _currentZoom = 1.0;
  double _baseZoom = 1.0;
  CameraController? _controller;
  List<CameraDescription> _availableCameras = [];
  int _selectedCameraIndex = 0;
  Future<void>? _initializeControllerFuture;
  File? _image;
  Uint8List? _imageBytes; // For web
  String _location = 'Đang lấy vị trí...';
  String _time = '';
  bool _isInitialized = false;
  bool _isProcessing = false;
  bool _isLoadingLocation = true;
  String? _cameraErrorMessage;
  final GlobalKey _previewContainerKey = GlobalKey();

  bool get _hasCapturedImage => kIsWeb ? _imageBytes != null : _image != null;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeLocationAndTime(); // Khởi tạo song song
  }

  // Khởi tạo vị trí và thời gian ngay lập tức
  Future<void> _initializeLocationAndTime() async {
    // Set thời gian ngay lập tức
    setState(() {
      _time = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
    });

    final cachedLocation = await readCachedLocation();
    final cachedTime = await readCachedTimestamp();

    if (cachedLocation != null &&
        cachedTime != null &&
        DateTime.now().difference(cachedTime).inMinutes < 10) {
      if (mounted) {
        setState(() {
          _location = cachedLocation;
          _isLoadingLocation = false;
        });
      }
      // Vẫn refresh vị trí ở background
      unawaited(_refreshLocationInBackground());
    } else {
      // Không có cache hoặc cache cũ, lấy vị trí mới
      unawaited(_getLocation());
    }
  }

  // Refresh vị trí trong background mà không làm gián đoạn UI
  Future<void> _refreshLocationInBackground() async {
    try {
      if (!locationServiceSupported()) {
        return;
      }

      if (!await ensureLocationPermission()) {
        return;
      }

      final snapshot = await getCurrentPosition(
        timeout: const Duration(seconds: 5),
      );

      final address = await resolveAddress(snapshot);
      final resolvedAddress =
          address.isEmpty ? formatCoordinates(snapshot) : address;

      if (resolvedAddress.isNotEmpty && mounted) {
        final now = DateTime.now();
        setState(() {
          _location = resolvedAddress;
        });
        await writeCachedLocation(resolvedAddress, now);
      }
    } catch (e) {
      // Không làm gì, giữ nguyên location cache
      debugPrint('Background location refresh failed: $e');
    }
  }

  Future<Uint8List> _composeImageWithOverlay(Uint8List baseBytes) async {
    final codec = await ui.instantiateImageCodec(baseBytes);
    final frame = await codec.getNextFrame();
    final originalImage = frame.image;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final Size size = Size(
      originalImage.width.toDouble(),
      originalImage.height.toDouble(),
    );

    canvas.drawImage(originalImage, Offset.zero, Paint());

    double clampFont(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final double titleFontSize = clampFont(size.width * 0.05, 28, 64);
    final double timeFontSize = clampFont(size.width * 0.042, 24, 48);
    final double locationFontSize = clampFont(size.width * 0.036, 20, 40);

    final double overlayHeight = size.height * 0.28;
    final Rect overlayRect = Rect.fromLTWH(
      0,
      size.height - overlayHeight,
      size.width,
      overlayHeight,
    );

    final Paint overlayPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, size.height),
        Offset(0, size.height - overlayHeight),
        const [
          Color(0xBF000000),
          Color(0x66000000),
          Colors.transparent,
        ],
        const [0.0, 0.7, 1.0],
      );

    canvas.drawRect(overlayRect, overlayPaint);

    final double horizontalPadding = size.width * 0.05;
    double textY = overlayRect.top + horizontalPadding;

    void drawText(
      String text,
      TextStyle style, {
      int maxLines = 2,
    }) {
      final textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: maxLines,
        ellipsis: '…',
      );
      textPainter.layout(maxWidth: size.width - (horizontalPadding * 2));
      textPainter.paint(canvas, Offset(horizontalPadding, textY));
      textY += textPainter.height + 8;
    }

    drawText(
      _getCleanTitle(),
      TextStyle(
        color: Colors.white,
        fontSize: titleFontSize,
        fontWeight: FontWeight.w700,
        shadows: const [
          Shadow(
            offset: Offset(2, 2),
            blurRadius: 6,
            color: Colors.black87,
          ),
        ],
      ),
    );

    drawText(
      _time,
      TextStyle(
        color: Colors.white,
        fontSize: timeFontSize,
        fontWeight: FontWeight.w500,
        shadows: const [
          Shadow(
            offset: Offset(2, 2),
            blurRadius: 6,
            color: Colors.black87,
          ),
        ],
      ),
      maxLines: 1,
    );

    drawText(
      _location,
      TextStyle(
        color: _isLoadingLocation ? Colors.orange[200] : Colors.white,
        fontSize: locationFontSize,
        fontWeight: FontWeight.w500,
        shadows: const [
          Shadow(
            offset: Offset(2, 2),
            blurRadius: 6,
            color: Colors.black87,
          ),
        ],
      ),
      maxLines: 3,
    );

    final picture = recorder.endRecording();
    final ui.Image finalImage = await picture.toImage(
      originalImage.width,
      originalImage.height,
    );

    final byteData = await finalImage.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw Exception('Không thể xử lý hình ảnh');
    }

    originalImage.dispose();
    finalImage.dispose();

    return byteData.buffer.asUint8List();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();

      if (!mounted) {
        return;
      }

      if (cameras.isEmpty) {
        setState(() {
          _cameraErrorMessage = 'Không tìm thấy camera';
          _isInitialized = false;
          _availableCameras = [];
        });
        return;
      }

      final int backCameraIndex = cameras.indexWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
      );

      setState(() {
        _availableCameras = cameras;
      });

      final initialIndex = backCameraIndex >= 0 ? backCameraIndex : 0;

      await _setupCameraController(initialIndex);
    } catch (e) {
      if (mounted) {
        setState(() {
          _cameraErrorMessage = 'Lỗi khi khởi tạo camera: $e';
          _isInitialized = false;
        });
      }
    }
  }

  Future<void> _setupCameraController(int cameraIndex) async {
    if (cameraIndex < 0 || cameraIndex >= _availableCameras.length) {
      return;
    }

    final previousController = _controller;
    _controller = null;
    await previousController?.dispose();

    CameraController? controller;

    try {
      final selectedCamera = _availableCameras[cameraIndex];
      controller = kIsWeb
          ? CameraController(
              selectedCamera,
              ResolutionPreset.high,
              enableAudio: false,
            )
          : CameraController(
              selectedCamera,
              ResolutionPreset.high,
              enableAudio: false,
              imageFormatGroup: ImageFormatGroup.jpeg,
            );

      final initializeFuture = controller.initialize();

      if (mounted) {
        setState(() {
          _controller = controller;
          _initializeControllerFuture = initializeFuture;
          _selectedCameraIndex = cameraIndex;
          _isInitialized = false;
          _cameraErrorMessage = null;
        });
      }

      await initializeFuture;

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      await controller?.dispose();
      if (mounted) {
        setState(() {
          _cameraErrorMessage = 'Lỗi khi khởi tạo camera: $e';
          _controller = null;
          _initializeControllerFuture = null;
          _isInitialized = false;
        });
      }
    }
  }

  Future<void> _switchCamera() async {
    if (_availableCameras.length < 2 || _isProcessing) {
      return;
    }

    final nextIndex = (_selectedCameraIndex + 1) % _availableCameras.length;
    setState(() {
      _image = null;
      _imageBytes = null;
    });
    await _setupCameraController(nextIndex);
  }

  Future<void> _getLocation() async {
    try {
      setState(() => _isLoadingLocation = true);
      
      if (!locationServiceSupported()) {
        if (mounted) {
          setState(() {
            _location = 'Thiết bị không hỗ trợ định vị';
            _isLoadingLocation = false;
          });
        }
        return;
      }

      if (!await ensureLocationPermission()) {
        if (mounted) {
          setState(() {
            _location = 'Quyền vị trí bị từ chối';
            _isLoadingLocation = false;
          });
        }
        return;
      }

      final snapshot = await getCurrentPosition(
        timeout: const Duration(seconds: 10),
      );

      final address = await resolveAddress(snapshot);
      final resolvedLocation =
          address.isEmpty ? formatCoordinates(snapshot) : address;

      final now = DateTime.now();
      if (mounted) {
        setState(() {
          _location = resolvedLocation;
          _isLoadingLocation = false;
        });
      }

      await writeCachedLocation(resolvedLocation, now);
    } catch (e) {
      if (mounted) {
        setState(() {
          _location = 'Không thể lấy vị trí. Vui lòng kiểm tra quyền truy cập.';
          _isLoadingLocation = false;
        });
      }
      debugPrint('Get location failed: $e');
    }
  }

  Future<void> _takePhoto() async {
    if (_isProcessing || _controller == null || _initializeControllerFuture == null) {
      return;
    }

    final captureTime = DateTime.now();

    setState(() {
      _isProcessing = true;
      _time = DateFormat('dd/MM/yyyy HH:mm:ss').format(captureTime);
    });

    try {
      await _initializeControllerFuture!;
      final XFile capturedFile = await _controller!.takePicture();

      if (!kIsWeb && _controller!.value.flashMode != FlashMode.off) {
        await _controller!.setFlashMode(FlashMode.off);
      }

      if (kIsWeb) {
        final rawBytes = await capturedFile.readAsBytes();
        final Uint8List compositedBytes = await _composeImageWithOverlay(rawBytes);

        if (mounted) {
          setState(() {
            _imageBytes = compositedBytes;
            _image = null;
            _isProcessing = false;
          });
        }
      } else {
        await Future.delayed(const Duration(milliseconds: 100));

        final renderObject = _previewContainerKey.currentContext?.findRenderObject();
        if (renderObject is! RenderRepaintBoundary) {
          throw Exception('Không thể truy cập camera preview');
        }

        final ui.Image renderedImage = await renderObject.toImage(pixelRatio: 3.0);
        final ByteData? byteData =
            await renderedImage.toByteData(format: ui.ImageByteFormat.png);

        if (byteData == null) {
          throw Exception('Không thể tạo byte dữ liệu ảnh');
        }

        final Uint8List pngBytes = byteData.buffer.asUint8List();

        final tempDir = await getTemporaryDirectory();
        final String tempPath =
            '${tempDir.path}/marked_image_${DateTime.now().millisecondsSinceEpoch}.png';
        final File finalFile = File(tempPath);
        await finalFile.writeAsBytes(pngBytes);

        if (mounted) {
          setState(() {
            _image = finalFile;
            _imageBytes = null;
            _isProcessing = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi chụp ảnh: $e')),
        );
      }
    }
  }

  Future<void> _saveImageToGallery() async {
    if (kIsWeb) {
      if (_imageBytes == null) return;
      final result = await BillRequestService().uploadFileHttpBytes(
        bytes: _imageBytes!,
        filename: 'camera_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      if (result != null && result['publicPath'] != null) {
        Navigator.pop(context, {
          'publicPath': result['publicPath'],
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Upload file thất bại!')),
          );
        }
      }
    } else {
      if (_image == null) return;
      final result = await BillRequestService().uploadFileHttp(file: _image!);
      if (result != null && result['publicPath'] != null) {
        Navigator.pop(context, {
          'file': _image,
          'publicPath': result['publicPath'],
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Upload file thất bại!')),
          );
        }
      }
    }
  }

  Widget _buildCamera() {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (_cameraErrorMessage != null) {
            return Center(
              child: Text(
                _cameraErrorMessage!,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (_isInitialized && _controller != null) {
            return GestureDetector(
              onScaleStart: (details) {
                if (kIsWeb || _controller == null) {
                  return;
                }
                _baseZoom = _currentZoom;
              },
              onScaleUpdate: (details) async {
                if (kIsWeb || _controller == null || !_controller!.value.isInitialized) {
                  return;
                }
                if (details.scale == 1.0) {
                  return;
                }

                double minZoom = await _controller!.getMinZoomLevel();
                double maxZoom = await _controller!.getMaxZoomLevel();
                double newZoom = (_baseZoom * details.scale).clamp(minZoom, maxZoom);
                setState(() {
                  _currentZoom = newZoom;
                });
                await _controller!.setZoomLevel(_currentZoom);
              },
              child: ClipRect(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Builder(
                    builder: (context) {
                      final previewSize = _controller!.value.previewSize;
                      final preview = CameraPreview(_controller!);

                      if (previewSize == null) {
                        return SizedBox.expand(child: preview);
                      }

                      return SizedBox(
                        width: previewSize.height,
                        height: previewSize.width,
                        child: preview,
                      );
                    },
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: Text(
                'Không thể khởi tạo camera',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // Hàm xử lý title để loại bỏ prefix không cần thiết
  String _getCleanTitle() {
    String cleanTitle = widget.title;
    
    // Xóa các prefix không cần thiết
    final prefixesToRemove = [
      'Cập nhật ảnh vào - ',
      'Cập nhật ảnh ra - ',
      'Cập nhật hình ảnh vào - ',
      'Cập nhật hình ảnh ra - ',
    ];
    
    for (final prefix in prefixesToRemove) {
      if (cleanTitle.startsWith(prefix)) {
        cleanTitle = cleanTitle.substring(prefix.length);
        break;
      }
    }
    
    return cleanTitle;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Chụp ảnh',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_availableCameras.length > 1)
            IconButton(
              onPressed: _isProcessing ? null : _switchCamera,
              icon: const Icon(Icons.cameraswitch, color: Colors.white, size: 28),
              tooltip: 'Đổi camera',
            ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Camera/Image preview - FULL SCREEN
            Positioned.fill(
              child: RepaintBoundary(
                key: _previewContainerKey,
                child: Stack(
                  children: [
                    // Camera hoặc Image
                    Positioned.fill(
                      child: _image != null
                          ? Image.file(
                              _image!,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: double.infinity,
                            )
                          : _imageBytes != null
                              ? Image.memory(
                                  _imageBytes!,
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  height: double.infinity,
                                )
                              : _buildCamera(),
                    ),
                    
                    // Overlay thông tin LÊN TRÊN ảnh (sẽ được capture)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.75),
                              Colors.black.withOpacity(0.4),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.7, 1.0],
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Tên công việc
                            Row(
                              children: [
                                const Icon(Icons.work_outline, color: Colors.white, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _getCleanTitle(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(1, 1),
                                          blurRadius: 3,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            
                            // Ngày giờ
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, color: Colors.white70, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  _time,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(1, 1),
                                        blurRadius: 3,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            
                            // Vị trí
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  _isLoadingLocation ? Icons.location_searching : Icons.location_on,
                                  color: _isLoadingLocation ? Colors.orange : Colors.white70,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _location,
                                    style: TextStyle(
                                      color: _isLoadingLocation ? Colors.orange : Colors.white,
                                      fontSize: 13,
                                      shadows: const [
                                        Shadow(
                                          offset: Offset(1, 1),
                                          blurRadius: 3,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Nút điều khiển - BÊN NGOÀI RepaintBoundary (không capture)
            if (_hasCapturedImage || _isInitialized)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: _isProcessing
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: _buildControlButton(
                              icon: _hasCapturedImage ? Icons.refresh : Icons.camera_alt,
                              label: _hasCapturedImage ? 'Chụp lại' : 'Chụp',
                              color: _hasCapturedImage ? Colors.orange : Colors.blue,
                              onPressed: _hasCapturedImage
                                  ? () {
                                      setState(() {
                                        _image = null;
                                        _imageBytes = null;
                                        _time = DateFormat('dd/MM/yyyy HH:mm:ss')
                                            .format(DateTime.now());
                                      });
                                      _refreshLocationInBackground();
                                    }
                                  : (_isLoadingLocation ? null : _takePhoto),
                            ),
                          ),

                          if (_hasCapturedImage) ...[
                            const SizedBox(width: 16),
                            Flexible(
                              child: _buildControlButton(
                                icon: Icons.check,
                                label: 'Lưu',
                                color: Colors.green,
                                onPressed: _isProcessing ? null : _saveImageToGallery,
                              ),
                            ),
                          ],
                        ],
                      ),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    final baseStyle = ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 8,
      shadowColor: color.withOpacity(0.5),
    );

    return ElevatedButton(
      onPressed: onPressed,
      style: baseStyle.copyWith(
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(MaterialState.disabled)) {
              return color.withOpacity(0.5);
            }
            return color;
          },
        ),
        foregroundColor: MaterialStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.white.withOpacity(0.7);
            }
            return Colors.white;
          },
        ),
        shadowColor: MaterialStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.transparent;
            }
            return color.withOpacity(0.5);
          },
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
