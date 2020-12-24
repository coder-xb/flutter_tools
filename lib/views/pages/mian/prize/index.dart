import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import '../../../widgets/index.dart';
import 'today.dart';
import 'zoday.dart';
import 'total.dart';
import 'record.dart';

class Prize extends StatefulWidget {
  @override
  _PrizeState createState() => _PrizeState();
}

class _PrizeState extends State<Prize> with SingleTickerProviderStateMixin {
  Future _future;
  PrizeModel _model;
  String _zoInssue = '----', _toInssue = '----';
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _future = _get();
    _tabController = TabController(vsync: this, length: 3, initialIndex: 1);
  }

  Future<PrizeModel> _get() async {
    HttpResponse _res = await $Http(
      token: $SP.getString('token'),
      lang: $SP.getString('lang', def: 'en-us'),
    ).get(API.prize['index']);
    if (_res.code == 0) {
      _model = PrizeModel.fromJson(_res.data);
      Future.delayed(
        Duration.zero,
        () => setState(() {
          _zoInssue = (_model.zoIssue != null &&
                  _model.zoIssue.isNotEmpty &&
                  _model.zoIssue != _model.toIssue)
              ? _model.zoIssue.substring(_model.zoIssue.length - 4)
              : '${Time.format(time: (DateTime.now()).add(Duration(days: -1)).millisecondsSinceEpoch, fmt: 'MMDD')}';
          _toInssue = (_model.toIssue != null && _model.toIssue.isNotEmpty)
              ? _model.toIssue.substring(_model.toIssue.length - 4)
              : '${Time.format(fmt: 'MMDD')}';
        }),
      );
    }
    return _model;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      backgroundColor: AppColor.c_FF7B76,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_prize.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: <Widget>[
            _appBar(),
            FutureBuilder(
              future: _future,
              builder: (BuildContext context, AsyncSnapshot snapshot) =>
                  snapshot.hasData ? _header(model: snapshot.data) : _header(),
            ),
            _tabView(),
          ],
        ),
      ),
    );
  }

  Widget _appBar() => MyAppBar(
        color: Colors.transparent,
        title: Text(I18n.of(context).$t('prizePool'),
            style: AppText.f17_w6_FFFFFF),
        prefix: AppTap(
          onTap: () => Navigator.of(context).pop(),
          icon: Icon(AppIcon.back, size: 14, color: AppColor.c_FFFFFF),
        ),
        suffix: AppTap(
          onTap: () => Navigator.of(context)
              .push(CupertinoPageRoute(builder: (_) => Record())),
          icon: Icon(AppIcon.more, size: 16, color: AppColor.c_FFFFFF),
        ),
      );

  Widget _header({PrizeModel model}) => Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: <Widget>[
            AppTap(
              onTap: () => Navigator.of(context)
                  .push(CupertinoPageRoute(builder: (_) => Record())),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: DefaultTextStyle(
                      style: AppText.f32_w7_FFFFFF
                          .copyWith(fontFamily: 'EncodeSans'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              model != null ? model.prize : '0.00000000',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                              'ETH',
                              style: AppText.f14_w5_FFFFFF.copyWith(
                                  color: AppColor.c_FFFFFF.withOpacity(.6)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    I18n.of(context).$t('prizeTotal'),
                    style: AppText.f14_w5_FFFFFF.copyWith(
                      color: AppColor.c_FFFFFF.withOpacity(.6),
                      fontFamily: 'EncodeSans',
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Row(
                children: <Widget>[
                  _shows(
                    text: I18n.of(context).$t('prizeTodayAward'),
                    num: model != null ? model.today : '0.00000000',
                  ),
                  _shows(
                    text: I18n.of(context).$t('prizeTotalAward'),
                    num: model != null ? model.total : '0.00000000',
                  ),
                ],
              ),
            )
          ],
        ),
      );

  Widget _tabBar() => DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: TabBar(
          controller: _tabController,
          labelColor: AppColor.c_FF7B76,
          labelStyle: AppText.f15_w7_FF7B76,
          unselectedLabelColor: AppColor.c_596373,
          unselectedLabelStyle: AppText.f15_w4_596373,
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 4, color: AppColor.c_FF7B76),
            ),
          ),
          labelPadding: EdgeInsets.symmetric(horizontal: 8),
          tabs: <Tab>[
            Tab(
              text: I18n.of(context)
                  .$t('prizePeriod', params: {'num': _zoInssue}),
            ),
            Tab(
              text: I18n.of(context)
                  .$t('prizePeriod', params: {'num': _toInssue}),
            ),
            Tab(text: I18n.of(context).$t('prizeTotalRank')),
          ],
        ),
      );

  Widget _tabView() => Expanded(
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
          decoration: BoxDecoration(
            color: AppColor.c_FFFFFF,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: <Widget>[
                  _tabBar(),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[Zoday(), Today(), Total()],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _shows({
    String num = '0',
    @required String text,
  }) =>
      Expanded(
        child: Column(
          children: <Widget>[
            Text(
              num,
              style: AppText.f18_w7_FFFFFF.copyWith(fontFamily: 'EncodeSans'),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              text,
              style: AppText.f14_w5_FFFFFF
                  .copyWith(color: AppColor.c_FFFFFF.withOpacity(.6)),
            ),
          ],
        ),
      );
}
