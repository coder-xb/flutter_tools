import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import '../../../widgets/index.dart';
import 'wards.dart';
import 'wallet/index.dart';
import 'actions/send.dart';
import 'actions/create.dart';
import 'actions/receive.dart';
import 'actions/transfer.dart';

class Asset extends StatefulWidget {
  @override
  _AssetState createState() => _AssetState();
}

class _AssetState extends State<Asset> with SingleTickerProviderStateMixin {
  Future _future;
  int _tabIndex = 0;
  AssetInfoModel _model;
  TabController _tabController;
  StreamSubscription _refreshSubscription;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _future = _get();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(() => setState(() {
          _tabIndex = _tabController.index;
          _future = _get();
        }));
    _refreshSubscription = evbus.on<RefreshAssetInfo>().listen((ev) {
      if (ev.refresh)
        setState(() {
          _future = _get();
        });
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _refreshSubscription?.cancel();
    super.dispose();
  }

  Future<AssetInfoModel> _get() async {
    HttpResponse _res = await $Http(
      token: $SP.getString('token'),
      lang: $SP.getString('lang', def: 'en-us'),
    ).get(_tabIndex == 0 ? API.wallet['info'] : API.wards['info']);
    if (_res.code == 0) _model = AssetInfoModel.fromJson(_res.data);

    return _model;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Coms.openDrawer(_key),
      child: Scaffold(
        key: _key,
        drawer: AppDrawer(),
        backgroundColor: AppColor.c_596373,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_asset.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: <Widget>[
              FutureBuilder(
                future: _future,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: <Widget>[
                        _appBar(),
                        _header(model: snapshot.data),
                      ],
                    );
                  } else
                    return Column(children: <Widget>[_appBar(), _header()]);
                },
              ),
              _tabIndex == 0 ? _walletBtn() : _wardsBtn(),
              _tabView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar() => MyAppBar(
        color: Colors.transparent,
        title: Text(Provider.of<ProfileState>(context).model.nickname,
            style: AppText.f17_w6_FFFFFF),
        prefix: AppTap(
          onTap: () => _key.currentState.openDrawer(),
          icon: Icon(AppIcon.menu, size: 14, color: AppColor.c_FFFFFF),
        ),
      );

  Widget _header({AssetInfoModel model}) => Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 15),
              child: DefaultTextStyle(
                style: AppText.f32_w7_FFFFFF.copyWith(fontFamily: 'EncodeSans'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        model != null ? model.usable : '0.00000000',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        'ETH',
                        style: AppText.f14_w5_FFFFFF
                            .copyWith(color: AppColor.c_FFFFFF.withOpacity(.6)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              '≈ ${CurSymbol.v(Provider.of<AppState>(context).currency)}${model != null ? model.usableValue : '0.00'}',
              style: AppText.f14_w5_FFFFFF.copyWith(
                color: AppColor.c_FFFFFF.withOpacity(.6),
                fontFamily: 'EncodeSans',
              ),
            ),
          ],
        ),
      );

  Widget _walletBtn() => Container(
        margin: EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
          color: AppColor.c_000000.withOpacity(.1),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AppTap(
              onTap: () => Navigator.of(context).push(
                CupertinoPageRoute(builder: (_) => Send()),
              ),
              child: Container(
                width: 95,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(I18n.of(context).$t('send'),
                    style: AppText.f12_w5_FF7B76),
              ),
            ),
            AppTap(
              onTap: () => Navigator.of(context).push(
                CupertinoPageRoute(builder: (_) => Receive()),
              ),
              child: Container(
                width: 95,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      width: .5,
                      color: AppColor.c_FFFFFF.withOpacity(.2),
                    ),
                    right: BorderSide(
                      width: .5,
                      color: AppColor.c_FFFFFF.withOpacity(.2),
                    ),
                  ),
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(I18n.of(context).$t('receive'),
                    style: AppText.f12_w5_41C88E),
              ),
            ),
            AppTap(
              onTap: () => Navigator.of(context).push(
                CupertinoPageRoute(builder: (_) => Transfer('wallet_to_wards')),
              ),
              child: Container(
                width: 95,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(I18n.of(context).$t('transfer'),
                    style: AppText.f12_w5_7DBEF4),
              ),
            ),
          ],
        ),
      );

  Widget _wardsBtn() => Container(
        margin: EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
          color: AppColor.c_000000.withOpacity(.1),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AppTap(
              onTap: () => Navigator.of(context).push(
                CupertinoPageRoute(builder: (_) => Creates()),
              ),
              child: Container(
                width: 140,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(I18n.of(context).$t('createContract'),
                    style: AppText.f12_w5_FCBE6B),
              ),
            ),
            AppTap(
              onTap: () => Navigator.of(context).push(
                CupertinoPageRoute(builder: (_) => Transfer('wards_to_wallet')),
              ),
              child: Container(
                width: 110,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      width: .5,
                      color: AppColor.c_FFFFFF.withOpacity(.2),
                    ),
                  ),
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(I18n.of(context).$t('transfer'),
                    style: AppText.f12_w5_7DBEF4),
              ),
            ),
          ],
        ),
      );

  Widget _tabBar() => DefaultTabController(
        length: 2,
        child: TabBar(
          controller: _tabController,
          labelColor: AppColor.c_596373,
          labelStyle: AppText.f15_w7_596373,
          unselectedLabelColor: AppColor.c_596373,
          unselectedLabelStyle: AppText.f15_w4_596373,
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 4, color: AppColor.c_596373),
            ),
          ),
          labelPadding: EdgeInsets.symmetric(horizontal: 8),
          tabs: <Tab>[
            Tab(text: I18n.of(context).$t('wallet')),
            Tab(text: I18n.of(context).$t('wards')),
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
                      children: <Widget>[Wallet(), Wards()],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
