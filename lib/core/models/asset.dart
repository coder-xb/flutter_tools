import 'package:rether/tools/index.dart';
import 'auth.dart';

class AssetInfoModel {
  String nickname, usable, usableValue, freeze, freezeValue;

  AssetInfoModel({
    this.usable, // 可用数量
    this.freeze, // 冻结数量
    this.nickname, // 用户昵称
    this.usableValue, // 可用数量价值
    this.freezeValue, // 冻结数量价值
  });

  factory AssetInfoModel.fromJson(Map<String, dynamic> json) => AssetInfoModel(
        nickname: json['nickname'] as String,
        usable: json['amount_usable'] as String,
        freeze: json['amount_freeze'] as String,
        usableValue: json['amount_usable_value'] as String,
        freezeValue: json['amount_freeze_value'] as String,
      );
}

class AssetBillModel {
  int billId, type, relateId;
  String text, remarks, amount, time, view;

  AssetBillModel({
    this.view, // 类型 withdraw-提币，recharge-充值
    this.text, // 类型文字
    this.time, // 创建时间
    this.type, // 订单类型
    this.billId, // 订单id
    this.amount, // 操作数量
    this.remarks, // 订单备注
    this.relateId, // 订单关联ID
  });

  factory AssetBillModel.fromJson(Map<String, dynamic> json) => AssetBillModel(
        type: json['type'] as int,
        view: json['view'] as String,
        billId: json['bill_id'] as int,
        amount: json['amount'] as String,
        remarks: json['remarks'] as String,
        relateId: json['relate_id'] as int,
        text: json['type_text'] as String,
        time: Time.format(
            time: json['createtime'] as int, fmt: 'YYYY/MM/DD hh:mm'),
      );
}

class AssetBillInfoModel {
  BillInfoModel info;
  BillCommonModel common;
  AssetBillInfoModel({
    this.info, // 附加信息
    this.common, // 公共信息
  });
  factory AssetBillInfoModel.fromJson(Map<String, dynamic> json) {
    return AssetBillInfoModel(
      info: BillInfoModel.fromJson(json['add_info']),
      common: BillCommonModel.fromJson(json['common_info']),
    );
  }
}

class BillInfoModel {
  int type, status;
  String otherType, from, to, hash, amount, real, fee, time;
  BillInfoModel({
    this.to, // 钱包地址 - to
    this.fee, // 手续费
    this.type, // 类型 1:外部 2:内部
    this.from, // 钱包地址 - from
    this.hash, // 交易hash
    this.real, // 实际到账数量
    this.time, // 创建时间
    this.status, // 状态 0:等待审核 1:正在处理 2:处理完成 3:审核未通过
    this.amount, // 申请数量
    this.otherType, // 其他类型 withdraw:提币 recharge:充值
  });

  factory BillInfoModel.fromJson(Map<String, dynamic> json) => BillInfoModel(
        to: json['address'] as String,
        hash: json['tx_hash'] as String,
        amount: json['amount'] as String,
        from: json['from_address'] as String,
        otherType: json['other_type'] as String,
        time: Time.format(
            time: json['createtime'] as int, fmt: 'YYYY/MM/DD hh:mm'),
        type: json['type'] != null ? json['type'] as int : null,
        status: json['status'] != null ? json['status'] as int : null,
        fee: json['amount_fee'] != null ? json['amount_fee'] as String : null,
        real:
            json['amount_real'] != null ? json['amount_real'] as String : null,
      );
}

class BillCommonModel {
  int billId, type, relateId;
  String text, remarks, amount, time, ip;

  BillCommonModel({
    this.ip, // IP地址
    this.text, // 类型文字
    this.time, // 创建时间
    this.type, // 订单类型
    this.billId, // 订单id
    this.amount, // 操作数量
    this.remarks, // 订单备注
    this.relateId, // 订单关联ID
  });

  factory BillCommonModel.fromJson(Map<String, dynamic> json) =>
      BillCommonModel(
        ip: json['ip'] as String,
        type: json['type'] as int,
        billId: json['bill_id'] as int,
        amount: json['amount'] as String,
        remarks: json['remarks'] as String,
        relateId: json['relate_id'] as int,
        text: json['type_text'] as String,
        time: Time.format(
            time: json['createtime'] as int, fmt: 'YYYY/MM/DD hh:mm'),
      );
}

class AssetReceiveModel {
  bool open;
  String amount, tips, min, max, address;
  AssetReceiveModel({
    this.min, // 最大值
    this.max, // 最小值
    this.open, // 是否开启
    this.tips, // 提示文本
    this.amount, // 可用数量
    this.address, // 钱包地址
  });

  factory AssetReceiveModel.fromJson(Map<String, dynamic> json) {
    bool _section = json['amount_section'] != null;
    return AssetReceiveModel(
      open: json['switch'] as bool,
      address: json['address'] as String,
      amount: json['amount_usable'] as String,
      min: _section ? json['amount_section']['min'] as String : '0.00000000',
      max: _section ? json['amount_section']['max'] as String : '0.00000000',
      tips: json['tips_text'] as String,
    );
  }
}

class AssetSendModel {
  bool open;
  AuthModel auth;
  String amount, tips, inMin, inMax, outMin, outMax, inFee, outFee, address;

  AssetSendModel({
    this.auth, // 安全验证
    this.open, // 是否开启
    this.tips, // 提示文本
    this.inMin, // 内部提币最小值
    this.inMax, // 内部提币最大值
    this.inFee, // 内部提币手续费
    this.outMin, // 外部提币最小值
    this.outMax, // 外部提币最大值
    this.outFee, // 外部提币手续费
    this.amount, // 可用数量
    this.address, // 钱包地址
  });

  factory AssetSendModel.fromJson(Map<String, dynamic> json) {
    bool _in = json['in'] != null, // 是否可用内部提币
        _out = json['out'] != null, // 是否可用外部提币
        _safe = (json['safe_auth'] != null), // 是否开启安全验证
        _inSection = (_in && json['in']['amount_section'] != null),
        _outSection = (_out && json['out']['amount_section'] != null);

    return AssetSendModel(
      open: json['switch'] as bool,
      tips: json['tips_text'] as String,
      address: json['address'] as String,
      amount: json['amount_usable'] as String,
      inMin: _inSection
          ? json['in']['amount_section']['min'] as String
          : '0.00000000',
      inMax: _inSection
          ? json['in']['amount_section']['max'] as String
          : '0.00000000',
      inFee: _in ? json['in']['amount_fee'] : '0.00000000',
      outMin: _outSection
          ? json['out']['amount_section']['min'] as String
          : '0.00000000',
      outMax: _outSection
          ? json['out']['amount_section']['max'] as String
          : '0.00000000',
      outFee: _out ? json['out']['amount_fee'] : '0.00000000',
      auth: _safe ? AuthModel.fromJson(json['safe_auth']) : null,
    );
  }
}

class AssetTransferModel {
  bool open;
  String amount, min, max, rate;
  AssetTransferModel({
    this.min, // 最小值
    this.max, // 最大值
    this.open, // 是否开启
    this.rate, // 手续费比例
    this.amount, // 可用数量
  });

  factory AssetTransferModel.fromJson(Map<String, dynamic> json) {
    bool _section = json['amount_section'] != null;
    return AssetTransferModel(
      open: json['switch'] as bool,
      rate: json['fee_rate'] as String,
      amount: json['balance'] as String,
      min: _section ? json['amount_section']['min'] as String : '0.00000000',
      max: _section ? json['amount_section']['max'] as String : '0.00000000',
    );
  }
}
