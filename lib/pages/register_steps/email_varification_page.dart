import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';
import 'package:we_chat_app/pages/register_page.dart';
import 'package:we_chat_app/pages/register_steps/email_page.dart';
import 'package:we_chat_app/pages/register_steps/privacy_policy_page.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/resources/strings.dart';
import 'package:we_chat_app/view_items/app_bar_title_view.dart';
import 'package:we_chat_app/utils/extension.dart';

class EmailVarificationPage extends StatelessWidget {

  final UserVO user;
  final File pickedFile;

  EmailVarificationPage({
    required this.user,
    required this.pickedFile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: 
            IconButton(
              icon:const FaIcon(FontAwesomeIcons.xmark,color: Colors.white,),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_1),
        child: Column(
          children: [
            const SizedBox(height: 82,),
            Icon(
              Icons.info_rounded,
              color: Colors.blue,
              size: 48,
            ),
            const SizedBox(height: 32,),
            AppBarTitleView(title: SECURITY_VARIFICATION_TEXT),
            const SizedBox(height: 32,),
            PrivacyContentView(text: SECURITY_VARIFICATION_CONTENT),
           const Spacer(),
           AcceptAndContinueButtonView(
            onClick: (){
              navigateToNextScreen(context,EmailPage(user: user,pickedFile: pickedFile,));
            },
             isAccept: true,
              text: "Start",
              ),
              const SizedBox(height: 32,),  
          ],
        ),
      ),
    );
  }
}