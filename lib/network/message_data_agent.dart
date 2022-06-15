import 'package:we_chat_app/data/vos/message_vo/message_vo.dart';
import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';

abstract class MessageDataAgent{

  void sendMessage(String loggedInUserId,String friendId,MessageVO message);
  Stream<List<MessageVO>> getAllMessage(String loggedInUserId,String friendId);

  Future<List<String>> getConversationUser(String loggedInUserId);
}