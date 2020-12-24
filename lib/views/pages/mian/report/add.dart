import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import '../../../widgets/index.dart';

class AddReport extends StatefulWidget {
  @override
  _AddReportState createState() => _AddReportState();
}

class _AddReportState extends State<AddReport> {
  int _nums = 5;
  Future _future;
  PickerItemModel _type;
  PickerListModel _model;
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

  Future<PickerListModel> _get() async {
    HttpResponse _res = await $Http(
      token: $SP.getString('token'),
      lang: $SP.getString('lang', def: 'en-us'),
    ).get(API.report['add_pre']);
    Map<String, dynamic> _types = {'-1': I18n.of(context).$t('selectType')};
    if (_res.code == 0) {
      _nums = _res.data['upload_image_max'];
      (_res.data['type_list'] as Map<String, dynamic>)
          .forEach((k, v) => _types[k] = v);
    }
    _model = PickerListModel.fromJson(_types);
    _type = _model.list[0];

    return _model;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.c_FFFFFF,
      body: SafeArea(
        top: false,
        child: AppTap(
          onTap: () => Coms.unfocus(context),
          child: Container(
            margin: EdgeInsets.only(top: 8),
            child: FutureBuilder(
              future: _future,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      _appBar(),
                      Expanded(child: _body()),
                      _button(),
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

  Widget _body() => ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[_select(), _input(), _imageView()],
      );

  Widget _select() => AppTap(
        onTap: () => Picker(
          adapter: PickerAdapter(_model),
          confirmText: I18n.of(context).$t('confirm'),
          cancelText: I18n.of(context).$t('cancel'),
          cancelTextStyle: AppText.f12_w4_FFFFFF,
          textStyle: AppText.f15_w4_596373,
          selectedTextStyle: AppText.f15_w4_A3ACBB,
          onConfirm: (PickerItemModel val) => setState(() {
            _type = val;
            _canSubmit = (_controller.text != '' && val.id != '-1');
          }),
        ).show(context),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: AppColor.c_FFFFFF,
            boxShadow: <BoxShadow>[
              BoxShadow(
                blurRadius: 20,
                color: AppColor.c_000000.withOpacity(.05),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  _type.name,
                  style: AppText.f15_w4_596373,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: AppColor.c_A3ACBB,
                size: 24,
              ),
            ],
          ),
        ),
      );

  Widget _input() => Container(
        margin: EdgeInsets.only(top: 20),
        child: Container(
          margin: EdgeInsets.only(top: 10),
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
            placehoder: I18n.of(context).$t('enterContent'),
            placehoderStyle: AppText.f15_w4_A3ACBB,
            onInput: (String val) =>
                setState(() => _canSubmit = (val != '' && _type.id != '-1')),
            onComplete: () => Coms.unfocus(context),
          ),
        ),
      );

  Widget _imageView() => Container(
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
        List.generate(_imgs.length, (int i) => _image(_imgs[i]));
    if (_imgs.length < _nums) _widgets.add(_addImage());
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 20),
      child: Wrap(spacing: 16, runSpacing: 16, children: _widgets),
    );
  }

  Widget _image(String img) => AppTap(
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

  Widget _addImage() => AppTap(
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
        API.report['add'],
        data: {
          'images': _imgs,
          'type': _type.id,
          'content': _controller.text,
        },
      ).then((res) {
        _isClick = true;
        Navigator.of(context).pop();
        if (res.code == 0) {
          evbus.fire(RefreshReport(true));
          Navigator.of(context).pop();
        }
      });
    }
  }
}
