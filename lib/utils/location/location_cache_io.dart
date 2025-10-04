import 'package:get_storage/get_storage.dart';

final GetStorage _box = GetStorage();

Future<String?> readCachedLocationImpl() async {
  return _box.read<String>('cached_location');
}

Future<DateTime?> readCachedTimestampImpl() async {
  final timeString = _box.read<String>('cached_location_time');
  if (timeString == null) {
    return null;
  }
  return DateTime.tryParse(timeString);
}

Future<void> writeCachedLocationImpl(String location, DateTime timestamp) async {
  await _box.write('cached_location', location);
  await _box.write('cached_location_time', timestamp.toIso8601String());
}
