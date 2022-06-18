import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:we_chat_app/blocs/email_page_bloc.dart';
import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';
import 'package:we_chat_app/pages/add_new_post_page.dart';
import 'package:we_chat_app/pages/home_page.dart';
import 'package:we_chat_app/pages/register_page.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/resources/strings.dart';
import 'package:we_chat_app/view_items/app_bar_title_view.dart';
import 'package:we_chat_app/view_items/text_field_for_login_and_register.dart';
import 'package:we_chat_app/utils/extension.dart';

class EmailPage extends StatelessWidget {

  final UserVO user;
  final File pickedFile;

  EmailPage({
    required this.user,
    required this.pickedFile,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EmailPageBloc(),
      child: Scaffold(
        appBar:  AppBar(
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
        body: Selector<EmailPageBloc,bool>(
          selector: (context,bloc) => bloc.isLoading,
          shouldRebuild: (previous,next) => previous != next,
          builder: (context,isLoading,child) =>
          Stack(
            children: [
              Container(
                color: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_1),
                child: Consumer<EmailPageBloc>(
                      builder: (context,EmailPageBloc bloc,child) =>
                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     const SizedBox(height: MARGIN_SIZE_FOR_SPACING,),
                     AppBarTitleView(title: EMAIL_PAGE_TITLE_TEXT),
                     const SizedBox(height: MARGIN_SIZE_FOR_ICON,),
                        TextFieldForRegisterAndLoginView(
                          formKey: bloc.emailFormKey,
                          controller: bloc.emailController,
                          hintText: EMAIL_PAGE_HINT_TEXT,
                          title: EMAIL_TEXT,
                          isPassword: false,
                          isPhone: false,
                          isEmail: true,
                          isName: false,
                          showPassword: (){},
                          isShowPassword: false,
                          ),
                       const Spacer(),
                       Center(
                         child: Builder(
                          builder: (context) =>
                           AcceptAndContinueButtonView(
                            onClick: (){
                              if( (bloc.emailFormKey.currentState!.validate())){
                                UserVO registerData = UserVO(
                                  id: user.id,
                                email: bloc.emailController.text,
                                userName: user.userName,
                                phone: user.phone,
                                password: user.password,
                                profileImage: "",
                                fcm: "",
                                qrCode: "",
                                ); 
                               EmailPageBloc emailBloc = Provider.of(context,listen: false);
                               emailBloc.registerUser(registerData, pickedFile)
                               .then((value) =>
                                navigateToNextScreen(context,HomePage()))
                                .catchError((error){
                                  errorSnackBar(context,error.toString());
                                });
                              }
                            },
                             isAccept: true,
                              text: DONE_TEXT,
                              ),
                         ),
                       ),
                       const SizedBox(height: 32,),
                    ],
                  ),
                ),
              ),


              Visibility(
                visible: isLoading,
                child: const LoadingShowView(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}