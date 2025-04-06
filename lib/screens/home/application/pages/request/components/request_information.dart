import 'package:flutter/material.dart';

import '../../../../../../model/attachment_file.dart';
import '../../../../../../utils/constants.dart';
import 'request_information_item.dart';

class RequestInformation extends StatelessWidget {
  const RequestInformation({
    super.key,
    required this.objectData,
    required this.files,
  });

  final dynamic objectData;
  final List<AttachmentFile> files;

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
          RequestInformationItem(
              title: "Tên đề xuất", data: objectData["Title"]),
          RequestInformationItem(
            title: "Biểu mẫu",
            data: objectData["TypeWorkFlowName"],
            suffixIcon: IconButton(
              onPressed: () {},
              icon: Image.asset(
                "assets/images/ic_goto.png",
                scale: 1.6,
              ),
            ),
          ),
          RequestInformationItem(
              title: "Ngày tạo", data: objectData["DateCreated"]),
          RequestInformationItem(
              title: "Người đề xuất", data: objectData["UserCreated"]),
          RequestInformationItem(
              title: "Phòng ban",
              data: objectData["DepartmentUserRequirement"]),
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
                        AttachmentFile file = files[index];

                        return GestureDetector(
                          onTap: () {
                            print("asdasdadsad");
                          },
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
