class AttachmentFile {
  final String fileName;
  final String filePath;

  AttachmentFile({required this.fileName, required this.filePath});

  factory AttachmentFile.fromMap(Map<String, dynamic> json) => AttachmentFile(
        fileName: json['FileName'],
        filePath: json['FilePath'],
      );
}
