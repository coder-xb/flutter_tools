import 'dart:ui';
import 'package:html/dom.dart' as dom;
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import '../../../../widgets/index.dart';

class Receive extends StatefulWidget {
  @override
  _ReceiveState createState() => _ReceiveState();
}

class _ReceiveState extends State<Receive> {
  Future _future;
  AssetReceiveModel _model;
  @override
  void initState() {
    super.initState();
    _future = _get();
  }

  Future<AssetReceiveModel> _get() async {
    HttpResponse _res = await $Http(
      token: $SP.getString('token'),
      lang: $SP.getString('lang', def: 'en-us'),
    ).get(API.wallet['recharge_pre']);
    if (_res.code == 0) _model = AssetReceiveModel.fromJson(_res.data);

    return _model;
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
            Expanded(
              child: FutureBuilder(
                future: _future,
                builder: (BuildContext context, AsyncSnapshot snapshot) =>
                    snapshot.hasData ? _body() : _qrLoading(),
              ),
            ),
            _button(),
          ],
        ),
      ),
    );
  }

  Widget _appBar() => MyAppBar(
        color: Colors.transparent,
        prefix: AppTap(
          onTap: () {
            evbus.fire(RefreshWalletBills(true));
            Navigator.of(context).pop();
          },
          icon: Icon(AppIcon.back, size: 14, color: AppColor.c_2F3231),
        ),
        title: Text(I18n.of(context).$t('receiveCoin', params: {'coin': 'ETH'}),
            style: AppText.f17_w6_151515),
      );

  Widget _qrLoading() => ListView(
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

  Widget _body() => ListView(
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
            child: Column(
              children: <Widget>[
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    _qrImage(),
                    _model.open ? Coms.empty : _qrMask(),
                  ],
                ),
                _model.open ? _qrAddress() : Coms.empty,
              ],
            ),
          ),
          _copyBtn(),
          _tips(),
        ],
      );

  Widget _qrImage() => Container(
        width: Screen.ins.setSize(250),
        child: QrImage(
          data: _model.address,
          size: Screen.ins.setSize(250),
          foregroundColor: AppColor.c_596C8B,
          backgroundColor: AppColor.c_FFFFFF,
        ),
      );

  Widget _qrMask() => ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Opacity(
            opacity: .6,
            child: Container(
              width: Screen.ins.setSize(250),
              height: Screen.ins.setSize(250),
              color: AppColor.c_FFFFFF,
              child: Center(
                child: Text(I18n.of(context).$t('receiveClose'),
                    style: AppText.f16_w5_596373),
              ),
            ),
          ),
        ),
      );

  Widget _qrAddress() => Container(
        margin: EdgeInsets.only(top: 20),
        child: Text(
          _model.address,
          style: AppText.f14_w6_596373.copyWith(height: 1.4),
          textAlign: TextAlign.center,
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

  Widget _copyBtn() => Container(
        margin: EdgeInsets.only(left: 30, right: 30, top: 25),
        child: AppTap(
          onTap: () => Coms.copy(context, _model.address),
          child: Container(
            height: 44,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: Text(
              I18n.of(context).$t('copyAddress'),
              style: AppText.f15_w5_596373,
            ),
          ),
        ),
      );

  Widget _button() => Container(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: AppTap(
          onTap: () {
            evbus.fire(RefreshWalletBills(true));
            evbus.fire(RefreshAssetInfo(true));
            Navigator.of(context).pop();
          },
          child: Container(
            height: 50,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: AppColor.c_596C8B,
              borderRadius: BorderRadius.circular(50),
            ),
            child:
                Text(I18n.of(context).$t('done'), style: AppText.f15_w7_FFFFFF),
          ),
        ),
      );
}
