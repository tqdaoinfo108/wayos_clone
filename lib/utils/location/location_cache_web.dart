import 'dart:async';

import 'package:web/web.dart' as web;

Future<String?> readCachedLocationImpl() async {
  final storage = web.window.localStorage;
  return storage['cached_location'];
}

Future<DateTime?> readCachedTimestampImpl() async {
  final storage = web.window.localStorage;
  final value = storage['cached_location_time'];
  if (value == null) {
    return null;
  }
  return DateTime.tryParse(value);
}

Future<void> writeCachedLocationImpl(String location, DateTime timestamp) async {
  final storage = web.window.localStorage;
  storage['cached_location'] = location;
  storage['cached_location_time'] = timestamp.toIso8601String();
}
