import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:we_chat_app/data/model/auth_model.dart';
import 'package:we_chat_app/data/model/auth_model_impl.dart';
import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';

class EmailPageBloc extends ChangeNotifier{

  TextEditingController emailController = TextEditingController();

  GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();


    ///Model
    AuthModel authModel = AuthModelImpl();


  Future<void> registerUser(UserVO user,File pickedFile){
     return authModel.registerNewUser(user, pickedFile);
   }

}