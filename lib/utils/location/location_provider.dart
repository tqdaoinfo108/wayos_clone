import 'location_snapshot.dart';
import 'location_provider_io.dart'
    if (dart.library.js_interop) 'location_provider_web.dart';

Future<bool> ensureLocationPermission() => ensureLocationPermissionImpl();

Future<LocationSnapshot> getCurrentPosition({
  Duration timeout = const Duration(seconds: 10),
}) =>
    getCurrentPositionImpl(timeout: timeout);

Future<String> resolveAddress(LocationSnapshot snapshot) =>
    resolveAddressImpl(snapshot);

bool locationServiceSupported() => locationServiceSupportedImpl();
