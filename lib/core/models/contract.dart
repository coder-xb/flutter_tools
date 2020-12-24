import 'package:rether/tools/index.dart';

class ContractModel {
  int max, mine, progress, appointment, completed;

  ContractModel({
    this.max, // 最大拥有
    this.mine, // 我拥有的
    this.progress,
    this.completed,
    this.appointment,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) => ContractModel(
        max: json['contract_nums_max'] as int,
        mine: json['contract_nums_my'] as int,
        progress: json['count_progress'] as int,
        completed: json['count_completed'] as int,
        appointment: json['count_appointment'] as int,
      );
}

class ContractInfoModel {
  int id, num, status, queue;
  String end,
      name,
      price,
      start,
      total,
      amount,
      create,
      cancel,
      surplus,
      payment,
      multiple;

  ContractInfoModel({
    this.id, // 合约ID
    this.num, // 份数
    this.end, // 结束时间
    this.name, // 合约名称
    this.queue, // 排队份数
    this.price, // 单价
    this.total, // 收益总数
    this.start, // 开始时间
    this.status, // 状态 0:预约中 1:进行中 2:已完成 3:已取消
    this.amount, // 总价
    this.cancel, // 取消时间
    this.create, // 创建时间
    this.payment, // 支付数量
    this.surplus, // 剩余收益
    this.multiple, // 收益倍数
  });

  factory ContractInfoModel.fromJson(Map<String, dynamic> json) =>
      ContractInfoModel(
        num: json['number'] as int,
        name: json['issue'] as String,
        status: json['status'] as int,
        id: json['contract_id'] as int,
        price: json['price'] as String,
        amount: json['amount'] as String,
        payment: json['pay_amount'] as String,
        multiple: json['profit_multiple'] as String,
        total: json['profit_amount_total'] as String,
        surplus: json['profit_amount_surplus'] as String,
        end: Time.format(fmt: 'MM/DD hh:mm', time: json['endtime'] as int),
        start: Time.format(fmt: 'MM/DD hh:mm', time: json['begintime'] as int),
        cancel:
            Time.format(fmt: 'MM/DD hh:mm', time: json['canceltime'] as int),
        create:
            Time.format(fmt: 'MM/DD hh:mm', time: json['createtime'] as int),
        queue: json['queue_nums'] != null ? json['queue_nums'] as int : null,
      );
}

class ContractLogsModel {
  int id, type;
  String text, amount, real, fee, remarks, time;

  ContractLogsModel({
    this.id, // 日志ID
    this.fee, // 手续费
    this.type, // 类型
    this.text, // 类型文字
    this.real, // 实际到账
    this.time, // 创建时间
    this.amount, // 释放数量
    this.remarks, // 备注信息
  });

  factory ContractLogsModel.fromJson(Map<String, dynamic> json) =>
      ContractLogsModel(
        type: json['type'] as int,
        id: json['logs_id'] as int,
        amount: json['amount'] as String,
        fee: json['amount_fee'] as String,
        text: json['type_text'] as String,
        remarks: json['remarks'] as String,
        real: json['amount_real'] as String,
        time: Time.format(
            time: json['createtime'] as int, fmt: 'YYYY/MM/DD hh:mm'),
      );
}

class ContractBuyModel {
  int stock, init, max, mine, queue, buyMax, buyMin;
  String balance, price;

  ContractBuyModel({
    this.max, // 最大拥有
    this.init, // 每日初始库存
    this.mine, // 我拥有的
    this.stock, // 库存
    this.queue, // 预约量
    this.price, // 价格
    this.balance, // 余额
    this.buyMin,
    this.buyMax,
  });

  factory ContractBuyModel.fromJson(Map<String, dynamic> json) =>
      ContractBuyModel(
        stock: json['stock'] as int,
        price: json['price'] as String,
        init: json['stock_init'] as int,
        queue: json['queue_nums'] as int,
        balance: json['balance'] as String,
        max: json['contract_nums_max'] as int,
        mine: json['contract_nums_my'] as int,
        buyMax: json['contract_nums_buy_max'] as int,
        buyMin: json['contract_nums_buy_min'] as int,
      );
}
