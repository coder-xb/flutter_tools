import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'adapter.dart';

typedef Selected = void Function(PickerItemModel val);
typedef Confirm = void Function(PickerItemModel val);
typedef Cancel = void Function();

class Picker {
  static const double textSize = 16;
  final PickerAdapter adapter;
  final VoidCallback onCancel;
  final Selected onSelect;
  final Confirm onConfirm;
  final Widget title, cancel, confirm;
  final String cancelText, confirmText;
  final double height, itemExtent;
  final TextStyle textStyle,
      cancelTextStyle,
      confirmTextStyle,
      selectedTextStyle;
  final TextAlign textAlign;
  final EdgeInsetsGeometry columnPadding;
  final Color backgroundColor, headercolor, containerColor;
  final Decoration headerDecoration;

  Widget _widget;
  _PickerWidgetState _state;

  Picker({
    this.adapter,
    this.height = 160,
    this.itemExtent = 36,
    this.columnPadding,
    this.textStyle,
    this.cancelTextStyle,
    this.confirmTextStyle,
    this.selectedTextStyle,
    this.textAlign = TextAlign.start,
    this.title,
    this.cancel,
    this.confirm,
    this.cancelText,
    this.confirmText,
    this.backgroundColor = Colors.white,
    this.containerColor,
    this.headercolor,
    this.headerDecoration,
    this.onCancel,
    this.onSelect,
    this.onConfirm,
  }) : assert(adapter != null);

  Widget get widget => _widget;
  _PickerWidgetState get state => _state;

  /// 生成picker控件
  Widget createPicker([ThemeData themeData]) {
    adapter.picker = this;
    _widget = _PickerWidget(
      picker: this,
      themeData: themeData,
    );
    return _widget;
  }

  /// 显示picker
  Future<T> show<T>(BuildContext context, [ThemeData themeData]) async =>
      await showModalBottomSheet<T>(
        context: context,
        builder: (_) => createPicker(themeData),
      );

  /// 取消
  void doCancel(BuildContext context) {
    Navigator.of(context).pop();
    if (onCancel != null) onCancel();
    _widget = null;
  }

  /// 确定
  void doConfirm(BuildContext context, PickerItemModel val) {
    Navigator.of(context).pop();
    if (onConfirm != null) onConfirm(val);
    _widget = null;
  }
}

/// 数据项
class PickerItem {
  final String text; // 显示内容
  final PickerItemModel val; // 数据值
  PickerItem({this.text, this.val});
}

class _PickerWidget<T> extends StatefulWidget {
  final Picker picker;
  final ThemeData themeData;
  _PickerWidget({Key key, @required this.picker, @required this.themeData})
      : super(key: key);

  @override
  _PickerWidgetState createState() =>
      _PickerWidgetState<T>(picker: this.picker, themeData: this.themeData);
}

class _PickerWidgetState<T> extends State<_PickerWidget> {
  final Picker picker;
  final ThemeData themeData;
  _PickerWidgetState(
      {Key key, @required this.picker, @required this.themeData});

  ThemeData theme;
  FixedExtentScrollController scrollController;

  @override
  void initState() {
    theme = themeData;
    picker._state = this;
    scrollController = FixedExtentScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          child: Row(children: _buildHeaderViews()),
          decoration: picker.headerDecoration ??
              BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: Color(0xFF626F81).withOpacity(.2), width: .5),
                ),
                color: picker.headercolor == null
                    ? theme.bottomAppBarColor
                    : picker.headercolor,
              ),
        ),
        _buildViews(),
      ],
    );
  }

  List<Widget> _buildHeaderViews() {
    if (theme == null) theme = Theme.of(context);
    List<Widget> items = [];

    if (picker.cancel != null) {
      items.add(DefaultTextStyle(
        style: picker.cancelTextStyle ??
            TextStyle(color: theme.accentColor, fontSize: Picker.textSize),
        child: picker.cancel,
      ));
    } else {
      String _cancelText = picker.cancelText ?? 'CANCEL';
      if (_cancelText != null || _cancelText != '') {
        items.add(InkWell(
          onTap: () => picker.doCancel(context),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Text(
              _cancelText,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xFFFF7B76),
                fontSize: Picker.textSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ));
      }
    }

    items.add(Expanded(
      child: Container(
        alignment: Alignment.center,
        child: picker.title == null
            ? picker.title
            : DefaultTextStyle(
                style: TextStyle(
                  fontSize: Picker.textSize,
                  color: theme.textTheme.title.color,
                ),
                child: picker.title,
              ),
      ),
    ));

    if (picker.confirm != null) {
      items.add(DefaultTextStyle(
        style: picker.confirmTextStyle ??
            TextStyle(color: theme.accentColor, fontSize: Picker.textSize),
        child: picker.confirm,
      ));
    } else {
      String _confirmText = picker.confirmText ?? 'CONFIRM';
      if (_confirmText != null || _confirmText.isNotEmpty) {
        items.add(InkWell(
          onTap: () => picker.doConfirm(
              context, picker.adapter.data[picker.adapter.select].val),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Text(
              _confirmText,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xFF41C88E),
                fontSize: Picker.textSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ));
      }
    }
    return items;
  }

  final Map<int, int> lastData = {};

  Widget _buildViews() {
    if (theme == null) theme = Theme.of(context);
    PickerAdapter adapter = picker.adapter;
    return adapter != null
        ? SafeArea(
            child: Container(
              padding: picker.columnPadding,
              height: picker.height,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: Color(0xFF626F81).withOpacity(.2), width: .5),
                ),
                color: picker.containerColor == null
                    ? theme.dialogBackgroundColor
                    : picker.containerColor,
              ),
              child: CupertinoPicker(
                backgroundColor: picker.backgroundColor,
                scrollController: scrollController,
                itemExtent: picker.itemExtent,
                onSelectedItemChanged: (int index) {
                  setState(() {
                    picker.adapter.select = index;
                  });
                  if (picker.onSelect != null)
                    picker.onSelect(adapter.data[index].val);
                },
                children: List.generate(adapter.data.length,
                    (int index) => adapter.build(context, index)),
              ),
            ),
          )
        : Container(height: 0);
  }
}
