import 'package:rether/tools/index.dart';

class NoticeListModel {
  int id;
  bool read;
  String img, desc, time, title;
  NoticeListModel({
    this.id, // ID
    this.img, // 封面图
    this.read, // 阅读量
    this.desc, // 描述
    this.time, // 时间
    this.title, // 标题
  });

  factory NoticeListModel.fromJson(Map<String, dynamic> json) =>
      NoticeListModel(
        id: json['id'] as int,
        read: json['is_read'] as bool,
        title: json['title'] as String,
        img: json['cover_pic'] as String,
        desc: json['description'] as String,
        time: Time.format(time: json['createtime'] as int, fmt: 'MM/DD hh:mm'),
      );
}

class NoticeInfoModel {
  int id, reads;
  String desc, time, title, author, content;
  NoticeInfoModel({
    this.id, // ID
    this.reads, // 阅读量
    this.desc, // 描述
    this.time, // 时间
    this.title, // 标题
    this.author, // 作者
    this.content, // 内容
  });

  factory NoticeInfoModel.fromJson(Map<String, dynamic> json) =>
      NoticeInfoModel(
        id: json['id'] as int,
        title: json['title'] as String,
        reads: json['read_nums'] as int,
        author: json['author'] as String,
        content: json['content'] as String,
        desc: json['description'] as String,
        time: Time.format(time: json['createtime'] as int, fmt: 'MM/DD hh:mm'),
      );
}
