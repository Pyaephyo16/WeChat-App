import 'package:json_annotation/json_annotation.dart';

part 'user_vo.g.dart';

@JsonSerializable()
class UserVO {

  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "user_name")
  String? userName;

  @JsonKey(name: "email")
  String? email;

  @JsonKey(name: "phone")
  String? phone;

  @JsonKey(name: "password")
  String? password;

  @JsonKey(name: "profile_image")
  String? profileImage;

  @JsonKey(name: "fcm")
  String? fcm;

  @JsonKey(name: "qr_code")
  String? qrCode;

  UserVO.empty();
  
  UserVO({
    this.id,
    this.userName,
    this.email,
    this.phone,
    this.password,
    this.profileImage,
    this.fcm,
    this.qrCode,
  });

  factory UserVO.fromJson(Map<String,dynamic> json) => _$UserVOFromJson(json);

  Map<String,dynamic> toJson() => _$UserVOToJson(this);

 

  @override
  String toString() {
    return 'UserVO(id: $id, userName: $userName, email: $email, phone: $phone, password: $password, profileImage: $profileImage, fcm: $fcm, qrCode: $qrCode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserVO &&
      other.id == id &&
      other.userName == userName &&
      other.email == email &&
      other.phone == phone &&
      other.password == password &&
      other.profileImage == profileImage &&
      other.fcm == fcm &&
      other.qrCode == qrCode;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      userName.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      password.hashCode ^
      profileImage.hashCode ^
      fcm.hashCode ^
      qrCode.hashCode;
  }
}
