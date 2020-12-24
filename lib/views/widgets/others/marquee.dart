import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

/// 滚动方向: 由左而右，由右而左，由上而下，由下而上
enum AnimDirection { ltr, rtl, utd, dtu }

/// 跑马灯效果
class Marquee extends StatefulWidget {
  final Color color;
  final TextStyle style;
  final Duration duration;
  final List<String> texts;
  final Widget prefix, suffix;
  final List<BoxShadow> shadow;
  final AnimDirection direction;
  final AlignmentGeometry alignment;
  final BorderRadiusGeometry radius;
  final ValueChanged<int> onTap;
  final double width, verPadding, horPadding;

  Marquee({
    Key key,
    this.texts,
    this.onTap,
    this.width,
    this.prefix,
    this.suffix,
    this.radius,
    this.shadow,
    this.verPadding = 10,
    this.horPadding = 15,
    this.color = Colors.white,
    this.alignment = Alignment.center,
    this.direction = AnimDirection.utd,
    this.duration = const Duration(milliseconds: 3000),
    this.style = const TextStyle(color: Color(0xFF333333), fontSize: 14),
  })  : assert(texts != null),
        super(key: key);

  @override
  _MarqueeState createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> with TickerProviderStateMixin {
  int _index = 0;
  AnimationController _controller;
  // 透明度
  Animation<double> _opcaity, _nextOpcaity;
  // 位移
  Animation<Offset> _offset, _nextOffset;

  @override
  void initState() {
    _initAnimation();
    super.initState();
  }

  /// 初始化动画
  void _initAnimation() {
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _opcaity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.1, curve: Curves.linear),
    ));
    _nextOpcaity = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.9, 1.0, curve: Curves.linear),
    ));
    if (widget.direction == AnimDirection.utd ||
        widget.direction == AnimDirection.dtu) {
      // 纵向滚动
      _offset = Tween<Offset>(
        begin: widget.direction == AnimDirection.utd
            ? const Offset(0.0, 0.0)
            : const Offset(0.0, 1.0),
        end: widget.direction == AnimDirection.utd
            ? const Offset(0.0, 1.0)
            : const Offset(0.0, 0.0),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.1, curve: Curves.linear),
      ));
      _nextOffset = Tween<Offset>(
        begin: const Offset(0.0, -1.0),
        end: const Offset(0.0, 0.0),
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(0.9, 1.0, curve: Curves.linear),
        ),
      );
    } else {
      // 横向滚动
      _offset = Tween<Offset>(
        begin: widget.direction == AnimDirection.rtl
            ? const Offset(1.0, 0.0)
            : const Offset(-1.0, 0.0),
        end: const Offset(0.0, 0.0),
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(0.0, 0.1, curve: Curves.linear),
        ),
      );

      _nextOffset = Tween<Offset>(
        begin: const Offset(0.0, 0.0),
        end: widget.direction == AnimDirection.rtl
            ? const Offset(-1.0, 0.0)
            : const Offset(1.0, 0.0),
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(0.9, 1.0, curve: Curves.linear),
        ),
      );
    }

    _controller
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _index++;
            if (_index >= widget.texts.length) _index = 0;
          });
          _controller.reset();
          _controller.forward();
        }
        if (status == AnimationStatus.dismissed) _controller.forward();
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) widget.onTap(_index);
      },
      child: Container(
        width: widget.width ?? MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: widget.color,
          boxShadow: widget.shadow,
          borderRadius: widget.radius ?? BorderRadius.circular(100),
        ),
        child: Row(children: <Widget>[_prefix(), _main(), _suffix()]),
      ),
    );
  }

  Widget _main() => Expanded(
        child: ClipRRect(
          child: SlideTransition(
            position: _nextOffset,
            child: FadeTransition(
              opacity: _nextOpcaity,
              child: SlideTransition(
                position: _offset,
                child: FadeTransition(
                  opacity: _opcaity,
                  child: Container(
                    alignment: widget.alignment,
                    width: widget.width ?? MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: widget.radius ?? BorderRadius.circular(100),
                    ),
                    padding: EdgeInsets.fromLTRB(
                      widget.prefix != null ? 0 : widget.horPadding,
                      widget.verPadding,
                      widget.suffix != null ? 0 : widget.horPadding,
                      widget.verPadding,
                    ),
                    child: Text(
                      widget.texts[_index],
                      maxLines: 1,
                      style: widget.style,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Widget _prefix() => widget.prefix != null
      ? Container(
          margin: EdgeInsets.only(right: 10, left: widget.horPadding),
          child: widget.prefix)
      : Container(width: 0, height: 0);

  Widget _suffix() => widget.suffix != null
      ? Container(
          margin: EdgeInsets.only(left: 10, right: widget.horPadding),
          child: widget.suffix)
      : Container(width: 0, height: 0);
}
