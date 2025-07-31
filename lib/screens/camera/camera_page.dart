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

import '../../service/bill_tracking/bill_tracking_service.dart';

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({required this.title, super.key});
  final String title;
  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  File? _image;
  String _location = 'Đang lấy vị trí...';
  String _time = '';
  bool _isInitialized = false;
  bool _isProcessing = false;
  final GlobalKey _previewContainerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _getLocation();
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
        ResolutionPreset.medium,
        enableAudio: false,
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
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) setState(() => _location = 'Quyền vị trí bị từ chối');
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks[0];
      String address = [
        place.street,
        place.subLocality,
        place.locality,
        place.administrativeArea,
        place.country
      ].where((e) => e != null && e.isNotEmpty).join(', ');

      if (mounted) {
        setState(() {
          _location = address.isEmpty ? 'Không xác định vị trí' : address;
          _time = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _location = 'Lỗi khi lấy vị trí: $e');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chụp ảnh giao việc'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Camera + overlay info (RepaintBoundary)
            Expanded(
              child: RepaintBoundary(
                key: _previewContainerKey,
                child: _image != null
                    ? Image.file(_image!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity)
                    : FutureBuilder<void>(
                        future: _initializeControllerFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (_isInitialized) {
                              return Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  CameraPreview(_controller!),
                                  Container(
                                    width: double.infinity,
                                    color: Colors.black54,
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          _time,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          widget.title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _location,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
                                child: CircularProgressIndicator());
                          }
                        },
                      ),
              ),
            ),
            // Nút chức năng luôn ở dưới cùng
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: _isProcessing
                  ? const Center(child: CircularProgressIndicator())
                  : Wrap(
                      spacing: 16.0,
                      runSpacing: 8.0,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _image == null
                              ? _takePhoto
                              : () {
                                  setState(() {
                                    _image = null;
                                    _time = DateFormat('dd/MM/yyyy HH:mm:ss')
                                        .format(DateTime.now());
                                    _getLocation();
                                  });
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _image == null ? Colors.blue : Colors.green,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            minimumSize: const Size(140, 48),
                          ),
                          icon: Icon(_image == null
                              ? Icons.camera_alt
                              : Icons.refresh),
                          label: Text(_image == null ? 'Chụp ảnh' : 'Chụp lại'),
                        ),
                        if (_image != null)
                          ElevatedButton.icon(
                            onPressed: _saveImageToGallery,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              minimumSize: const Size(140, 48),
                            ),
                            icon: const Icon(Icons.save),
                            label: const Text('Lưu ảnh'),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
