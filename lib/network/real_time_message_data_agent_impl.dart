import 'package:firebase_database/firebase_database.dart';
import 'package:we_chat_app/data/vos/message_vo/message_vo.dart';
import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';
import 'package:we_chat_app/network/message_data_agent.dart';


  const String contactsAndMessagesCollection = "contactsAndMessages";

class RealTimeMessageDataAgentImpl extends MessageDataAgent{

  static final RealTimeMessageDataAgentImpl _singleton = RealTimeMessageDataAgentImpl._internal();

  factory RealTimeMessageDataAgentImpl(){
    return _singleton;
  }

  RealTimeMessageDataAgentImpl._internal();

  ///Real Time
  var firebase = FirebaseDatabase.instance.reference();
  

   
  @override
  void sendMessage(String loggedInUserId,String friendId,MessageVO message) {
     sendMessagePrepare(loggedInUserId, friendId, message);
      sendMessagePrepare(friendId,loggedInUserId,message);
  }
    

  Future<void> sendMessagePrepare(String loggedInUserId,String friendId,MessageVO message){
    return firebase
      .child(contactsAndMessagesCollection)
      .child(loggedInUserId.toString())
      .child(friendId.toString())
      .child(message.timeStamp.toString())
      .set(message.toJson());
  }
  
  @override
  Stream<List<MessageVO>> getAllMessage(String loggedInUserId,String friendId) {
    return firebase
        .child(contactsAndMessagesCollection)
        .child(loggedInUserId.toString())
        .child(friendId.toString())
        .onValue.map((event){
          return event.snapshot.children.map<MessageVO>((snapshot){
            return MessageVO.fromJson(Map<String,dynamic>.from(snapshot.value as Map));
          }).toList();
        });

  }
  
  @override
  Stream<List<String?>> getConversationUser(String loggedInUserId) {
    return firebase
      .child(contactsAndMessagesCollection)
      .child(loggedInUserId)
      .onValue
      .map((event){
        return event.snapshot.children.map((snapshot){
            return snapshot.key;
        }).toList();
      });

      // .get()
      // .then((value){
      //     return parseData(value);
      // });
  }

    // List<String> parseData(DataSnapshot snapshot){
    //     List<String> contacts = [];
    //     Map<String,dynamic> maps = Map<String,dynamic>.from(snapshot.value as Map);
      
    //     maps.keys.forEach((element) {
    //       contacts.add(element);
    //     });
    //     return contacts;
    // }
 

}