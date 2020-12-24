import 'package:flutter/material.dart';

import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import '../others/tap.dart';

class VerDialog extends StatefulWidget {
  final bool force;
  final String version;
  final VoidCallback confirm, dismiss;

  VerDialog({
    Key key,
    this.confirm,
    this.dismiss,
    this.force = false,
    this.version = '0.0.0',
  }) : super(key: key);

  @override
  _VerDialogState createState() => _VerDialogState();
}

class _VerDialogState extends State<VerDialog> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Material(
        type: MaterialType.transparency,
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
                                I18n.of(context).$t('verUpdate',
                                    params: {'ver': widget.version}),
                                style: AppText.f14_w5_596373),
                            _button(),
                          ],
                        ),
                      ),
                      !widget.force
                          ? Positioned(
                              top: 0,
                              right: 0,
                              child: AppTap(
                                onTap: _dismiss,
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
                          : Coms.empty,
                    ],
                  ),
                ],
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
          AppIcon.warning,
          size: 80,
          color: AppColor.c_FCBE6B,
        ),
      );

  Widget _button() => Container(
        margin: EdgeInsets.only(top: 35),
        child: AppTap(
          onTap: _confirm,
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColor.c_FCBE6B,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              I18n.of(context).$t('ok'),
              style: AppText.f16_w7_FFFFFF,
            ),
          ),
        ),
      );

  void _confirm() {
    Navigator.of(context).pop();
    if (widget.confirm != null) widget.confirm();
  }

  void _dismiss() {
    Navigator.of(context).pop();
    if (widget.dismiss != null) widget.dismiss();
  }
}
