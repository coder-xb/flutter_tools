import 'package:oktoast/oktoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import '../../../../widgets/index.dart';
import 'package:rether/views/pages/index.dart';

class LoginPassword extends StatefulWidget {
  @override
  _LoginPasswordState createState() => _LoginPasswordState();
}

class _LoginPasswordState extends State<LoginPassword> {
  bool _canSubmit = false, _isClick = true;
  FocusNode _newNode, _confirmNode;
  TextEditingController _oldController, _newController, _confirmController;

  @override
  void initState() {
    super.initState();
    _confirmNode = FocusNode();
    _oldController = TextEditingController();
    _newController = TextEditingController();
    _confirmController = TextEditingController();
  }

  @override
  void dispose() {
    _oldController?.dispose();
    _newController?.dispose();
    _confirmController?.dispose();
    super.dispose();
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
            Expanded(child: _body()),
            _button(),
          ],
        ),
      ),
    );
  }

  Widget _appBar() => MyAppBar(
        color: Colors.transparent,
        title: Text(I18n.of(context).$t('passwordLogin'),
            style: AppText.f17_w6_151515),
        prefix: AppTap(
          onTap: () => Navigator.of(context).pop(),
          icon: Icon(AppIcon.back, size: 14, color: AppColor.c_2F3231),
        ),
      );

  Widget _body() => Container(
        margin: EdgeInsets.only(top: 8),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[_oldPassword(), _newPassword(), _tips()],
        ),
      );

  Widget _oldPassword() => Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColor.c_000000.withOpacity(.05),
              blurRadius: 20,
            ),
          ],
        ),
        child: Input(
          horPadding: 20,
          verPadding: 16,
          obscure: true,
          style: AppText.f15_w5_596373,
          controller: _oldController,
          inputType: TextInputType.visiblePassword,
          placehoderStyle: AppText.f15_w5_A3ACBB,
          onInput: (String val) => setState(() => _canSubmit =
              (_newController.text.length > 5 &&
                  _confirmController.text.length > 5 &&
                  val.length > 5)),
          placehoder: I18n.of(context).$t('enterOldPasswprd'),
          onComplete: () {
            if (_canSubmit) {
              _submit();
            } else
              FocusScope.of(context).requestFocus(_newNode);
          },
          suffix: _oldController.text.length > 5
              ? AppTap(
                  onTap: () => setState(() {
                    _oldController.clear();
                    _canSubmit = false;
                  }),
                  icon: Icon(
                    AppIcon.error,
                    size: 16,
                    color: AppColor.c_A3ACBB,
                  ),
                )
              : null,
        ),
      );

  Widget _newPassword() => Container(
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: AppColor.c_FFFFFF,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColor.c_000000.withOpacity(.05),
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Input(
              horPadding: 20,
              verPadding: 16,
              obscure: true,
              focusNode: _newNode,
              controller: _newController,
              style: AppText.f15_w5_596373,
              placehoderStyle: AppText.f15_w5_A3ACBB,
              inputType: TextInputType.visiblePassword,
              placehoder: I18n.of(context).$t('enterNewPasswprd'),
              onInput: (String val) => setState(() => _canSubmit =
                  (_oldController.text.length > 5 &&
                      _confirmController.text.length > 5 &&
                      val.length > 5)),
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
                  FocusScope.of(context).requestFocus(_confirmNode);
              },
              suffix: _newController.text.length > 5
                  ? AppTap(
                      onTap: () => setState(() {
                        _newController.clear();
                        _canSubmit = false;
                      }),
                      icon: Icon(
                        AppIcon.error,
                        size: 16,
                        color: AppColor.c_A3ACBB,
                      ),
                    )
                  : null,
            ),
            Input(
              horPadding: 20,
              verPadding: 16,
              obscure: true,
              focusNode: _confirmNode,
              controller: _confirmController,
              style: AppText.f15_w5_596373,
              inputType: TextInputType.visiblePassword,
              placehoderStyle: AppText.f15_w5_A3ACBB,
              placehoder: I18n.of(context).$t('confirmNewPasswprd'),
              onInput: (String val) => setState(() => _canSubmit =
                  (_oldController.text.length > 5 &&
                      _newController.text.length > 5 &&
                      val.length > 5)),
              suffix: _confirmController.text.length > 5
                  ? AppTap(
                      onTap: () => setState(() {
                        _confirmController.clear();
                        _canSubmit = false;
                      }),
                      icon: Icon(
                        AppIcon.error,
                        size: 16,
                        color: AppColor.c_A3ACBB,
                      ),
                    )
                  : null,
              onComplete: _submit,
            ),
          ],
        ),
      );

  Widget _tips() => Container(
        margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Text(
          I18n.of(context).$t('loginPasswordTips'),
          style: AppText.f13_w4_596373,
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
                Text(I18n.of(context).$t('done'), style: AppText.f15_w7_FFFFFF),
          ),
        ),
      );

  void _submit() {
    Coms.unfocus(context);
    if (_canSubmit) {
      if (_newController.text == _confirmController.text) {
        if (_isClick) {
          _isClick = false;
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AppLoading('submiting'),
          );
          $Http(
            token: $SP.getString('token'),
            lang: $SP.getString('lang', def: 'en-us'),
          ).post(
            API.setting['change_login'],
            data: {
              'old_password': _oldController.text,
              'new_password': _newController.text,
            },
          ).then((res) {
            _isClick = true;
            Navigator.of(context).pop();
            if (res.code == 0) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => AppDialog(
                  type: DialogType.warning,
                  text: I18n.of(context).$t('loginPasswordSuccesss'),
                  complete: () {
                    $SP.remove('token');
                    Navigator.of(context).pushAndRemoveUntil(
                      CupertinoPageRoute(builder: (_) => Index()),
                      (r) => r == null,
                    );
                  },
                ),
              );
            }
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
