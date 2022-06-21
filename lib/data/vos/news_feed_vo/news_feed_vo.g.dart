// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_feed_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsFeedVO _$NewsFeedVOFromJson(Map<String, dynamic> json) => NewsFeedVO(
      id: json['id'] as int?,
      userId: json['user_id'] as String?,
      description: json['description'] as String?,
      fileType: json['file_type'] as String?,
      post: json['post'] as String?,
      userName: json['user_name'] as String?,
      profileImage: json['profile_image'] as String?,
      favourites: (json['favourites'] as List<dynamic>?)
          ?.map((e) => FavouriteVO.fromJson(e as Map<String, dynamic>))
          .toList(),
      isLike: json['isLike'] as bool?,
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => CommentVO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NewsFeedVOToJson(NewsFeedVO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'description': instance.description,
      'file_type': instance.fileType,
      'post': instance.post,
      'user_name': instance.userName,
      'profile_image': instance.profileImage,
      'favourites': instance.favourites,
      'isLike': instance.isLike,
      'comments': instance.comments,
    };
