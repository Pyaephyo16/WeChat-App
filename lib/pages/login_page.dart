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
                          const SizedBox(height: 100,),
                          Center(child: TitleTextView(titleText: LOGIN_TITLE_TEXT)),
                           const SizedBox(height: 64,),
                          TextFieldForRegisterAndLoginView(
                            formKey: bloc.lgEmailFormKey,
                            controller: bloc.lgEmailController,
                            hintText: "Enter Your Email",
                            title: "Email",
                            isPassword: false,
                            isPhone: false,
                            isEmail: true,
                            isName: false,
                            showPassword: (){},
                            isShowPassword: false,
                            ),
                              const SizedBox(height: 22,),
                          TextFieldForRegisterAndLoginView(
                            formKey: bloc.lgPasswordFormKey,
                            controller: bloc.lgPasswordController,
                            hintText: "Enter Password",
                            title: "Password",
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
                            const SizedBox(height: 26,),
                            Builder(
                              builder: (context) =>
                               AcceptAndContinueButtonView(
                                onClick: (){
                                  if( (bloc.lgEmailFormKey.currentState!.validate())
                                   && (bloc.lgPasswordFormKey.currentState!.validate()) ){
                            
                                    ///Need network call
                                   LoginBloc bloc = Provider.of(context,listen: false);
                                    bloc.tapLogin(bloc.lgEmailController.text,bloc.lgPasswordController.text)
                                    .then((value) => 
                                   navigateToNextScreen(context,HomePage())).catchError((error){
                                      errorSnackBar(context,error.toString());
                                   });
                            
                                   }
                                },
                                 isAccept: true,
                                  text: "Accept and Continue"
                                  ),
                            ),
                             const SizedBox(height: 64,),
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