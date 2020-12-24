import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
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
  int _nums = 5;
  Future _future;
  ReportInfoModel _model;
  bool _canSubmit = false, _isClick = true;
  TextEditingController _controller;
  List<String> _imgs = List<String>();

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

  Future<ReportInfoModel> _get() async {
    HttpResponse _res = await $Http(
      token: $SP.getString('token'),
      lang: $SP.getString('lang', def: 'en-us'),
    ).get(API.report['info'], params: {'id': widget.id});
    if (_res.code == 0) _model = ReportInfoModel.fromJson(_res.data);

    return _model;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.c_FFFFFF,
      body: SafeArea(
        top: false,
        child: FutureBuilder(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: <Widget>[
                  _appBar(),
                  Expanded(child: _body()),
                  _model.info.status == 0 ? _button() : Coms.empty,
                ],
              );
            } else
              return Column(
                children: <Widget>[
                  _appBar(),
                  Expanded(
                    child: AppLoading(
                      'loading',
                      type: LoadingType.widget,
                      color: AppColor.c_596373,
                      style: AppText.f12_w5_596373,
                    ),
                  ),
                ],
              );
          },
        ),
      ),
    );
  }

  Widget _appBar() => MyAppBar(
        color: Colors.transparent,
        title:
            Text(I18n.of(context).$t('report'), style: AppText.f17_w6_151515),
        prefix: AppTap(
          onTap: () => Navigator.of(context).pop(),
          icon: Icon(AppIcon.back, size: 14, color: AppColor.c_2F3231),
        ),
      );

  Widget _body() {
    List<Widget> _widgets = _model.reply.length != 0
        ? List.generate(_model.reply.length, (int i) => _reply(_model.reply[i]))
        : List<Widget>();
    _widgets.insert(0, _content());
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _widgets,
        ),
        _model.info.status == 0 ? _continue() : Coms.empty,
      ],
    );
  }

  Widget _content() => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                I18n.of(context)
                    .$t('createTime', params: {'time': _model.info.create}),
                style: AppText.f14_w4_A3ACBB,
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
              child: Text(_model.info.content, style: AppText.f14_w4_596373),
            ),
            _imageView(_model.info.imgs),
          ],
        ),
      );

  Widget _reply(ReplyItemModel model) => Container(
        margin: EdgeInsets.only(top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Text(I18n.of(context).$t('reply'),
                        style: AppText.f14_w4_FF7B76),
                  ),
                  Text(
                      I18n.of(context)
                          .$t('atTime', params: {'time': model.time}),
                      style: AppText.f14_w4_A3ACBB)
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
              child: Text(model.content, style: AppText.f14_w4_596373),
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

  Widget _continue() => Container(
        margin: EdgeInsets.only(top: 25, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                I18n.of(context).$t('continue'),
                style: AppText.f14_w4_A3ACBB,
              ),
            ),
            _input(),
            _replyImageView(),
          ],
        ),
      );

  Widget _input() => Container(
        decoration: BoxDecoration(
          color: AppColor.c_FFFFFF,
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: 20,
              color: AppColor.c_000000.withOpacity(.05),
            ),
          ],
        ),
        child: Input(
          maxLines: 7,
          horPadding: 20,
          verPadding: 20,
          controller: _controller,
          style: AppText.f15_w4_596373,
          placehoder: I18n.of(context).$t('enterReply'),
          placehoderStyle: AppText.f15_w4_A3ACBB,
          onInput: (String val) => setState(() => _canSubmit = val != ''),
          onComplete: () => Coms.unfocus(context),
        ),
      );

  Widget _replyImageView() => Container(
        margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  AppIcon.link,
                  size: 16,
                  color: AppColor.c_A3ACBB,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text.rich(
                    TextSpan(
                      text: I18n.of(context).$t('addImage'),
                      style: AppText.f15_w4_596373,
                      children: <TextSpan>[
                        TextSpan(
                          text: I18n.of(context)
                              .$t('imageMax', params: {'num': _nums}),
                          style: AppText.f15_w4_A3ACBB,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            _addView(),
          ],
        ),
      );

  Widget _addView() {
    List<Widget> _widgets =
        List.generate(_imgs.length, (int i) => _replyImage(_imgs[i]));
    if (_imgs.length < _nums) _widgets.add(_replyAddImage());
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 20),
      child: Wrap(spacing: 16, runSpacing: 16, children: _widgets),
    );
  }

  Widget _replyImage(String img) => AppTap(
        onTap: () => setState(() => _imgs.remove(img)),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ClipRRect(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(color: AppColor.c_FFFFFF),
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
              ),
            ),
            Container(
              width: 80,
              height: 80,
              alignment: Alignment.center,
              color: AppColor.c_000000.withOpacity(.15),
              child: Icon(AppIcon.delete, color: AppColor.c_FFFFFF),
            ),
          ],
        ),
      );

  Widget _replyAddImage() => AppTap(
        onTap: _getImg,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(color: AppColor.c_F1F2F4),
          child: Icon(
            AppIcon.image,
            color: AppColor.c_A3ACBB,
          ),
        ),
      );

  Widget _button() => Container(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: AppTap(
          onTap: _submit,
          child: Container(
            height: 50,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: _canSubmit ? AppColor.c_596C8B : AppColor.c_B7BEC9,
              borderRadius: BorderRadius.circular(50),
            ),
            child:
                Text(I18n.of(context).$t('done'), style: AppText.f15_w7_FFFFFF),
          ),
        ),
      );

  Future _getImg() async {
    ImagePickerSaver.pickImage(source: ImageSource.gallery)
        .then((File file) async {
      if (file != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AppLoading('submiting'),
        );
        String _path = file.path;
        FormData _form = FormData.fromMap({
          'type': 'feedback',
          'file': await MultipartFile.fromFile(
            _path,
            filename: _path.substring(_path.lastIndexOf('/') + 1, _path.length),
          ),
        });

        $Http(
          upload: true,
          lang: $SP.getString('lang', def: 'en-us'),
        ).post(API.upload, data: _form).then((res) {
          Navigator.of(context).pop();
          if (res.code == 0) setState(() => _imgs.add(res.data['file_url']));
        });
      }
    });
  }

  void _refresh() {
    setState(() {
      _imgs?.clear();
      _future = _get();
      _canSubmit = false;
      _controller?.clear();
    });
  }

  void _submit() {
    Coms.unfocus(context);
    if (_canSubmit && _isClick) {
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
        API.report['reply'],
        data: {
          'id': widget.id,
          'images': _imgs,
          'content': _controller.text,
        },
      ).then((res) {
        _isClick = true;
        Navigator.of(context).pop();
        if (res.code == 0) _refresh();
      });
    }
  }
}
