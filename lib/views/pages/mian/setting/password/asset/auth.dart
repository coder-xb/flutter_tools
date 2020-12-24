import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import '../../../../../widgets/index.dart';

class AssetAuthModel {
  bool googleAuth, assetAuth, phoneAuth, emailAuth;
  String authCode, email, phone, phoneCode;

  AssetAuthModel({
    this.email, // 邮箱
    this.phone, // 手机
    this.authCode, // 认证标识
    this.phoneCode, // 手机区号
    this.assetAuth, // 是否开启密码验证
    this.phoneAuth, // 是否开启手机验证
    this.emailAuth, // 是否开启邮箱验证
    this.googleAuth, // 是否开启谷歌验证
  });

  factory AssetAuthModel.fromJson(Map<String, dynamic> json) {
    bool _emailAuth = json['email_auth'] != null, // 邮箱验证
        _phoneAuth = json['phone_auth'] != null, // 手机验证
        _googleAuth = json['google_auth'] != null, // 谷歌验证
        _assetAuth = json['asset_password_auth'] != null; // 资产密码验证

    return AssetAuthModel(
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

class AssetAuth extends StatefulWidget {
  final String email;
  final ValueChanged<bool> callback;
  final bool isGoogle, isEmail;
  AssetAuth({
    Key key,
    this.email,
    this.callback,
    this.isEmail = false, // 邮箱验证
    this.isGoogle = true, // 谷歌验证
  }) : super(key: key);
  @override
  _AssetAuthState createState() => _AssetAuthState();
}

class _AssetAuthState extends State<AssetAuth> {
  Timer _timer;
  int _seconds = 60;
  TextEditingController _emailController, _googleController;
  bool _available = true, _canSubmit = false, _isClick = true;

  @override
  void initState() {
    if (widget.isEmail) Future.delayed(Duration.zero, _getCaptcha);
    _emailController = TextEditingController();
    _googleController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: <Widget>[
          Expanded(
            child: AppTap(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColor.c_FFFFFF,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: SafeArea(
              top: false,
              child: AppTap(
                onTap: () => Coms.unfocus(context),
                child: Column(children: <Widget>[_input(), _button()]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _input() => Container(
        padding: EdgeInsets.only(top: 30, bottom: 10),
        child: Column(
          children: <Widget>[
            Text(
              I18n.of(context).$t('safetyAuth'),
              style: AppText.f18_w5_596373,
            ),
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  widget.isEmail ? _email() : Coms.empty,
                  widget.isGoogle ? _google() : Coms.empty,
                ],
              ),
            ),
          ],
        ),
      );

  /// 邮箱验证
  Widget _email() => Container(
        margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      I18n.of(context).$t('emailAuth'),
                      style: AppText.f14_w4_596373,
                    ),
                  ),
                  AppTap(
                    onTap: () async {
                      ClipboardData _res =
                          await Clipboard.getData('text/plain');
                      if (_res.text.length == 6) {
                        setState(() {
                          _emailController.text = _res.text;
                          if (widget.isGoogle) {
                            _canSubmit = _googleController.text.length == 6;
                          } else
                            _canSubmit = true;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        I18n.of(context).$t('paste'),
                        style: AppText.f14_w4_596373,
                      ),
                    ),
                  )
                ],
              ),
            ),
            _available
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(I18n.of(context).$t('tryAgain'),
                            style: AppText.f11_w4_A3ACBB),
                      ),
                      AppTap(
                        onTap: _getCaptcha,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 15, 8),
                          child: Text(I18n.of(context).$t('get'),
                              style: AppText.f11_w5_596C8B),
                        ),
                      ),
                    ],
                  )
                : Container(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      I18n.of(context).$t('authTips', params: {
                        'time': '${_seconds.toString().padLeft(2, '0')}s'
                      }),
                      style: AppText.f11_w4_A3ACBB,
                    ),
                  ),
            Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: CodeInput(
                decoration: LooseDecoration(
                  size: 0,
                  space: 5,
                  color: AppColor.c_E0E2E6,
                  bgColor: AppColor.c_F1F2F4,
                  radius: Radius.circular(5),
                  style:
                      AppText.f32_w4_3E5A87.copyWith(fontFamily: 'EncodeSans'),
                ),
                autoFocus: false,
                controller: _emailController,
                inputType: TextInputType.text,
                onInput: (String val) => setState(() {
                  if (widget.isGoogle) {
                    _canSubmit =
                        (val.length == 6 && _googleController.text.length == 6);
                  } else
                    _canSubmit = val.length == 6;
                }),
              ),
            ),
          ],
        ),
      );

  /// 谷歌验证
  Widget _google() => Container(
        margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      I18n.of(context).$t('googleAuth'),
                      style: AppText.f14_w4_596373,
                    ),
                  ),
                  AppTap(
                    onTap: () async {
                      ClipboardData _res =
                          await Clipboard.getData('text/plain');
                      if (_res.text.length == 6) {
                        setState(() {
                          _googleController.text = _res.text;
                          if (widget.isEmail) {
                            _canSubmit = _emailController.text.length == 6;
                          } else
                            _canSubmit = true;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        I18n.of(context).$t('paste'),
                        style: AppText.f14_w4_596373,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: CodeInput(
                decoration: LooseDecoration(
                  size: 0,
                  space: 5,
                  color: AppColor.c_E0E2E6,
                  bgColor: AppColor.c_F1F2F4,
                  radius: Radius.circular(5),
                  style:
                      AppText.f32_w4_3E5A87.copyWith(fontFamily: 'EncodeSans'),
                ),
                autoFocus: false,
                controller: _googleController,
                inputType: TextInputType.text,
                onInput: (String val) => setState(() {
                  if (widget.isEmail) {
                    _canSubmit =
                        (val.length == 6 && _emailController.text.length == 6);
                  } else
                    _canSubmit = val.length == 6;
                }),
              ),
            )
          ],
        ),
      );

  Widget _button() => Container(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: AppTap(
          onTap: _submit,
          child: Container(
            height: 50,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: _canSubmit ? AppColor.c_596C8B : AppColor.c_B7BEC9,
              borderRadius: BorderRadius.circular(50),
            ),
            child:
                Text(I18n.of(context).$t('auth'), style: AppText.f15_w7_FFFFFF),
          ),
        ),
      );
  void _getCaptcha() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AppLoading('loading'),
    );
    $Http(
      lang: $SP.getString('lang', def: 'en-us'),
    ).post(
      API.auth['email'],
      data: {'email': widget.email},
    ).then((res) {
      Navigator.of(context).pop();
      if (res.code == 0) {
        _seconds = res.data['interval_time'];
        _startTimer();
      }
    });
  }

  void _startTimer() {
    _available = false;
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (_seconds == 1) {
        _resetTimer();
        return;
      }
      setState(() => _seconds--);
    });
  }

  void _resetTimer() {
    setState(() {
      _timer?.cancel();
      _seconds = 60;
      _available = true;
    });
  }

  void _submit() {
    Coms.unfocus(context);
    if (_canSubmit && _isClick) {
      _isClick = false;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AppLoading('authing'),
      );
      $Http(
        token: $SP.getString('token'),
        lang: $SP.getString('lang', def: 'en-us'),
      ).post(API.setting['check_auth'], data: {
        'sms_code': '',
        'email_code': _emailController.text,
        'google_code': _googleController.text,
      }).then((res) {
        _isClick = true;
        Navigator.of(context).pop();
        if (res.code == 0) _callback(true);
      });
    }
  }

  void _callback(bool suc) {
    Navigator.of(context).pop();
    if (widget.callback != null) widget.callback(suc);
  }
}
