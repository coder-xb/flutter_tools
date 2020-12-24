import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info/package_info.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import '../../../widgets/index.dart';
import 'google/index.dart';
import 'others/index.dart';
import 'profile/index.dart';
import 'password/index.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  Future _future;
  AuthModel _auth;
  SettingModel _setting;
  String _ver = '1.1.32';
  StreamSubscription _refreshSubscription;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _future = _get();
    Future.delayed(Duration.zero, () {
      PackageInfo.fromPlatform().then((PackageInfo info) {
        setState(() => _ver = info.version);
      });
    });
    _refreshSubscription = evbus.on<RefreshSetting>().listen((ev) {
      if (ev.refresh)
        setState(() {
          _future = _get();
        });
    });
  }

  @override
  void dispose() {
    _refreshSubscription?.cancel();
    super.dispose();
  }

  Future<SettingModel> _get() async {
    print(I18n.of(context).$t(''));
    HttpResponse _res = await $Http(
      token: $SP.getString('token'),
      lang: $SP.getString('lang', def: 'en-us'),
    ).get(API.setting['index']);
    if (_res.code == 0) {
      _auth = AuthModel.fromJson(_res.data['safe_auth']);
      _setting = SettingModel.fromJson(
        google: _res.data['google_auth'] as bool,
        asset: _res.data['asset_password'] as bool,
      );
    }

    return _setting;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Coms.openDrawer(_key),
      child: Scaffold(
        key: _key,
        drawer: AppDrawer(),
        backgroundColor: AppColor.c_FFFFFF,
        body: SafeArea(
          top: false,
          child: Column(
            children: <Widget>[
              _appBar(),
              Expanded(
                child: FutureBuilder(
                  future: _future,
                  builder: (BuildContext context, AsyncSnapshot snapshot) =>
                      snapshot.hasData ? _widget(model: _setting) : _widget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar() => MyAppBar(
        color: Colors.transparent,
        title:
            Text(I18n.of(context).$t('setting'), style: AppText.f17_w6_151515),
        prefix: AppTap(
          onTap: () => _key.currentState.openDrawer(),
          icon: Icon(AppIcon.menu, size: 14, color: AppColor.c_2F3231),
        ),
      );

  Widget _widget({SettingModel model}) => Container(
        margin: EdgeInsets.only(top: 8),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _avatar(),
            _base(model: model),
            _full(),
            _button(),
          ],
        ),
      );

  Widget _avatar() => SetTile(
        onTap: () => Navigator.of(context).push(
          CupertinoPageRoute(builder: (_) => Profile()),
        ),
        height: 76,
        shadow: <BoxShadow>[
          BoxShadow(
            color: AppColor.c_000000.withOpacity(.05),
            blurRadius: 20,
          ),
        ],
        padding: EdgeInsets.symmetric(horizontal: 20),
        prefix: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(48),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppColor.c_000000.withOpacity(.1),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: ClipOval(
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: (Provider.of<ProfileState>(context)
                          .model
                          .avatar
                          .isNotEmpty)
                      ? FadeImg.assetNetwork(
                          image:
                              Provider.of<ProfileState>(context).model.avatar,
                          imageScale: 2,
                          fit: BoxFit.cover,
                          placeholder: 'assets/images/icon_avatar.png',
                        )
                      : Image.asset(
                          'assets/images/icon_avatar.png',
                          scale: 2,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(Provider.of<ProfileState>(context).model.nickname,
                    style: AppText.f15_w6_596373),
                Container(
                  margin: EdgeInsets.only(top: 4),
                  child: Text(
                    'UID: ${Provider.of<ProfileState>(context).model.uid}',
                    style: AppText.f13_w5_A3ACBB,
                  ),
                ),
              ],
            ),
          ],
        ),
        suffix:
            Text(I18n.of(context).$t('change'), style: AppText.f13_w4_A3ACBB),
        suffixIcon: Icon(AppIcon.next, size: 12, color: AppColor.c_A3ACBB),
      );

  Widget _base({SettingModel model}) => Container(
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColor.c_000000.withOpacity(.05),
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            _email(),
            _google(sets: model != null ? model.google : false),
            _assetPwd(sets: model != null ? model.asset : false),
            _loginPwd(),
          ],
        ),
      );

  Widget _full({ProfileState state}) => Container(
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColor.c_000000.withOpacity(.05),
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            _currency(),
            _language(),
            _version(),
          ],
        ),
      );

  Widget _email({ProfileState state}) => SetTile(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 20),
        prefix:
            Text(I18n.of(context).$t('setEmail'), style: AppText.f15_w5_596373),
        suffix: Text(Coms.email(Provider.of<ProfileState>(context).model.email),
            style: AppText.f13_w4_A3ACBB),
      );

  Widget _google({bool sets = false}) => SetTile(
        onTap: () => _toGoogle(!sets),
        height: 50,
        border: Border(
          top: BorderSide(
            width: .5,
            color: AppColor.c_626F81.withOpacity(.2),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20),
        prefix:
            Text(I18n.of(context).$t('google'), style: AppText.f15_w5_596373),
        suffix: Text(
            (sets ? I18n.of(context).$t('bound') : I18n.of(context).$t('bind')),
            style: AppText.f13_w4_A3ACBB),
        suffixIcon: Icon(AppIcon.next, size: 12, color: AppColor.c_A3ACBB),
      );

  Widget _assetPwd({bool sets = false}) => SetTile(
        onTap: () => _toAsset(!sets),
        height: 50,
        border: Border(
          top: BorderSide(
            width: .5,
            color: AppColor.c_626F81.withOpacity(.2),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20),
        prefix: Text(I18n.of(context).$t('passwordAsset'),
            style: AppText.f15_w5_596373),
        suffix: Text(I18n.of(context).$t(sets ? 'change' : 'notSet'),
            style: AppText.f13_w4_A3ACBB),
        suffixIcon: Icon(AppIcon.next, size: 12, color: AppColor.c_A3ACBB),
      );

  Widget _loginPwd() => SetTile(
        onTap: _toLogin,
        height: 50,
        border: Border(
          top: BorderSide(
            width: .5,
            color: AppColor.c_626F81.withOpacity(.2),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20),
        prefix: Text(I18n.of(context).$t('passwordLogin'),
            style: AppText.f15_w5_596373),
        suffix:
            Text(I18n.of(context).$t('change'), style: AppText.f13_w4_A3ACBB),
        suffixIcon: Icon(AppIcon.next, size: 12, color: AppColor.c_A3ACBB),
      );

  Widget _currency() => SetTile(
        onTap: () => Navigator.of(context).push(
          CupertinoPageRoute(builder: (_) => Currency()),
        ),
        height: 50,
        border: Border(
          top: BorderSide(
            width: .5,
            color: AppColor.c_626F81.withOpacity(.2),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20),
        prefix:
            Text(I18n.of(context).$t('currency'), style: AppText.f15_w5_596373),
        suffix: Text(Provider.of<AppState>(context).currency,
            style: AppText.f13_w4_A3ACBB),
        suffixIcon: Icon(AppIcon.next, size: 12, color: AppColor.c_A3ACBB),
      );

  Widget _language() => SetTile(
        onTap: () => Navigator.of(context).push(
          CupertinoPageRoute(builder: (_) => Language()),
        ),
        height: 50,
        border: Border(
          top: BorderSide(
            width: .5,
            color: AppColor.c_626F81.withOpacity(.2),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20),
        prefix:
            Text(I18n.of(context).$t('language'), style: AppText.f15_w5_596373),
        suffix: Text(I18n.of(context).$t(Provider.of<AppState>(context).spLang),
            style: AppText.f13_w4_A3ACBB),
        suffixIcon: Icon(AppIcon.next, size: 12, color: AppColor.c_A3ACBB),
      );

  Widget _version() => SetTile(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 20),
        border: Border(
          top: BorderSide(
            width: .5,
            color: AppColor.c_626F81.withOpacity(.2),
          ),
        ),
        prefix:
            Text(I18n.of(context).$t('version'), style: AppText.f15_w5_596373),
        suffix: Text('v$_ver', style: AppText.f13_w4_A3ACBB),
      );

  Widget _button() => Container(
        margin: EdgeInsets.fromLTRB(40, 40, 40, 0),
        child: AppTap(
          onTap: () => Coms.logout(context),
          child: Container(
            height: 50,
            alignment: Alignment.center,
            width: Screen.ins.setSize(295),
            decoration: BoxDecoration(
              color: AppColor.c_FFFFFF,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColor.c_000000.withOpacity(.05),
                  blurRadius: 20,
                ),
              ],
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              I18n.of(context).$t('signout'),
              style: AppText.f16_w7_FF7B76,
            ),
          ),
        ),
      );

  /// 去设置谷歌验证
  void _toGoogle(bool set) {
    if (set) {
      if (!_auth.assetAuth && !_auth.emailAuth && !_auth.googleAuth) {
        Navigator.of(context).push(
          CupertinoPageRoute(builder: (_) => Google()),
        );
      } else {
        Navigator.of(context).push(
          AuthRoute(
            child: SafeAuth(
              email: _auth.email,
              code: _auth.authCode,
              isAsset: _auth.assetAuth,
              isEmail: _auth.emailAuth,
              isGoogle: _auth.googleAuth,
              callback: (bool success) {
                if (success)
                  Navigator.of(context).push(
                    CupertinoPageRoute(builder: (_) => Google()),
                  );
              },
            ),
          ),
        );
      }
    }
  }

  /// 去设置(修改)资产密码
  void _toAsset(bool set) {
    if (set) {
      if (!_auth.assetAuth && !_auth.emailAuth && !_auth.googleAuth) {
        Navigator.of(context).push(
          CupertinoPageRoute(builder: (_) => AssetPassword(1)),
        );
      } else {
        Navigator.of(context).push(
          AuthRoute(
            child: SafeAuth(
              email: _auth.email,
              code: _auth.authCode,
              isAsset: _auth.assetAuth,
              isEmail: _auth.emailAuth,
              isGoogle: _auth.googleAuth,
              callback: (bool success) {
                if (success)
                  Navigator.of(context).push(
                    CupertinoPageRoute(builder: (_) => AssetPassword(1)),
                  );
              },
            ),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AppLoading('loading'),
      );
      $Http(
        token: $SP.getString('token'),
        lang: $SP.getString('lang', def: 'en-us'),
      ).get(API.setting['get_auths']).then((res) {
        Navigator.of(context).pop();
        if (res.code == 0) {
          AssetAuthModel _model = AssetAuthModel.fromJson(res.data);
          if (!_model.assetAuth && !_model.emailAuth && !_model.googleAuth) {
            Navigator.of(context).push(
              CupertinoPageRoute(builder: (_) => AssetPassword(2)),
            );
          } else {
            Navigator.of(context).push(
              AuthRoute(
                child: AssetAuth(
                  email: _model.email,
                  isEmail: _model.emailAuth,
                  isGoogle: _model.googleAuth,
                  callback: (bool suc) {
                    if (suc) {
                      Navigator.of(context).push(
                        CupertinoPageRoute(builder: (_) => AssetPassword(2)),
                      );
                    }
                  },
                ),
              ),
            );
          }
        }
      });
    }
  }

  /// 去修改登录密码
  void _toLogin() {
    if (!_auth.assetAuth && !_auth.emailAuth && !_auth.googleAuth) {
      Navigator.of(context).push(
        CupertinoPageRoute(builder: (_) => LoginPassword()),
      );
    } else {
      Navigator.of(context).push(
        AuthRoute(
          child: SafeAuth(
            email: _auth.email,
            code: _auth.authCode,
            isAsset: _auth.assetAuth,
            isEmail: _auth.emailAuth,
            isGoogle: _auth.googleAuth,
            callback: (bool success) {
              if (success)
                Navigator.of(context).push(
                  CupertinoPageRoute(builder: (_) => LoginPassword()),
                );
            },
          ),
        ),
      );
    }
  }
}
