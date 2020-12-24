import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import '../../../widgets/index.dart';

class Detail extends StatefulWidget {
  final int id;
  Detail(this.id);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  Future _future;
  NoticeInfoModel _model;

  @override
  void initState() {
    super.initState();
    _future = _get();
  }

  Future<NoticeInfoModel> _get() async {
    HttpResponse _res = await $Http(
      token: $SP.getString('token'),
      lang: $SP.getString('lang', def: 'en-us'),
    ).get(API.notice['info'], params: {'id': widget.id});
    if (_res.code == 0) _model = NoticeInfoModel.fromJson(_res.data);

    return _model;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.c_FFFFFF,
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _appBar(),
            Expanded(
              child: FutureBuilder(
                future: _future,
                builder: (BuildContext context, AsyncSnapshot snapshot) =>
                    snapshot.hasData
                        ? _body()
                        : AppLoading(
                            'loading',
                            type: LoadingType.widget,
                            color: AppColor.c_596373,
                            style: AppText.f12_w5_596373,
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
      );

  Widget _body() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _title(),
          _author(),
          _content(),
        ],
      );

  Widget _title() => Container(
        margin: EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Text(_model.title, style: AppText.f18_w5_151515),
      );

  Widget _author() => Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 18),
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
            ClipOval(
              child: SizedBox(
                width: 40,
                height: 40,
                child: Image.asset(
                  'assets/images/icon_basic.png',
                  scale: 2,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            _infos(),
            _reads(),
          ],
        ),
      );

  Widget _infos() => Expanded(
        child: Container(
          margin: EdgeInsets.only(left: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _model.author,
                style: AppText.f15_w5_596373,
              ),
              Container(
                margin: EdgeInsets.only(top: 2),
                child: Text(
                  I18n.of(context)
                      .$t('publishTime', params: {'time': _model.time}),
                  style: AppText.f12_w4_A3ACBB,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _reads() => Column(
        children: <Widget>[
          Icon(
            AppIcon.read,
            size: 18,
            color: AppColor.c_A3ACBB,
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Text(
              '${_model.reads}',
              style: AppText.f11_w4_A3ACBB,
            ),
          ),
        ],
      );

  Widget _content() => Expanded(
        child: Container(
          margin: EdgeInsets.all(20),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Html(useRichText: false, data: _model.content),
            ],
          ),
        ),
      );
}
