import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';
import 'package:we_chat_app/dummy/dummy_data.dart';

class ConservationPageBloc extends ChangeNotifier{

List<MessageDummyVO> messagesDummy = convsersationDummyList;
  bool isDisposed = false;

   String userText = "";
   bool isAddTap = false;
   //File? cameraPhoto;
   File? pickedFile;
   String? fileType;
  FlickManager? manager;
  final TextEditingController msgController = TextEditingController();


  void onTextChanged(String text){
    userText = text;
    _notifySafely();
  }

  void tapAdd(){
    isAddTap = !isAddTap;
    _notifySafely();
  }

  // void cameraImageChosen(File cameraImage){
  //   print("camera image path conservation bloc ===================> ${cameraImage.path}");
  //   cameraPhoto = cameraImage;
  //   pickedFile = null;
  //   _notifySafely();
  // }

  void fileChosen(File chooseFile,String type){
    print("file path conservation bloc ===================> ${chooseFile.path}");
     print("file extension add post bloc===================> ${type}");
    pickedFile = chooseFile;
    //cameraPhoto = null;
    fileType = type;
    if(type == "mp4"){
      manager = FlickManager(videoPlayerController: VideoPlayerController.file(chooseFile),autoPlay: false);
       print("flick manager check =============> $manager");
    }
    _notifySafely();
  }

  void deleteChosenPhoto(){
    //cameraPhoto = null;
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