import 'package:flutter/material.dart';

import 'attachment_file_model.dart';

class RequestInformationItemModel {
  final String label;
  final String? value;
  final Widget? suffix;
  final List<AttachmentFileModel>? files;

  RequestInformationItemModel(
      {required this.label, this.value, this.suffix, this.files});
}
