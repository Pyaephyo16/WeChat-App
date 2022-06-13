import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:we_chat_app/data/vos/country_dial_vo.dart';

class RegisterBloc extends ChangeNotifier{

  File? pickedFile;
  String? fileType;
  bool isDisposed = false;
  bool isShowPassword = true;
  bool isAccept = false;
   CountryDialVO? country;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController regionController = TextEditingController();

  GlobalKey<FormState> nameFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> phoneFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> regionFormKey = GlobalKey<FormState>();


  Future<File?> fileChosen(File chooseFile,String type){
    print("file path add post bloc ===================> ${chooseFile.path}");
    print("file extension add post bloc===================> ${type}");
    pickedFile = chooseFile;
    fileType = type;
    _notifySafely();
    return Future.value(pickedFile);
  }

  void countrySelected(CountryDialVO chooseCountry){
    country = chooseCountry;
    regionController.text = "${chooseCountry.name}  (${chooseCountry.dial})";
    phoneController.text = chooseCountry.dial ?? "";
    _notifySafely();
  }

    showPassword(){
      isShowPassword = !isShowPassword;
      _notifySafely();
    }

    acceptTap(){
      isAccept = !isAccept;
      _notifySafely();
    }


  _notifySafely(){
    if(!isDisposed){
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    regionController.dispose();
    super.dispose();
    isDisposed = true;
  }


}