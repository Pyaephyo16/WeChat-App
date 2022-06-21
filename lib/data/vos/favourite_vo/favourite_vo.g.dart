// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favourite_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavouriteVO _$FavouriteVOFromJson(Map<String, dynamic> json) => FavouriteVO(
      isLike: json['is_like'] as bool?,
      postId: json['post_id'] as String?,
      userId: json['user_id'] as String?,
      userName: json['user_name'] as String?,
    );

Map<String, dynamic> _$FavouriteVOToJson(FavouriteVO instance) =>
    <String, dynamic>{
      'is_like': instance.isLike,
      'post_id': instance.postId,
      'user_id': instance.userId,
      'user_name': instance.userName,
    };
