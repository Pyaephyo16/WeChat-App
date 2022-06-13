import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

void main()async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FCMService().listenForMessages();

  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  AuthModel authModel = AuthModelImpl();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: (authModel.isLoggedIn()) ? HomePage() : SplashPage(),
    );
  }
}
