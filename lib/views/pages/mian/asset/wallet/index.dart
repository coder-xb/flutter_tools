import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import '../../../../widgets/index.dart';
import 'detail.dart';

class Wallet extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  int _page = 1;
  Future _future;
  EasyRefreshController _controller;
  StreamSubscription _refreshSubscription;
  List<AssetBillModel> _bills = List<AssetBillModel>();

  @override
  void initState() {
    super.initState();
    _future = _get(true);
    _controller = EasyRefreshController();
    _refreshSubscription = evbus.on<RefreshWalletBills>().listen((ev) {
      if (ev.refresh)
        setState(() {
          _future = _get(true);
        });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _refreshSubscription?.cancel();
    super.dispose();
  }

  Future<List<AssetBillModel>> _get(bool refresh) async {
    HttpResponse _res = await $Http(
      token: $SP.getString('token'),
      lang: $SP.getString('lang', def: 'en-us'),
    ).get(API.wallet['bill_list'], params: {'page': _page});
    if (_res.code == 0) {
      if (refresh) {
        evbus.fire(RefreshAssetInfo(true));
        _bills = _handler((_res.data as List).cast());
      } else
        _bills.addAll(_handler((_res.data as List).cast()));
    }

    return _bills;
  }

  List<AssetBillModel> _handler(List<Map<String, dynamic>> data) =>
      List.generate(data.length, (int i) => AssetBillModel.fromJson(data[i]));

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: FutureBuilder(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return EasyRefresh(
              controller: _controller,
              enableControlFinishLoad: true,
              enableControlFinishRefresh: true,
              header: ClassicalHeader(
                infoColor: AppColor.c_596373,
                textColor: AppColor.c_596373,
                infoText: I18n.of(context).$t('refreshInfo'),
                noMoreText: I18n.of(context).$t('noMoreData'),
                refreshText: I18n.of(context).$t('pullDown'),
                refreshedText: I18n.of(context).$t('refreshed'),
                refreshingText: I18n.of(context).$t('refreshing'),
                refreshReadyText: I18n.of(context).$t('releaseTo'),
                refreshFailedText: I18n.of(context).$t('refreshFailed'),
              ),
              footer: ClassicalFooter(
                infoColor: AppColor.c_596373,
                textColor: AppColor.c_596373,
                infoText: I18n.of(context).$t('loadInfo'),
                loadText: I18n.of(context).$t('pushLoad'),
                loadedText: I18n.of(context).$t('loaded'),
                loadingText: I18n.of(context).$t('loadeding'),
                noMoreText: I18n.of(context).$t('noMoreData'),
                loadReadyText: I18n.of(context).$t('releaseTo'),
                loadFailedText: I18n.of(context).$t('loadFailed'),
              ),
              onRefresh: () async => await Future.delayed(
                Duration(seconds: 1),
                () => setState(() {
                  _page = 1;
                  _future = _get(true);
                  _controller.finishRefresh();
                  _controller.resetLoadState();
                }),
              ),
              onLoad: _bills.length >= 10 * _page
                  ? () async => await Future.delayed(
                        Duration(seconds: 1),
                        () => setState(() {
                          _page++;
                          _future = _get(false);
                          _controller.finishLoad();
                        }),
                      )
                  : null,
              child: _bills.length != 0 ? _listView() : AppNone('noData'),
            );
          } else
            return AppLoading(
              'loading',
              type: LoadingType.widget,
              color: AppColor.c_596373,
              style: AppText.f12_w5_596373,
            );
        },
      ),
    );
  }

  Widget _listView() => ListView.builder(
        itemCount: _bills.length,
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context, int index) =>
            _itemView(_bills[index]),
      );

  Widget _itemView(AssetBillModel model) => AppTap(
        onTap: () {
          if (model.view == 'withdraw' || model.view == 'recharge')
            Navigator.of(context).push(
              CupertinoPageRoute(
                  builder: (_) => Detail(model.billId, model.view)),
            );
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Text(
                        '${double.parse(model.amount) >= 0 ? '+${model.amount}' : model.amount}',
                        style: double.parse(model.amount) >= 0
                            ? AppText.f14_w7_41C88E
                                .copyWith(fontFamily: 'EncodeSans')
                            : AppText.f14_w7_FF7B76
                                .copyWith(fontFamily: 'EncodeSans'),
                      ),
                    ),
                    Text(model.time, style: AppText.f10_w4_A3ACBB),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Text(model.text, style: AppText.f14_w4_596373),
                  ),
                  Text(model.remarks, style: AppText.f10_w4_A3ACBB),
                ],
              )
            ],
          ),
        ),
      );
}
