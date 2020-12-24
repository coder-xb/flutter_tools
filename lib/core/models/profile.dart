class ProfileModel {
  String uid, avatar, nickname, email, phone, phoneCode;
  ProfileModel({
    this.uid,
    this.email,
    this.phone,
    this.avatar,
    this.nickname,
    this.phoneCode,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        uid: json['uid'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        avatar: json['avatar'] as String,
        nickname: json['nickname'] as String,
        phoneCode: json['phone_code'] as String,
      );
}

class SettingModel {
  bool asset, google;
  SettingModel({
    this.asset,
    this.google,
  });

  factory SettingModel.fromJson({bool asset, bool google}) =>
      SettingModel(asset: asset, google: google);
}
