import 'package:rether/tools/index.dart';

class NodeModel {
  int mine, nodeContract, superNode, vaild, invaild;

  NodeModel({
    this.mine, // 我的节点
    this.vaild, // 有效会员数
    this.invaild, // 无效会员数
    this.superNode, // 超级节点数
    this.nodeContract, // 节点合约数
  });
  factory NodeModel.fromJson(Map<String, dynamic> json) => NodeModel(
        mine: json['my_nodes'] as int,
        vaild: json['vaild_nums'] as int,
        invaild: json['invaild_nums'] as int,
        superNode: json['super_node'] as int,
        nodeContract: json['node_contract'] as int,
      );
}

class NodeUserModel {
  int level, nums;
  String email, phone, avatar, nickname, uid, time;

  NodeUserModel({
    this.uid, // UID
    this.nums, // 合约量
    this.time, // 创建时间
    this.level, // 等级
    this.phone, // 手机
    this.email, // 邮箱
    this.avatar, // 头像
    this.nickname, // 昵称
  });

  factory NodeUserModel.fromJson(Map<String, dynamic> json) => NodeUserModel(
        uid: json['uid'] as String,
        level: json['levels'] as int,
        phone: json['phone'] as String,
        email: json['email'] as String,
        avatar: json['avatar'] as String,
        nums: json['contract_nums'] as int,
        nickname: json['nickname'] as String,
        time: Time.format(
            time: json['createtime'] as int, fmt: 'YYYY/MM/DD hh:mm'),
      );
}
