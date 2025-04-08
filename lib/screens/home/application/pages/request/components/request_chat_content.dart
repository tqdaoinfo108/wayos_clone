import 'package:flutter/material.dart';
import 'package:wayos_clone/utils/app_date_format.dart';
import 'package:wayos_clone/utils/constants.dart';

class RequestChatContent extends StatelessWidget {
  final dynamic data;
  const RequestChatContent(this.data, {super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        textDirection: TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Row(
            children: [
              Text(
                data['UserComment'],
                style: Theme.of(context).textTheme.labelLarge,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
              Flexible(
                child: Text(
                  " - ${AppDateFormat.formatDate(data['DateCreated'])}",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: blackColor40, fontWeight: FontWeight.normal),
                  softWrap: true,
                ),
              ),
            ],
          ),
          Text(
            data['ContentComment'],
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(fontWeight: FontWeight.normal),
            softWrap: true,
          ),
        ],
      ),
    );
  }
}
