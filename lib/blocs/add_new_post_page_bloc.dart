import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';
import 'package:we_chat_app/data/model/cloud_news_feed_model_impl.dart';
import 'package:we_chat_app/data/model/we_chat_model.dart';
import 'package:we_chat_app/data/vos/news_feed_vo/news_feed_vo.dart';

class AddNewPostPageBloc extends ChangeNotifier{

  File? pickedFile;
  String? fileType;
  FlickManager? manager;
  //String postDescription = "";
  bool isDisposed = false;
  bool isError = false;

  TextEditingController despController = TextEditingController();


    ///Edit Mode Variables
    bool isEditMode = false;
    String? editImageOrVideo;
    String userName = "";
    String profileImage = "";
    NewsFeedVO? newsFeedPostById;

  ///Model
  WeChatModel model = CloudNewsFeedModelImpl();


    AddNewPostPageBloc(int? idForEdit){
        if(idForEdit != null){
          isEditMode = true;
            prepopulateForEdit(idForEdit);
        }else{
          populateForNewPost();
        }
    }

    void populateForNewPost(){
        profileImage = "https://preview.keenthemes.com/metronic-v4/theme_rtl/assets/pages/media/profile/profile_user.jpg";
        userName = "Nina Rocha";
        _notifySafely();
    }

    void prepopulateForEdit(int idForEdit){
      model.getNewsFeedPostById(idForEdit).listen((event) {
            userName = event.userName ?? "";
            profileImage = event.profileImage ?? "";
            editImageOrVideo = event.post ?? "";
            fileType = event.fileType ?? "";
            //postDescription = event.description ?? "";
            despController.text = event.description ?? "";
            newsFeedPostById = event;
            print("edit get by id =====> $editImageOrVideo");
            _notifySafely();
      });
    }


  // void descriptionType(String text){
  //     postDescription = text;
  // }


  Future<File?> fileChosen(File chooseFile,String type){
    print("file path add post bloc ===================> ${chooseFile.path}");
    print("file extension add post bloc===================> ${type}");
    pickedFile = chooseFile;
    fileType = type;
    if(type == "mp4"){
       manager = FlickManager(videoPlayerController: VideoPlayerController.file(chooseFile),autoPlay: false);
    }
    editImageOrVideo = null;
    _notifySafely();
    return Future.value(pickedFile);
  }

   void deleteChosenPhoto(){
    pickedFile = null;
    fileType = null;
    manager = null;
    editImageOrVideo = null;
    _notifySafely();
  }

  Future<void> tapPostButton(){
    if(despController.text.isEmpty){
      isError = true;
      _notifySafely();
      return Future.error("error");
    }else{
      if(isEditMode){
      return editedDataPost();
      }else{
        return addPost();
      }
    }
  }

  Future<void> editedDataPost(){
      newsFeedPostById?.description = despController.text;
      newsFeedPostById?.fileType = fileType;
      newsFeedPostById?.post = editImageOrVideo ?? pickedFile?.path.toString();
        if(editImageOrVideo == null){
           return model.editPost(newsFeedPostById!,true);
        }else{
           return model.editPost(newsFeedPostById!,false);
        }
  }


  Future<void> addPost(){
    //return model.addNewPost(postDescription,pickedFile,fileType);
    return model.addNewPost(despController.text,pickedFile,fileType);
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
    manager?.dispose();
  }

}