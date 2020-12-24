import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:rether/tools/index.dart';
import 'package:rether/core/index.dart';
import '../../widgets/index.dart';
import '../index.dart';
import '../mian/index.dart';
import 'forget/index.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FocusNode _passwordNode;
  bool _canSubmit = false, _isClick = true;
  TextEditingController _accountController, _passwordController;

  @override
  void initState() {
    super.initState();
    _passwordNode = FocusNode();
    _passwordController = TextEditingController();
    _accountController = TextEditingController(text: $SP.getString('uid'));
  }

  @override
  void dispose() {
    _passwordController?.dispose();
    _accountController?.dispose();
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
              child: Column(
                children: <Widget>[_inputs(), _loginButton(), _forgetButton()],
              ),
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
          onTap: () => Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(builder: (_) => Index()),
            (r) => r == null,
          ),
        ),
      );

  Widget _inputs() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[_account(), _password()],
      );

  Widget _account() => Container(
        margin: EdgeInsets.only(bottom: 25),
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
              controller: _accountController,
              placehoderStyle: AppText.f17_w5_A3ACBB,
              placehoder: I18n.of(context).$t('accountInput'),
              style: AppText.f17_w5_596373,
              inputType: TextInputType.emailAddress,
              border: Border(
                bottom: BorderSide(
                  width: .5,
                  color: AppColor.c_626F81.withOpacity(.2),
                ),
              ),
              onInput: (String val) {
                setState(() => _canSubmit =
                    (val != '' && _passwordController.text.length > 5));
                if (val != '') $SP.remove('uid');
              },
              onComplete: () {
                if (_canSubmit) {
                  _login();
                } else
                  FocusScope.of(context).requestFocus(_passwordNode);
              },
            ),
          ],
        ),
      );

  Widget _password() => Container(
        margin: EdgeInsets.only(bottom: 35),
        width: Screen.ins.setSize(295),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              I18n.of(context).$t('password'),
              style: AppText.f11_w5_A3ACBB,
            ),
            Input(
              horPadding: 0,
              verPadding: 12,
              focusNode: _passwordNode,
              controller: _passwordController,
              placehoder: I18n.of(context).$t('passwordInput'),
              placehoderStyle: AppText.f17_w5_A3ACBB,
              style: AppText.f17_w5_596373,
              obscure: true,
              inputType: TextInputType.visiblePassword,
              border: Border(
                bottom: BorderSide(
                  width: .5,
                  color: AppColor.c_626F81.withOpacity(.2),
                ),
              ),
              onInput: (String val) => setState(() => _canSubmit =
                  (_accountController.text != '' && val.length > 5)),
              onComplete: _login,
            ),
          ],
        ),
      );

  Widget _loginButton() => AppTap(
        onTap: _login,
        child: Container(
          height: 50,
          alignment: Alignment.center,
          width: Screen.ins.setSize(295),
          decoration: BoxDecoration(
            color: _canSubmit ? AppColor.c_596C8B : AppColor.c_B7BEC9,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            I18n.of(context).$t('login'),
            style: AppText.f16_w7_FFFFFF,
          ),
        ),
      );

  Widget _forgetButton() => Container(
        margin: EdgeInsets.only(top: 10),
        child: AppTap(
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(builder: (_) => Forget()),
          ),
          child: Container(
            height: 44,
            alignment: Alignment.center,
            width: Screen.ins.setSize(295),
            color: Colors.transparent,
            child: Text(
              I18n.of(context).$t('forget'),
              style: AppText.f14_w7_596373,
            ),
          ),
        ),
      );

  void _login() {
    Coms.unfocus(context);
    if (_canSubmit && _isClick) {
      _isClick = false;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AppLoading('logining'),
      );
      $Http(
        lang: $SP.getString('lang', def: 'en-us'),
      ).post(API.login, data: {
        'account': _accountController.text,
        'password': _passwordController.text,
      }).then((res) {
        _isClick = true;
        Navigator.of(context).pop();
        if (res.code == 0) {
          $SP.setString('lang', res.data['lang']);
          $SP.setString('token', res.data['token']);
          $SP.remove('uid');
          Provider.of<AppState>(context, listen: false)
              .setLang(res.data['lang']);
          Provider.of<AppState>(context, listen: false)
              .setCurrency(res.data['currency']);
          Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(builder: (_) => Home()),
            (r) => r == null,
          );
        }
      });
    }
  }
}
