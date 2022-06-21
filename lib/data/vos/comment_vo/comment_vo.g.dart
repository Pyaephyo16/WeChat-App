// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentVO _$CommentVOFromJson(Map<String, dynamic> json) => CommentVO(
      comment: json['comment'] as String?,
      postId: json['post_id'] as String?,
      userId: json['user_id'] as String?,
      userName: json['user_name'] as String?,
    );

Map<String, dynamic> _$CommentVOToJson(CommentVO instance) => <String, dynamic>{
      'comment': instance.comment,
      'post_id': instance.postId,
      'user_id': instance.userId,
      'user_name': instance.userName,
    };
