// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserVO _$UserVOFromJson(Map<String, dynamic> json) => UserVO(
      id: json['id'] as String?,
      userName: json['user_name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      password: json['password'] as String?,
      profileImage: json['profile_image'] as String?,
      fcm: json['fcm'] as String?,
      qrCode: json['qr_code'] as String?,
    );

Map<String, dynamic> _$UserVOToJson(UserVO instance) => <String, dynamic>{
      'id': instance.id,
      'user_name': instance.userName,
      'email': instance.email,
      'phone': instance.phone,
      'password': instance.password,
      'profile_image': instance.profileImage,
      'fcm': instance.fcm,
      'qr_code': instance.qrCode,
    };
