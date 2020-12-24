import 'package:oktoast/oktoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:rether/tools/index.dart';
import 'package:rether/core/index.dart';
import '../../../widgets/index.dart';
import '../login.dart';
import 'dialog.dart';

class Password extends StatefulWidget {
  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  FocusNode _confirmNode;
  bool _canSubmit = false, _isClick = true;
  TextEditingController _controller, _confirmController;

  @override
  void initState() {
    super.initState();
    _confirmNode = FocusNode();
    _controller = TextEditingController();
    _confirmController = TextEditingController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _confirmController?.dispose();
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
        children: <Widget>[_password(), _confirm()],
      );

  Widget _password() => Container(
        margin: EdgeInsets.only(bottom: 25),
        width: Screen.ins.setSize(295),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              I18n.of(context).$t('loginPassword'),
              style: AppText.f11_w5_A3ACBB,
            ),
            Input(
              horPadding: 0,
              verPadding: 12,
              obscure: true,
              controller: _controller,
              placehoder: I18n.of(context).$t('passwordInput'),
              placehoderStyle: AppText.f17_w5_A3ACBB,
              style: AppText.f17_w5_596373,
              inputType: TextInputType.visiblePassword,
              border: Border(
                bottom: BorderSide(
                  width: .5,
                  color: AppColor.c_626F81.withOpacity(.2),
                ),
              ),
              onInput: (String val) => setState(() => _canSubmit =
                  (val.length > 5 && _confirmController.text.length > 5)),
              onComplete: () {
                if (_canSubmit) {
                  _submit();
                } else
                  FocusScope.of(context).requestFocus(_confirmNode);
              },
            ),
          ],
        ),
      );

  Widget _confirm() => Container(
        margin: EdgeInsets.only(bottom: 12),
        width: Screen.ins.setSize(295),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              I18n.of(context).$t('confirmPassword'),
              style: AppText.f11_w5_A3ACBB,
            ),
            Input(
              horPadding: 0,
              verPadding: 12,
              obscure: true,
              focusNode: _confirmNode,
              controller: _confirmController,
              placehoder: I18n.of(context).$t('passwordConfirm'),
              placehoderStyle: AppText.f17_w5_A3ACBB,
              style: AppText.f17_w5_596373,
              inputType: TextInputType.visiblePassword,
              border: Border(
                bottom: BorderSide(
                  width: .5,
                  color: AppColor.c_626F81.withOpacity(.2),
                ),
              ),
              onInput: (String val) => setState(() =>
                  _canSubmit = (_controller.text.length > 5 && val.length > 5)),
              onComplete: _submit,
            ),
          ],
        ),
      );

  Widget _tips() => Container(
        margin: EdgeInsets.only(bottom: 30),
        width: Screen.ins.setSize(295),
        child: Text(
          I18n.of(context).$t('loginPasswordTips'),
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
    if (_canSubmit) {
      if (_controller.text == _confirmController.text) {
        if (_isClick) {
          _isClick = false;
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AppLoading('submiting'),
          );
          $Http(lang: $SP.getString('lang', def: 'en-us'))
              .post(API.regist['step_3'], data: {
            'type': 'email',
            'email': $SP.getString('email'),
            'password': _controller.text,
            'invite_code': $SP.getString('inviteCode'),
          }).then((res) {
            _isClick = true;
            Navigator.of(context).pop();
            if (res.code == 0)
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => SignDialog(
                  uid: res.data['uid'],
                  complete: () {
                    Provider.of<AppState>(context, listen: false)
                        .setLang(res.data['lang']);
                    Provider.of<AppState>(context, listen: false)
                        .setCurrency(res.data['currency']);
                    $SP.setString('uid', res.data['uid']);
                    $SP.setString('lang', res.data['lang']);
                    $SP.remove('email');
                    $SP.remove('inviteCode');
                    Navigator.of(context).pushAndRemoveUntil(
                      CupertinoPageRoute(builder: (_) => Login()),
                      (r) => r == null,
                    );
                  },
                ),
              );
          });
        }
      } else
        showToast(
          I18n.of(context).$t('passwordDiff'),
          onDismiss: () => FocusScope.of(context).requestFocus(_confirmNode),
        );
    }
  }
}
