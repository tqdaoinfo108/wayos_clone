import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'dart:async';

class CameraWebHelper {
  static html.VideoElement? _videoElement;
  static html.MediaStream? _stream;
  static bool _isRegistered = false;

  static Future<void> initializeWebCamera() async {
    try {
      // Create video element
      _videoElement = html.VideoElement()
        ..autoplay = true
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'cover';

      // Register view factory only once
      if (!_isRegistered) {
        // ignore: undefined_prefixed_name
        ui_web.platformViewRegistry.registerViewFactory(
          'camera-video',
          (int viewId) => _videoElement!,
        );
        _isRegistered = true;
      }

      // Get user media
      _stream = await html.window.navigator.mediaDevices!.getUserMedia({
        'video': {
          'facingMode': 'environment', // Back camera
          'width': {'ideal': 1920},
          'height': {'ideal': 1080},
        }
      });

      _videoElement!.srcObject = _stream;
      await _videoElement!.play();
    } catch (e) {
      throw Exception('Không thể khởi tạo camera: $e');
    }
  }

  static Future<String> getWebLocation() async {
    try {
      final completer = Completer<html.Geoposition>();
      
      html.window.navigator.geolocation.getCurrentPosition()
        .then((position) => completer.complete(position))
        .catchError((error) => completer.completeError(error));

      final position = await completer.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Timeout'),
      );
      
      final coords = position.coords!;
      
      // Use Nominatim for reverse geocoding
      try {
        await html.HttpRequest.getString(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=${coords.latitude}&lon=${coords.longitude}',
        );
        
        // For simplicity, return coordinates
        return 'Lat: ${coords.latitude!.toStringAsFixed(6)}, Lon: ${coords.longitude!.toStringAsFixed(6)}';
      } catch (e) {
        return 'Lat: ${coords.latitude!.toStringAsFixed(6)}, Lon: ${coords.longitude!.toStringAsFixed(6)}';
      }
    } catch (e) {
      return 'Không thể lấy vị trí: $e';
    }
  }

  static void dispose() {
    if (_stream != null) {
      _stream!.getTracks().forEach((track) => track.stop());
      _stream = null;
    }
    if (_videoElement != null) {
      _videoElement!.srcObject = null;
      _videoElement = null;
    }
  }

  static html.VideoElement? get videoElement => _videoElement;
}
