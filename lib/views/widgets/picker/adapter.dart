import 'package:flutter/material.dart';
import 'picker.dart';

/// 数据适配器接口类
abstract class Adapter<T> {
  Picker picker;
  Widget build(BuildContext context, int index);
  Widget makeText(String text, bool select) => Container(
        alignment: Alignment.center,
        child: DefaultTextStyle(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          textAlign: picker.textAlign,
          style: picker.textStyle ??
              TextStyle(color: Colors.black87, fontSize: Picker.textSize),
          child: Text(text, style: select ? picker.selectedTextStyle : null),
        ),
      );
}

class PickerAdapter extends Adapter<Map<String, dynamic>> {
  List<PickerItem> data;
  int select = 0;
  PickerAdapter(PickerListModel model) {
    _parseData(model);
  }

  void _parseData(final PickerListModel model) {
    if (model.list != null &&
        model.list.length > 0 &&
        (data == null || data.length == 0)) {
      if (data == null) data = List<PickerItem>();
      _parseDataItem(model.list, data);
    }
  }

  void _parseDataItem(List<PickerItemModel> picks, List<PickerItem> items) {
    if (picks == null) return;
    picks.forEach((val) {
      items.add(PickerItem(val: val, text: val.name));
    });
  }

  @override
  Widget build(BuildContext context, int index) {
    final PickerItem item = data[index];
    return item.text != null && item.text.isNotEmpty
        ? makeText(item.text, index == select)
        : makeText('Slect', 0 == index);
  }
}

class PickerListModel {
  List<PickerItemModel> list;
  PickerListModel({this.list});

  factory PickerListModel.fromJson(Map<String, dynamic> json) {
    List<PickerItemModel> _temps = List<PickerItemModel>();
    json.forEach((k, v) =>
        _temps.add(PickerItemModel.fromJson({'id': '$k', 'name': '$v'})));
    return PickerListModel(list: _temps);
  }
}

class PickerItemModel {
  String id, name;
  PickerItemModel({this.id, this.name});

  factory PickerItemModel.fromJson(Map<String, dynamic> json) =>
      PickerItemModel(
        id: json['id'] as String,
        name: json['name'] as String,
      );
}
