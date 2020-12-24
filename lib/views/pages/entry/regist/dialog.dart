import 'package:flutter/material.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import 'package:rether/views/widgets/index.dart';

class SignDialog extends StatefulWidget {
  final String uid;
  final VoidCallback complete;

  SignDialog({
    Key key,
    this.complete,
    this.uid = '',
  }) : super(key: key);

  @override
  _SignDialogState createState() => _SignDialogState();
}

class _SignDialogState extends State<SignDialog> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.complete != null) _complete();
        return false;
      },
      child: Material(
        type: MaterialType.transparency,
        child: AppTap(
          onTap: () {
            if (widget.complete != null) _complete();
          },
          child: SafeArea(
            top: false,
            child: Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(25),
                          margin: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: AppColor.c_FFFFFF,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            children: <Widget>[
                              _icons(),
                              Text(
                                I18n.of(context).$t('registSuccess1'),
                                style: AppText.f14_w5_596373,
                                textAlign: TextAlign.center,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 4),
                                child: Text(
                                  I18n.of(context).$t('registSuccess2'),
                                  style: AppText.f12_w5_596373,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 4),
                                child: AppTap(
                                  onTap: () => Coms.copy(context, widget.uid),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(widget.uid,
                                          style: AppText.f16_w5_41C88E),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.only(bottom: 2),
                                        child: Icon(AppIcon.copy,
                                            size: 12, color: AppColor.c_41C88E),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              _button(),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: AppTap(
                            onTap: () {
                              if (widget.complete != null) _complete();
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColor.c_A3ACBB,
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  width: 3,
                                  color: AppColor.c_FFFFFF,
                                ),
                              ),
                              child: Icon(
                                AppIcon.close,
                                size: 12,
                                color: AppColor.c_FFFFFF,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _icons() => Container(
        margin: EdgeInsets.only(top: 15, bottom: 30),
        child: Icon(
          AppIcon.success,
          size: 80,
          color: AppColor.c_41C88E,
        ),
      );

  Widget _button() => Container(
        margin: EdgeInsets.only(top: 35),
        child: AppTap(
          onTap: () {
            if (widget.complete != null) _complete();
          },
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColor.c_41C88E,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              I18n.of(context).$t('confirm'),
              style: AppText.f16_w7_FFFFFF,
            ),
          ),
        ),
      );

  void _complete() {
    Navigator.of(context).pop();
    widget.complete();
  }
}
