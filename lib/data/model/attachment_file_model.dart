class AttachmentFileModel {
  final String fileName;
  final String filePath;

  AttachmentFileModel({required this.fileName, required this.filePath});

  factory AttachmentFileModel.fromMap(Map<String, dynamic> json) =>
      AttachmentFileModel(
        fileName: json['FileName'],
        filePath: json['FilePath'],
      );
}
