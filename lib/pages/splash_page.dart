import 'package:flutter/material.dart';
import 'package:we_chat_app/fcm/fcm_service.dart';
import 'package:we_chat_app/pages/login_page.dart';
import 'package:we_chat_app/pages/register_page.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/resources/strings.dart';
import 'package:we_chat_app/utils/extension.dart';
import 'package:we_chat_app/view_items/divide_line_view.dart';

class SplashPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              // child: Image.network("https://64.media.tumblr.com/604d7e01bb5494ab526dc736ebd27f1c/tumblr_nfwkulIpvo1r630xzo1_1280.jpg",
              //   fit: BoxFit.cover,
              // ),
              child: Image.asset("./asset/image/we_chat_wallpaper.jpg",
              fit: BoxFit.cover,
              ),
            ),
          ),
    
          Positioned(
            left: 0,
            right: 0,
            bottom: 60,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_1),
              child: Row(
                children: [
                    LoginButtonView(
                      name: LOGIN_TEXT,
                       isLogin: true,
                       onClick: (){
                        navigateToNextScreen(context,LoginPage());
                       },
                       ),
                   const Spacer(),
                    LoginButtonView(
                      name: SIGNUP_TEXT,
                      isLogin: false,
                      onClick: (){
                        showBTMSheetForMethod(
                          context,
                          tappedMobile: (){
                            navigateToNextScreen(context,RegisterPage());
                          },
                          tappedFacebook: (){},
                          );
                      },
                      ),
                ],
              ),
            ),
            )
        ],
      ),
    );
  }

  void showBTMSheetForMethod(BuildContext context,{required Function tappedMobile,required Function tappedFacebook}){
     showModalBottomSheet(
      context: context,
       builder: (_){
        return Container(
          decoration:const BoxDecoration(
            color: SIGNUP_BTM_COLOR,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SignUpMethodView(
                text: SIGNUP_VIA_MOBILE_TETXT,
                tapped: (){
                  tappedMobile();
                },
              ),
             DivideLineView(),
              SignUpMethodView(
                text: SIGNUP_VIA_FACEBOOK_TEXT,
                tapped: (){
                  tappedFacebook();
                },
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MARGIN_MEDIUM_1,
                color: Colors.black,
              ),
              SignUpMethodView(
                text: CANCEL_TEXT,
                tapped: (){
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
       }
       );
  }

}

class SignUpMethodView extends StatelessWidget {

  final String text;
  final Function tapped;

  SignUpMethodView({
    required this.text,
    required this.tapped,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        tapped();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: MARGIN_MEDIUM_1),
        child: Text(text,
        textAlign: TextAlign.center,
        style:const TextStyle(
          fontSize: TEXT_MEDIUM_1X,
          color: Colors.white,
        ),
        ),
      ),
    );
  }
}

class LoginButtonView extends StatelessWidget {

  final String name;
  final bool isLogin;
  final Function onClick;

  LoginButtonView({
    required this.name,
    required this.isLogin,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onClick();
      },
      child: Container(
        alignment: Alignment.center,
        width: LOGIN_BTN_CONTAINER_WIDTH,
        height: LOGIN_BTN_CONTAINER_HEIGHT,
        decoration: BoxDecoration(
          color: (isLogin) ? PRIMARY_COLOR : Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(TEXT_SMALL_1X),
        ),
        child: Text(
          name,
        style:const TextStyle(
          fontSize: MARGIN_MEDIUM_2,
          color: Colors.white,
        ),
        ),
      ),
    );
  }
}