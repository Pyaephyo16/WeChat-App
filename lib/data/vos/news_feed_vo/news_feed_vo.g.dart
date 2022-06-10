// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_feed_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsFeedVO _$NewsFeedVOFromJson(Map<String, dynamic> json) => NewsFeedVO(
      id: json['id'] as int?,
      description: json['description'] as String?,
      fileType: json['file_type'] as String?,
      post: json['post'] as String?,
      userName: json['user_name'] as String?,
      profileImage: json['profile_image'] as String?,
    );

Map<String, dynamic> _$NewsFeedVOToJson(NewsFeedVO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'file_type': instance.fileType,
      'post': instance.post,
      'user_name': instance.userName,
      'profile_image': instance.profileImage,
    };
