class File {
  File(String path);

  Future<File> writeAsBytes(List<int> bytes, {bool flush = false}) async {
    throw UnsupportedError('File operations are not supported on the web.');
  }

  String get path =>
      throw UnsupportedError('File paths are not available on the web.');
}
