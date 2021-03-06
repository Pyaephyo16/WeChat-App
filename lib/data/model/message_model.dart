import 'dart:io';

import 'package:we_chat_app/data/vos/message_vo/message_vo.dart';
import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';

abstract class MessageModel{

 void sendMessage(String loggedInUserId,String friendId,MessageVO message,File? pickedFile,String? fileType);
 Stream<List<MessageVO>> getAllMessage(String loggedInUserId,String friendId);
 Stream<List<String?>> getConversationUser(String loggedInUserId);
  void deleteConservationUser(String loggedInUserId,String friendId);
}