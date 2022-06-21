import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:we_chat_app/data/vos/comment_vo/comment_vo.dart';
import 'package:we_chat_app/data/vos/favourite_vo/favourite_vo.dart';

part 'news_feed_vo.g.dart';

@JsonSerializable()
class NewsFeedVO {

  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "user_id")
  String? userId;

  @JsonKey(name: "description")
  String? description;

  @JsonKey(name: "file_type")
  String? fileType;

  @JsonKey(name: "post")
  String? post;

  @JsonKey(name: "user_name")
  String? userName;

  @JsonKey(name: "profile_image")
  String? profileImage;
  

  List<FavouriteVO>? favourites;

  bool? isLike;

  List<CommentVO>? comments;
  
  NewsFeedVO({
    this.id,
    this.userId,
    this.description,
    this.fileType,
    this.post,
    this.userName,
    this.profileImage,
    this.favourites,
    this.isLike,
    this.comments,
  });



    factory NewsFeedVO.fromJson(Map<String,dynamic> json) => _$NewsFeedVOFromJson(json);

    Map<String,dynamic> toJson() => _$NewsFeedVOToJson(this);


  @override
  String toString() {
    return 'NewsFeedVO(id: $id, userId: $userId, description: $description, fileType: $fileType, post: $post, userName: $userName, profileImage: $profileImage, favourites: $favourites, isLike: $isLike, comments: $comments)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is NewsFeedVO &&
      other.id == id &&
      other.userId == userId &&
      other.description == description &&
      other.fileType == fileType &&
      other.post == post &&
      other.userName == userName &&
      other.profileImage == profileImage &&
      listEquals(other.favourites, favourites) &&
      other.isLike == isLike &&
      listEquals(other.comments, comments);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      userId.hashCode ^
      description.hashCode ^
      fileType.hashCode ^
      post.hashCode ^
      userName.hashCode ^
      profileImage.hashCode ^
      favourites.hashCode ^
      isLike.hashCode ^
      comments.hashCode;
  }
}
