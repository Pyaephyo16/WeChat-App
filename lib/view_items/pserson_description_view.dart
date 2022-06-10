import 'package:flutter/material.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';

class PersonDescriptionView extends StatelessWidget {

  final String description;
  final bool isChatPage;

  PersonDescriptionView({
    required this.description,
    this.isChatPage = true,
    });

  @override
  Widget build(BuildContext context) {
    return Text(description,
    maxLines: (isChatPage) ? 1 : 4,
    overflow: (isChatPage) ? TextOverflow.ellipsis : null,
    style: TextStyle(
      color: CHAT_HEAD_SUBTITLE_COLOR,
      fontWeight: FontWeight.w500,
      fontSize: TEXT_MEDIUM_1,
    ),
    );
  }
}