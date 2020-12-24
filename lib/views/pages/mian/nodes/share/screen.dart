import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import '../../../../widgets/index.dart';

class ShareScreen extends StatefulWidget {
  final VoidCallback confirm;
  final ShareModel model;
  ShareScreen({
    this.model,
    this.confirm,
  });
  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  double _padding, _width, _height;
  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    _padding = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        top: false,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                AppTap(
                  onTap: _confirm,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(
                        _width * .04, _padding, _width * .04, _padding),
                    child: Screenshot(
                      controller: Coms.screen,
                      child: Container(
                        width: _width,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [AppColor.c_596373, AppColor.c_768BA3],
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[_logo(), _body()],
                        ),
                      ),
                    ),
                  ),
                ),
                _button(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _logo() => Container(
        margin: EdgeInsets.fromLTRB(_width * .08, _height * .04, 0, 0),
        child: Image.asset(
          'assets/images/icon_textlogo2.png',
          scale: 2,
          width: _width * .36,
        ),
      );

  Widget _body() => Container(
        margin: EdgeInsets.fromLTRB(_width * .08, 8, _width * .08, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[_title(), _texts(), _qrInfo()],
        ),
      );

  Widget _title() => Container(
        padding: EdgeInsets.symmetric(vertical: _height * .03),
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
          borderRadius: BorderRadius.circular(100),
        ),
        child: ClipOval(
          child: SizedBox(
            width: _width * .18,
            height: _width * .18,
            child: widget.model.avatar != null && widget.model.avatar.isNotEmpty
                ? FadeImg.assetNetwork(
                    image: widget.model.avatar,
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
          margin: EdgeInsets.only(left: _width * .034),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: _height * .005),
                child: Text(
                  widget.model.nickname,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: _width * .052,
                    color: AppColor.c_FFFFFF,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                Levels.v(widget.model.level),
                style: TextStyle(
                  fontSize: _width * .032,
                  color: AppColor.c_FFFFFF.withOpacity(.6),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: _height * .012),
                child: Row(
                  children: List.generate(
                    6,
                    (int index) => Star(
                      widget.model.level > -1 &&
                          widget.model.level < 7 &&
                          widget.model.level > index,
                      size: _width * .038,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _texts() => Container(
        margin: EdgeInsets.only(top: _height * .04),
        child: Text(
          widget.model.content,
          style: TextStyle(
            fontSize: _width * .042,
            color: AppColor.c_FFFFFF,
          ),
        ),
      );

  Widget _qrInfo() => Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              I18n.of(context).$t('enterInviteCode'),
              style: TextStyle(
                fontSize: _width * .042,
                color: AppColor.c_FFFFFF.withOpacity(.6),
              ),
            ),
            _qrCode(),
            Text(
              I18n.of(context).$t('orScan'),
              style: TextStyle(
                fontSize: _width * .042,
                color: AppColor.c_FFFFFF.withOpacity(.6),
              ),
            ),
            _qrImgae(),
          ],
        ),
      );

  Widget _qrCode() => Container(
        margin: EdgeInsets.symmetric(vertical: _height * 0.015),
        child: Text(
          '‘ ${widget.model.code} ’',
          style: TextStyle(
            fontSize: _width * .075,
            color: AppColor.c_FFFFFF,
            fontWeight: FontWeight.w700,
            fontFamily: 'EncodeSans',
          ),
        ),
      );

  Widget _qrImgae() => Container(
        margin: EdgeInsets.only(top: _height * .025, bottom: _height * .08),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: AppColor.c_FFFFFF,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: _width * .5,
          child: QrImage(
            data: '‘ ${widget.model.qrcode} ’',
            size: _width * .5,
            foregroundColor: AppColor.c_596C8B,
            backgroundColor: AppColor.c_FFFFFF,
          ),
        ),
      );

  Widget _button() => Container(
        margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
        child: AppTap(
          onTap: _confirm,
          child: Container(
            height: 50,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: AppColor.c_596C8B.withOpacity(.8),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(I18n.of(context).$t('saveImg'),
                style: AppText.f15_w7_FFFFFF),
          ),
        ),
      );

  void _confirm() {
    Navigator.of(context).pop();
    if (widget.confirm != null) widget.confirm();
  }
}
