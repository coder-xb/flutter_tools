import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

import 'package:rether/tools/index.dart';
import 'package:rether/core/index.dart';
import '../../../widgets/index.dart';
import 'pwd.dart';

class Verify extends StatefulWidget {
  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  Timer _timer;
  int _seconds = 60;
  TextEditingController _controller;
  bool _available = true, _canSubmit = false, _isClick = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    Future.delayed(Duration.zero, _getCaptcha);
  }

  @override
  void dispose() {
    _timer?.cancel();
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
              child: Column(children: <Widget>[_captcha(), _tips(), _button()]),
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

  Widget _captcha() => Container(
        width: Screen.ins.setSize(295),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  I18n.of(context).$t('emailCaptcha'),
                  style: AppText.f11_w5_A3ACBB,
                ),
                AppTap(
                  onTap: () async {
                    ClipboardData _res = await Clipboard.getData('text/plain');
                    if (_res.text.length == 6) {
                      setState(() {
                        _controller.text = _res.text;
                        _canSubmit = _controller.text.length == 6;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      I18n.of(context).$t('paste'),
                      style: AppText.f12_w4_596373,
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              height: 60,
              child: CodeInput(
                controller: _controller,
                decoration: LineDecoration(
                  color: AppColor.c_E0E2E6,
                  enteredColor: AppColor.c_A3ACBB,
                  style:
                      AppText.f32_w4_3E5A87.copyWith(fontFamily: 'EncodeSans'),
                ),
                autoFocus: false,
                inputType: TextInputType.text,
                onInput: (String val) =>
                    setState(() => _canSubmit = val.length == 6),
                onComplete: _submit,
              ),
            ),
          ],
        ),
      );

  Widget _tips() => Container(
        margin:
            _available ? EdgeInsets.zero : EdgeInsets.fromLTRB(0, 25, 0, 30),
        width: Screen.ins.setSize(295),
        child: _available
            ? Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 25, 0, 30),
                    child: Text(I18n.of(context).$t('tryAgain'),
                        style: AppText.f11_w5_596373),
                  ),
                  AppTap(
                    onTap: _getCaptcha,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 25, 15, 30),
                      child: Text(I18n.of(context).$t('get'),
                          style: AppText.f11_w5_596C8B),
                    ),
                  ),
                ],
              )
            : Text(
                I18n.of(context).$t('authTips', params: {
                  'time': '${_seconds.toString().padLeft(2, '0')}s'
                }),
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
      data: {'email': $SP.getString('email')},
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
        builder: (_) => AppLoading('submiting'),
      );
      $Http(
        lang: $SP.getString('lang', def: 'en-us'),
      ).post(API.regist['step_2'], data: {
        'type': 'email',
        'email': $SP.getString('email'),
        'email_code': _controller.text,
      }).then((res) {
        _isClick = true;
        Navigator.of(context).pop();
        if (res.code == 0)
          Navigator.of(context)
              .pushReplacement(CupertinoPageRoute(builder: (_) => Password()));
      });
    }
  }
}
