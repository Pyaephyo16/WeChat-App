import 'package:json_annotation/json_annotation.dart';

part 'message_vo.g.dart';

@JsonSerializable()
class MessageVO {

  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "time_stamp")
  String? timeStamp;

  @JsonKey(name: "user_name")
  String? userName;

  @JsonKey(name: "profile_image")
  String? profileImge;

  @JsonKey(name: "mssage")
  String? message;

  @JsonKey(name: "post")
  String? post;

  @JsonKey(name: "file_type")
  String? fileType;
  
  MessageVO({
    this.id,
    this.timeStamp,
    this.userName,
    this.profileImge,
    this.message,
    this.post,
    this.fileType,
  });
  
  
    factory MessageVO.fromJson(Map<String,dynamic> json) => _$MessageVOFromJson(json);

    Map<String,dynamic> toJson() => _$MessageVOToJson(this);

  @override
  String toString() {
    return 'MessageVO(id: $id, timeStamp: $timeStamp, userName: $userName, profileImge: $profileImge, message: $message, post: $post, fileType: $fileType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is MessageVO &&
      other.id == id &&
      other.timeStamp == timeStamp &&
      other.userName == userName &&
      other.profileImge == profileImge &&
      other.message == message &&
      other.post == post &&
      other.fileType == fileType;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      timeStamp.hashCode ^
      userName.hashCode ^
      profileImge.hashCode ^
      message.hashCode ^
      post.hashCode ^
      fileType.hashCode;
  }
}
