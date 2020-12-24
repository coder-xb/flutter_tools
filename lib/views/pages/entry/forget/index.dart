import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:rether/tools/index.dart';
import 'package:rether/core/index.dart';
import '../../../widgets/index.dart';
import 'verify.dart';

class Forget extends StatefulWidget {
  @override
  _ForgetState createState() => _ForgetState();
}

class _ForgetState extends State<Forget> {
  bool _canSubmit = false, _isClick = true;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.c_596373,
      body: AppTap(
        onTap: () => Coms.unfocus(context),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_main.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Stack(children: <Widget>[_title(), _content()]),
        ),
      ),
    );
  }

  Widget _title() => Column(
        children: <Widget>[
          _appBar(),
          Container(
            margin: EdgeInsets.only(top: 80),
            child: Image.asset('assets/images/icon_textlogo.png', width: 120),
          ),
        ],
      );

  Widget _content() => Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: AppColor.c_FFFFFF,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Container(
              padding: EdgeInsets.only(top: 50),
              margin: EdgeInsets.only(bottom: 10),
              child: Column(children: <Widget>[_account(), _tips(), _button()]),
            ),
          ),
        ),
      );

  Widget _appBar() => MyAppBar(
        height: Screen.ins.setSize(44),
        color: Colors.transparent,
        prefix: AppTap(
          icon: Icon(
            AppIcon.back,
            size: 14,
            color: AppColor.c_FFFFFF,
          ),
          onTap: () => Navigator.of(context).pop(),
        ),
      );

  Widget _account() => Container(
        margin: EdgeInsets.only(bottom: 12),
        width: Screen.ins.setSize(295),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              I18n.of(context).$t('account'),
              style: AppText.f11_w5_A3ACBB,
            ),
            Input(
              horPadding: 0,
              verPadding: 12,
              controller: _controller,
              placehoder: I18n.of(context).$t('accountInput'),
              placehoderStyle: AppText.f17_w5_A3ACBB,
              inputType: TextInputType.emailAddress,
              style: AppText.f17_w5_596373,
              border: Border(
                bottom: BorderSide(
                  width: .5,
                  color: AppColor.c_626F81.withOpacity(.2),
                ),
              ),
              onInput: (String val) => setState(() => _canSubmit = val != ''),
              onComplete: _submit,
            ),
          ],
        ),
      );

  Widget _tips() => Container(
        margin: EdgeInsets.only(bottom: 30),
        width: Screen.ins.setSize(295),
        child: Text(
          I18n.of(context).$t('forgetTips'),
          style: AppText.f11_w5_596373,
        ),
      );

  Widget _button() => AppTap(
        onTap: _submit,
        child: Container(
          height: 50,
          alignment: Alignment.center,
          width: Screen.ins.setSize(295),
          decoration: BoxDecoration(
            color: _canSubmit ? AppColor.c_596C8B : AppColor.c_B7BEC9,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            I18n.of(context).$t('next'),
            style: AppText.f16_w7_FFFFFF,
          ),
        ),
      );

  void _submit() {
    Coms.unfocus(context);
    if (_canSubmit && _isClick) {
      _isClick = false;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AppLoading('loading'),
      );
      $Http(
        lang: $SP.getString('lang', def: 'en-us'),
      ).post(API.forget['step_1'], data: {
        'uid': _controller.text,
      }).then((res) {
        _isClick = true;
        Navigator.of(context).pop();
        if (res.code == 0) {
          // 缓存UID
          $SP.setString('uid', _controller.text);
          Navigator.of(context).pushReplacement(
              CupertinoPageRoute(builder: (_) => Verify(res.data['email'])));
        }
      });
    }
  }
}
