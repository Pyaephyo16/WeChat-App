import 'package:flutter/material.dart';
import 'package:we_chat_app/resources/dimens.dart';

class AppBarTitleView extends StatelessWidget{

  final String title;

  AppBarTitleView({
    required this.title,
  });

  @override
  Widget build(BuildContext context){
    return  Text(
              title,
            style: TextStyle(
              color: Colors.white,
              fontSize: TEXT_LARGE_1,
              fontWeight: FontWeight.bold,
            ),
            );
  }

}