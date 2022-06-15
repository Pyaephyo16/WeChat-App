import 'package:flutter/foundation.dart';

import 'package:we_chat_app/data/vos/message_vo/message_vo.dart';
import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';

class ChatHistoryVO {

    String? friendId;
    UserVO? friend;
    List<MessageVO> messages = [];
    
  ChatHistoryVO({
    this.friendId,
    this.friend,
    required this.messages,
  });
    

  @override
  String toString() => 'ChatHistoryVO(friendId: $friendId, friend: $friend, messages: $messages)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ChatHistoryVO &&
      other.friendId == friendId &&
      other.friend == friend &&
      listEquals(other.messages, messages);
  }

  @override
  int get hashCode => friendId.hashCode ^ friend.hashCode ^ messages.hashCode;
}
