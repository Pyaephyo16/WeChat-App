import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:we_chat_app/data/model/auth_model.dart';
import 'package:we_chat_app/data/model/auth_model_impl.dart';
import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';

class EmailPageBloc extends ChangeNotifier{

  
  bool isLoading = false;
  bool isDisposed = false;

  TextEditingController emailController = TextEditingController();

  GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();


    ///Model
    AuthModel authModel = AuthModelImpl();


  Future<void> registerUser(UserVO user,File pickedFile){
      isLoading = true;
      _notifySafely();
     return authModel.registerNewUser(user, pickedFile).whenComplete((){
      isLoading = false;
      _notifySafely();
     });
   }


    _notifySafely(){
      if(!isDisposed){
        notifyListeners();
      }
    }

    @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }

}