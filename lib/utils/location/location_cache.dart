import 'location_cache_io.dart'
    if (dart.library.js_interop) 'location_cache_web.dart';

Future<String?> readCachedLocation() => readCachedLocationImpl();

Future<DateTime?> readCachedTimestamp() => readCachedTimestampImpl();

Future<void> writeCachedLocation(String location, DateTime timestamp) =>
    writeCachedLocationImpl(location, timestamp);
