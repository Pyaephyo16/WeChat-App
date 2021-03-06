import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:we_chat_app/blocs/login_bloc.dart';
import 'package:we_chat_app/pages/add_new_post_page.dart';
import 'package:we_chat_app/pages/home_page.dart';
import 'package:we_chat_app/pages/register_page.dart';
import 'package:we_chat_app/pages/register_steps/privacy_policy_page.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/resources/strings.dart';
import 'package:we_chat_app/view_items/app_bar_title_view.dart';
import 'package:we_chat_app/view_items/text_field_for_login_and_register.dart';
import 'package:we_chat_app/utils/extension.dart';

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
      return ChangeNotifierProvider(
        create: (context) => LoginBloc(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar:  AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
                  icon:const FaIcon(FontAwesomeIcons.xmark,color: Colors.white,),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
          ),
          body: Selector<LoginBloc,bool>(
            selector: (context,bloc) => bloc.isLoading,
            shouldRebuild: (previous,next) => previous != next,
            builder: (context,isLoading,child) =>
            Stack(
              children: [
                Container(
                  color: Colors.black,
                  padding:const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_1),
                  child: Consumer<LoginBloc>(
                    builder: (context,LoginBloc bloc,child) =>
                    Column(
                      children: [
                          const SizedBox(height: MARGIN_SIZE_FOR_CHAT,),
                          Center(child: TitleTextView(titleText: LOGIN_TITLE_TEXT)),
                           const SizedBox(height: MARGIN_FOR_LOGIN_PAGE_SPACING,),
                          TextFieldForRegisterAndLoginView(
                            formKey: bloc.lgEmailFormKey,
                            controller: bloc.lgEmailController,
                            hintText: EMAIL_PAGE_HINT_TEXT,
                            title: EMAIL_TEXT,
                            isPassword: false,
                            isPhone: false,
                            isEmail: true,
                            isName: false,
                            showPassword: (){},
                            isShowPassword: false,
                            ),
                              const SizedBox(height: MARGIN_MEDIUM_2X,),
                          TextFieldForRegisterAndLoginView(
                            formKey: bloc.lgPasswordFormKey,
                            controller: bloc.lgPasswordController,
                            hintText: ENTER_PASSWORD_TEXT,
                            title: PASSWORD_TEXT,
                            isPassword: true,
                            isPhone: false,
                            isEmail: false,
                            isName: false,
                            showPassword: (){
                              LoginBloc bloc = Provider.of(context,listen: false);
                              bloc.showPassword();
                            },
                            isShowPassword: bloc.isShowPassword,
                            ),
                            const Spacer(),
                            PrivacyContentView(text: LOGIN_PAGE_MARK_TEXT),
                            const SizedBox(height: MARGIN_SIZE_FOR_APP_BAR_ICON,),
                            Builder(
                              builder: (context) =>
                               AcceptAndContinueButtonView(
                                onClick: (){
                                  if( (bloc.lgEmailFormKey.currentState!.validate())
                                   && (bloc.lgPasswordFormKey.currentState!.validate()) ){
                                   LoginBloc bloc = Provider.of(context,listen: false);
                                    bloc.tapLogin(bloc.lgEmailController.text,bloc.lgPasswordController.text)
                                    .then((value) => 
                                   navigateToNextScreen(context,HomePage())).catchError((error){
                                      errorSnackBar(context,error.toString());
                                   });
                            
                                   }
                                },
                                 isAccept: true,
                                  text: ACCEPT_AND_CONTINUER_TEXT,
                                  ),
                            ),
                             const SizedBox(height: MARGIN_FOR_LOGIN_PAGE_SPACING,),
                      ],
                    ),
                  ),
                ),
          
          
                Visibility(
                  visible: isLoading,
                  child:const LoadingShowView(),
                  ),
          
              ],
            ),
          ),
        ),
      );
  }
}