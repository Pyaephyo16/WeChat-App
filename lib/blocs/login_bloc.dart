import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:we_chat_app/data/model/auth_model.dart';
import 'package:we_chat_app/data/model/auth_model_impl.dart';

class LoginBloc extends ChangeNotifier{

  bool isDisposed = false;
  bool isShowPassword = true;
  bool isLoading = false;

  TextEditingController lgEmailController = TextEditingController();
  TextEditingController lgPasswordController = TextEditingController();

  GlobalKey<FormState> lgEmailFormKey = GlobalKey<FormState>();
   GlobalKey<FormState> lgPasswordFormKey = GlobalKey<FormState>();


    //Model
    AuthModel authModel = AuthModelImpl();

  Future<void> tapLogin(String email,String password){
      isLoading = true;
      _notifySafely();
    return authModel.loginUser(email, password).whenComplete((){
        isLoading = false;
        _notifySafely();
    });
  }

 showPassword(){
      isShowPassword = !isShowPassword;
      _notifySafely();
    }

    _notifySafely(){
      if(!isDisposed){
        notifyListeners();
      }
    }

   @override
  void dispose() {
    lgEmailController.dispose();
    lgPasswordController.dispose();
    super.dispose();
    isDisposed = true;
  }

}