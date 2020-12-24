import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import '../../../../widgets/index.dart';

/// 谷歌验证
class GoogleAuth extends StatefulWidget {
  final String secret;
  final ValueChanged<bool> callback;
  GoogleAuth({
    Key key,
    this.callback,
    @required this.secret,
  }) : super(key: key);
  @override
  _GoogleAuthState createState() => _GoogleAuthState();
}

class _GoogleAuthState extends State<GoogleAuth> {
  TextEditingController _controller;
  bool _isClick = true, _canSubmit = false;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
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
                          _controller.text = _res.text;
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
            Text(
              I18n.of(context).$t('googleAuth'),
              style: AppText.f18_w5_596373,
            ),
            _google(),
          ],
        ),
      );

  /// 谷歌验证
  Widget _google() => Container(
        margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
        child: Container(
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: CodeInput(
            decoration: LooseDecoration(
              size: 0,
              space: 5,
              color: AppColor.c_E0E2E6,
              bgColor: AppColor.c_F1F2F4,
              radius: Radius.circular(5),
              style: AppText.f32_w4_3E5A87.copyWith(fontFamily: 'EncodeSans'),
            ),
            controller: _controller,
            autoFocus: false,
            inputType: TextInputType.text,
            onInput: (String val) => setState(() {
              _canSubmit = val.length == 6;
            }),
          ),
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

  void _submit() {
    if (_isClick && _canSubmit) {
      _isClick = false;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AppLoading('submiting'),
      );
      $Http(
        token: $SP.getString('token'),
        lang: $SP.getString('lang', def: 'en-us'),
      ).post(API.setting['google'], data: {
        'google_code': _controller.text,
        'google_secret': widget.secret,
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
