import 'dart:math';
import 'package:oktoast/oktoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import '../../../../widgets/index.dart';
import '../../contract/index.dart';

class Creates extends StatefulWidget {
  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Creates> {
  Future _future;
  double _payment = 0;
  ContractBuyModel _model;
  TextEditingController _controller;
  bool _canSubmit = true, _isClick = true;

  @override
  void initState() {
    super.initState();
    _future = _get();
    _controller = TextEditingController(text: '1');
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<ContractBuyModel> _get() async {
    HttpResponse _res = await $Http(
      token: $SP.getString('token'),
      lang: $SP.getString('lang', def: 'en-us'),
    ).get(API.contract['buy_pre']);
    if (_res.code == 0) {
      _model = ContractBuyModel.fromJson(_res.data);
      setState(() {
        if (_controller != null) {
          _controller.text = _model.buyMin.toString();
        } else
          _controller = TextEditingController(text: _model.buyMin.toString());
        _payment = Num.multiply(_model.buyMin, double.parse(_model.price));
      });
    }
    return _model;
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
              Expanded(
                child: FutureBuilder(
                  future: _future,
                  builder: (BuildContext context, AsyncSnapshot snapshot) =>
                      snapshot.hasData ? _body() : _loading(),
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
        title: Text(I18n.of(context).$t('createContract'),
            style: AppText.f17_w6_151515),
        prefix: AppTap(
          onTap: () => Navigator.of(context).pop(),
          icon: Icon(AppIcon.back, size: 14, color: AppColor.c_2F3231),
        ),
      );

  Widget _body() => ListView(
        padding: EdgeInsets.all(30),
        children: <Widget>[
          Container(
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
              children: <Widget>[_amount(), _portion(), _gas()],
            ),
          ),
        ],
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

  Widget _amount() => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              I18n.of(context).$t('contractAmount'),
              style: AppText.f14_w5_596373,
            ),
            Input(
              horPadding: 0,
              verPadding: 15,
              placehoder: '0',
              controller: _controller,
              placehoderStyle:
                  AppText.f24_w6_FF7B76.copyWith(fontFamily: 'EncodeSans'),
              style: AppText.f24_w6_FF7B76.copyWith(fontFamily: 'EncodeSans'),
              formatter: [InpInt()],
              inputType: TextInputType.number,
              border: Border(
                bottom: BorderSide(
                  width: .5,
                  color: AppColor.c_626F81.withOpacity(.2),
                ),
              ),
              onInput: (String val) {
                setState(() {
                  _canSubmit = (val != '' && Num.more(double.parse(val), 0));
                  if (_canSubmit) {
                    _payment = Num.multiply(
                        double.parse(val), double.parse(_model.price));
                  } else
                    _payment = 0;
                });
              },
              onComplete: _submit,
              suffix: AppTap(
                onTap: _setAll,
                child: Container(
                  padding: EdgeInsets.fromLTRB(15, 15, 0, 15),
                  child: Text(
                    I18n.of(context).$t('all'),
                    style: AppText.f12_w5_FF7B76,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                I18n.of(context)
                    .$t('canCreate', params: {'num': _model.max - _model.mine}),
                style: AppText.f10_w5_A3ACBB,
              ),
            ),
          ],
        ),
      );

  Widget _portion() => Container(
        margin: EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(I18n.of(context).$t('contractAppointment'),
                style: AppText.f14_w5_596373),
            /*Text(I18n.of(context).$t('todayPortion'),
                style: AppText.f14_w5_596373),*/
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
                  Text(
                    '${_model.queue}',
                    style: AppText.f15_w5_41C88E
                        .copyWith(fontFamily: 'EncodeSans'),
                  ),
                  /*Text(
                    '${_model.stock}',
                    style: AppText.f15_w5_FF7B76
                        .copyWith(fontFamily: 'EncodeSans'),
                  ),*/
                  Text(
                    I18n.of(context).$t('currentQueue'),
                    style: AppText.f11_w5_A3ACBB,
                  ),
                  /*Text(
                    I18n.of(context)
                        .$t('currentQueue', params: {'num': _model.queue}),
                    style: AppText.f11_w5_A3ACBB,
                  ),*/
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                I18n.of(context).$t('createTips'),
                style: AppText.f10_w5_A3ACBB,
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
            Text(I18n.of(context).$t('payment'), style: AppText.f14_w5_596373),
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
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Text(
                        Num.toFixed(_payment, pos: 8),
                        style: AppText.f12_w5_596373,
                      ),
                    ),
                  ),
                  Text('ETH', style: AppText.f12_w5_596373),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                I18n.of(context)
                    .$t('free', params: {'num': _model.balance, 'coin': 'ETH'}),
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
              color: (_canSubmit) ? AppColor.c_596C8B : AppColor.c_B7BEC9,
              borderRadius: BorderRadius.circular(50),
            ),
            child:
                Text(I18n.of(context).$t('done'), style: AppText.f15_w7_FFFFFF),
          ),
        ),
      );

  void _setAll() => setState(() {
        double _balance = double.parse(_model.balance); // 余额
        int _can =
            Num.divide(double.parse(_model.balance), double.parse(_model.price))
                .floor(); // 我能购买的
        if (Num.more(_balance, 0) && _model.buyMax > 0 && Num.more(_can, 0)) {
          _controller.text = Num.lessOrEqual(_can, _model.buyMax)
              ? _can.toString()
              : _model.buyMax.toString();
        } else
          _controller.text = '1';

        _payment = Num.multiply(
            double.parse(_controller.text), double.parse(_model.price));
        _canSubmit = (_controller.text != '' &&
            Num.more(double.parse(_controller.text), 0));
      });

  void _submit() {
    Coms.unfocus(context);
    if (_canSubmit) {
      double _balance = double.parse(_model.balance);
      if (Num.lessOrEqual(_payment, _balance)) {
        _submitHandler();
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
      ).post(
        API.contract['buy'],
        data: {'number': _controller.text},
      ).then((res) {
        _isClick = true;
        Navigator.of(context).pop();
        if (res.code == 0)
          Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(builder: (_) => Contract()),
            (r) => r == null,
          );
      });
    }
  }
}
