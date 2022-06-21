import 'package:json_annotation/json_annotation.dart';

part 'comment_vo.g.dart';

@JsonSerializable()
class CommentVO {

  @JsonKey(name: "comment")
  String? comment;

  @JsonKey(name: "post_id")
  String? postId;

  @JsonKey(name: "user_id")
  String? userId;

  @JsonKey(name: "user_name")
  String? userName;

  CommentVO.empty();
  
  CommentVO({
    this.comment,
    this.postId,
    this.userId,
    this.userName,
  });

        factory CommentVO.fromJson(Map<String,dynamic> json) => _$CommentVOFromJson(json);

    Map<String,dynamic> toJson() => _$CommentVOToJson(this);


  @override
  String toString() {
    return 'CommentVO(comment: $comment, postId: $postId, userId: $userId, userName: $userName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CommentVO &&
      other.comment == comment &&
      other.postId == postId &&
      other.userId == userId &&
      other.userName == userName;
  }

  @override
  int get hashCode {
    return comment.hashCode ^
      postId.hashCode ^
      userId.hashCode ^
      userName.hashCode;
  }
}
