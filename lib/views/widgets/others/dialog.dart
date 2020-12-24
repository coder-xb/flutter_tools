import 'package:flutter/material.dart';

import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import 'tap.dart';

enum DialogType { error, success, warning }

class AppDialog extends StatefulWidget {
  final String text, lightText;
  final DialogType type;
  final bool maskDismiss;
  final VoidCallback confirm, dismiss, complete;

  AppDialog({
    Key key,
    this.confirm,
    this.dismiss,
    this.complete,
    this.text = '',
    this.lightText,
    this.maskDismiss = false,
    this.type = DialogType.success,
  }) : super(key: key);

  @override
  _AppDialogState createState() => _AppDialogState();
}

class _AppDialogState extends State<AppDialog> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.maskDismiss)
          widget.complete != null ? _complete() : _dismiss();
        return false;
      },
      child: Material(
        type: MaterialType.transparency,
        child: AppTap(
          onTap: () {
            if (widget.maskDismiss)
              widget.complete != null ? _complete() : _dismiss();
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
                              Text(widget.text, style: AppText.f14_w5_596373),
                              widget.lightText != null
                                  ? Container(
                                      margin: EdgeInsets.only(top: 8),
                                      child: Text(widget.lightText,
                                          style: widget.type == DialogType.error
                                              ? AppText.f16_w5_FF7B76
                                              : (widget.type ==
                                                      DialogType.success
                                                  ? AppText.f16_w5_41C88E
                                                  : AppText.f16_w5_FCBE6B)),
                                    )
                                  : Coms.empty,
                              _button(),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: AppTap(
                            onTap: () => widget.complete != null
                                ? _complete()
                                : _dismiss(),
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
          widget.type == DialogType.error
              ? AppIcon.error
              : (widget.type == DialogType.success
                  ? AppIcon.success
                  : AppIcon.warning),
          size: 80,
          color: widget.type == DialogType.error
              ? AppColor.c_FF7B76
              : (widget.type == DialogType.success
                  ? AppColor.c_41C88E
                  : AppColor.c_FCBE6B),
        ),
      );

  Widget _button() => Container(
        margin: EdgeInsets.only(top: 35),
        child: AppTap(
          onTap: () => widget.complete != null ? _complete() : _confirm(),
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: widget.type == DialogType.error
                  ? AppColor.c_FF7B76
                  : (widget.type == DialogType.success
                      ? AppColor.c_41C88E
                      : AppColor.c_FCBE6B),
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

  void _complete() {
    Navigator.of(context).pop();
    widget.complete();
  }
}
