import 'package:flutter/material.dart';

import 'attachment_file_model.dart';

class RequestInformationRecordItem {
  final String label;
  final String value;
  final Widget? suffix;
  final List<AttachmentFileModel>? files;

  RequestInformationRecordItem(
      {required this.label, required this.value, this.suffix, this.files});
}
