import 'dart:io';

import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';

abstract class AuthModel{

  Future<void> registerNewUser(UserVO user,File pickedFile);
  Future<void> loginUser(String email,String password);
  Future<UserVO> getLoggedInUser();
  bool isLoggedIn();
  Future<void> logout();

}