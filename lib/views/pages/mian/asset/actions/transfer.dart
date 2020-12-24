import 'dart:ui';
import 'package:oktoast/oktoast.dart';
import 'package:flutter/material.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import '../../../../widgets/index.dart';

class Transfer extends StatefulWidget {
  final String mode;
  Transfer(this.mode);
  @override
  _TransferState createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  Future _future;
  double _fee = 0;
  FocusNode _amountNode;
  bool _canSubmit = false, _isClick = true;
  AssetTransferModel _model;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _future = _get();
    _amountNode = FocusNode();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<AssetTransferModel> _get() async {
    HttpResponse _res = await $Http(
      token: $SP.getString('token'),
      lang: $SP.getString('lang', def: 'en-us'),
    ).get(API.transfer['prepare'], params: {'model': widget.mode});
    if (_res.code == 0) _model = AssetTransferModel.fromJson(_res.data);

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
        title: Text(
            I18n.of(context).$t('transferCoin', params: {'coin': 'ETH'}),
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
              height: Screen.ins.setSize(330),
              child: Center(
                child: Text(I18n.of(context).$t('transferClose'),
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
          children: <Widget>[_amount(), _fromTo(), _gas()],
        ),
      );

  Widget _amount() => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              I18n.of(context).$t('transferAmount'),
              style: AppText.f14_w5_596373,
            ),
            Input(
              horPadding: 0,
              verPadding: 15,
              placehoder: '0.00',
              focusNode: _amountNode,
              controller: _controller,
              placehoderStyle:
                  AppText.f24_w6_41C88E.copyWith(fontFamily: 'EncodeSans'),
              style: AppText.f24_w6_41C88E.copyWith(fontFamily: 'EncodeSans'),
              inputType: TextInputType.numberWithOptions(
                decimal: true,
              ),
              onInput: (String val) {
                setState(() {
                  _canSubmit = (val != '' && Num.more(double.parse(val), 0));
                  if (_canSubmit) {
                    _fee = Num.multiply(
                        double.parse(val), double.parse(_model.rate));
                  } else
                    _fee = 0;
                });
              },
              border: Border(
                bottom: BorderSide(
                  width: .5,
                  color: AppColor.c_626F81.withOpacity(.2),
                ),
              ),
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
              onComplete: _submit,
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

  Widget _fromTo() => Container(
        margin: EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DefaultTextStyle(
              style: AppText.f14_w5_596373,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(I18n.of(context).$t('from')),
                  Text(I18n.of(context).$t('to')),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Text(
                        I18n.of(context).$t(widget.mode == 'wallet_to_wards'
                            ? 'wallet'
                            : 'wards'),
                        style: AppText.f15_w5_41C88E,
                      ),
                    ),
                  ),
                  Icon(
                    AppIcon.to,
                    size: 12,
                    color: AppColor.c_A3ACBB,
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        I18n.of(context).$t(widget.mode == 'wallet_to_wards'
                            ? 'wards'
                            : 'wallet'),
                        style: AppText.f15_w5_FCBE6B,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );

  Widget _gas() => Container(
        margin: EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(I18n.of(context).$t('gas'), style: AppText.f14_w5_596373),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: .5,
                    color: AppColor.c_626F81.withOpacity(.2),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(Num.toFixed(_fee, pos: 8), style: AppText.f12_w5_596373),
                  Text('ETH', style: AppText.f10_w5_596373),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                double.parse(_model.rate) == 0
                    ? I18n.of(context).$t('feeNow')
                    : I18n.of(context).$t('feeRate', params: {
                        'rate': Num.toPercent(double.parse(_model.rate), pos: 2)
                      }),
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

  void _setAll() => setState(() {
        _controller.text = Num.more(double.parse(_model.amount), 0)
            ? ((double.parse(_model.max) == 0 ||
                    Num.lessOrEqual(
                        double.parse(_model.amount), double.parse(_model.max)))
                ? _model.amount
                : _model.max)
            : '0.00';
        _fee = Num.multiply(
            double.parse(_controller.text), double.parse(_model.rate));
        _canSubmit = (_controller.text != '' &&
            Num.more(double.parse(_controller.text), 0));
      });

  void _submit() {
    Coms.unfocus(context);
    if (_canSubmit) {
      double _balance = double.parse(_model.amount), // 余额
          _amount = double.parse(_controller.text); // 输入
      if (Num.lessOrEqual(_amount, _balance)) {
        double _min = double.parse(_model.min), _max = double.parse(_model.max);
        if (Num.moreOrEqual(_amount, _min != 0 ? _min : 0)) {
          if (_max != 0) {
            Num.lessOrEqual(_amount, _max)
                ? _submitHandler()
                : showToast(
                    I18n.of(context).$t('transferMax', params: {'num': _max}));
          } else
            _submitHandler();
        } else
          showToast(I18n.of(context)
              .$t('transferMin', params: {'num': _min != 0 ? _min : 0}));
      } else
        showToast(I18n.of(context).$t('notEnough'));
    }
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
      ).post(API.transfer['transfer'], data: {
        'model': widget.mode,
        'amount': _controller.text,
      }).then((res) {
        _isClick = true;
        Navigator.of(context).pop();
        if (res.code == 0) {
          widget.mode == 'wallet_to_wards'
              ? evbus.fire(RefreshWalletBills(true))
              : evbus.fire(RefreshWardsBills(true));
          evbus.fire(RefreshAssetInfo(true));
          Navigator.of(context).pop();
        }
      });
    }
  }
}
