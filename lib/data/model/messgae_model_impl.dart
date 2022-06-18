import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:we_chat_app/data/model/message_model.dart';
import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';
import 'package:we_chat_app/data/vos/message_vo/message_vo.dart';
import 'package:we_chat_app/network/cloud_news_feed_data_agent_impl.dart';
import 'package:we_chat_app/network/message_data_agent.dart';
import 'package:we_chat_app/network/real_time_message_data_agent_impl.dart';
import 'package:we_chat_app/network/we_chat_data_agent.dart';

class MessageModelImpl extends MessageModel{

  static final MessageModelImpl _singleton = MessageModelImpl._internal();

  factory MessageModelImpl(){
    return _singleton;
  }

  MessageModelImpl._internal();

  ///DataAgent
  MessageDataAgent messageDataAgent = RealTimeMessageDataAgentImpl();

    //Other Model
  WeChatDataAgent dataAgent = CloudNewsFeedDataAgentImpl();

  @override
  void sendMessage(String loggedInUserId,String friendId,MessageVO message,File? pickedFile,String? fileType){
    if(pickedFile != null && fileType != null){
      dataAgent
      .uploadFileToFirebaseStorage(pickedFile)
      .then((downloadUrl) => prepareMessage(message, downloadUrl, fileType))
      .then((messageData) => messageDataAgent.sendMessage(loggedInUserId,friendId,messageData));
    }else{
    messageDataAgent.sendMessage(loggedInUserId, friendId, message);
    }
  }

  Future<MessageVO> prepareMessage(MessageVO message,String downloadUrl,String fileType){
    MessageVO messageData =  MessageVO(
        id: message.id,
        timeStamp: message.timeStamp,
        userName: message.userName,
        profileImge: message.profileImge,
        message: message.message,
        post: downloadUrl,
        fileType: fileType,
       );
      return Future.value(messageData);
  }
  
  @override
  Stream<List<MessageVO>> getAllMessage(String loggedInUserId, String friendId) {
    return messageDataAgent.getAllMessage(loggedInUserId, friendId);
  }
  
  @override
  Stream<List<String?>> getConversationUser(String loggedInUserId) {
    return messageDataAgent.getConversationUser(loggedInUserId);
  }
  
  @override
  void deleteConservationUser(String loggedInUserId, String friendId) {
    messageDataAgent.deleteConservationUser(loggedInUserId, friendId);
  }
  

}