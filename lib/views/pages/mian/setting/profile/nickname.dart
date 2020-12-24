import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import '../../../../widgets/index.dart';

class Nickname extends StatefulWidget {
  final String nickname;
  Nickname(this.nickname);
  @override
  _NicknameState createState() => _NicknameState();
}

class _NicknameState extends State<Nickname> {
  bool _canSubmit = true, _isClick = true;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.nickname);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.c_FFFFFF,
      body: SafeArea(
        top: false,
        child: AppTap(
          onTap: () => Coms.unfocus(context),
          child: Column(
            children: <Widget>[_appBar(), _body(), _button()],
          ),
        ),
      ),
    );
  }

  Widget _appBar() => MyAppBar(
        color: Colors.transparent,
        title:
            Text(I18n.of(context).$t('nickname'), style: AppText.f17_w6_151515),
        prefix: AppTap(
          onTap: () => Navigator.of(context).pop(),
          icon: Icon(AppIcon.back, size: 14, color: AppColor.c_2F3231),
        ),
      );

  Widget _body() => Expanded(
        child: Container(
          margin: EdgeInsets.only(top: 8),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: AppColor.c_FFFFFF,
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
                  onComplete: _submit,
                  controller: _controller,
                  onInput: (String val) =>
                      setState(() => _canSubmit = val != ''),
                  style: AppText.f15_w5_596373,
                  placehoderStyle: AppText.f15_w5_A3ACBB,
                  inputType: TextInputType.text,
                  placehoder: I18n.of(context).$t('nicknameInput'),
                  suffix: _canSubmit
                      ? AppTap(
                          onTap: () => setState(() {
                            _controller.clear();
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
              ),
            ],
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
                Text(I18n.of(context).$t('done'), style: AppText.f15_w7_FFFFFF),
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
        builder: (_) => AppLoading('submiting'),
      );
      $Http(
        token: $SP.getString('token'),
        lang: $SP.getString('lang', def: 'en-us'),
      ).post(
        API.setting['nickname'],
        data: {'nickname': _controller.text},
      ).then((res) {
        _isClick = true;
        Navigator.of(context).pop();
        if (res.code == 0) {
          Provider.of<ProfileState>(context, listen: false)
              .setNickname(_controller.text);
          Navigator.of(context).pop();
        }
      });
    }
  }
}
