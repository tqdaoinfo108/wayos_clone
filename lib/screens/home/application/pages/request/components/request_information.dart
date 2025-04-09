import 'package:flutter/material.dart';
import '../../../../../../model/attachment_file_model.dart';
import '../../../../../../model/request_information_item_model.dart';
import '../../../../../../utils/constants.dart';
import 'request_information_item.dart';

class RequestInformation extends StatelessWidget {
  final ValueChanged<AttachmentFileModel> onDownload;
  final List<RequestInformationItemModel> items;

  const RequestInformation({
    super.key,
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
        physics: NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => SizedBox(height: 10),
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) {
          RequestInformationItemModel item = items[index];
          Widget? child;
          if (item.files != null) {
            child = item.files!.isEmpty
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
            label: item.label,
            value: item.value,
            suffixIcon: item.suffix,
            child: child,
          );
        },
      ),
    );
  }
}
