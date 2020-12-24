import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rether/tools/index.dart';
import 'package:rether/core/index.dart';
import '../../../../widgets/index.dart';
import 'dialog.dart';

class Share extends StatefulWidget {
  final int type; // 类型 0-drawer，1-nodes
  Share(this.type);
  @override
  _ShareState createState() => _ShareState();
}

class _ShareState extends State<Share> {
  Future _future;
  ShareModel _model;
  TextEditingController _controller;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _future = _get();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<ShareModel> _get() async {
    HttpResponse _res = await $Http(
      token: $SP.getString('token'),
      lang: $SP.getString('lang', def: 'en-us'),
    ).get(API.node['share']);
    if (_res.code == 0) _model = ShareModel.fromJson(_res.data);

    return _model;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => widget.type == 0 ? Coms.openDrawer(_key) : true,
      child: Scaffold(
        key: _key,
        drawer: AppDrawer(),
        backgroundColor: AppColor.c_596373,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColor.c_596373, AppColor.c_768BA3],
            ),
          ),
          child: AppTap(
            onTap: () => Coms.unfocus(context),
            child: SafeArea(
              top: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _appBar(),
                  _logo(),
                  _body(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() => MyAppBar(
        color: Colors.transparent,
        prefix: AppTap(
          onTap: () => widget.type == 0
              ? _key.currentState.openDrawer()
              : Navigator.of(context).pop(),
          icon: Icon(widget.type == 0 ? AppIcon.menu : AppIcon.back,
              size: 14, color: AppColor.c_FFFFFF),
        ),
        suffix: AppTap(
          onTap: () => Navigator.of(context)
              .push(AuthRoute(child: ShareDialog(model: _model))),
          icon: Icon(AppIcon.share, size: 16, color: AppColor.c_FFFFFF),
        ),
      );

  Widget _logo() => Container(
        margin: EdgeInsets.fromLTRB(45, 10, 45, 0),
        child: Image.asset(
          'assets/images/icon_textlogo2.png',
          scale: 2,
          width: Screen.ins.setSize(130),
        ),
      );

  Widget _body() => Expanded(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 45, vertical: 10),
          child: FutureBuilder(
            future: _future,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                _controller = TextEditingController(text: _model.content);
                return ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[_title(), _input(), _qrInfo()],
                );
              } else
                return AppLoading(
                  'loading',
                  type: LoadingType.widget,
                  color: AppColor.c_FFFFFF,
                  style: AppText.f12_w5_FFFFFF,
                );
            },
          ),
        ),
      );

  Widget _title() => Container(
        padding: EdgeInsets.symmetric(vertical: 25),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: AppColor.c_FFFFFF.withOpacity(.4),
            ),
          ),
        ),
        child: Row(
          children: <Widget>[_avatar(), _nickname()],
        ),
      );

  Widget _avatar() => Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 3,
            color: AppColor.c_FCBE6B,
          ),
          borderRadius: BorderRadius.circular(80),
        ),
        child: ClipOval(
          child: SizedBox(
            width: 76,
            height: 76,
            child: _model.avatar != null && _model.avatar.isNotEmpty
                ? FadeImg.assetNetwork(
                    image: _model.avatar,
                    imageScale: 2,
                    fit: BoxFit.cover,
                    placeholder: 'assets/images/icon_avatar.png',
                  )
                : Image.asset(
                    'assets/images/icon_avatar.png',
                    scale: 2,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      );

  Widget _nickname() => Expanded(
        child: Container(
          margin: EdgeInsets.only(left: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 25,
                margin: EdgeInsets.only(bottom: 6),
                child: Text(
                  _model.nickname,
                  maxLines: 1,
                  style: AppText.f18_w6_FFFFFF,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                Levels.v(_model.level),
                style: AppText.f12_w6_FFFFFF
                    .copyWith(color: AppColor.c_FFFFFF.withOpacity(.6)),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  children: List.generate(
                    6,
                    (int index) => Star(_model.level > -1 &&
                        _model.level < 7 &&
                        _model.level > index),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _input() => Container(
        margin: EdgeInsets.only(top: 25),
        child: Input(
          maxLines: 4,
          horPadding: 0,
          verPadding: 0,
          controller: _controller,
          color: Colors.transparent,
          style: AppText.f15_w4_FFFFFF,
          maxLength: 68,
          placehoder: I18n.of(context).$t('saySomething'),
          placehoderStyle: AppText.f15_w4_FFFFFF,
          onComplete: () => Coms.unfocus(context),
          onInput: (String val) {
            _saveText(val);
            _model.content = val;
          },
        ),
      );

  Widget _qrInfo() => Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              I18n.of(context).$t('enterInviteCode'),
              style: AppText.f15_w4_FFFFFF
                  .copyWith(color: AppColor.c_FFFFFF.withOpacity(.6)),
            ),
            _qrCode(),
            Text(
              I18n.of(context).$t('orScan'),
              style: AppText.f15_w4_FFFFFF
                  .copyWith(color: AppColor.c_FFFFFF.withOpacity(.6)),
            ),
            _qrImgae(),
          ],
        ),
      );

  Widget _qrCode() => Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: AppTap(
          onTap: () => Coms.copy(context, _model.code),
          child: Row(
            children: <Widget>[
              Text(
                '‘ ${_model.code} ’',
                style: AppText.f36_w7_FFFFFF.copyWith(fontFamily: 'EncodeSans'),
              ),
              Container(
                margin: EdgeInsets.only(left: 15),
                child: Icon(
                  AppIcon.copy,
                  size: 20,
                  color: AppColor.c_FFFFFF,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _qrImgae() => Container(
        margin: EdgeInsets.only(top: 20, bottom: 100),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: AppColor.c_FFFFFF,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: Screen.ins.setSize(200),
          child: QrImage(
            data: _model.qrcode,
            size: Screen.ins.setSize(200),
            foregroundColor: AppColor.c_596C8B,
            backgroundColor: AppColor.c_FFFFFF,
          ),
        ),
      );

  void _saveText(String val) => $Http(
        showError: false,
        token: $SP.getString('token'),
        lang: $SP.getString('lang', def: 'en-us'),
      ).post(API.node['post'], data: {'content': val});
}
