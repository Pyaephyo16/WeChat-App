import 'package:json_annotation/json_annotation.dart';

import 'package:we_chat_app/data/vos/user_vo/user_vo.dart';

part 'favourite_vo.g.dart';

@JsonSerializable()
class FavouriteVO {

  @JsonKey(name: "is_like")
  bool? isLike;

  @JsonKey(name: "post_id")
  String? postId;

  @JsonKey(name: "user_id")
  String? userId;

  @JsonKey(name: "user_name")
  String? userName;

  FavouriteVO.empty();

  FavouriteVO({
    this.isLike,
    this.postId,
    this.userId,
    this.userName,
  });

      factory FavouriteVO.fromJson(Map<String,dynamic> json) => _$FavouriteVOFromJson(json);

    Map<String,dynamic> toJson() => _$FavouriteVOToJson(this);



  @override
  String toString() {
    return 'FavouriteVO(isLike: $isLike, postId: $postId, userId: $userId, userName: $userName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is FavouriteVO &&
      other.isLike == isLike &&
      other.postId == postId &&
      other.userId == userId &&
      other.userName == userName;
  }

  @override
  int get hashCode {
    return isLike.hashCode ^
      postId.hashCode ^
      userId.hashCode ^
      userName.hashCode;
  }
}
