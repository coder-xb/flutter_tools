import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import '../../../../widgets/index.dart';
import 'auth.dart';

class Google extends StatefulWidget {
  @override
  _GoogleState createState() => _GoogleState();
}

class _GoogleState extends State<Google> {
  Future _future;
  Map<String, dynamic> _data = Map<String, dynamic>();

  @override
  void initState() {
    super.initState();
    _future = _get();
    _future.then((res) {});
  }

  Future _get() async {
    HttpResponse _res = await $Http(
      token: $SP.getString('token'),
      lang: $SP.getString('lang', def: 'en-us'),
    ).get(API.setting['google_pre']);
    if (_res.code == 0) _data = _res.data;
    return _res.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    snapshot.hasData ? _body() : _loading(),
              ),
              //child: _body(),
            ),
            _button(),
          ],
        ),
      ),
    );
  }

  Widget _appBar() => MyAppBar(
        color: Colors.transparent,
        prefix: AppTap(
          onTap: () => Navigator.of(context).pop(),
          icon: Icon(AppIcon.back, size: 14, color: AppColor.c_2F3231),
        ),
        title:
            Text(I18n.of(context).$t('google'), style: AppText.f17_w6_151515),
      );

  Widget _loading() => ListView(
        padding: EdgeInsets.all(30),
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: AppColor.c_FFFFFF,
              borderRadius: BorderRadius.circular(15),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColor.c_000000.withOpacity(.05),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Container(
              width: Screen.ins.setSize(250),
              height: Screen.ins.setSize(250),
              child: AppLoading(
                'loading',
                type: LoadingType.widget,
                color: AppColor.c_596373,
                style: AppText.f12_w5_596373,
              ),
            ),
          ),
        ],
      );

  Widget _body() => ListView(
        padding: EdgeInsets.all(30),
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 30),
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: AppColor.c_FFFFFF,
              borderRadius: BorderRadius.circular(15),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColor.c_000000.withOpacity(.05),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              children: <Widget>[_qrImage(), _googleKey()],
            ),
          ),
          _copyBtn()
        ],
      );

  Widget _qrImage() => Container(
        width: Screen.ins.setSize(250),
        child: QrImage(
          data: _data['qrcode'],
          size: Screen.ins.setSize(250),
          foregroundColor: AppColor.c_596C8B,
          backgroundColor: AppColor.c_FFFFFF,
        ),
      );

  Widget _googleKey() => Container(
        margin: EdgeInsets.only(top: 20),
        child: Text(
          _data['secret'],
          style: AppText.f14_w6_596373.copyWith(height: 1.4),
          textAlign: TextAlign.center,
        ),
      );

  Widget _copyBtn() => Container(
        margin: EdgeInsets.all(30),
        child: AppTap(
          onTap: () => Coms.copy(context, _data['secret']),
          child: Container(
            height: 44,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: Text(
              I18n.of(context).$t('copyKey'),
              style: AppText.f15_w5_596373,
            ),
          ),
        ),
      );

  Widget _button() => Container(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: AppTap(
          onTap: () => Navigator.of(context).push(
            AuthRoute(
              child: GoogleAuth(
                secret: _data['secret'],
                callback: (bool success) {
                  if (success) {
                    evbus.fire(RefreshSetting(true));
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ),
          child: Container(
            height: 50,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: AppColor.c_596C8B,
              borderRadius: BorderRadius.circular(50),
            ),
            child:
                Text(I18n.of(context).$t('next'), style: AppText.f15_w7_FFFFFF),
          ),
        ),
      );
}
