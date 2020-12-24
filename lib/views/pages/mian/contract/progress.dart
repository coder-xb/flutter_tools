import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import '../../../widgets/index.dart';
import 'detail.dart';

class Progress extends StatefulWidget {
  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  int _page = 1;
  Future _future;
  String _status = 'progress';
  EasyRefreshController _controller;
  List<ContractInfoModel> _lists = List<ContractInfoModel>();

  @override
  void initState() {
    _future = _get(true);
    _controller = EasyRefreshController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  Future<List<ContractInfoModel>> _get(bool refresh) async {
    HttpResponse _res = await $Http(
      token: $SP.getString('token'),
      lang: $SP.getString('lang', def: 'en-us'),
    ).get(API.contract['list'], params: {'page': _page, 'status': _status});
    if (_res.code == 0)
      refresh
          ? _lists = _handler((_res.data as List).cast())
          : _lists.addAll(_handler((_res.data as List).cast()));

    return _lists;
  }

  List<ContractInfoModel> _handler(List<Map<String, dynamic>> data) =>
      List.generate(
        data.length,
        (int i) => ContractInfoModel.fromJson(data[i]),
      );

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
                infoColor: AppColor.c_FF7B76,
                textColor: AppColor.c_FF7B76,
                infoText: I18n.of(context).$t('refreshInfo'),
                noMoreText: I18n.of(context).$t('noMoreData'),
                refreshText: I18n.of(context).$t('pullDown'),
                refreshedText: I18n.of(context).$t('refreshed'),
                refreshingText: I18n.of(context).$t('refreshing'),
                refreshReadyText: I18n.of(context).$t('releaseTo'),
                refreshFailedText: I18n.of(context).$t('refreshFailed'),
              ),
              footer: ClassicalFooter(
                infoColor: AppColor.c_FF7B76,
                textColor: AppColor.c_FF7B76,
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
              onLoad: _lists.length >= 10 * _page
                  ? () async => await Future.delayed(
                        Duration(seconds: 1),
                        () => setState(() {
                          _page++;
                          _future = _get(false);
                          _controller.finishLoad();
                        }),
                      )
                  : null,
              child: _lists.length != 0 ? _listView() : AppNone('noData'),
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
  }

  Widget _listView() => ListView.builder(
        itemCount: _lists.length,
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context, int index) =>
            _itemView(_lists[index]),
      );

  Widget _itemView(ContractInfoModel model) => AppTap(
        onTap: () => Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (_) => Detail(
              id: model.id,
              name: model.name,
              status: _status,
            ),
          ),
        ),
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
                      child: Text(model.name, style: AppText.f14_w4_596373),
                    ),
                    Text(
                      I18n.of(context)
                          .$t('beginTime', params: {'time': model.start}),
                      style: AppText.f10_w4_A3ACBB,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Text(
                      model.surplus,
                      style: AppText.f14_w7_41C88E
                          .copyWith(fontFamily: 'EncodeSans'),
                    ),
                  ),
                  Text(I18n.of(context).$t('notDistributed'),
                      style: AppText.f10_w4_A3ACBB),
                ],
              )
            ],
          ),
        ),
      );
}
