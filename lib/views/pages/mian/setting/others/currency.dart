import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import '../../../../widgets/index.dart';

class Currency extends StatefulWidget {
  @override
  _CurrencyState createState() => _CurrencyState();
}

class _CurrencyState extends State<Currency> {
  Future _future;
  List<CurrencyModel> _curs = List<CurrencyModel>();

  @override
  void initState() {
    super.initState();
    _future = _get();
  }

  Future<List<CurrencyModel>> _get() async {
    HttpResponse _res = await $Http(
      token: $SP.getString('token'),
      lang: $SP.getString('lang', def: 'en-us'),
    ).get(API.other['currency']);
    if (_res.code == 0) _curs = _handler((_res.data as List).cast());

    return _curs;
  }

  List<CurrencyModel> _handler(List<Map<String, dynamic>> data) =>
      List.generate(data.length, (int i) => CurrencyModel.fromJson(data[i]));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      backgroundColor: AppColor.c_FFFFFF,
      body: SafeArea(
        top: false,
        child: Column(
          children: <Widget>[
            _appBar(),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 8),
                child: FutureBuilder(
                  future: _future,
                  builder: (BuildContext context, AsyncSnapshot snapshot) =>
                      snapshot.hasData
                          ? _listView()
                          : AppLoading(
                              'loading',
                              type: LoadingType.widget,
                              color: AppColor.c_596373,
                              style: AppText.f12_w5_596373,
                            ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _appBar() => MyAppBar(
        color: Colors.transparent,
        title:
            Text(I18n.of(context).$t('currency'), style: AppText.f17_w6_151515),
        prefix: AppTap(
          onTap: () => Navigator.of(context).pop(),
          icon: Icon(AppIcon.back, size: 14, color: AppColor.c_2F3231),
        ),
      );

  Widget _listView() => ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
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
              children: List.generate(
                _curs.length,
                (int i) => _currency(
                  name: _curs[i].name,
                  border: i != _curs.length - 1,
                  check:
                      _curs[i].code == Provider.of<AppState>(context).currency,
                  onTap: () => _setCurrency(_curs[i].code),
                ),
              ),
            ),
          ),
        ],
      );

  Widget _currency({
    @required String name,
    @required VoidCallback onTap,
    bool check = false,
    bool border = false,
  }) =>
      SetTile(
        height: 50,
        onTap: onTap,
        padding: EdgeInsets.symmetric(horizontal: 20),
        prefix: Text(name, style: AppText.f15_w5_596373),
        border: border
            ? Border(
                bottom: BorderSide(
                    width: .5, color: AppColor.c_626F81.withOpacity(.2)),
              )
            : null,
        suffixIcon: check
            ? Icon(AppIcon.check, size: 10, color: AppColor.c_A3ACBB)
            : null,
      );

  void _setCurrency(String cur) {
    if (cur == Provider.of<AppState>(context, listen: false).currency) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AppLoading('submiting'),
    );
    $Http(
      token: $SP.getString('token'),
      lang: $SP.getString('lang', def: 'en-us'),
    ).post(API.setting['currency'], data: {'currency': cur}).then((res) {
      Navigator.of(context).pop();
      if (res.code == 0)
        Provider.of<AppState>(context, listen: false).setCurrency(cur);
    });
  }
}
