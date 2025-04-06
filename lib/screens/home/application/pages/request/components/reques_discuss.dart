import 'package:flutter/material.dart';
import 'package:wayos_clone/screens/home/application/pages/request/components/request_chat_content.dart';
import 'package:wayos_clone/theme/input_decoration_theme.dart';
import 'package:wayos_clone/utils/constants.dart';

class RequestDiscuss extends StatefulWidget {
  final List<dynamic> dataComment;
  final ValueChanged<String> createComment;
  final bool commentLoading;
  const RequestDiscuss(this.dataComment, this.createComment,
      {super.key, this.commentLoading = false});
  @override
  State<RequestDiscuss> createState() => _RequestDiscussState();
}

class _RequestDiscussState extends State<RequestDiscuss> {
  late TextEditingController _disscussContent;
  late FocusNode _commentFocusNode;

  @override
  void initState() {
    super.initState();
    _disscussContent = TextEditingController();
    _commentFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 10,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 20,
          children: [
            Expanded(
              child: Theme(
                data: Theme.of(context).copyWith(
                  inputDecorationTheme: customInputDecorationTheme,
                ),
                child: TextField(
                  controller: _disscussContent,
                  focusNode: _commentFocusNode,
                  onTapOutside: (event) {
                    _commentFocusNode.unfocus();
                  },
                  decoration: InputDecoration(
                    hintText: 'Nhập thảo luận...',
                    suffixIcon: widget.commentLoading
                        ? Transform.scale(
                            scale: 0.5,
                            child: CircularProgressIndicator(),
                          )
                        : null,
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.black),
                ),
              ),
            ),
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: secondaryColor,
              ),
              child: IconButton(
                icon: Image.asset(
                  "assets/images/ic_send.png",
                  color: whiteColor,
                ),
                onPressed: () {
                  widget.createComment(_disscussContent.text);
                  _disscussContent.clear();
                },
              ),
            ),
          ],
        ),
        // Chat content
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: 20),
          itemCount: widget.dataComment.length,
          itemBuilder: (context, index) {
            return RequestChatContent(widget.dataComment[index]);
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _commentFocusNode.dispose();
    _disscussContent.dispose();
    super.dispose();
  }
}
