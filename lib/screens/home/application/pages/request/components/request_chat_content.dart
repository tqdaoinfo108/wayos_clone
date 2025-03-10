import 'package:flutter/material.dart';
import 'package:wayos_clone/utils/constants.dart';

class RequestChatContent extends StatelessWidget {
  const RequestChatContent(this.data, {
    super.key,
  });
final dynamic data;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(8.0), // Thêm khoảng cách bên trong Container
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        textDirection: TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Row(
            children: [
              Flexible(
                child: Text(
                  data['UserComment'],
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: blackColor,
                      fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  softWrap: true,
                
                ),
              ),
              Flexible(
                child: Text(
                  " - ${data['DateCreated']}",
                  style: TextStyle(color: Colors.grey),
                  softWrap: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(0.0),
            child:  Text(data['ContentComment'],
                style: TextStyle(color: blackColor),
                softWrap: true,),
          ),
        ],
      ),
    );
  }
}
