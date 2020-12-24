import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import '../../../widgets/index.dart';
import 'share/index.dart';

import 'vaild.dart';
import 'invaild.dart';

class Nodes extends StatefulWidget {
  @override
  _NodesState createState() => _NodesState();
}

class _NodesState extends State<Nodes> with SingleTickerProviderStateMixin {
  Future _future;
  NodeModel _model;
  int _vaild = 0, _invaild = 0;
  TabController _tabController;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _future = _get();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<NodeModel> _get() async {
    HttpResponse _res = await $Http(
      token: $SP.getString('token'),
      lang: $SP.getString('lang', def: 'en-us'),
    ).get(API.node['index']);
    if (_res.code == 0) {
      _model = NodeModel.fromJson(_res.data);
      Future.delayed(
        Duration.zero,
        () => setState(() {
          _vaild = _model.vaild;
          _invaild = _model.invaild;
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
              image: AssetImage('assets/images/bg_nodes.png'),
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
        title: Text(I18n.of(context).$t('nodes'), style: AppText.f17_w6_FFFFFF),
        prefix: AppTap(
          onTap: () => _key.currentState.openDrawer(),
          icon: Icon(AppIcon.menu, size: 14, color: AppColor.c_FFFFFF),
        ),
        suffix: AppTap(
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(builder: (_) => Share(1)),
          ),
          icon: Icon(AppIcon.share, size: 16, color: AppColor.c_FFFFFF),
        ),
      );

  Widget _header({NodeModel model}) => Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Text(
                model != null ? Num.toThousand(model.mine) : '0',
                style: AppText.f32_w7_FFFFFF.copyWith(fontFamily: 'EncodeSans'),
              ),
            ),
            Text(
              I18n.of(context).$t('teamNodes'),
              style: AppText.f14_w5_FFFFFF
                  .copyWith(color: AppColor.c_FFFFFF.withOpacity(.6)),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Row(
                children: <Widget>[
                  _shows(
                    text: I18n.of(context).$t('nodeContract'),
                    num: model != null ? model.nodeContract.toString() : '0',
                  ),
                  _shows(
                    text: I18n.of(context).$t('superNode'),
                    num: model != null ? model.superNode.toString() : '0',
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _tabBar() => DefaultTabController(
        length: 2,
        child: TabBar(
          controller: _tabController,
          labelColor: AppColor.c_41C88E,
          labelStyle: AppText.f15_w7_596373,
          unselectedLabelColor: AppColor.c_596373,
          unselectedLabelStyle: AppText.f15_w4_596373,
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 4, color: AppColor.c_41C88E),
            ),
          ),
          labelPadding: EdgeInsets.all(6),
          tabs: <Tab>[
            Tab(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(I18n.of(context).$t('vaild')),
                  Text('($_vaild)', style: TextStyle(fontSize: AppFont.f11)),
                ],
              ),
            ),
            Tab(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(I18n.of(context).$t('invaild')),
                  Text('($_invaild)', style: TextStyle(fontSize: AppFont.f11)),
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
                      children: <Widget>[Vaild(), Invaild()],
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
              overflow: TextOverflow.ellipsis,
              style: AppText.f18_w7_FFFFFF.copyWith(fontFamily: 'EncodeSans'),
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
