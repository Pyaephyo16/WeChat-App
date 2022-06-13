import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:we_chat_app/blocs/privacy_policy_page_bloc.dart';
import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';
import 'package:we_chat_app/pages/register_page.dart';
import 'package:we_chat_app/pages/register_steps/email_varification_page.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/resources/strings.dart';
import 'package:we_chat_app/view_items/app_bar_title_view.dart';
import 'package:we_chat_app/utils/extension.dart';

class PrivacyPolicyPage extends StatelessWidget {

  final UserVO user;
  final File pickedFile;

  PrivacyPolicyPage({
    required this.user,
    required this.pickedFile,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PrivacyPolicyPageBloc(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 1,
          leading: IconButton(
              icon: FaIcon(FontAwesomeIcons.xmark),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            title: AppBarTitleView(title: "Privacy Policy"),
            actions: [
              IconButton(
               icon:const Icon(Icons.more_horiz,size: MARGIN_SIZE_FOR_APP_BAR_ICON,color: Colors.white,),
              onPressed: (){
              },
            ),
            ],
        ),
        body: Container(
             padding:const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_1),
              color: PRIVACY_PAGE_BG_COLOR,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: MARGIN_MEDIUM_1,),
                    Center(child: AppBarTitleView(title: "WECHAT PRIVACY POLICY")),
                    const SizedBox(height: MARGIN_MEDIUM_1,),
                    PrivacyDateView(
                      text: "Last Updated: 202-03-22",
                    ),
                    const SizedBox(height: MARGIN_MEDIUM_1,),
                    AppBarTitleView(title: "Summary"),
                    const SizedBox(height: MARGIN_MEDIUM_1,),
                    PrivacyContentView(text: PRIVACY_SUMMARY),

                     const SizedBox(height: MARGIN_MEDIUM_1,),
                    AppBarTitleView(title: PRIVAY_APPLY),
                    const SizedBox(height: MARGIN_MEDIUM_1,),
                    PrivacyContentView(text: PRIVACY_APPLY_CONTENT),
                    const SizedBox(height: MARGIN_MEDIUM),
                    PrivacyContentView(text: PRIVAY_APPLY_FACTS),

                     const SizedBox(height: MARGIN_MEDIUM_1,),
                    AppBarTitleView(title: WEIXIN_USER),
                    const SizedBox(height: MARGIN_MEDIUM_1,),
                    PrivacyContentView(text: WEIXIN_USER_CONTENT),
                  ],
                )
                ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.2,
                child: Consumer<PrivacyPolicyPageBloc>(
                  builder: (context,PrivacyPolicyPageBloc bloc,child) =>
                 Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 22,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CheckIconView(
                            onTapAccept: (){
                              PrivacyPolicyPageBloc pBloc = Provider.of(context,listen: false);
                              pBloc.changeCheck();
                            },
                             isAccept: bloc.isRead,
                             ),
                             SizedBox(width: 16,),
                             TermsOfServiceNoteText(
                              text: "I have read and accept the above terms",
                              ),
                        ],
                      ),
                      SizedBox(height: 22,),
                      AcceptAndContinueButtonView(
                        onClick: (){
                     navigateToNextScreen(context,EmailVarificationPage(user: user,pickedFile: pickedFile));
                        },
                         isAccept: bloc.isRead,
                         text: "Next",
                         ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrivacyDateView extends StatelessWidget {

  final String text;

  PrivacyDateView({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text,
    style: TextStyle(
      fontSize: 16,
      color: CONTACT_SEARCH_TEXT_COLOR,
      fontWeight: FontWeight.w500,
    ),
    );
  }
}

class PrivacyContentView extends StatelessWidget {

  final String text;

  PrivacyContentView({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text,
    style: TextStyle(
      fontSize: 16,
      color: CONTACT_SEARCH_TEXT_COLOR,
      fontWeight: FontWeight.w500,
    ),
    );
  }
}