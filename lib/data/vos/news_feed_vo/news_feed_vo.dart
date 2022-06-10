import 'package:json_annotation/json_annotation.dart';

part 'news_feed_vo.g.dart';

@JsonSerializable()
class NewsFeedVO {

  @JsonKey(name: "id")
  int? id;

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
  
  NewsFeedVO({
    this.id,
    this.description,
    this.fileType,
    this.post,
    this.userName,
    this.profileImage,
  });

    factory NewsFeedVO.fromJson(Map<String,dynamic> json) => _$NewsFeedVOFromJson(json);

    Map<String,dynamic> toJson() => _$NewsFeedVOToJson(this);

  @override
  String toString() {
    return 'NewsFeedVO(id: $id, description: $description, fileType: $fileType, post: $post, userName: $userName, profileImage: $profileImage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is NewsFeedVO &&
      other.id == id &&
      other.description == description &&
      other.fileType == fileType &&
      other.post == post &&
      other.userName == userName &&
      other.profileImage == profileImage;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      description.hashCode ^
      fileType.hashCode ^
      post.hashCode ^
      userName.hashCode ^
      profileImage.hashCode;
  }
}
