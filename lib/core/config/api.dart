/// API接口
class API {
  API._();

  /// 测试服务器
  /*static final String url = 'http://api.rether.cacifu.com/api';
  static final String upload = 'http://upload.rether.cacifu.com/upload/img';
  static final String shares = 'http://web.rether.cacifu.com/index.html';*/

  /// 正式服务器
  static final String url = 'https://api.rether.io/api';
  static final String upload = 'https://upload.rether.io/upload/img';
  static final String shares = 'https://web.rether.io/index.html';

  /// 入口
  static final String login = '/login';
  static final String logout = '/logout';
  static final Map<String, String> regist = {
    'step_1': '/register/step_1',
    'step_2': '/register/step_2',
    'step_3': '/register/step_3',
  };
  static final Map<String, String> forget = {
    'step_1': '/forget/step_1',
    'step_2': '/forget/step_2',
    'step_3': '/forget/step_3',
  };

  /// 认证
  static final Map<String, String> auth = {
    'email': '/auth/email_send',
    'pass': '/auth/safe_auth_pass',
  };

  /// 主页
  static final String home = '/home';

  /// 版本检查
  static final String version = '/version';

  /// 其他
  static final Map<String, String> other = {
    'language': '/other/lang_list', // 语言
    'currency': '/other/country_currency_list', // 货币
  };

  /// 资产账户
  static final Map<String, String> wallet = {
    'info': '/asset/wallet/info', // 详情
    'bill_list': '/asset/wallet/bill_list', // 账单日志
    'bill_info': '/asset/wallet/bill_info', // 账单详情
    'recharge_pre': '/asset/wallet/recharge_prepare', // 充值准备
    'withdraw': '/asset/wallet/withdraw', // 提币
    'withdraw_pre': '/asset/wallet/withdraw_prepare', // 提币准备
    'withdraw_check': '/asset/wallet/withdraw_check', // 提币 - 地址检查
  };

  /// 收益账户
  static final Map<String, String> wards = {
    'info': '/asset/wards/info', // 详情
    'bill_list': '/asset/wards/bill_list', // 账单日志
    'bill_info': '/asset/wards/biil_info', // 账单详情
  };

  /// 划转
  static final Map<String, String> transfer = {
    'prepare': '/asset/transfer/prepare', // 准备
    'transfer': '/asset/transfer/transfer', // 划转
  };

  /// 合约
  static final Map<String, String> contract = {
    'index': '/contract/my/index', // 主页
    'list': '/contract/my/list', // 列表
    'info': '/contract/my/info', // 详情
    'logs': '/contract/my/profit_logs', // 收益日志
    'buy': '/contract/act/buy', // 购买
    'buy_pre': '/contract/act/buy_prepare', // 购买日志
    'cancel': '/contract/act/cancel', // 取消
  };

  /// 推荐节点
  static final Map<String, String> node = {
    'index': '/user/invite/index', // 主页
    'list': '/user/invite/user_list', // 用户列表
    'share': '/user/invite/share', // 分享
    'post': '/user/invite/post', // 保存
  };

  /// 设置
  static final Map<String, String> setting = {
    'lang': '/user/set/lang', // 设置语言
    'index': '/user/set/index', // 主页
    'currency': '/user/set/currency', // 设置货币
    'avatar': '/user/profile/avatar_update', // 修改头像
    'nickname': '/user/profile/nickname_update', // 昵称修改
    'google': '/user/safe/google_auth_bind', // 谷歌验证绑定
    'google_pre': '/user/safe/google_auth_bind_prepare', // 谷歌验证绑定-准备
    'set_asset': '/user/safe/asset_password_add', // 设置资产密码
    'get_auths': '/user/safe/asset_password_update_prepare', // 资产密码-获取验证方式
    'check_auth': '/user/safe/asset_password_update_check', // 资产密码-检测验证方式
    'change_asset': '/user/safe/asset_password_update_complete', // 修改资产密码
    'change_login': '/user/safe/login_password_update', // 修改登录密码
  };

  /// 反馈
  static final Map<String, String> report = {
    'add': '/user/feedback/add', // 提交
    'list': '/user/feedback/list', // 我的反馈
    'info': '/user/feedback/info', // 反馈详情
    'reply': '/user/feedback/reply', // 回复反馈
    'add_pre': '/user/feedback/add_prepare', // 提交-准备
  };

  /// 通知公告
  static final Map<String, String> notice = {
    'list': '/message/notice/list', // 列表
    'info': '/message/notice/info', // 详情
    'read': '/message/notice/read', // 全部已读
  };

  /// 奖池
  static final Map<String, String> prize = {
    'index': '/game1/index', // 主页
    'today': '/game1/paihang1', // 今日排行
    'zoday': '/game1/paihang2', // 昨日排行
    'total': '/game1/paihang3', // 总排行
    'logs': '/game1/prize_pool_logs', // 奖池日志
  };
}
