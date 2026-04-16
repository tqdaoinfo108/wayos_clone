import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart' as geo;

import 'location_snapshot.dart';

Future<bool> ensureLocationPermissionImpl() async {
  bool serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return false;
  }

  geo.LocationPermission permission = await geo.Geolocator.checkPermission();
  if (permission == geo.LocationPermission.denied) {
    permission = await geo.Geolocator.requestPermission();
  }

  if (permission == geo.LocationPermission.denied ||
      permission == geo.LocationPermission.deniedForever) {
    return false;
  }

  return true;
}

Future<LocationSnapshot> getCurrentPositionImpl({
  Duration timeout = const Duration(seconds: 10),
}) async {
  final position = await geo.Geolocator.getCurrentPosition(
    desiredAccuracy: geo.LocationAccuracy.medium,
    timeLimit: timeout,
  ).timeout(
    timeout,
    onTimeout: () => throw Exception('Timeout khi lấy vị trí'),
  );

  return LocationSnapshot(
    latitude: position.latitude,
    longitude: position.longitude,
  );
}

Future<String> resolveAddressImpl(LocationSnapshot snapshot) async {
  final placemarks = await placemarkFromCoordinates(
    snapshot.latitude,
    snapshot.longitude,
  ).timeout(
    const Duration(seconds: 5),
    onTimeout: () => throw Exception('Timeout'),
  );

  if (placemarks.isNotEmpty) {
    final place = placemarks.first;
    final address = [
      place.street,
      place.subLocality,
      place.locality,
      place.administrativeArea,
    ].where((e) => e != null && e.isNotEmpty).join(', ');

    if (address.isNotEmpty) {
      return address;
    }
  }

  return formatCoordinates(snapshot);
}

bool locationServiceSupportedImpl() => true;
