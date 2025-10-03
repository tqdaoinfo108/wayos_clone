import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../../service/bill_tracking/bill_tracking_service.dart';

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({required this.title, super.key});
  final String title;
  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  double _currentZoom = 1.0;
  double _baseZoom = 1.0;
  final box = GetStorage();

  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  File? _image;
  String _location = 'Đang lấy vị trí...';
  String _time = '';
  bool _isInitialized = false;
  bool _isProcessing = false;
  bool _isLoadingLocation = true;
  final GlobalKey _previewContainerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeLocationAndTime(); // Khởi tạo song song
  }

  // Khởi tạo vị trí và thời gian ngay lập tức
  void _initializeLocationAndTime() {
    // Set thời gian ngay lập tức
    setState(() {
      _time = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
    });

    // Thử load từ cache trước
    final cachedLocation = box.read<String>('cached_location');
    final cachedTimeStr = box.read<String>('cached_location_time');
    DateTime? cachedTime = cachedTimeStr != null ? DateTime.tryParse(cachedTimeStr) : null;

    // Nếu có cache và còn mới (trong vòng 10 phút)
    if (cachedLocation != null && 
        cachedTime != null && 
        DateTime.now().difference(cachedTime).inMinutes < 10) {
      setState(() {
        _location = cachedLocation;
        _isLoadingLocation = false;
      });
      // Vẫn refresh vị trí ở background
      _refreshLocationInBackground();
    } else {
      // Không có cache hoặc cache cũ, lấy vị trí mới
      _getLocation();
    }
  }

  // Refresh vị trí trong background mà không làm gián đoạn UI
  Future<void> _refreshLocationInBackground() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || 
          permission == LocationPermission.deniedForever) {
        return; // Không làm gì nếu không có quyền
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium, // Dùng medium cho nhanh hơn
        timeLimit: const Duration(seconds: 5), // Giới hạn thời gian
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw Exception('Timeout'),
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      ).timeout(
        const Duration(seconds: 3),
        onTimeout: () => throw Exception('Timeout'),
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
        ].where((e) => e != null && e.isNotEmpty).join(', ');

        if (address.isNotEmpty && mounted) {
          final now = DateTime.now();
          setState(() {
            _location = address;
          });
          // Cập nhật cache
          box.write('cached_location', address);
          box.write('cached_location_time', now.toIso8601String());
        }
      }
    } catch (e) {
      // Không làm gì, giữ nguyên location cache
      print('Background location refresh failed: $e');
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) setState(() => _location = 'Không tìm thấy camera');
        return;
      }

      final firstCamera = cameras.first;
      _controller = CameraController(
        firstCamera,
        ResolutionPreset.high, // Dùng high cho chất lượng tốt hơn
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg, // JPEG nhẹ hơn
      );
      
      _initializeControllerFuture = _controller!.initialize();
      await _initializeControllerFuture;

      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _location = 'Lỗi khi khởi tạo camera: $e');
      }
    }
  }

  Future<void> _getLocation() async {
    try {
      setState(() => _isLoadingLocation = true);
      
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            setState(() {
              _location = 'Quyền vị trí bị từ chối';
              _isLoadingLocation = false;
            });
          }
          return;
        }
      }

      // Sử dụng medium accuracy để nhanh hơn
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 10),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Timeout khi lấy vị trí');
        },
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw Exception('Timeout'),
      );

      Placemark place = placemarks[0];
      String address = [
        place.street,
        place.subLocality,
        place.locality,
        place.administrativeArea,
      ].where((e) => e != null && e.isNotEmpty).join(', ');

      final now = DateTime.now();
      if (mounted) {
        setState(() {
          _location = address.isEmpty ? 'Không xác định vị trí' : address;
          _isLoadingLocation = false;
        });
      }
      
      // Lưu cache
      box.write('cached_location', _location);
      box.write('cached_location_time', now.toIso8601String());
    } catch (e) {
      if (mounted) {
        setState(() {
          _location = 'Lỗi khi lấy vị trí: $e';
          _isLoadingLocation = false;
        });
      }
    }
  }

  Future<void> _takePhoto() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    try {
      await _initializeControllerFuture!;
      await _controller!.takePicture();
      await _controller!.setFlashMode(FlashMode.off);
      await Future.delayed(const Duration(milliseconds: 100));

      RenderRepaintBoundary boundary = _previewContainerKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      final ui.Image renderedImage = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await renderedImage.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) throw Exception('Không thể tạo byte dữ liệu ảnh');

      final Uint8List pngBytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final String tempPath =
          '${tempDir.path}/marked_image_${DateTime.now().millisecondsSinceEpoch}.png';
      final File finalFile = File(tempPath);
      await finalFile.writeAsBytes(pngBytes);

      if (mounted) {
        setState(() {
          _image = finalFile;
          _isProcessing = false;
        });
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
                          : FutureBuilder<void>(
                              future: _initializeControllerFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done) {
                                  if (_isInitialized && _controller != null) {
                                    return GestureDetector(
                                      onScaleStart: (details) {
                                        _baseZoom = _currentZoom;
                                      },
                                      onScaleUpdate: (details) async {
                                        if (_controller != null && details.scale != 1.0) {
                                          double minZoom = await _controller!.getMinZoomLevel();
                                          double maxZoom = await _controller!.getMaxZoomLevel();
                                          double newZoom = (_baseZoom * details.scale).clamp(minZoom, maxZoom);
                                          setState(() {
                                            _currentZoom = newZoom;
                                          });
                                          await _controller!.setZoomLevel(_currentZoom);
                                        }
                                      },
                                      child: ClipRect(
                                        child: FittedBox(
                                          fit: BoxFit.cover,
                                          child: SizedBox(
                                            width: _controller!.value.previewSize!.height,
                                            height: _controller!.value.previewSize!.width,
                                            child: CameraPreview(_controller!),
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
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  );
                                }
                              },
                            ),
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
            if (_image != null || _isInitialized)
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
                          // Nút chụp/chụp lại
                          if (_location != 'Đang lấy vị trí...')
                            Flexible(
                              child: _buildControlButton(
                                icon: _image == null ? Icons.camera_alt : Icons.refresh,
                                label: _image == null ? 'Chụp' : 'Chụp lại',
                                color: _image == null ? Colors.blue : Colors.orange,
                                onPressed: _image == null
                                    ? _takePhoto
                                    : () {
                                        setState(() {
                                          _image = null;
                                          _time = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
                                        });
                                      },
                              ),
                            ),
                          
                          // Spacing giữa 2 button
                          if (_image != null && _location != 'Đang lấy vị trí...')
                            const SizedBox(width: 16),
                          
                          // Nút lưu
                          if (_image != null)
                            Flexible(
                              child: _buildControlButton(
                                icon: Icons.check,
                                label: 'Lưu',
                                color: Colors.green,
                                onPressed: _saveImageToGallery,
                              ),
                            ),
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
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 8,
        shadowColor: color.withOpacity(0.5),
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
