import 'package:flutter/material.dart';
import 'package:wayos_clone/route/route_constants.dart';

import '../../../../../../model/attachment_file_model.dart';
import '../../../../../../model/request_information_record_item.dart';
import '../../../../../../model/workflow_request_information_model.dart';
import '../../../../../../utils/constants.dart';
import 'request_information_item.dart';

class RequestInformation extends StatelessWidget {
  final WorkflowRequestInformationModel model;
  final List<AttachmentFileModel> files;
  final ValueChanged<AttachmentFileModel> onDownload;

  const RequestInformation({
    super.key,
    required this.model,
    required this.files,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: blackColor,
          ),
          bodyMedium: TextStyle(
            color: blackColor,
          ),
        ),
      ),
      child: Column(
        spacing: 15,
        children: [
          RequestInformationItem(title: "Tên đề xuất", data: model.title),
          RequestInformationItem(
            title: "Biểu mẫu",
            data: model.typeWorkFlowName,
            suffixIcon: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, PREVIEW_WORKFLOW_PAGE_ROUTE,
                    arguments: model);
              },
              icon: Image.asset(
                "assets/images/ic_goto.png",
                scale: 1.6,
              ),
            ),
          ),
          RequestInformationItem(title: "Ngày tạo", data: model.dateCreated),
          RequestInformationItem(
              title: "Người đề xuất", data: model.userCreated),
          RequestInformationItem(
              title: "Phòng ban", data: model.departmentUserRequirement),
          RequestInformationItem(
              title: "Tệp đính kèm",
              child: files.isEmpty
                  ? Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: blackColor5,
                      ),
                      child: Text(
                        "Không có tập tin đính kèm",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.blue),
                      ),
                    )
                  : ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                      itemCount: files.length,
                      itemBuilder: (context, index) {
                        AttachmentFileModel file = files[index];

                        return GestureDetector(
                          onTap: () => onDownload(file),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: blackColor5,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Text(file.fileName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(color: Colors.blue)),
                                ),
                                Expanded(child: SizedBox()),
                                Expanded(
                                    child: Image.asset(
                                  "assets/images/ic_download.png",
                                  scale: 1.7,
                                )),
                              ],
                            ),
                          ),
                        );
                      },
                    )),
        ],
      ),
    );
  }
}

class RequestInformationForm extends StatelessWidget {
  // final WorkflowRequestInformationModel model;

  final ValueChanged<AttachmentFileModel> onDownload;
  final List<RequestInformationRecordItem> items;

  const RequestInformationForm({
    super.key,
    // required this.model,
    required this.onDownload,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: blackColor,
          ),
          bodyMedium: TextStyle(
            color: blackColor,
          ),
        ),
      ),
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemCount: items.length,
        itemBuilder: (context, index) {
          RequestInformationRecordItem item = items[index];
          if (item.files != null) {
            return item.files!.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: blackColor5,
                    ),
                    child: Text(
                      "Không có tập tin đính kèm",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.blue),
                    ),
                  )
                : ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemCount: item.files!.length,
                    itemBuilder: (context, index) {
                      AttachmentFileModel file = item.files![index];

                      return GestureDetector(
                        onTap: () => onDownload(file),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: blackColor5,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Text(file.fileName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(color: Colors.blue)),
                              ),
                              Expanded(child: SizedBox()),
                              Expanded(
                                  child: Image.asset(
                                "assets/images/ic_download.png",
                                scale: 1.7,
                              )),
                            ],
                          ),
                        ),
                      );
                    },
                  );
          }

          return RequestInformationItem(
            title: item.label,
            data: item.value,
            suffixIcon: item.suffix,
          );
        },
      ),
      // Column(
      //   spacing: 15,
      //   children: [
      //     RequestInformationItem(title: "Tên đề xuất", data: model.title),
      //     RequestInformationItem(
      //       title: "Biểu mẫu",
      //       data: model.typeWorkFlowName,
      //       suffixIcon: IconButton(
      //         onPressed: () {
      //           Navigator.pushNamed(context, PREVIEW_WORKFLOW_PAGE_ROUTE,
      //               arguments: model);
      //         },
      //         icon: Image.asset(
      //           "assets/images/ic_goto.png",
      //           scale: 1.6,
      //         ),
      //       ),
      //     ),
      //     RequestInformationItem(title: "Ngày tạo", data: model.dateCreated),
      //     RequestInformationItem(
      //         title: "Người đề xuất", data: model.userCreated),
      //     RequestInformationItem(
      //         title: "Phòng ban", data: model.departmentUserRequirement),
      //     RequestInformationItem(
      //         title: "Tệp đính kèm",
      //         child: files.isEmpty
      //             ? Container(
      //                 padding: const EdgeInsets.all(10),
      //                 decoration: BoxDecoration(
      //                   color: blackColor5,
      //                 ),
      //                 child: Text(
      //                   "Không có tập tin đính kèm",
      //                   style: Theme.of(context)
      //                       .textTheme
      //                       .bodyLarge
      //                       ?.copyWith(color: Colors.blue),
      //                 ),
      //               )
      //             : ListView.separated(
      //                 physics: NeverScrollableScrollPhysics(),
      //                 shrinkWrap: true,
      //                 separatorBuilder: (context, index) =>
      //                     SizedBox(height: 10),
      //                 itemCount: files.length,
      //                 itemBuilder: (context, index) {
      //                   AttachmentFileModel file = files[index];

      //                   return GestureDetector(
      //                     onTap: () => onDownload(file),
      //                     child: Container(
      //                       padding: const EdgeInsets.symmetric(
      //                           horizontal: 14, vertical: 8),
      //                       decoration: BoxDecoration(
      //                         color: blackColor5,
      //                       ),
      //                       child: Row(
      //                         children: [
      //                           Expanded(
      //                             flex: 5,
      //                             child: Text(file.fileName,
      //                                 style: Theme.of(context)
      //                                     .textTheme
      //                                     .bodyLarge
      //                                     ?.copyWith(color: Colors.blue)),
      //                           ),
      //                           Expanded(child: SizedBox()),
      //                           Expanded(
      //                               child: Image.asset(
      //                             "assets/images/ic_download.png",
      //                             scale: 1.7,
      //                           )),
      //                         ],
      //                       ),
      //                     ),
      //                   );
      //                 },
      //               )),
      //   ],
      // ),
    );
  }
}
