// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageVO _$MessageVOFromJson(Map<String, dynamic> json) => MessageVO(
      id: json['id'] as String?,
      timeStamp: json['time_stamp'] as String?,
      userName: json['user_name'] as String?,
      profileImge: json['profile_image'] as String?,
      message: json['mssage'] as String?,
      post: json['post'] as String?,
      fileType: json['file_type'] as String?,
    );

Map<String, dynamic> _$MessageVOToJson(MessageVO instance) => <String, dynamic>{
      'id': instance.id,
      'time_stamp': instance.timeStamp,
      'user_name': instance.userName,
      'profile_image': instance.profileImge,
      'mssage': instance.message,
      'post': instance.post,
      'file_type': instance.fileType,
    };
