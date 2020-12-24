import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import '../../../widgets/index.dart';

class Vaild extends StatefulWidget {
  @override
  _VaildState createState() => _VaildState();
}

class _VaildState extends State<Vaild> {
  int _page = 1;
  Future _future;
  EasyRefreshController _controller;
  List<NodeUserModel> _users = List<NodeUserModel>();

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

  Future<List<NodeUserModel>> _get(bool refresh) async {
    HttpResponse _res = await $Http(
      token: $SP.getString('token'),
      lang: $SP.getString('lang', def: 'en-us'),
    ).get(API.node['list'], params: {'page': _page, 'is_valid': 1});
    if (_res.code == 0)
      refresh
          ? _users = _handler((_res.data as List).cast())
          : _users.addAll(_handler((_res.data as List).cast()));

    return _users;
  }

  List<NodeUserModel> _handler(List<Map<String, dynamic>> data) =>
      List.generate(data.length, (int i) => NodeUserModel.fromJson(data[i]));

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
                infoColor: AppColor.c_A3ACBB,
                textColor: AppColor.c_A3ACBB,
                infoText: I18n.of(context).$t('refreshInfo'),
                noMoreText: I18n.of(context).$t('noMoreData'),
                refreshText: I18n.of(context).$t('pullDown'),
                refreshedText: I18n.of(context).$t('refreshed'),
                refreshingText: I18n.of(context).$t('refreshing'),
                refreshReadyText: I18n.of(context).$t('releaseTo'),
                refreshFailedText: I18n.of(context).$t('refreshFailed'),
              ),
              footer: ClassicalFooter(
                infoColor: AppColor.c_A3ACBB,
                textColor: AppColor.c_A3ACBB,
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
              onLoad: _users.length >= 10 * _page
                  ? () async => await Future.delayed(
                        Duration(seconds: 1),
                        () => setState(() {
                          _page++;
                          _future = _get(false);
                          _controller.finishLoad();
                        }),
                      )
                  : null,
              child: _users.length != 0 ? _listView() : AppNone('noData'),
            );
          } else
            return AppLoading(
              'loading',
              type: LoadingType.widget,
              color: AppColor.c_41C88E,
              style: AppText.f12_w5_41C88E,
            );
        },
      ),
    );
  }

  Widget _listView() => ListView.builder(
        itemCount: _users.length,
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context, int index) =>
            _itemView(_users[index]),
      );

  Widget _itemView(NodeUserModel model) => Container(
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
                      Coms.uid(model.uid),
                      style: AppText.f14_w7_596373,
                    ),
                  ),
                  Row(
                    children: List.generate(
                      6,
                      (int index) => Star(
                        model.level > -1 &&
                            model.level < 7 &&
                            model.level > index,
                        size: 10,
                      ),
                    ),
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
                      '${model.nums} ${I18n.of(context).$t('contract')}',
                      style: AppText.f14_w4_596373),
                ),
                Text(model.time, style: AppText.f10_w4_A3ACBB),
              ],
            ),
          ],
        ),
      );
}
