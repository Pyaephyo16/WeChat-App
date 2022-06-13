import 'package:flutter/material.dart';
import 'package:we_chat_app/resources/strings.dart';

class ChatHeadView extends StatelessWidget {

  final String image;
  final bool isChatPage;

  ChatHeadView({
    required this.image,
    required this.isChatPage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (isChatPage) ? 50 : 30,
      height: (isChatPage) ? 50 : 30,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular((isChatPage) ? 25 : 15),
      ),
      child: Image.network( (image == "") ? CONSTANT_IMAGE : image,
      fit: BoxFit.cover,),
    );
  }
}