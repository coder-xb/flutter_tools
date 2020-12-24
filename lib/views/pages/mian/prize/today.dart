import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import '../../../widgets/index.dart';

class Today extends StatefulWidget {
  @override
  _TodayState createState() => _TodayState();
}

class _TodayState extends State<Today> {
  Future _future;
  EasyRefreshController _controller;
  List<RankModel> _ranks = List<RankModel>();

  @override
  void initState() {
    super.initState();
    _future = _get();
    _controller = EasyRefreshController();
  }

  Future<List<RankModel>> _get() async {
    HttpResponse _res = await $Http(
      token: $SP.getString('token'),
      lang: $SP.getString('lang', def: 'en-us'),
    ).get(API.prize['today']);
    if (_res.code == 0)
      _ranks = _res.data != null
          ? _handler((_res.data as List).cast())
          : List<RankModel>();

    return _ranks;
  }

  List<RankModel> _handler(List<Map<String, dynamic>> data) =>
      List.generate(data.length, (int i) => RankModel.fromJson(data[i]));

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
              onRefresh: () async => await Future.delayed(
                Duration(seconds: 1),
                () => setState(() {
                  _future = _get();
                  _controller.finishRefresh();
                  _controller.resetLoadState();
                }),
              ),
              onLoad: null,
              child: _ranks.length != 0
                  ? _listView()
                  : AppNone(
                      'noData',
                      icon: AppIcon.nodata,
                    ),
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
        itemCount: _ranks.length,
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context, int index) =>
            _itemView(_ranks[index]),
      );

  Widget _itemView(RankModel model) => (model.total != null && model.total != 0)
      ? Container(
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
              Container(
                width: 30,
                height: 30,
                margin: EdgeInsets.only(right: 10),
                alignment: Alignment.center,
                child: Container(
                  width: model.rank == 1 ? 28 : 23,
                  height: model.rank == 1 ? 30 : 23,
                  alignment: Alignment.center,
                  padding: model.rank == 1
                      ? EdgeInsets.only(bottom: 5)
                      : EdgeInsets.zero,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/${model.rank == 1 ? 'icon_first' : (model.rank < 4 ? 'icon_three' : 'icon_rank')}.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Text(
                    '${model.rank}',
                    style: model.rank == 1
                        ? AppText.f15_w6_FFFFFF
                        : (model.rank < 4
                            ? AppText.f12_w6_FFFFFF
                            : AppText.f10_w5_FFFFFF),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Text(
                        Coms.uid(model.uid),
                        style: model.rank == 1
                            ? AppText.f14_w7_FF7B76
                            : AppText.f14_w7_596373,
                      ),
                    ),
                    Text(
                        I18n.of(context)
                            .$t('prizeExpected', params: {'num': model.reward}),
                        style: model.rank == 1
                            ? AppText.f10_w4_FCBE6B
                            : AppText.f10_w4_A3ACBB),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Text(
                        I18n.of(context)
                            .$t('prizeCopies', params: {'num': model.total}),
                        style: AppText.f14_w4_596373),
                  ),
                  Text(I18n.of(context).$t('prizeContract'),
                      style: AppText.f10_w4_A3ACBB),
                ],
              ),
            ],
          ),
        )
      : Coms.empty;
}
