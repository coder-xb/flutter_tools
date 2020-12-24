class AuthModel {
  bool googleAuth, assetAuth, phoneAuth, emailAuth;
  String authCode, email, phone, phoneCode;

  AuthModel({
    this.email, // 邮箱
    this.phone, // 手机
    this.authCode, // 认证标识
    this.phoneCode, // 手机区号
    this.assetAuth, // 是否开启密码验证
    this.phoneAuth, // 是否开启手机验证
    this.emailAuth, // 是否开启邮箱验证
    this.googleAuth, // 是否开启谷歌验证
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    bool _emailAuth = json['email_auth'] != null, // 邮箱验证
        _phoneAuth = json['phone_auth'] != null, // 手机验证
        _googleAuth = json['google_auth'] != null, // 谷歌验证
        _assetAuth = json['asset_password_auth'] != null; // 资产密码验证

    return AuthModel(
      emailAuth: _emailAuth,
      assetAuth: _assetAuth,
      phoneAuth: _phoneAuth,
      googleAuth: _googleAuth,
      authCode: json['auth_code'] as String,
      email: _emailAuth ? json['email_auth']['email'] as String : '',
      phone: _phoneAuth ? json['phone_auth']['phone'] as String : '',
      phoneCode: _phoneAuth ? json['phone_auth']['phone_code'] as String : '',
    );
  }
}
