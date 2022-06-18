import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:we_chat_app/blocs/register_bloc.dart';
import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';
import 'package:we_chat_app/pages/country_page.dart';
import 'package:we_chat_app/pages/register_steps/privacy_policy_page.dart';
import 'package:we_chat_app/pages/splash_page.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:path/path.dart' as p;
import 'package:we_chat_app/resources/strings.dart';
import 'package:we_chat_app/view_items/divide_line_view.dart';
import 'package:we_chat_app/view_items/text_field_for_login_and_register.dart';
import 'package:we_chat_app/utils/extension.dart';

class RegisterPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegisterBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          leading: IconButton(
            icon:const FaIcon(FontAwesomeIcons.xmark),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_1),
          child: Consumer<RegisterBloc>(
                builder: (context,RegisterBloc bloc,child) => Column(
              children: [
                TitleTextView(
                  titleText: SIGN_UP_BY_PHONE_TEXT,
                ),
               const SizedBox(height: MARGIN_MEDIUM,),
                 ChooseProfileView(
                    onClick: (){
                      choosePhotoBTMSheet(
                        context,
                        chooseGallery: ()async{
                       final imagePicker = ImagePicker();
                                final XFile? galleryImage = await imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                                if (galleryImage != null) {
                                   RegisterBloc bloc = Provider.of(context, listen: false);
                                   final fileType = p.extension(galleryImage.path);
                                   bloc.fileChosen(File(galleryImage.path),fileType);
                                }
                                Navigator.pop(context);
                    },
                    ChooseCamera: ()async{
                         final imagePicker = ImagePicker();
                                final XFile? cameraImage = await imagePicker.pickImage(source: ImageSource.camera, imageQuality: 80);
                                if (cameraImage != null) {
                                   RegisterBloc bloc = Provider.of(context, listen: false);
                                   final fileType = p.extension(cameraImage.path);
                                   bloc.fileChosen(File(cameraImage.path),fileType);
                                }
                                Navigator.pop(context);
                    },
                         );
                    },
                    pickedFile: bloc.pickedFile,
                  ),

               const SizedBox(height: MARGIN_SIZE_FOR_REGISTER_SPACEING,),
               
               TextFieldForRegisterAndLoginView(
                formKey: bloc.nameFormKey,
                 controller: bloc.nameController,
                  hintText: ENTER_NAME_TEXT,
                  title: NAME_TEXT,
                  isPassword: false,
                  isPhone: false,
                  isEmail: false,
                  isName: true,
                  isShowPassword: false,
                  showPassword: (){},
                  ),

                  const SizedBox(height: MARGIN_MEDIUM_2X,),

                  RegionView(
                    controller: bloc.regionController,
                    formKey: bloc.regionFormKey,
                    onClick: (){
                      navigateToNextScreen(context,CountryPage()).then((value){
                        if(value != null){
                          RegisterBloc bloc = Provider.of(context,listen: false);
                          bloc.countrySelected(value);
                        }
                      });
                    },
                  ),

                   const SizedBox(height: 22,),

                  TextFieldForRegisterAndLoginView(
                formKey: bloc.phoneFormKey,
                 controller: bloc.phoneController,
                  title: PHONE_TEXT,
                  hintText: ENTER_PHONE_TEXT,
                  isPassword: false,
                  isPhone: true,
                  isEmail: false,
                  isName: false,
                  isShowPassword: false,
                   showPassword: (){},
                  ),

                 const SizedBox(height: 22,),

                  TextFieldForRegisterAndLoginView(
                formKey: bloc.passwordFormKey,
                 controller: bloc.passwordController,
                  title: PASSWORD_TEXT,
                  hintText: ENTER_PASSWORD_TEXT,
                  isPassword: true,
                  isPhone: false,
                  isEmail: false,
                  isName: false,
                  isShowPassword: bloc.isShowPassword,
                   showPassword: (){
                    RegisterBloc bloc = Provider.of(context,listen: false);
                    bloc.showPassword();
                   },
                  ),

                  const SizedBox(height: MARGIN_FOR_CONTACT_NAME_TITLE,),

                  TermsOfServiceView(
                    isAccept: bloc.isAccept,
                    onTapAccept: (){
                       RegisterBloc bloc = Provider.of(context,listen: false);
                       bloc.acceptTap();
                    },
                  ),

                  const SizedBox(height: MARGIN_SIZE_FOR_ICON,),

                  AcceptAndContinueButtonView(
                    isAccept: bloc.isAccept,
                    text: ACCEPT_AND_CONTINUER_TEXT,
                    onClick: (){
                      if( (bloc.nameFormKey.currentState!.validate()) && bloc.phoneFormKey.currentState!.validate() 
                      && bloc.passwordFormKey.currentState!.validate() && bloc.regionFormKey.currentState!.validate() 
                      && bloc.pickedFile != null ){
                        UserVO registerUser = UserVO(
                          id: "",
                          userName: bloc.nameController.text,
                          email: "",
                          phone: bloc.phoneController.text,
                          password: bloc.passwordController.text,
                          profileImage: "",
                          fcm: "",
                          qrCode: "",
                        );
                        navigateToNextScreen(context,PrivacyPolicyPage(user: registerUser,pickedFile: bloc.pickedFile!,));
                      }else if(bloc.pickedFile == null){
                          snackBarDataShow(context,PROFILE_IMAGE_WARNING_TEXT);
                      }
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void choosePhotoBTMSheet(BuildContext context,{required Function chooseGallery,required Function ChooseCamera}){
    showModalBottomSheet(
      context: context,
       builder: (_){
        return Container(
          color: SIGNUP_BTM_COLOR,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SignUpMethodView(
                text: GALLERY_TEXT,
                 tapped: (){
                  chooseGallery();
                 }
                 ),
                 DivideLineView(),
                 SignUpMethodView(
                text: CAMERA_TEXT,
                 tapped: (){
                  ChooseCamera();
                 }
                 ),
            ]
          ),
        );  
       }
       );
  }

}

class AcceptAndContinueButtonView extends StatelessWidget {

  final Function onClick;
  final bool isAccept;
  final String text;

  AcceptAndContinueButtonView({
    required this.onClick,
    required this.isAccept,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        (isAccept) ? onClick() : null;
      },
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.6,
        height: ACCEPT_AND_CONTINUE_CONTAINER_HEIGHT,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MARGIN_SMALL_1),
          color:(isAccept) ? PRIMARY_COLOR : DISABLED_BTN_COLOR,
        ),
        child: Text(text,
        style: TextStyle(
          color: (isAccept) ? Colors.white : CONTACT_SEARCH_TEXT_COLOR,
          fontSize: TEXT_MEDIUM_1X,
          fontWeight: FontWeight.w400,
        ),
        ),
      ),
    );
  }
}

class TermsOfServiceView extends StatelessWidget {

  final bool isAccept;
  final Function onTapAccept;

  TermsOfServiceView({
    required this.isAccept,
    required this.onTapAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: MARGIN_SIZE_FOR_ICON),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
            CheckIconView(onTapAccept: onTapAccept, isAccept: isAccept),
           const SizedBox(width: MARGIN_SMALL_1,),
           const TermsOfServiceTextView(),
            ],
          ),
         const SizedBox(height: MARGIN_MEDIUM_2X,),
         TermsOfServiceNoteText(
            text: TERMS_OF_SERVICE_NOTE_TEXT,
         ),
        ],
      ),
    );
  }
}

class TermsOfServiceNoteText extends StatelessWidget {

  final String text;

  TermsOfServiceNoteText({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text,
    style:const TextStyle(
      color: CONTACT_SEARCH_TEXT_COLOR,
      fontSize: TEXT_MEDIUM,
    ),
    );
  }
}

class TermsOfServiceTextView extends StatelessWidget {
  const TermsOfServiceTextView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RichText(
        textAlign: TextAlign.center,
        text:const TextSpan(
          text: I_HAVE_READ_TEXT,
          style: TextStyle(
            color: CONTACT_SEARCH_TEXT_COLOR,
            fontSize: TEXT_MEDIUM,
          ),
          children: [
            TextSpan(
              text: TERMS_OF_SERVICE_SHOW_TEXT,
              style: TextStyle(
            color: TERMS_OF_SERVICE_COLOR,
            fontSize: TEXT_MEDIUM,
          ),
            )
          ],
        ),
      ),
      );
  }
}

class CheckIconView extends StatelessWidget {
  const CheckIconView({
    Key? key,
    required this.onTapAccept,
    required this.isAccept,
  }) : super(key: key);

  final Function onTapAccept;
  final bool isAccept;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTapAccept();
      },
      child: Container(
        width: CHECK_ICON_WIDTH,
        height: CHECK_ICON_HEIGHT,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MARGIN_FOR_CHECK_ICON),
          color: (isAccept) ? PRIMARY_COLOR : Colors.transparent,
          border: (isAccept) ? Border.all(color: PRIMARY_COLOR) : Border.all(color: CONTACT_SEARCH_TEXT_COLOR),
        ),
        child: Icon(Icons.check,color: (isAccept) ? Colors.white : CONTACT_SEARCH_TEXT_COLOR,size: MARGIN_MEDIUM_1,),
      ),
    );
  }
}

class RegionView extends StatelessWidget {

  final Function onClick;
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;

  RegionView({
    required this.onClick,
    required this.controller,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
      return Row(
        children: [
           Container(
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width * 0.3,
          child:const Text(REGION_TEXT,
            style: TextStyle(
              color: Colors.white,
              fontSize: TEXT_MEDIUM_1X,
          fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: (){
              onClick();
            },
            child: Form(
              key: formKey,
              child: TextFormField(
                controller: controller,
                enabled: false,
                style:const TextStyle(
                    color: Colors.white,
                    fontSize: TEXT_MEDIUM_1X,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration:const InputDecoration(
                       hintText: CHOOSE_REGION_TEXT,
                    hintStyle: TextStyle(
                     color: CONTACT_SEARCH_TEXT_COLOR,
                   fontSize: TEXT_MEDIUM_1X,
                       fontWeight: FontWeight.w400,
                        ),
                  ),
                  validator: (str){
                    if(str!.isEmpty){
                      return REQUIRED_TEXT;
                    }
                    return null;
                  },
              ),
            ),
          ),
          ),
        ],
      );
  }
}

class ChooseProfileView extends StatelessWidget {

  final Function onClick;
  final File? pickedFile;

  ChooseProfileView({
    required this.onClick,
    required this.pickedFile,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onClick();
      },
      child: Container(
        width: PROFILE_CONTAINER_WIDTH,
        height: CONTACT_ICON_ROW_CONTAINER_HEIGHT,
        color: CHAT_HEAD_SUBTITLE_COLOR,
        child: (pickedFile == null) ? Icon(Icons.camera,size: MARGIN_SIZE_FOR_ICON,color: Colors.white,)
        : Image.file(pickedFile ?? File(''),
        fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class TitleTextView extends StatelessWidget {

  final String titleText;

  TitleTextView({
    required this.titleText,
  });

  @override
  Widget build(BuildContext context) {
    return Text(titleText,
    style:const TextStyle(
      color: Colors.white,
      fontSize: TEXT_LARGE,
    ),
    );
  }
}