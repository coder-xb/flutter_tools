import 'dart:ui';
import 'package:html/dom.dart' as dom;
import 'package:oktoast/oktoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import '../../../../widgets/index.dart';

class Send extends StatefulWidget {
  @override
  _SendState createState() => _SendState();
}

class _SendState extends State<Send> {
  Future _future;
  double _fee = 0, _max = 0, _min = 0;
  int _sendType = 1; // 提币类型 1-外部，2-内部
  AssetSendModel _model;
  FocusNode _addressNode, _gasNode;
  bool _addressCorrect = false, // 地址是否有效
      _canSubmit = false, // 是否可提交
      _isClick = true;
  TextEditingController _amountController, _addressController, _gasController;

  @override
  void initState() {
    super.initState();
    _future = _get();
    _gasNode = FocusNode();
    _addressNode = FocusNode();
    _gasController = TextEditingController();
    _amountController = TextEditingController();
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    _gasController?.dispose();
    _amountController?.dispose();
    _addressController?.dispose();
    super.dispose();
  }

  Future<AssetSendModel> _get() async {
    HttpResponse _res = await $Http(
      token: $SP.getString('token'),
      lang: $SP.getString('lang', def: 'en-us'),
    ).get(API.wallet['withdraw_pre']);
    if (_res.code == 0) {
      _model = AssetSendModel.fromJson(_res.data);
      _fee = double.parse(_sendType == 1 ? _model.outFee : _model.inFee);
      _max = double.parse(_sendType == 1 ? _model.outMax : _model.inMax);
      _min = double.parse(_sendType == 1 ? _model.outMin : _model.inMin);
    }
    return _model;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.c_FFFFFF,
      body: AppTap(
        onTap: () => Coms.unfocus(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: <Widget>[
              _appBar(),
              Expanded(
                child: FutureBuilder(
                  future: _future,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListView(
                        padding: EdgeInsets.all(20),
                        children: <Widget>[
                          Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              _body(),
                              _model.open ? Coms.empty : _mask(),
                            ],
                          ),
                          _tips(),
                        ],
                      );
                    } else
                      return _loading();
                  },
                ),
              ),
              _button(),
            ],
          ),
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
        title: Text(I18n.of(context).$t('sendCoin', params: {'coin': 'ETH'}),
            style: AppText.f17_w6_151515),
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

  Widget _mask() => ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Opacity(
            opacity: .6,
            child: Container(
              color: AppColor.c_FFFFFF,
              width: Screen.ins.setSize(300),
              height: Screen.ins.setSize(320),
              child: Center(
                child: Text(I18n.of(context).$t('sendClose'),
                    style: AppText.f16_w5_596373),
              ),
            ),
          ),
        ),
      );

  Widget _body() => Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[_amount(), _address(), _gas()],
        ),
      );

  Widget _amount() => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              I18n.of(context).$t('sendAmount'),
              style: AppText.f14_w5_596373,
            ),
            Input(
              horPadding: 0,
              verPadding: 15,
              placehoder: '0.00',
              formatter: [InpDouble()],
              controller: _amountController,
              placehoderStyle:
                  AppText.f24_w6_41C88E.copyWith(fontFamily: 'EncodeSans'),
              style: AppText.f24_w6_41C88E.copyWith(fontFamily: 'EncodeSans'),
              inputType: TextInputType.numberWithOptions(decimal: true),
              border: Border(
                bottom: BorderSide(
                  width: .5,
                  color: AppColor.c_626F81.withOpacity(.2),
                ),
              ),
              onInput: (String val) => setState(() => _canSubmit = (val != '' &&
                  Num.more(double.parse(val), 0) &&
                  _addressController.text != '')),
              suffix: AppTap(
                onTap: _setAll,
                child: Container(
                  padding: EdgeInsets.fromLTRB(15, 15, 0, 15),
                  child: Text(
                    I18n.of(context).$t('all'),
                    style: AppText.f12_w5_41C88E,
                  ),
                ),
              ),
              onComplete: () {
                if (_canSubmit) {
                  _submit();
                } else
                  FocusScope.of(context).requestFocus(_addressNode);
              },
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                I18n.of(context)
                    .$t('free', params: {'num': _model.amount, 'coin': 'ETH'}),
                style: AppText.f10_w5_A3ACBB,
              ),
            ),
          ],
        ),
      );

  Widget _address() => Container(
        margin: EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(I18n.of(context).$t('to'), style: AppText.f14_w5_596373),
            Input(
              horPadding: 0,
              verPadding: 10,
              focusNode: _addressNode,
              style: AppText.f12_w5_596373,
              controller: _addressController,
              placehoder: I18n.of(context).$t('enterWalletAddress'),
              placehoderStyle: AppText.f12_w5_596373,
              maxLines: null,
              inputType: TextInputType.multiline,
              border: Border(
                bottom: BorderSide(
                  width: .5,
                  color: AppColor.c_626F81.withOpacity(.2),
                ),
              ),
              onInput: _checkAddress,
              onComplete: () {
                if (_canSubmit) _submit();
              },
              suffix: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _addressCorrect
                      ? Icon(AppIcon.correct,
                          size: 16, color: AppColor.c_41C88E)
                      : Coms.empty,
                  AppTap(
                    onTap: _scan,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(15, 15, 0, 15),
                      child: Icon(
                        AppIcon.scan,
                        size: 16,
                        color: AppColor.c_596373,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _gas() => Container(
        margin: EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(I18n.of(context).$t('gas'), style: AppText.f14_w5_596373),
            Input(
              horPadding: 0,
              verPadding: 15,
              focusNode: _gasNode,
              formatter: [InpDouble()],
              controller: _gasController,
              style: AppText.f12_w5_596373,
              placehoder: _fee.toString(),
              placehoderStyle: AppText.f12_w5_596373,
              inputType: TextInputType.numberWithOptions(
                decimal: true,
              ),
              border: Border(
                bottom: BorderSide(
                  width: .5,
                  color: AppColor.c_626F81.withOpacity(.2),
                ),
              ),
              suffix: Row(
                children: <Widget>[
                  Text('ETH', style: AppText.f10_w5_596373),
                  _addBtn(),
                  _removeBtn(),
                ],
              ),
              onComplete: _submit,
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                I18n.of(context).$t('sendTips'),
                style: AppText.f10_w5_A3ACBB,
              ),
            ),
          ],
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

  Widget _addBtn() => Container(
        margin: EdgeInsets.only(left: 15),
        child: AppTap(
          onTap: _addGas,
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColor.c_A3ACBB,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(
              Icons.add,
              size: 16,
              color: AppColor.c_FFFFFF,
            ),
          ),
        ),
      );

  Widget _removeBtn() => Container(
        margin: EdgeInsets.only(left: 10),
        child: AppTap(
          onTap: _removeGas,
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _gasController.text != '' &&
                      Num.more(double.parse(_gasController.text), _fee)
                  ? AppColor.c_A3ACBB
                  : AppColor.c_E0E2E6,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(
              Icons.remove,
              size: 16,
              color: AppColor.c_FFFFFF,
            ),
          ),
        ),
      );

  Widget _tips() => Container(
        margin: EdgeInsets.only(top: 40),
        child: Html(
          useRichText: true,
          data: _model.tips,
          customTextStyle: (dom.Node node, TextStyle baseStyle) =>
              AppText.f12_w4_596373.copyWith(height: 1.4),
          customEdgeInsets: (dom.Node node) => EdgeInsets.zero,
        ),
      );

  void _setAll() => setState(() {
        _amountController.text = Num.more(double.parse(_model.amount), 0)
            ? ((_max == 0 || Num.lessOrEqual(double.parse(_model.amount), _max))
                ? _model.amount
                : _max.toString())
            : '0.00';
        _canSubmit = (_amountController.text != '' &&
            Num.more(double.parse(_amountController.text), 0) &&
            _addressController.text != '');
      });

  Future _checkAddress(String address) async {
    setState(() => _canSubmit = (_amountController.text != '' &&
        Num.more(double.parse(_amountController.text), 0) &&
        address != ''));
    HttpResponse _res = await $Http(
      token: $SP.getString('token'),
      showError: false,
      lang: $SP.getString('lang', def: 'en-us'),
    ).post(API.wallet['withdraw_check'], data: {'address': address});
    setState(() {
      _addressCorrect = _res.code == 0;
      if (_res.code == 0) {
        _sendType = _res.data['withdraw_type'] as int;
        _fee = double.parse(_sendType == 1 ? _model.outFee : _model.inFee);
        _max = double.parse(_sendType == 1 ? _model.outMax : _model.inMax);
        _min = double.parse(_sendType == 1 ? _model.outMin : _model.inMin);
        _gasController.text = _fee.toString();
      }
    });
  }

  void _addGas() {
    if (_gasController.text != '') {
      double _gas = double.parse(_gasController.text);
      setState(() {
        _gasController.text = Num.add(_gas, _fee).toString();
      });
    } else
      setState(() {
        _gasController.text = Num.add(_fee, _fee).toString();
      });
  }

  void _removeGas() {
    if (_gasController.text != '') {
      double _gas = double.parse(_gasController.text);
      if (Num.lessOrEqual(_gas, _fee)) return;
      setState(() {
        _gasController.text = Num.subtract(_gas, _fee).toString();
      });
    } else
      setState(() {
        _gasController.text = _fee.toString();
      });
  }

  void _submit() {
    Coms.unfocus(context);
    if (_canSubmit) {
      double _balance = double.parse(_model.amount), // 余额
          _amount = double.parse(_amountController.text); // 输入
      if (Num.lessOrEqual(_amount, _balance)) {
        if (Num.moreOrEqual(_amount, _min != 0 ? _min : 0)) {
          if (_max != 0) {
            Num.lessOrEqual(_amount, _max)
                ? _submitAuth()
                : showToast(
                    I18n.of(context).$t('sendMax', params: {'num': _max}));
          } else
            _submitAuth();
        } else
          showToast(I18n.of(context)
              .$t('sendMin', params: {'num': _min != 0 ? _min : 0}));
      } else
        showToast(I18n.of(context).$t('notEnough'));
    }
  }

  void _submitAuth() {
    if (!_model.auth.assetAuth &&
        !_model.auth.emailAuth &&
        !_model.auth.googleAuth) {
      _submitHandler();
      return;
    }

    Navigator.of(context).push(
      AuthRoute(
        child: SafeAuth(
          email: _model.auth.email,
          code: _model.auth.authCode,
          isAsset: _model.auth.assetAuth,
          isEmail: _model.auth.emailAuth,
          isGoogle: _model.auth.googleAuth,
          callback: (bool success) {
            if (success) _submitHandler();
          },
        ),
      ),
    );
  }

  void _submitHandler() {
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
      ).post(API.wallet['withdraw'], data: {
        'amount': _amountController.text,
        'address': _addressController.text,
        'amount_fee': _gasController.text != '' ? _gasController.text : _fee
      }).then((res) {
        _isClick = true;
        Navigator.of(context).pop();
        if (res.code == 0) {
          evbus.fire(RefreshWalletBills(true));
          evbus.fire(RefreshAssetInfo(true));
          Navigator.of(context).pop();
        }
      });
    }
  }

  Future _scan() async {
    try {
      String _address = (await BarcodeScanner.scan()).rawContent;
      if (_address.isNotEmpty) {
        setState(() {
          _addressController.text = _address;
        });
        _checkAddress(_address);
      }
    } on PlatformException catch (_) {
      if (_.code == BarcodeScanner.cameraAccessDenied)
        showToast(I18n.of(context).$t('camera'));
    }
  }
}
