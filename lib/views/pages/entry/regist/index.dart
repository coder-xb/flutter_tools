import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:rether/tools/index.dart';
import 'package:rether/core/index.dart';
import '../../../widgets/index.dart';
import 'verify.dart';

class Regist extends StatefulWidget {
  @override
  _RegistState createState() => _RegistState();
}

class _RegistState extends State<Regist> {
  FocusNode _emailNode;
  bool _canSubmit = false, _isClick = true;
  String _inviteCode = $SP.getString('inviteCode');
  TextEditingController _inviteController, _emailController;

  @override
  void initState() {
    super.initState();
    _emailNode = FocusNode();
    _emailController = TextEditingController();
    _inviteController = TextEditingController(text: _inviteCode);
  }

  @override
  void dispose() {
    _inviteController?.dispose();
    _emailController?.dispose();
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
              child: Column(children: <Widget>[_inputs(), _tips(), _button()]),
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

  Widget _inputs() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[_invite(), _email()],
      );

  Widget _invite() => Container(
        margin: EdgeInsets.only(bottom: 25),
        width: Screen.ins.setSize(295),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              I18n.of(context).$t('inviteCode'),
              style: AppText.f11_w5_A3ACBB,
            ),
            Input(
              horPadding: 0,
              verPadding: 12,
              disabled: _inviteCode != '',
              controller: _inviteController,
              placehoder: I18n.of(context).$t('inviteCodeInput'),
              placehoderStyle: AppText.f17_w5_A3ACBB,
              style: AppText.f17_w5_596373,
              onInput: (String val) => setState(() => _canSubmit =
                  (val != '' && Reg.isEmail(_emailController.text))),
              border: Border(
                bottom: BorderSide(
                  width: .5,
                  color: AppColor.c_626F81.withOpacity(.2),
                ),
              ),
              onComplete: () {
                if (_canSubmit) {
                  _submit();
                } else
                  FocusScope.of(context).requestFocus(_emailNode);
              },
            ),
          ],
        ),
      );

  Widget _email() => Container(
        margin: EdgeInsets.only(bottom: 12),
        width: Screen.ins.setSize(295),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              I18n.of(context).$t('email'),
              style: AppText.f11_w5_A3ACBB,
            ),
            Input(
              horPadding: 0,
              verPadding: 12,
              focusNode: _emailNode,
              controller: _emailController,
              placehoder: I18n.of(context).$t('emailInput'),
              placehoderStyle: AppText.f17_w5_A3ACBB,
              style: AppText.f17_w5_596373,
              inputType: TextInputType.emailAddress,
              border: Border(
                bottom: BorderSide(
                  width: .5,
                  color: AppColor.c_626F81.withOpacity(.2),
                ),
              ),
              onInput: (String val) => setState(() => _canSubmit =
                  (_inviteController.text != '' && Reg.isEmail(val))),
              onComplete: _submit,
            ),
          ],
        ),
      );

  Widget _tips() => Container(
        margin: EdgeInsets.only(bottom: 30),
        width: Screen.ins.setSize(295),
        child: Text(
          I18n.of(context).$t('recommendEmail'),
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

  void _reset() {
    _emailController?.clear();
    if ($SP.getString('invite') == '') _inviteController?.clear();
  }

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
      ).post(API.regist['step_1'], data: {
        'type': 'email',
        'email': _emailController.text,
        'invite_code': _inviteController.text,
      }).then((res) {
        _isClick = true;
        Navigator.of(context).pop();
        if (res.code == 0) {
          // 缓存InviteCode
          if (_inviteCode == '')
            $SP.setString('inviteCode', _inviteController.text);
          // 缓存email
          $SP.setString('email', _emailController.text);
          _reset();
          Navigator.of(context)
              .pushReplacement(CupertinoPageRoute(builder: (_) => Verify()));
        }
      });
    }
  }
}
