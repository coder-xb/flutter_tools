import 'package:rether/tools/index.dart';

class ReportItemModel {
  List<dynamic> imgs;
  int id, type, status;
  String text, update, create, content;

  ReportItemModel({
    this.id, // ID
    this.type, // 类型
    this.imgs, // 图片
    this.text, // 类型文字
    this.status, // 状态 - 0:正在处理 1:已完成
    this.create, // 创建时间
    this.update, // 更新时间
    this.content, // 内容
  });

  factory ReportItemModel.fromJson(Map<String, dynamic> json) =>
      ReportItemModel(
        id: json['id'] as int,
        type: json['type'] as int,
        status: json['status'] as int,
        text: json['type_text'] as String,
        content: json['content'] as String,
        imgs: json['images'] as List<dynamic>,
        create:
            Time.format(time: json['createtime'] as int, fmt: 'MM/DD hh:mm'),
        update:
            Time.format(time: json['updatetime'] as int, fmt: 'MM/DD hh:mm'),
      );
}

class ReplyItemModel {
  List<dynamic> imgs;
  int id, related, type;
  String time, content;

  ReplyItemModel({
    this.id, // ID
    this.imgs, // 图片
    this.type, // 类型 - 0:普通 1:系统
    this.time, // 回复时间
    this.content, // 内容
    this.related, // 关联ID
  });

  factory ReplyItemModel.fromJson(Map<String, dynamic> json) => ReplyItemModel(
        id: json['id'] as int,
        type: json['user_type'] as int,
        related: json['relate_id'] as int,
        content: json['content'] as String,
        imgs: json['images'] as List<dynamic>,
        time: Time.format(
            time: json['createtime'] as int, fmt: 'YYYY/MM/DD hh:mm'),
      );
}

class ReportInfoModel {
  ReportItemModel info;
  List<ReplyItemModel> reply;
  ReportInfoModel({this.info, this.reply});

  factory ReportInfoModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> _reply = (json['reply_list'] as List).cast();
    return ReportInfoModel(
      info: ReportItemModel.fromJson(json['info']),
      reply: List.generate(
          _reply.length, (int i) => ReplyItemModel.fromJson(_reply[i])),
    );
  }
}
