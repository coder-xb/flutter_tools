// ignore_for_file: INVALID_USE_OF_PROTECTED_MEMBER
// ignore_for_file: INVALID_USE_OF_VISIBLE_FOR_TESTING_MEMBER
// ignore_for_file: NON_CONSTANT_IDENTIFIER_NAMES
// ignore_for_file: MUST_BE_IMMUTABLE
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Badge extends StatefulWidget {
  // 目标组件
  final Widget child;
  // 圆点显示文字
  final String text;
  // 圆点文字样式
  final TextStyle style;
  // 圆点背景色/边框颜色
  final Color color, borderColor;
  // 圆点大小/边框宽度/圆角半径
  final double size, borderSize, radius;
  // 圆点是圆形还是矩形/
  final bool round;

  // 圆点位置/与目标组件之间的间距
  double top, left, right, spacing;

  // 圆点是在目标组件外还是内部/在目标组件之前或之后
  bool _inside = false, _before;

  Badge({
    Key key,
    @required this.child,
    this.text,
    this.color = Colors.redAccent,
    this.round = true,
    this.borderColor = Colors.white,
    this.borderSize = 2,
    this.style = const TextStyle(
      color: Colors.white,
      fontSize: 12,
    ),
    this.top = -10,
    this.right = -10,
    this.left,
    this.size = 12,
    this.radius,
  }) : super(key: key);

  // 在目标组件的左上角创建圆点(Stack)
  Badge.left({
    Key key,
    @required this.child,
    this.text,
    this.color = Colors.redAccent,
    this.round = true,
    this.borderColor = Colors.white,
    this.borderSize = 2,
    this.style = const TextStyle(
      color: Colors.white,
      fontSize: 12,
    ),
    this.top = -10,
    this.left = -10,
    this.size = 12,
    this.radius = 5,
  }) : super(key: key);

  // 在目标组件的右上角创建圆点(Stack)
  Badge.right({
    Key key,
    @required this.child,
    this.text,
    this.color = Colors.redAccent,
    this.round = true,
    this.borderColor = Colors.white,
    this.borderSize = 2,
    this.style = const TextStyle(
      color: Colors.white,
      fontSize: 12,
    ),
    this.top = -10,
    this.right = -10,
    this.size = 12,
    this.radius = 5,
  }) : super(key: key);

  // 在目标组件的后面创建圆点(Row)
  Badge.after(
      {Key key,
      @required this.child,
      this.text,
      this.color = Colors.redAccent,
      this.round = true,
      this.borderColor = Colors.white,
      this.borderSize = 2,
      this.style = const TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),
      this.spacing = 0,
      this.size = 12,
      this.radius = 5})
      : super(key: key) {
    this._inside = true;
    this._before = false;
  }

  // 在目标组件的前面创建圆点(Row)
  Badge.before({
    Key key,
    @required this.child,
    this.text,
    this.color = Colors.redAccent,
    this.round = true,
    this.borderColor = Colors.white,
    this.borderSize = 2,
    this.style = const TextStyle(
      color: Colors.white,
      fontSize: 12,
    ),
    this.size = 12,
    this.spacing = 0,
    this.radius = 5,
  }) : super(key: key) {
    this._inside = true;
    this._before = true;
  }

  @override
  _BadgeState createState() => _BadgeState();
}

class _BadgeState extends State<Badge> {
  @override
  Widget build(BuildContext context) {
    return widget._inside ? _createInside() : _createCorner();
  }

  // 在目标组件前/后创建圆点
  Widget _createInside() => Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          widget._before ? null : widget.child,
          Container(
            margin: widget._before
                ? EdgeInsets.only(right: widget.spacing)
                : EdgeInsets.only(left: widget.spacing),
            decoration: _decoration(),
            width: widget.size,
            height: widget.text != null ? null : widget.size,
            child: widget.text != null ? _text() : null,
            alignment: Alignment.center,
          ),
          widget._before ? widget.child : null,
        ].where((l) => l != null).toList(),
      );

  // 在目标组件左/右上角创建圆点
  Widget _createCorner() => Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          widget.child,
          Positioned(
            top: widget.top,
            right: widget.right,
            left: widget.left,
            child: Container(
              decoration: _decoration(),
              width: widget.text != null ? null : widget.size,
              height: widget.text != null ? null : widget.size,
              child: widget.text != null ? _text() : null,
            ),
          )
        ],
      );

  // 圆点内部的文字组件
  Widget _text() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
        child: Text(
          widget.text,
          style: widget.style,
        ),
      );

  // 圆点的外观修饰
  BoxDecoration _decoration() => BoxDecoration(
        color: widget.color,
        border: Border.all(
          color: widget.borderColor,
          width: widget.borderSize,
        ),
        borderRadius: widget.round
            ? BorderRadius.circular(100)
            : BorderRadius.circular(widget.radius ?? 0),
      );
}
