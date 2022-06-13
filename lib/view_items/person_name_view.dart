import 'package:flutter/material.dart';
import 'package:we_chat_app/resources/dimens.dart';

class PersonNameView extends StatelessWidget {

  final String name;

  PersonNameView({
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
       name,
      style:const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: TEXT_LARGE,
      ),
    );
  }
}