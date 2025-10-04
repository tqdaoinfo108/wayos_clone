class LocationSnapshot {
  const LocationSnapshot({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
}

String formatCoordinates(LocationSnapshot snapshot) {
  return 'Tọa độ: ${snapshot.latitude.toStringAsFixed(6)}, ${snapshot.longitude.toStringAsFixed(6)}';
}
