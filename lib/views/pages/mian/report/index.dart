import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import '../../../widgets/index.dart';
import 'add.dart';
import 'detail.dart';

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  int _page = 1;
  Future _future;
  EasyRefreshController _controller;
  StreamSubscription _refreshSubscription;
  List<ReportItemModel> _lists = List<ReportItemModel>();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _future = _get(true);
    _controller = EasyRefreshController();
    _refreshSubscription = evbus.on<RefreshReport>().listen((ev) {
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

  Future<List<ReportItemModel>> _get(bool refresh) async {
    HttpResponse _res = await $Http(
      token: $SP.getString('token'),
      lang: $SP.getString('lang', def: 'en-us'),
    ).get(API.report['list'], params: {'page': _page});
    if (_res.code == 0)
      refresh
          ? _lists = _handler((_res.data as List).cast())
          : _lists.addAll(_handler((_res.data as List).cast()));

    return _lists;
  }

  List<ReportItemModel> _handler(List<Map<String, dynamic>> data) =>
      List.generate(data.length, (int i) => ReportItemModel.fromJson(data[i]));

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Coms.openDrawer(_key),
      child: Scaffold(
        key: _key,
        drawer: AppDrawer(),
        backgroundColor: AppColor.c_FFFFFF,
        body: SafeArea(
          top: false,
          child: Column(
            children: <Widget>[
              _appBar(),
              Expanded(
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
                          refreshFailedText:
                              I18n.of(context).$t('refreshFailed'),
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
                        child: _lists.length != 0
                            ? _listView()
                            : AppNone('noData', child: _button()),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar() => MyAppBar(
        color: Colors.transparent,
        title:
            Text(I18n.of(context).$t('report'), style: AppText.f17_w6_151515),
        prefix: AppTap(
          onTap: () => _key.currentState.openDrawer(),
          icon: Icon(AppIcon.menu, size: 14, color: AppColor.c_2F3231),
        ),
        suffix: AppTap(
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(builder: (_) => AddReport()),
          ),
          icon: Icon(AppIcon.edit, size: 16, color: AppColor.c_2F3231),
        ),
      );

  Widget _listView() => ListView.builder(
        itemCount: _lists.length,
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context, int index) =>
            _itemView(_lists[index], index: index),
      );

  Widget _itemView(ReportItemModel model, {int index}) => AppTap(
        onTap: () => Navigator.of(context).push(
          CupertinoPageRoute(builder: (_) => Detail(model.id)),
        ),
        child: Container(
          margin: index == 0 ? EdgeInsets.zero : EdgeInsets.only(top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      I18n.of(context)
                          .$t('createTime', params: {'time': model.create}),
                      style: AppText.f14_w4_A3ACBB,
                    ),
                    Text(
                      I18n.of(context)
                          .$t(model.status == 0 ? 'progress' : 'complete'),
                      style: AppText.f11_w4_A3ACBB,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: AppColor.c_FFFFFF,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppColor.c_000000.withOpacity(.05),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(model.content, style: AppText.f14_w4_596373),
                    model.create != model.update
                        ? _reply(model.update)
                        : Coms.empty,
                  ],
                ),
              ),
              model.imgs.length != 0 ? _imageView(model.imgs) : Coms.empty,
            ],
          ),
        ),
      );

  Widget _reply(String time) => Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Text(I18n.of(context).$t('lastedReply'),
                      style: AppText.f12_w4_FF7B76),
                ),
                Text(I18n.of(context).$t('atTime', params: {'time': time}),
                    style: AppText.f12_w4_A3ACBB)
              ],
            ),
          ],
        ),
      );

  Widget _imageView(List<dynamic> imgs) => Container(
        margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: List.generate(imgs.length, (int i) => _image(imgs[i])),
        ),
      );

  Widget _image(String img) => Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: AppColor.c_FFFFFF,
          border: Border.all(
            width: .5,
            color: AppColor.c_626F81.withOpacity(.2),
          ),
        ),
        child: img != null && img.isNotEmpty
            ? FadeImg.assetNetwork(
                image: img,
                imageScale: 2,
                fit: BoxFit.cover,
                placeholder: 'assets/images/icon_img.png',
              )
            : Image.asset(
                'assets/images/icon_img.png',
                scale: 2,
                fit: BoxFit.cover,
              ),
      );

  Widget _button() => Container(
        margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: AppTap(
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(builder: (_) => AddReport()),
          ),
          child: Container(
            height: 50,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: AppColor.c_596C8B,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              I18n.of(context).$t('reportNow'),
              style: AppText.f15_w7_FFFFFF,
            ),
          ),
        ),
      );
}
