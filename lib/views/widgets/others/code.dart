import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum EntryType { line, tight, loose }

abstract class CodeDecoration {
  /// 字体样式
  final TextStyle style, hintStyle, errorStyle;

  /// 密码形式字体样式
  final Obscure obscure;
  final String errorText, hintText;

  EntryType get entryType;

  const CodeDecoration({
    this.style,
    this.obscure,
    this.errorText,
    this.errorStyle,
    this.hintText,
    this.hintStyle,
  });

  CodeDecoration copyWith({
    TextStyle style,
    Obscure obscure,
    String errorText,
    TextStyle errorStyle,
    String hintText,
    TextStyle hintStyle,
  });
}

class Obscure {
  static final String _wrapLine = '\n';
  final String text;
  final bool isObscure;

  Obscure({
    this.isObscure = false,
    this.text = '*',
  })  : assert(text.length > 0),
        assert(text.indexOf(_wrapLine) == -1);
}

class LineDecoration extends CodeDecoration {
  final double space, size;
  final Color color, enteredColor;

  const LineDecoration({
    TextStyle style = const TextStyle(fontSize: 24, color: Color(0xFF333333)),
    Obscure obscure,
    String errorText,
    TextStyle errorStyle,
    String hintText,
    TextStyle hintStyle,
    this.space = 10.0,
    this.size = 1.0,
    this.enteredColor,
    this.color = Colors.cyan,
  }) : super(
          style: style,
          obscure: obscure,
          errorText: errorText,
          errorStyle: errorStyle,
          hintText: hintText,
          hintStyle: hintStyle,
        );

  @override
  EntryType get entryType => EntryType.line;

  @override
  CodeDecoration copyWith({
    TextStyle style,
    Obscure obscure,
    String errorText,
    TextStyle errorStyle,
    String hintText,
    TextStyle hintStyle,
    double height,
  }) =>
      LineDecoration(
        style: style ?? this.style,
        obscure: obscure ?? this.obscure,
        errorText: errorText ?? this.errorText,
        errorStyle: errorStyle ?? this.errorStyle,
        hintText: hintText ?? this.hintStyle,
        hintStyle: hintStyle ?? this.hintStyle,
        size: this.size,
        color: this.color,
        space: this.space,
        enteredColor: this.enteredColor,
      );
}

class TightDecoration extends CodeDecoration {
  final double size;
  final Radius radius;
  final Color color, bgColor;

  const TightDecoration({
    TextStyle style = const TextStyle(fontSize: 24, color: Color(0xFF333333)),
    Obscure obscure,
    String errorText,
    TextStyle errorStyle,
    String hintText,
    TextStyle hintStyle,
    this.bgColor,
    this.size = 1.0,
    this.color = Colors.cyan,
    this.radius = const Radius.circular(6.0),
  }) : super(
          style: style,
          obscure: obscure,
          errorText: errorText,
          errorStyle: errorStyle,
          hintText: hintText,
          hintStyle: hintStyle,
        );

  @override
  EntryType get entryType => EntryType.tight;

  @override
  CodeDecoration copyWith({
    TextStyle style,
    double height,
    Obscure obscure,
    String errorText,
    TextStyle errorStyle,
    String hintText,
    TextStyle hintStyle,
  }) =>
      TightDecoration(
        style: style ?? this.style,
        obscure: obscure ?? this.obscure,
        errorText: errorText ?? this.errorText,
        errorStyle: errorStyle ?? this.errorStyle,
        hintText: hintText ?? this.hintStyle,
        hintStyle: hintStyle ?? this.hintStyle,
        size: this.size,
        color: this.color,
        radius: this.radius,
        bgColor: this.bgColor,
      );
}

class LooseDecoration extends CodeDecoration {
  final double space, size;
  final Radius radius;
  final Color color, bgColor, enteredColor;

  const LooseDecoration({
    TextStyle style = const TextStyle(fontSize: 24, color: Color(0xFF333333)),
    Obscure obscure,
    String errorText,
    TextStyle errorStyle,
    String hintText,
    TextStyle hintStyle,
    this.bgColor,
    this.size = 1.0,
    this.space = 10.0,
    this.enteredColor,
    this.color = Colors.cyan,
    this.radius = const Radius.circular(6.0),
  }) : super(
          style: style,
          obscure: obscure,
          errorText: errorText,
          errorStyle: errorStyle,
          hintText: hintText,
          hintStyle: hintStyle,
        );

  @override
  EntryType get entryType => EntryType.loose;

  @override
  CodeDecoration copyWith({
    TextStyle style,
    double height,
    Obscure obscure,
    String errorText,
    TextStyle errorStyle,
    String hintText,
    TextStyle hintStyle,
  }) =>
      LooseDecoration(
        style: style ?? this.style,
        obscure: obscure ?? this.obscure,
        errorText: errorText ?? this.errorText,
        errorStyle: errorStyle ?? this.errorStyle,
        hintText: hintText ?? this.hintStyle,
        hintStyle: hintStyle ?? this.hintStyle,
        size: this.size,
        space: this.space,
        color: this.color,
        radius: this.radius,
        bgColor: this.bgColor,
        enteredColor: this.enteredColor,
      );
}

class CodeInput extends StatefulWidget {
  final int length;
  final VoidCallback onComplete;
  final ValueChanged<String> onInput;
  final CodeDecoration decoration;
  final List<TextInputFormatter> formatters;
  final TextEditingController controller;
  final bool autoFocus, enabled;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final TextInputType inputType;

  CodeInput({
    Key key,
    this.length = 6,
    this.onInput,
    this.onComplete,
    this.decoration = const LooseDecoration(),
    List<TextInputFormatter> formatter,
    this.inputType = TextInputType.phone,
    this.controller,
    this.focusNode,
    this.autoFocus = true,
    this.enabled = true,
    this.textInputAction = TextInputAction.done,
  })  : assert(length != null && length > 0),
        assert(decoration != null),
        assert(decoration.hintText == null ||
            decoration.hintText.length == length),
        formatters = formatter == null
            ? <TextInputFormatter>[
                LengthLimitingTextInputFormatter(length),
              ]
            : formatter
          ..add(LengthLimitingTextInputFormatter(length)),
        super(key: key);

  @override
  _CodeInputState createState() => _CodeInputState();
}

class _CodeInputState extends State<CodeInput> {
  String _text;
  TextEditingController _controller;
  TextEditingController get _effectController =>
      widget.controller ?? _controller;

  void _codeChanged() {
    setState(() => _updateText());
  }

  void _updateText() {
    _text = _effectController.text.runes.length > widget.length
        ? String.fromCharCodes(_effectController.text.runes.take(widget.length))
        : _effectController.text;
  }

  @override
  void initState() {
    if (widget.controller == null) _controller = TextEditingController();
    _effectController.addListener(_codeChanged);
    _updateText();
    super.initState();
  }

  @override
  void dispose() {
    _effectController.removeListener(_codeChanged);
    _effectController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CodeInput oldWidget) {
    if (widget.controller == null && oldWidget.controller != null) {
      oldWidget.controller.removeListener(_codeChanged);
      _controller = TextEditingController.fromValue(oldWidget.controller.value);
      _controller.addListener(_codeChanged);
    } else if (widget.controller != null && oldWidget.controller == null) {
      _controller.removeListener(_codeChanged);
      _controller = null;
      widget.controller.addListener(_codeChanged);
      if (_text != widget.controller.text) _codeChanged();
    }

    if (oldWidget.length > widget.length && _text.runes.length > widget.length)
      setState(() {
        _text = _text.substring(0, widget.length);
        _effectController.text = _text;
        _effectController.selection =
            TextSelection.collapsed(offset: _text.runes.length);
      });

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.decoration.style.fontSize != null
          ? widget.decoration.style.fontSize * 2
          : 48,
      child: CustomPaint(
        foregroundPainter: _CodePaint(
          text: _text ?? _text.trim(),
          length: widget.length,
          decoration: widget.decoration,
          themeData: Theme.of(context),
        ),
        child: TextField(
          controller: _effectController,
          style: TextStyle(
            fontSize: 1,
            color: Colors.transparent,
          ),
          cursorColor: Colors.transparent,
          cursorWidth: 0.0,
          autocorrect: false,
          textAlign: TextAlign.center,
          enableInteractiveSelection: false,
          maxLength: widget.length,
          keyboardType: widget.inputType,
          inputFormatters: widget.formatters,
          focusNode: widget.focusNode,
          autofocus: widget.autoFocus,
          textInputAction: widget.textInputAction,
          obscureText: true,
          onChanged: widget.onInput,
          decoration: InputDecoration(
            counterText: '',
            border: OutlineInputBorder(borderSide: BorderSide.none),
            errorText: widget.decoration.errorText,
            errorStyle: widget.decoration.errorStyle,
          ),
          enabled: widget.enabled,
          onEditingComplete: widget.onComplete,
        ),
      ),
    );
  }
}

class _CodePaint extends CustomPainter {
  final String text;
  final int length;
  final EntryType type;
  final CodeDecoration decoration;
  final ThemeData themeData;

  _CodePaint({
    @required this.text,
    @required this.length,
    CodeDecoration decoration,
    this.type = EntryType.tight,
    this.themeData,
  }) : this.decoration = decoration.copyWith(
          style: decoration.style ?? themeData.textTheme.headline,
          errorStyle: decoration.errorStyle ??
              themeData.textTheme.caption.copyWith(color: themeData.errorColor),
          hintStyle: decoration.hintStyle ??
              themeData.textTheme.headline.copyWith(color: themeData.hintColor),
        );

  @override
  bool shouldRepaint(CustomPainter old) =>
      !(old is _CodePaint && old.text == this.text);

  T _sumList<T extends num>(Iterable<T> list) {
    T sum = 0 as T;
    list.forEach((n) => sum += n);
    return sum;
  }

  void _drawTignt(Canvas cvs, Size size) {
    double height =
        decoration.errorText != null && decoration.errorText.isNotEmpty
            ? size.height - (decoration.errorStyle.fontSize + 8.0)
            : size.height;

    TightDecoration dr = decoration as TightDecoration;
    Paint borderPaint = Paint()
          ..color = dr.color
          ..strokeWidth = dr.size
          ..style = PaintingStyle.stroke
          ..isAntiAlias = true,
        bgPaint;

    if (dr.bgColor != null)
      bgPaint = Paint()
        ..color = dr.bgColor
        ..strokeWidth = dr.size
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;

    Rect rect = Rect.fromLTRB(
      dr.size / 2,
      dr.size / 2,
      size.width - dr.size / 2,
      height - dr.size / 2,
    );

    if (bgPaint != null)
      cvs.drawRRect(RRect.fromRectAndRadius(rect, dr.radius), bgPaint);

    cvs.drawRRect(RRect.fromRectAndRadius(rect, dr.radius), borderPaint);

    double width = (size.width - dr.size * (length + 1)) / length;

    for (int i = 1; i < length; i++) {
      double x = width + dr.size * i + dr.size / 2 + width * (i - 1);
      cvs.drawLine(
          Offset(x, dr.size), Offset(x, height - dr.size), borderPaint);
    }

    int index = 0;
    double startX = 0.0, startY = 0.0;

    bool obsureOn = decoration.obscure != null && decoration.obscure.isObscure;

    text.runes.forEach((v) {
      String code = obsureOn ? decoration.obscure.text : String.fromCharCode(v);

      TextPainter textPainter = TextPainter(
        text: TextSpan(text: code, style: decoration.style),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      if (startY == 0.0) startY = height / 2 - textPainter.height / 2;
      startX = dr.size * (index + 1) + width * index + textPainter.width / 2;
      textPainter.paint(cvs, Offset(startX, startY));
      index++;
    });

    if (decoration.hintText != null)
      decoration.hintText.substring(index).runes.forEach((v) {
        String code = String.fromCharCode(v);
        TextPainter textPainter = TextPainter(
          text: TextSpan(text: code, style: decoration.hintStyle),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        startY = height / 2 - textPainter.height / 2;
        startX = dr.size * (index + 1) +
            width * index +
            width / 2 -
            textPainter.width / 2;
        textPainter.paint(cvs, Offset(startX, startY));
        index++;
      });
  }

  void _drawLoose(Canvas cvs, Size size) {
    double height =
        decoration.errorText != null && decoration.errorText.isNotEmpty
            ? size.height - (decoration.errorStyle.fontSize + 8.0)
            : size.height;
    LooseDecoration dr = decoration as LooseDecoration;
    Paint borderPaint = Paint()
          ..color = dr.color
          ..strokeWidth = dr.size
          ..style = PaintingStyle.stroke
          ..isAntiAlias = true,
        bgPaint;

    if (dr.bgColor != null)
      bgPaint = Paint()
        ..color = dr.bgColor
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;

    double totalSpace = (length - 1) * dr.space,
        width = (size.width - dr.size * 2 * length - totalSpace) / length,
        startX = dr.size / 2,
        startY = height - dr.size / 2;

    List<double> spaces = List.filled(length - 1, dr.space);

    for (int i = 0; i < length; i++) {
      if (i < text.length && dr.enteredColor != null) {
        borderPaint.color = dr.enteredColor;
      } else if (decoration.errorText != null &&
          decoration.errorText.isNotEmpty) {
        if (dr.bgColor == null)
          borderPaint.color = decoration.errorStyle.color;
        else
          bgPaint = Paint()
            ..color = decoration.errorStyle.color
            ..style = PaintingStyle.fill
            ..isAntiAlias = true;
      } else
        borderPaint.color = dr.color;

      RRect rRect = RRect.fromRectAndRadius(
          Rect.fromLTRB(startX, dr.size / 2, startX + width + dr.size, startY),
          dr.radius);
      cvs.drawRRect(rRect, borderPaint);
      if (bgPaint != null) cvs.drawRRect(rRect, bgPaint);
      startX += width + dr.size * 2 + (i == length - 1 ? 0 : spaces[i]);
    }

    int index = 0;
    startY = 0.0;
    bool obscureOn = decoration.obscure != null && decoration.obscure.isObscure;

    text.runes.forEach((v) {
      String code =
          obscureOn ? decoration.obscure.text : String.fromCharCode(v);
      TextPainter textPainter = TextPainter(
        text: TextSpan(text: code, style: decoration.style),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      if (startY == 0.0) startY = height / 2 - textPainter.height / 2;
      startX = width * index +
          width / 2 -
          textPainter.width / 2 +
          _sumList(spaces.take(index)) +
          dr.size * index * 2 +
          dr.size;
      textPainter.paint(cvs, Offset(startX, startY));
      index++;
    });

    if (decoration.hintText != null)
      decoration.hintText.substring(index).runes.forEach((v) {
        String code = String.fromCharCode(v);
        TextPainter textPainter = TextPainter(
          text: TextSpan(text: code, style: decoration.hintStyle),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        startY = height / 2 - textPainter.height / 2;
        startX = width * index +
            width / 2 -
            textPainter.width / 2 +
            _sumList(spaces.take(index)) +
            dr.size * index * 2 +
            dr.size;
        textPainter.paint(cvs, Offset(startX, startY));
      });
  }

  void _drawLine(Canvas cvs, Size size) {
    double height =
        decoration.errorText != null && decoration.errorText.isNotEmpty
            ? size.height - (decoration.errorStyle.fontSize + 8.0)
            : size.height;

    LineDecoration dr = decoration as LineDecoration;
    Paint linePaint = Paint()
      ..color = dr.color
      ..strokeWidth = dr.size
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    double startX = 0.0,
        startY = height - dr.size,
        totalLen = (length - 1) * dr.space;
    List<double> spaces = List.filled(length - 1, dr.space);

    double width = (size.width - totalLen) / length;

    for (int i = 0; i < length; i++) {
      if (i < text.length && dr.enteredColor != null) {
        linePaint.color = dr.enteredColor;
      } else if (decoration.errorText != null &&
          decoration.errorText.isNotEmpty) {
        linePaint.color = decoration.errorStyle.color;
      } else
        linePaint.color = dr.color;
      cvs.drawLine(
          Offset(startX, startY), Offset(startX + width, startY), linePaint);
      startX += width + (i == length - 1 ? 0 : spaces[i]);
    }

    int index = 0;
    startX = 0.0;
    startY = 0.0;

    bool obscureOn = decoration.obscure != null && decoration.obscure.isObscure;
    text.runes.forEach((v) {
      String code =
          obscureOn ? decoration.obscure.text : String.fromCharCode(v);
      TextPainter textPainter = TextPainter(
        text: TextSpan(text: code, style: decoration.style),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      if (startY == 0.0) startY = height / 2 - textPainter.height / 2;
      startX = width * index +
          width / 2 -
          textPainter.width / 2 +
          _sumList(spaces.take(index));
      textPainter.paint(cvs, Offset(startX, startY));
      index++;
    });

    if (decoration.hintText != null)
      decoration.hintText.substring(index).runes.forEach((v) {
        String code = String.fromCharCode(v);
        TextPainter textPainter = TextPainter(
          text: TextSpan(text: code, style: decoration.hintStyle),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        startY = height / 2 - textPainter.height / 2;
        startX = width * index +
            width / 2 -
            textPainter.width / 2 +
            _sumList(spaces.take(index));
        textPainter.paint(cvs, Offset(startX, startY));
        index++;
      });
  }

  @override
  void paint(Canvas canvas, Size size) {
    switch (decoration.entryType) {
      case EntryType.tight:
        _drawTignt(canvas, size);
        break;
      case EntryType.loose:
        _drawLoose(canvas, size);
        break;
      case EntryType.line:
        _drawLine(canvas, size);
        break;
    }
  }
}
