import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:we_chat_app/blocs/setting_page_bloc.dart';
import 'package:we_chat_app/data/model/auth_model.dart';
import 'package:we_chat_app/data/model/auth_model_impl.dart';
import 'package:we_chat_app/fcm/fcm_service.dart';
import 'package:we_chat_app/pages/add_new_post_page.dart';
import 'package:we_chat_app/pages/country_page.dart';
import 'package:we_chat_app/pages/home_page.dart';
import 'package:we_chat_app/pages/qr_code_page.dart';
import 'package:we_chat_app/pages/register_page.dart';
import 'package:we_chat_app/pages/register_steps/email_page.dart';
import 'package:we_chat_app/pages/register_steps/email_varification_page.dart';
import 'package:we_chat_app/pages/register_steps/privacy_policy_page.dart';
import 'package:we_chat_app/pages/splash_page.dart';
import 'package:we_chat_app/resources/colors.dart';

void main()async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FCMService().listenForMessages();

    WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en','US'),Locale('my','MM')],
      fallbackLocale: Locale('en','US'),
      path: "asset/langs",
      saveLocale: true,
      child: PreApp(),
      ),
    );
}

class PreApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SettingPageBloc(),
      child: MyApp(),
    );
  }
}


class MyApp extends StatelessWidget {

  AuthModel authModel = AuthModelImpl();

  @override
  Widget build(BuildContext context) {
     return Consumer<SettingPageBloc>(
        builder: (context,SettingPageBloc setting,child) =>
         MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          themeMode: setting.chooseTheme,
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.green,
            primaryColor: Colors.black,
            primaryColorLight: CONSERVATION_TEXTFIELD_CONTAINER_COLOR,
            bottomAppBarColor: Colors.white,
            primaryColorDark: CONTACT_PAGE_BG_COLOR,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.green,
            primaryColor: Colors.white,
            primaryColorLight: Colors.black12,
            bottomAppBarColor: Colors.black,
            primaryColorDark: Colors.grey[800],
          ),
          home: (authModel.isLoggedIn()) ? HomePage() : SplashPage(),
        ),
    //),
    );
  }
}
