import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import '../../../widgets/index.dart';

class Detail extends StatefulWidget {
  final int id;
  final String name, status;
  Detail({
    @required this.id,
    @required this.name,
    @required this.status,
  });

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  int _logsPage = 1;
  bool _isClick = true;
  ContractInfoModel _model;
  Future _infoFuture, _logsFuture;
  EasyRefreshController _controller;
  List<ContractLogsModel> _logs = List<ContractLogsModel>();

  @override
  void initState() {
    super.initState();
    _infoFuture = _getInfo();
    _logsFuture = _getLogs(true);
    _controller = EasyRefreshController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<ContractInfoModel> _getInfo() async {
    HttpResponse _res = await $Http(
      token: $SP.getString('token'),
      lang: $SP.getString('lang', def: 'en-us'),
    ).get(API.contract['info'], params: {'contract_id': widget.id});
    if (_res.code == 0) _model = ContractInfoModel.fromJson(_res.data);

    return _model;
  }

  Future<List<ContractLogsModel>> _getLogs(bool refresh) async {
    HttpResponse _res = await $Http(
      token: $SP.getString('token'),
      lang: $SP.getString('lang', def: 'en-us'),
    ).get(
      API.contract['logs'],
      params: {'page': _logsPage, 'contract_id': widget.id},
    );
    if (_res.code == 0)
      refresh
          ? _logs = _handler((_res.data as List).cast())
          : _logs.addAll(_handler((_res.data as List).cast()));

    return _logs;
  }

  List<ContractLogsModel> _handler(List<Map<String, dynamic>> data) =>
      List.generate(
          data.length, (int i) => ContractLogsModel.fromJson(data[i]));

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
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  children: <Widget>[
                    FutureBuilder(
                      future: _infoFuture,
                      builder: (BuildContext context, AsyncSnapshot snapshot) =>
                          snapshot.hasData ? _body() : _loading(),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 20),
                        child: FutureBuilder(
                          future: _logsFuture,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return EasyRefresh(
                                controller: _controller,
                                enableControlFinishLoad: true,
                                enableControlFinishRefresh: true,
                                header: ClassicalHeader(
                                  infoColor: AppColor.c_FF7B76,
                                  textColor: AppColor.c_FF7B76,
                                  infoText: I18n.of(context).$t('refreshInfo'),
                                  noMoreText: I18n.of(context).$t('noMoreData'),
                                  refreshText: I18n.of(context).$t('pullDown'),
                                  refreshedText:
                                      I18n.of(context).$t('refreshed'),
                                  refreshingText:
                                      I18n.of(context).$t('refreshing'),
                                  refreshReadyText:
                                      I18n.of(context).$t('releaseTo'),
                                  refreshFailedText:
                                      I18n.of(context).$t('refreshFailed'),
                                ),
                                footer: ClassicalFooter(
                                  infoColor: AppColor.c_FF7B76,
                                  textColor: AppColor.c_FF7B76,
                                  infoText: I18n.of(context).$t('loadInfo'),
                                  loadText: I18n.of(context).$t('pushLoad'),
                                  loadedText: I18n.of(context).$t('loaded'),
                                  loadingText: I18n.of(context).$t('loadeding'),
                                  noMoreText: I18n.of(context).$t('noMoreData'),
                                  loadReadyText:
                                      I18n.of(context).$t('releaseTo'),
                                  loadFailedText:
                                      I18n.of(context).$t('loadFailed'),
                                ),
                                onRefresh: () async => await Future.delayed(
                                  Duration(seconds: 1),
                                  () => setState(() {
                                    _logsPage = 1;
                                    _logsFuture = _getLogs(true);
                                    _controller.finishRefresh();
                                    _controller.resetLoadState();
                                  }),
                                ),
                                onLoad: _logs.length >= 10 * _logsPage
                                    ? () async => await Future.delayed(
                                          Duration(seconds: 1),
                                          () => setState(() {
                                            _logsPage++;
                                            _logsFuture = _getLogs(false);
                                            _controller.finishLoad();
                                          }),
                                        )
                                    : null,
                                child: _logs.length != 0
                                    ? _listView()
                                    : AppNone('noData'),
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
                      ),
                    ),
                  ],
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
        prefix: AppTap(
          onTap: () => Navigator.of(context).pop(),
          icon: Icon(AppIcon.back, size: 14, color: AppColor.c_2F3231),
        ),
        title: Text(widget.name, style: AppText.f17_w6_151515),
        suffix: widget.status == 'appointment'
            ? AppTap(
                onTap: _cancel,
                icon: Icon(AppIcon.delete, size: 16, color: AppColor.c_FF7B76),
              )
            : Coms.empty,
      );

  Widget _loading() => Container(
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
        child: AppLoading(
          'loading',
          type: LoadingType.widget,
          color: AppColor.c_FF7B76,
          style: AppText.f12_w5_FF7B76,
        ),
      );

  Widget _body() => Container(
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
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  I18n.of(context).$t('totalAmount'),
                  style: AppText.f10_w5_A3ACBB,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        Num.toFixed(double.parse(_model.total), pos: 2),
                        style: AppText.f24_w7_FF7B76
                            .copyWith(fontFamily: 'EncodeSans'),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        child: Text('ETH', style: AppText.f11_w5_A3ACBB),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${_model.num} * ${double.parse(_model.price)} * ${Num.toPercent(double.parse(_model.multiple))}%',
                  style: AppText.f10_w5_A3ACBB,
                ),
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 4),
                    child: Text(
                      widget.name,
                      style: AppText.f15_w7_596373,
                    ),
                  ),
                  Text(
                    widget.status == 'progress'
                        ? I18n.of(context)
                            .$t('beginTime', params: {'time': _model.start})
                        : (widget.status == 'appointment'
                            ? I18n.of(context).$t('createTime',
                                params: {'time': _model.create})
                            : I18n.of(context)
                                .$t('endTime', params: {'time': _model.end})),
                    style: AppText.f10_w4_A3ACBB,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 4),
                          child: Text(
                            widget.status == 'progress'
                                ? _model.surplus
                                : (widget.status == 'appointment'
                                    ? I18n.of(context).$t('contractAppointment')
                                    : I18n.of(context).$t('contractCompleted')),
                            style: widget.status == 'progress'
                                ? AppText.f15_w5_41C88E
                                    .copyWith(fontFamily: 'EncodeSans')
                                : AppText.f15_w5_41C88E,
                          ),
                        ),
                        Text(
                          widget.status == 'progress'
                              ? I18n.of(context).$t('notDistributed')
                              : (widget.status == 'appointment'
                                  ? I18n.of(context).$t('queueFront', params: {
                                      'num': _model.queue != null
                                          ? _model.queue
                                          : 0
                                    })
                                  : I18n.of(context).$t('notDistributed')),
                          style: AppText.f10_w4_A3ACBB,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _listView() => ListView.builder(
        itemCount: _logs.length,
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context, int index) =>
            _itemView(_logs[index]),
      );

  Widget _itemView(ContractLogsModel model) => Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
                      model.amount,
                      style: AppText.f15_w7_FF7B76
                          .copyWith(fontFamily: 'EncodeSans'),
                    ),
                  ),
                  Text(
                    I18n.of(context)
                        .$t('gasAmount', params: {'num': model.fee}),
                    style: AppText.f10_w4_A3ACBB,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Text(model.text, style: AppText.f14_w4_596373),
                ),
                Text(model.time, style: AppText.f10_w4_A3ACBB),
              ],
            )
          ],
        ),
      );

  void _cancel() {
    if (_model != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AppDialog(
          type: DialogType.warning,
          text: I18n.of(context).$t('cancelTips'),
          confirm: _cancelHandler,
        ),
      );
    }
  }

  void _cancelHandler() {
    if (_isClick) {
      _isClick = false;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AppLoading('submiting'),
      );
      $Http(
        token: $SP.getString('token'),
        lang: $SP.getString('lang', def: 'en-us'),
      ).post(
        API.contract['cancel'],
        data: {'contract_id': _model.id},
      ).then((res) {
        _isClick = true;
        Navigator.of(context).pop();
        if (res.code == 0) {
          evbus.fire(RefreshAppoint(true));
          Navigator.of(context).pop();
        }
      });
    }
  }
}
