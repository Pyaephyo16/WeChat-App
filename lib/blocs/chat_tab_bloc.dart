import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:we_chat_app/data/model/auth_model.dart';
import 'package:we_chat_app/data/model/auth_model_impl.dart';
import 'package:we_chat_app/data/model/cloud_news_feed_model_impl.dart';
import 'package:we_chat_app/data/model/message_model.dart';
import 'package:we_chat_app/data/model/messgae_model_impl.dart';
import 'package:we_chat_app/data/model/we_chat_model.dart';
import 'package:we_chat_app/data/vos/chat_history_vo.dart';
import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';
import 'package:we_chat_app/dummy/dummy_data.dart';

class ChatTabBloc extends ChangeNotifier{

 List<UserDummyVO> usersDummy = userDummyList;

 UserVO? loggedInUser;
 List<ChatHistoryVO> chatHistory = [];
  List<ChatHistoryVO> temp = [];
 bool isDisposed = false;

    ///Model
  WeChatModel model = CloudNewsFeedModelImpl();

  //Message Model
  MessageModel msgModel = MessageModelImpl();


  ///Model
  WeChatModel weChatModel = CloudNewsFeedModelImpl();

  ///Auth
  AuthModel auth = AuthModelImpl();

  ChatTabBloc(){

      auth.getLoggedInUser().then((value){
          weChatModel.getUserById(value.id ?? "").listen((event) {
              loggedInUser = event;
               chatHistory.clear();
             temp.clear();
               getAllFriendData(value);
              _notifySafely();
          });
      });
  }

  void getAllFriendData(UserVO value) {
    msgModel.getConversationUser(value.id ?? "").listen((event){
           print("conversation friend id list ====> $event");
          chatHistory.clear();
          temp.clear();
          _notifySafely();
        event.forEach((element) {
            weChatModel.getUserById(element!).listen((friend){
              msgModel.getAllMessage(value.id ?? "",element).listen((data) {
                  temp.add(
                      ChatHistoryVO(
                        friendId: element,
                        friend: friend,
                        messages: data,
                        ),
                  );
        chatHistory = temp;
        print("check history  length ===> ${chatHistory.length}");
        _notifySafely();
            });
            });
        });
    });
  }


  void remoteUser(String friendId,UserVO user){
    msgModel.deleteConservationUser(loggedInUser?.id ?? "", friendId);
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