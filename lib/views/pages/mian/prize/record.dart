import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import '../../../widgets/index.dart';

class Record extends StatefulWidget {
  @override
  _RecordState createState() => _RecordState();
}

class _RecordState extends State<Record> {
  int _page = 1;
  Future _future;
  EasyRefreshController _controller;
  List<PrizeLogsModel> _logs = List<PrizeLogsModel>();

  @override
  void initState() {
    super.initState();
    _future = _get(true);
    _controller = EasyRefreshController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<List<PrizeLogsModel>> _get(bool refresh) async {
    HttpResponse _res = await $Http(
      token: $SP.getString('token'),
      lang: $SP.getString('lang', def: 'en-us'),
    ).get(API.prize['logs'], params: {'page': _page});
    print(_res.data);
    if (_res.code == 0)
      refresh
          ? _logs = _handler((_res.data as List).cast())
          : _logs.addAll(_handler((_res.data as List).cast()));

    return _logs;
  }

  List<PrizeLogsModel> _handler(List<Map<String, dynamic>> data) =>
      List.generate(data.length, (int i) => PrizeLogsModel.fromJson(data[i]));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.c_FFFFFF,
      body: SafeArea(
        top: false,
        child: Column(
          children: <Widget>[
            _appBar(),
            _body(),
          ],
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
        title: Text(I18n.of(context).$t('prizeRecord'),
            style: AppText.f17_w6_151515),
      );

  Widget _body() => Expanded(
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
                onLoad: _logs.length >= 10 * _page
                    ? () async => await Future.delayed(
                          Duration(seconds: 1),
                          () => setState(() {
                            _page++;
                            _future = _get(false);
                            _controller.finishLoad();
                          }),
                        )
                    : null,
                child: _logs.length != 0
                    ? ListView.builder(
                        itemCount: _logs.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (BuildContext context, int index) =>
                            _itemView(_logs[index]),
                      )
                    : AppNone('noData'),
              );
            } else
              return AppLoading(
                'loading',
                type: LoadingType.widget,
                color: AppColor.c_FF7B76,
                style: AppText.f12_w5_FF7B76,
              );
          },
        ),
      );

  Widget _itemView(PrizeLogsModel model) => Container(
        padding: EdgeInsets.all(16),
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
                    margin: EdgeInsets.only(bottom: 2),
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
                  margin: EdgeInsets.only(bottom: 2),
                  child: Text(
                      I18n.of(context).$t('prizePeriod', params: {
                            'num': model.issue.substring(model.issue.length - 4)
                          }) +
                          model.text,
                      style: AppText.f14_w5_596373),
                ),
                Text(Coms.uid(model.uid), style: AppText.f10_w4_A3ACBB),
              ],
            )
          ],
        ),
      );
}
