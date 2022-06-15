import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:we_chat_app/data/model/message_model.dart';
import 'package:we_chat_app/data/model/messgae_model_impl.dart';
import 'package:we_chat_app/data/vos/message_vo/message_vo.dart';
import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';
import 'package:we_chat_app/dummy/dummy_data.dart';

class ConservationPageBloc extends ChangeNotifier{

  //List<MessageDummyVO> messagesDummy = convsersationDummyList;
  bool isDisposed = false;

  List<MessageVO>? messageList;

   String userText = "";
   bool isAddTap = false;
   File? pickedFile;
   String? fileType;
  FlickManager? manager;

  final TextEditingController msgController = TextEditingController();

    ///Model
    MessageModel model = MessageModelImpl();

  ConservationPageBloc(UserVO loggedInUser,UserVO friend){
    print("conver bloc =========> ${loggedInUser.id} ${friend.id}");
      model.getAllMessage(loggedInUser.id ?? "",friend.id ?? "").listen((event) {
          messageList = event;
          _notifySafely();
      });

  }


  void onTextChanged(String text){
    userText = text;
    _notifySafely();
  }

  void tapAdd(){
    isAddTap = !isAddTap;
    _notifySafely();
  }


    sendMessage(UserVO loggedInUser,UserVO friend,{required Function emptyCallBack}){
      print("loggedin user profile ============> ${loggedInUser.profileImage}");
       print("friend user profile ============> ${loggedInUser.profileImage}");
      if(msgController.text.isNotEmpty || pickedFile != null){
          var time = DateTime.now().microsecondsSinceEpoch;
       MessageVO message = MessageVO(
        id: loggedInUser.id,
        timeStamp: time.toString(),
        userName: loggedInUser.userName,
        profileImge: loggedInUser.profileImage,
        message: msgController.text,
        post: "",
        fileType: "",
       );
       print("message ===========> $message");
      model.sendMessage(loggedInUser.id ?? "", friend.id ?? "", message,pickedFile,fileType);
      msgController.clear();
      if(pickedFile != null){
        pickedFile = null;
        _notifySafely();
      }
      }else{
        emptyCallBack();
      }
    }



  void fileChosen(File chooseFile,String type){
    print("file path conservation bloc ===================> ${chooseFile.path}");
     print("file extension add post bloc===================> ${type}");
    pickedFile = chooseFile;
    isAddTap = !isAddTap;
    fileType = type;
    if(type == "mp4"){
      manager = FlickManager(videoPlayerController: VideoPlayerController.file(chooseFile),autoPlay: false);
       print("flick manager check =============> $manager");
    }
    _notifySafely();
  }

  void deleteChosenPhoto(){
    pickedFile = null;
    fileType = null;
    manager = null;
    _notifySafely();
  }


  _notifySafely(){
    if(!isDisposed){
      notifyListeners();
    }
  }

  @override
  void dispose() {
    msgController.dispose();
    super.dispose();
    isDisposed = true;
  }

}