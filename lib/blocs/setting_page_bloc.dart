import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:we_chat_app/utils/shared_preference.dart';

class SettingPageBloc extends ChangeNotifier{

  ThemeMode chooseTheme = ThemeMode.light;

  SettingPageBloc(){

    SharedPref.getData(key: "theme").then((value){
        if(value != null){
          if(value == "dark"){
        chooseTheme = ThemeMode.dark;
        notifyListeners();
      }else{
        chooseTheme = ThemeMode.light;
        notifyListeners();
      }
        }
    });

  }
  
  void changeTheme(bool isOn){
    if(isOn == true){
      chooseTheme = ThemeMode.dark;
      SharedPref.saveData(key: "theme", value: "dark");
      notifyListeners();
    }else{
      chooseTheme = ThemeMode.light;
      SharedPref.saveData(key: "theme", value: "light");
      notifyListeners();
    }
    print("change theme result ==========> ${chooseTheme}");
  }

}