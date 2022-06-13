import 'package:flutter/material.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/resources/strings.dart';
import 'package:we_chat_app/view_items/app_bar_title_view.dart';

class TextFieldForRegisterAndLoginView extends StatelessWidget {


  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final String hintText;
  final String title;
  final bool isPhone;
  final bool isPassword;
  final bool isEmail;
  final bool isName;
  final Function showPassword;
  final bool isShowPassword;

  TextFieldForRegisterAndLoginView({
    required this.formKey,
    required this.controller,
    required this.hintText,
    required this.title,
    required this.isPassword,
    required this.isPhone,
    required this.isEmail,
    required this.isName,
    required this.showPassword,
    required this.isShowPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextFieldTitleView(title: title,isBeforeLogin: true,),
        Expanded(
          child: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              keyboardType: (isPhone) ? TextInputType.phone : (isEmail) ? TextInputType.emailAddress : TextInputType.name,
              obscureText: (isEmail) ? false : (isPhone) ?  false : (isName) ? false : isShowPassword,
              style:const TextStyle(
                color: Colors.white,
                fontSize: TEXT_MEDIUM_1X,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
               focusColor: PRIMARY_COLOR,
                   hintText: hintText,
                hintStyle:const TextStyle(
                 color: CONTACT_SEARCH_TEXT_COLOR,
               fontSize: TEXT_MEDIUM_1X,
                   fontWeight: FontWeight.w400,
                    ),
                suffixIcon: (isPassword) ?
                 IconButton(
                  onPressed: (){
                    showPassword();
                  },
            icon: Icon(Icons.remove_red_eye_outlined,color: CONTACT_SEARCH_TEXT_COLOR,size: 22,))
                : null
              ),
              validator: (str){
                if(str!.isEmpty){
                  return REQUIRED_TEXT;
                }else{
                    if(isPhone == true){
                      if(str.length < 9){
                        return "Invalid Phone Number";
                      }
                    }else if(isPassword == true){
                        if(str.length < 6){
                          return "At least 6 character";
                        }
                    }else if(isEmail == true){
                      if(!str.endsWith("@gmail.com")){
                        return "Invalid Email Address";
                      }
                    }
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}

class TextFieldTitleView extends StatelessWidget {
  const TextFieldTitleView({
    Key? key,
    required this.title,
    required this.isBeforeLogin,
  }) : super(key: key);

  final String title;
  final bool isBeforeLogin;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width * 0.3,
      child: Text(title,
        style:  TextStyle(
          color: (isBeforeLogin) ? Colors.white : Colors.black,
          fontSize: TEXT_MEDIUM_1X,
      fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}