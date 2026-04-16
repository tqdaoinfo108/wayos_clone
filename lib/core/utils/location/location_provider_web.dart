import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'location_snapshot.dart';

Future<bool> ensureLocationPermissionImpl() async {
  return locationServiceSupportedImpl();
}

Future<LocationSnapshot> getCurrentPositionImpl({
  Duration timeout = const Duration(seconds: 10),
}) async {
  final geolocation = web.window.navigator.geolocation;
  if (geolocation == null) {
    throw Exception('Trình duyệt không hỗ trợ geolocation');
  }

  final completer = Completer<LocationSnapshot>();

  void success(web.GeolocationPosition position) {
    final coords = position.coords;
    if (coords.latitude != null && coords.longitude != null) {
      completer.complete(
        LocationSnapshot(
          latitude: coords.latitude!,
          longitude: coords.longitude!,
        ),
      );
    } else {
      completer.completeError(
        Exception('Không nhận được toạ độ từ trình duyệt'),
      );
    }
  }

  void error(web.GeolocationPositionError error) {
    final message = error.message ?? 'Lỗi geolocation (mã ${error.code})';
    completer.completeError(Exception(message));
  }

  geolocation.getCurrentPosition(
    success.toJS,
    error.toJS,
  );

  return completer.future.timeout(
    timeout,
    onTimeout: () => throw Exception('Timeout khi lấy vị trí'),
  );
}

Future<String> resolveAddressImpl(LocationSnapshot snapshot) async {
  return formatCoordinates(snapshot);
}

bool locationServiceSupportedImpl() =>
    web.window.navigator.geolocation != null;
