import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:we_chat_app/data/model/auth_model.dart';
import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';
import 'package:we_chat_app/fcm/fcm_service.dart';
import 'package:we_chat_app/network/cloud_news_feed_data_agent_impl.dart';
import 'package:we_chat_app/network/we_chat_data_agent.dart';

class AuthModelImpl extends AuthModel{

  static final AuthModelImpl _singleton = AuthModelImpl._internal();

  factory AuthModelImpl(){
    return _singleton;
  }

  WeChatDataAgent dataAgent = CloudNewsFeedDataAgentImpl();



  AuthModelImpl._internal();
  
  @override
  Future<void> registerNewUser(UserVO user,File pickedFile) {
      return dataAgent
        .uploadFileToFirebaseStorage(pickedFile)
        .then((downloadUrl) => registerUserData(user, downloadUrl))
        .then((newUser) => dataAgent.registerNewUser(newUser));
  }


  Future<UserVO> registerUserData(UserVO user,String profileImage)async{
    String fcm =await FCMService().getFCMToken();
    UserVO registerData = UserVO(
      id: "",
      userName: user.userName,
      email: user.email,
      phone: user.phone,
      password: user.password,
      profileImage: profileImage,
      fcm: fcm,
      qrCode: "",
    );
    return Future.value(registerData);
  }

  
  @override
  Future<void> loginUser(String email, String password) {
    return dataAgent.loginUser(email, password);
  }

  @override
  Future<UserVO> getLoggedInUser() {
    return dataAgent.getLoggedInUser();
  }

  @override
  bool isLoggedIn() {
    return dataAgent.isLoggedIn();
  }

  @override
  Future<void> logout() {
   return dataAgent.logout();
  }

}