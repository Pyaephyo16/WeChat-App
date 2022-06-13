import 'package:flutter/foundation.dart';
import 'package:we_chat_app/data/model/auth_model.dart';
import 'package:we_chat_app/data/model/auth_model_impl.dart';
import 'package:we_chat_app/data/model/cloud_news_feed_model_impl.dart';
import 'package:we_chat_app/data/model/we_chat_model.dart';
import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';

class MeTabBloc extends ChangeNotifier{

  UserVO? loggedInUser;
  bool isDisposed = false;

  //Auth
  AuthModel authModel = AuthModelImpl();

  //Model
  WeChatModel model = CloudNewsFeedModelImpl();


  MeTabBloc(){

      authModel.getLoggedInUser().then((value){
          model.getUserById(value.id ?? "").listen((event) {
              loggedInUser = event;
              _notifySafely();
          });
      });

  }


  Future<void> logout(){
    return authModel.logout();
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