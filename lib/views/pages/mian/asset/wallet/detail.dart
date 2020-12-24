import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import '../../../../widgets/index.dart';

class Detail extends StatefulWidget {
  final int id;
  final String type;
  Detail(this.id, this.type);
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  Future _future;
  AssetBillInfoModel _model;

  @override
  void initState() {
    super.initState();
    _future = _get();
  }

  Future<AssetBillInfoModel> _get() async {
    HttpResponse _res = await $Http(
      token: $SP.getString('token'),
      lang: $SP.getString('lang', def: 'en-us'),
    ).get(API.wallet['bill_info'], params: {'bill_id': widget.id});
    if (_res.code == 0) _model = AssetBillInfoModel.fromJson(_res.data);

    return _model;
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
            FutureBuilder(
              future: _future,
              builder: (BuildContext context, AsyncSnapshot snapshot) =>
                  snapshot.hasData
                      ? _body()
                      : AppLoading(
                          'loading',
                          type: LoadingType.widget,
                          color: widget.type == 'withdraw'
                              ? AppColor.c_FF7B76
                              : AppColor.c_41C88E,
                          style: widget.type == 'withdraw'
                              ? AppText.f12_w5_FF7B76
                              : AppText.f12_w5_41C88E,
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBar() => MyAppBar(
        color: Colors.transparent,
        prefix: AppTap(
          onTap: () => Navigator.of(context).pop(),
          icon: Icon(AppIcon.back, size: 14, color: AppColor.c_2F3231),
        ),
        title: Text(
            I18n.of(context).$t(widget.type == 'withdraw' ? 'send' : 'receive'),
            style: AppText.f17_w6_151515),
      );

  Widget _body() => Expanded(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: <Widget>[
              _title(),
              _content(),
            ],
          ),
        ),
      );

  Widget _title() => Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColor.c_FFFFFF,
          borderRadius: BorderRadius.circular(15),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColor.c_000000.withOpacity(.05),
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    I18n.of(context).$t(widget.type == 'withdraw'
                        ? 'sendAmount'
                        : 'receiveAmount'),
                    style: AppText.f10_w5_A3ACBB,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          widget.type == 'withdraw'
                              ? _model.info.amount
                              : ((_model.info.real != null &&
                                      _model.info.real.isNotEmpty)
                                  ? _model.info.real
                                  : _model.info.amount),
                          style: widget.type == 'withdraw'
                              ? AppText.f24_w7_FF7B76
                                  .copyWith(fontFamily: 'EncodeSans')
                              : AppText.f24_w7_41C88E
                                  .copyWith(fontFamily: 'EncodeSans'),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Text('ETH', style: AppText.f11_w5_A3ACBB),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            (_model.info.type != null && _model.info.type == 2)
                ? Container(
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                    decoration: BoxDecoration(
                      color: widget.type == 'withdraw'
                          ? AppColor.c_FF7B76
                          : AppColor.c_41C88E,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(I18n.of(context).$t('quick'),
                        style: AppText.f10_w6_FFFFFF),
                  )
                : Coms.empty,
          ],
        ),
      );

  Widget _content() => Expanded(
        child: Container(
          margin: EdgeInsets.only(top: 20),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              _itemView(
                title: 'create',
                time: _model.common.time,
                style: AppText.f14_w4_596373,
              ),
              _model.info.from.isNotEmpty
                  ? AppTap(
                      onTap: () => Coms.copy(context, _model.info.from),
                      child: _itemView(title: 'from', value: _model.info.from),
                    )
                  : Coms.empty,
              _model.info.to.isNotEmpty
                  ? AppTap(
                      onTap: () => Coms.copy(context, _model.info.to),
                      child: _itemView(title: 'to', value: _model.info.to),
                    )
                  : Coms.empty,
              _model.info.hash.isNotEmpty
                  ? AppTap(
                      onTap: () => Coms.copy(context, _model.info.hash),
                      child: _itemView(title: 'hash', value: _model.info.hash),
                    )
                  : Coms.empty,
              _model.info.status != null
                  ? _itemView(
                      title: 'status',
                      value: _model.info.status == 0
                          ? I18n.of(context).$t('wait')
                          : (_model.info.status == 1
                              ? I18n.of(context).$t('deal')
                              : (_model.info.status == 2
                                  ? I18n.of(context).$t('over')
                                  : I18n.of(context).$t('not'))),
                      style: AppText.f14_w4_596373,
                    )
                  : Coms.empty,
            ],
          ),
        ),
      );

  Widget _itemView({
    String time,
    String value = '',
    String title = '',
    TextStyle style,
  }) =>
      Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 14),
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
              width: Screen.ins.setSize(100),
              child: Text(
                I18n.of(context).$t(title),
                style: AppText.f15_w4_A3ACBB,
              ),
            ),
            Expanded(
              child: Text(
                time != null ? time : value,
                style: style ?? AppText.f10_w5_596373,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      );
}
