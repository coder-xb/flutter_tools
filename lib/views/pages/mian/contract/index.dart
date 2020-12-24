import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import '../../../widgets/index.dart';
import '../asset/actions/create.dart';

import 'appoint.dart';
import 'progress.dart';
import 'complete.dart';

class Contract extends StatefulWidget {
  @override
  _ContractState createState() => _ContractState();
}

class _ContractState extends State<Contract>
    with SingleTickerProviderStateMixin {
  Future _future;
  int _progress = 0, _appointment = 0, _completed = 0;
  ContractModel _model;
  TabController _tabController;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _future = _get();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<ContractModel> _get() async {
    HttpResponse _res = await $Http(
      token: $SP.getString('token'),
      lang: $SP.getString('lang', def: 'en-us'),
    ).get(API.contract['index']);
    if (_res.code == 0) {
      _model = ContractModel.fromJson(_res.data);
      Future.delayed(
        Duration.zero,
        () => setState(() {
          _progress = _model.progress;
          _completed = _model.completed;
          _appointment = _model.appointment;
        }),
      );
    }

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
              image: AssetImage('assets/images/bg_contract.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: <Widget>[
              _appBar(),
              FutureBuilder(
                future: _future,
                builder: (BuildContext context, AsyncSnapshot snapshot) =>
                    snapshot.hasData
                        ? _header(model: snapshot.data)
                        : _header(),
              ),
              _tabView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar() => MyAppBar(
        color: Colors.transparent,
        title:
            Text(I18n.of(context).$t('contract'), style: AppText.f17_w6_FFFFFF),
        prefix: AppTap(
          onTap: () => _key.currentState.openDrawer(),
          icon: Icon(AppIcon.menu, size: 14, color: AppColor.c_FFFFFF),
        ),
      );

  Widget _header({ContractModel model}) => Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Text(
                model != null ? '${model.mine}' : '0',
                style: AppText.f32_w7_FFFFFF.copyWith(fontFamily: 'EncodeSans'),
              ),
            ),
            Text(
              I18n.of(context).$t('myContract'),
              style: AppText.f14_w5_FFFFFF
                  .copyWith(color: AppColor.c_FFFFFF.withOpacity(.6)),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: AppTap(
                onTap: () => Navigator.of(context).push(
                  CupertinoPageRoute(builder: (_) => Creates()),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                  decoration: BoxDecoration(
                    color: AppColor.c_000000.withOpacity(.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    I18n.of(context).$t('canCreate', params: {
                      'num': model != null ? (model.max - model.mine) : 0
                    }),
                    style: AppText.f12_w5_FFFFFF,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _tabBar() => DefaultTabController(
        length: 3,
        child: TabBar(
          controller: _tabController,
          labelColor: AppColor.c_FF7B76,
          labelStyle: AppText.f13_w7_FF7B76,
          unselectedLabelColor: AppColor.c_596373,
          unselectedLabelStyle: AppText.f13_w4_596373,
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 4, color: AppColor.c_FF7B76),
            ),
          ),
          labelPadding: EdgeInsets.all(6),
          tabs: <Tab>[
            Tab(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(I18n.of(context).$t('contractProgress')),
                  Text('($_progress)', style: TextStyle(fontSize: AppFont.f11)),
                ],
              ),
            ),
            Tab(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(I18n.of(context).$t('contractAppointment')),
                  Text('($_appointment)',
                      style: TextStyle(fontSize: AppFont.f11)),
                ],
              ),
            ),
            Tab(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(I18n.of(context).$t('contractCompleted')),
                  Text('($_completed)',
                      style: TextStyle(fontSize: AppFont.f11)),
                ],
              ),
            ),
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
                      children: <Widget>[
                        Progress(),
                        Appoint(),
                        Complete(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
