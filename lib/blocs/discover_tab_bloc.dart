import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:we_chat_app/data/model/auth_model.dart';
import 'package:we_chat_app/data/model/auth_model_impl.dart';
import 'package:we_chat_app/data/model/cloud_news_feed_model_impl.dart';
import 'package:we_chat_app/data/model/we_chat_model.dart';
import 'package:we_chat_app/data/vos/news_feed_vo/news_feed_vo.dart';
import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';
import 'package:we_chat_app/dummy/dummy_data.dart';

class DiscoverTabBloc extends ChangeNotifier{

  //List<UserDummyVO> usersDummy = userDummyList;

  String comment = "";
  bool isDisposed = false;
  List<NewsFeedVO>? newsFeedList;
  UserVO? loggedInUser;

  ///Model
  WeChatModel model = CloudNewsFeedModelImpl();

  ///Auth 
  AuthModel authModel = AuthModelImpl();

  DiscoverTabBloc(){

      authModel.getLoggedInUser().then((value){
          model.getUserById(value.id ?? "").listen((event) {
              loggedInUser = event;
              _notifySafely();
          });
      });

    model.getAllPost().listen((event){
        newsFeedList = event;
        _notifySafely();
    });

  }

  commentedChanged(String text){
    comment = text;
    print("coment in bloc =======> $comment");
    _notifySafely();
  }


    Future<void> deletePost(int postId)async{
      await model.deletePost(postId);
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