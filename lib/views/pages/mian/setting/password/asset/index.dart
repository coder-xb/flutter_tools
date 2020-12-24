import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import '../../../../../widgets/index.dart';

class AssetPassword extends StatefulWidget {
  final int type; // 类型 -- 1:设置，2:修改
  AssetPassword(this.type);
  @override
  _AssetPasswordState createState() => _AssetPasswordState();
}

class _AssetPasswordState extends State<AssetPassword> {
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
      backgroundColor: AppColor.c_FFFFFF,
      body: SafeArea(
        top: false,
        child: AppTap(
          onTap: () => Coms.unfocus(context),
          child: Column(
            children: <Widget>[
              _appBar(),
              Expanded(child: _body()),
              _button(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar() => MyAppBar(
        color: Colors.transparent,
        title: Text(I18n.of(context).$t('passwordAsset'),
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
                maxLength: 6,
                obscure: true,
                controller: _controller,
                formatter: [InpInt()],
                inputType: TextInputType.number,
                style: AppText.f15_w5_596373,
                placehoderStyle: AppText.f15_w5_A3ACBB,
                placehoder: I18n.of(context).$t('assetPasswordInput'),
                onInput: (String val) =>
                    setState(() => _canSubmit = val.length == 6),
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
                onComplete: _submit,
              ),
            ),
            _tips(),
          ],
        ),
      );

  Widget _tips() => Container(
        margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Text(
          I18n.of(context).$t('assetPasswordTips'),
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
        API.setting[widget.type == 1 ? 'set_asset' : 'change_asset'],
        data: {'asset_password': _controller.text},
      ).then((res) {
        _isClick = true;
        Navigator.of(context).pop();
        if (res.code == 0) {
          evbus.fire(RefreshSetting(true));
          Navigator.of(context).pop();
        }
      });
    }
  }
}
