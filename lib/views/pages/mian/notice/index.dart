import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import '../../../widgets/index.dart';
import 'detail.dart';

class Notice extends StatefulWidget {
  @override
  _NoticeState createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  int _page = 1;
  Future _future;
  EasyRefreshController _controller;
  List<NoticeListModel> _lists = List<NoticeListModel>();

  @override
  void initState() {
    super.initState();
    _future = _get(true);
    _controller = EasyRefreshController();
  }

  Future<List<NoticeListModel>> _get(bool refresh) async {
    HttpResponse _res = await $Http(
      token: $SP.getString('token'),
      lang: $SP.getString('lang', def: 'en-us'),
    ).get(API.notice['list'], params: {'page': _page});
    if (_res.code == 0)
      refresh
          ? _lists = _handler((_res.data as List).cast())
          : _lists.addAll(_handler((_res.data as List).cast()));

    return _lists;
  }

  List<NoticeListModel> _handler(List<Map<String, dynamic>> data) =>
      List.generate(data.length, (int i) => NoticeListModel.fromJson(data[i]));

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.c_FFFFFF,
      body: SafeArea(
        top: false,
        child: Column(
          children: <Widget>[
            _appBar(),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 8, 20, 0),
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
                            : AppNone('noData'),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBar() => MyAppBar(
        color: Colors.transparent,
        title:
            Text(I18n.of(context).$t('notice'), style: AppText.f17_w6_151515),
        prefix: AppTap(
          onTap: () => Navigator.of(context).pop(),
          icon: Icon(AppIcon.back, size: 14, color: AppColor.c_2F3231),
        ),
        suffix: AppTap(
          onTap: _readAll,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(I18n.of(context).$t('allRead'),
                style: AppText.f15_w4_2F3231),
          ),
        ),
      );

  Widget _listView() => ListView.builder(
        itemCount: _lists.length,
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context, int index) =>
            _itemView(_lists[index], index: index),
      );

  Widget _itemView(NoticeListModel model, {int index}) => Container(
        margin: EdgeInsets.only(bottom: 20),
        child: AppTap(
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(builder: (_) => Detail(model.id)),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColor.c_FFFFFF,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColor.c_000000.withOpacity(.05),
                  blurRadius: 20,
                ),
              ],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: .5,
                color: AppColor.c_626F81.withOpacity(.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _title(model.title, model.read),
                (model.img != null && model.img.isNotEmpty)
                    ? _image(model.img)
                    : Coms.empty,
                _desc(model.desc),
                _time(model.time),
              ],
            ),
          ),
        ),
      );
  Widget _title(String title, bool read) => Badge.right(
        top: 20,
        right: 15,
        color: read ? Colors.transparent : AppColor.c_FF7B76,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Text(title, style: AppText.f18_w5_596373),
        ),
      );

  Widget _image(String img) => Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(bottom: 10),
        child: FadeImg.assetNetwork(
          image: img,
          imageScale: 2,
          fit: BoxFit.fitWidth,
          placeholder: 'assets/images/icon_img1.png',
        ),
      );

  Widget _desc(String desc) => Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
        child: Text(desc, style: AppText.f16_w4_596373),
      );

  Widget _time(String time) => Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Text(I18n.of(context).$t('publishTime', params: {'time': time}),
            style: AppText.f12_w4_A3ACBB),
      );

  void _readAll() {
    $Http(
      token: $SP.getString('token'),
      lang: $SP.getString('lang', def: 'en-us'),
    ).post(API.notice['read']).then((res) {
      if (res.code == 0)
        setState(() {
          _future = _get(true);
        });
    });
  }
}
