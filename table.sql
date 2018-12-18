/*
Navicat MySQL Data Transfer

Source Server         : root
Source Server Version : 50628
Source Host           : localhost:3306
Source Database       : p2p

Target Server Type    : MYSQL
Target Server Version : 50628
File Encoding         : 65001

Date: 2018-12-18 14:38:25
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for account
-- ----------------------------
DROP TABLE IF EXISTS `account`;
CREATE TABLE `account` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` int(10) unsigned DEFAULT NULL COMMENT '用户ID',
  `total` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '总资产',
  `available_balance` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '可用余额(清算+未清算)',
  `recharge` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '充值金额(未清算)',
  `tender_freeze` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '投标冻结',
  `withdraw_freeze` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '提现冻结',
  `accumulated_income` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '累计收益',
  `wait_capital` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '待收本金',
  `wait_interest` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '待收利息',
  `version` int(10) unsigned DEFAULT '0' COMMENT '乐观锁版本号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id_unique` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户资产账户表';

-- ----------------------------
-- Records of account
-- ----------------------------

-- ----------------------------
-- Table structure for account_detail_log
-- ----------------------------
DROP TABLE IF EXISTS `account_detail_log`;
CREATE TABLE `account_detail_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned DEFAULT NULL COMMENT '用户ID',
  `amount` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '实际操作金额',
  `classify` tinyint(2) DEFAULT NULL COMMENT '资金变动类型 0:充值 1:投资 2:回款 3:提现 4:平台奖励 5:承接奖励 6:转让回款 7:撤标 ',
  `total` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '当前总金额',
  `available_balance` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '可用余额(已清算+未清算)',
  `recharge` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '充值金额(未清算)',
  `tender_freeze` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '投标冻结金额',
  `withdraw_freeze` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '提现冻结金额',
  `accumulated_income` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '累计收益',
  `wait_capital` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '待收本金',
  `wait_interest` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '待收利息',
  `add_time` datetime DEFAULT NULL COMMENT '发生时间',
  `remark` varchar(200) DEFAULT NULL COMMENT '备注信息',
  PRIMARY KEY (`id`),
  KEY `user_id_index` (`user_id`) USING BTREE,
  KEY `type_index` (`classify`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户资产变动详细记录表';

-- ----------------------------
-- Records of account_detail_log
-- ----------------------------

-- ----------------------------
-- Table structure for account_log
-- ----------------------------
DROP TABLE IF EXISTS `account_log`;
CREATE TABLE `account_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` int(10) unsigned DEFAULT NULL COMMENT '用户id',
  `amount` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '金额',
  `classify` tinyint(2) unsigned DEFAULT NULL COMMENT '资金变动类型 0:充值 1:投资 2:回款 3:提现 4:平台奖励 5:承接奖励 6:转让回款',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `tender_id` int(10) unsigned DEFAULT NULL COMMENT '投标id',
  `remark` varchar(100) DEFAULT NULL COMMENT '备注信息',
  `order_no` varchar(100) DEFAULT NULL COMMENT '订单号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='投资人资金记录表';

-- ----------------------------
-- Records of account_log
-- ----------------------------

-- ----------------------------
-- Table structure for app_feedback
-- ----------------------------
DROP TABLE IF EXISTS `app_feedback`;
CREATE TABLE `app_feedback` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned DEFAULT NULL COMMENT '用户ID',
  `state` tinyint(1) unsigned DEFAULT NULL COMMENT '状态: 0:待解决 1:已解决',
  `version` varchar(50) DEFAULT NULL COMMENT '软件版本',
  `system_version` varchar(50) DEFAULT NULL COMMENT '系统版本',
  `content` varchar(200) DEFAULT NULL COMMENT '反馈内容',
  `add_time` datetime DEFAULT NULL COMMENT '反馈时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `index_status` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='APP用户反馈信息表';

-- ----------------------------
-- Records of app_feedback
-- ----------------------------

-- ----------------------------
-- Table structure for app_version
-- ----------------------------
DROP TABLE IF EXISTS `app_version`;
CREATE TABLE `app_version` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `classify` char(20) DEFAULT NULL COMMENT '版本类型 IOS,ANDROID',
  `version` char(10) DEFAULT NULL COMMENT '版本号:1.2.8',
  `force_update` bit(1) DEFAULT b'0' COMMENT '是否强制更新 0:否 1:是',
  `url` varchar(500) DEFAULT NULL COMMENT '下载地址,android为实际下载地址,ios是跳转到app_store',
  `add_time` datetime DEFAULT NULL COMMENT '上传时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注信息:版本更新的东西或解决的问题',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='APP版本管理表';

-- ----------------------------
-- Records of app_version
-- ----------------------------

-- ----------------------------
-- Table structure for bank
-- ----------------------------
DROP TABLE IF EXISTS `bank`;
CREATE TABLE `bank` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nid` varchar(20) DEFAULT NULL COMMENT '所属模板nid,例如充值,开户,提现等',
  `code` varchar(20) NOT NULL COMMENT '银行编码类型:ABC,ICBC',
  `transform_code` varchar(50) DEFAULT NULL COMMENT '第三方充值银行编码(三方支付公司采用的编码可能不是ABC,ICBC等)',
  `bank_name` varchar(20) NOT NULL COMMENT '银行名称',
  `limit_amount` decimal(10,2) unsigned DEFAULT '0.00' COMMENT '单卡当日限额',
  `icon` varchar(500) DEFAULT NULL COMMENT '银行图标(长图)',
  `logo` varchar(500) DEFAULT NULL COMMENT '银行图标logo(短图)',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` bit(1) DEFAULT b'0' COMMENT '删除状态:0:正常 1:已删除(数据库可见,后台不可见)',
  `locked` bit(1) DEFAULT b'0' COMMENT '锁定状态 0:未锁定1:锁定(相当于下架,后台可见,前台不可见)',
  `remark` varchar(100) DEFAULT NULL COMMENT '银行卡限额说明',
  PRIMARY KEY (`id`),
  KEY `type_index` (`code`),
  KEY `name_index` (`bank_name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='银行信息表';

-- ----------------------------
-- Records of bank
-- ----------------------------
INSERT INTO `bank` VALUES ('1', null, '1', null, '我是出借,你是出借吗', '0.00', null, null, '2018-04-25 14:36:43', null, '\0', '\0', '去');

-- ----------------------------
-- Table structure for bank_card
-- ----------------------------
DROP TABLE IF EXISTS `bank_card`;
CREATE TABLE `bank_card` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL COMMENT '用户ID',
  `user_type` tinyint(1) unsigned DEFAULT '0' COMMENT '用户类型 0:投资人 1:借款人',
  `bank_code` varchar(10) DEFAULT NULL COMMENT '银行编号:ABC,ICBC',
  `bank_num` varchar(32) DEFAULT NULL COMMENT '银行卡号',
  `mobile` char(11) DEFAULT NULL COMMENT '银行预留手机号',
  `deleted` bit(1) DEFAULT b'0' COMMENT '删除状态 0:正常 1:已删除',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(100) DEFAULT NULL COMMENT '备注信息',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id_index` (`user_id`) USING BTREE,
  KEY `user_type_index` (`user_type`),
  KEY `bank_code_index` (`bank_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='银行卡信息表';

-- ----------------------------
-- Records of bank_card
-- ----------------------------

-- ----------------------------
-- Table structure for banner
-- ----------------------------
DROP TABLE IF EXISTS `banner`;
CREATE TABLE `banner` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `classify` tinyint(2) unsigned DEFAULT NULL COMMENT '轮播图类型:由system_dict的banner_classify维护(不同模块的轮播均在该表中维护)',
  `client_type` tinyint(1) unsigned DEFAULT '0' COMMENT '客户端类型 0:PC 1:APP',
  `img_url` varchar(500) NOT NULL COMMENT '轮播图片地址',
  `turn_url` varchar(500) DEFAULT NULL COMMENT '轮播图点击后跳转的URL',
  `sort` tinyint(2) unsigned DEFAULT NULL COMMENT '轮播图顺序(小<->大) 最小的在最前面',
  `start_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '开始展示时间(可在指定时间后开始展示)',
  `end_time` datetime DEFAULT NULL COMMENT '取消展示的时间(只在某个时间段展示)',
  `click` bit(1) DEFAULT b'1' COMMENT '是否可点击 0:否 1:可以',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` bit(1) DEFAULT b'0' COMMENT '删除状态 0:未删除 1:已删除',
  `remark` varchar(200) DEFAULT NULL COMMENT '备注信息',
  PRIMARY KEY (`id`),
  KEY `type_client_type_index` (`classify`,`client_type`) USING BTREE COMMENT '组合索引',
  KEY `type_index` (`classify`),
  KEY `client_type_index` (`classify`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='轮播图维护表';

-- ----------------------------
-- Records of banner
-- ----------------------------
INSERT INTO `banner` VALUES ('1', '1', '1', '1', '1', null, '2018-10-17 10:18:08', null, '1', null, null, null, null);

-- ----------------------------
-- Table structure for borrower
-- ----------------------------
DROP TABLE IF EXISTS `borrower`;
CREATE TABLE `borrower` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `mobile` char(11) NOT NULL COMMENT '手机号码',
  `password` varchar(128) DEFAULT NULL COMMENT '登陆密码MD5',
  `deposit_no` varchar(128) DEFAULT NULL COMMENT '存管号',
  `deposit_status` tinyint(1) unsigned DEFAULT NULL COMMENT '存管状态',
  `locked` bit(1) DEFAULT b'0' COMMENT '用户状态 0:未锁定 1:锁定(不可登陆系统)',
  `deleted` bit(1) DEFAULT b'0' COMMENT '删除状态 0:正常 1:已删除(仅数据库可见)',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `mobile_index` (`mobile`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='个人借款人信息';

-- ----------------------------
-- Records of borrower
-- ----------------------------

-- ----------------------------
-- Table structure for borrower_account
-- ----------------------------
DROP TABLE IF EXISTS `borrower_account`;
CREATE TABLE `borrower_account` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `borrower_id` int(10) unsigned DEFAULT NULL COMMENT '借款人id',
  `total` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '借款总额(该值只会累加)',
  `available_balance` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '可用余额(清算+未清算)',
  `recharge` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '充值金额',
  `withdraw_freeze` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '提现冻结金额',
  `repay` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '已还金额',
  `un_repay` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '未还金额',
  `pay` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '已缴费金额',
  PRIMARY KEY (`id`),
  UNIQUE KEY `borrower_id_unique` (`borrower_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='借款人资产表';

-- ----------------------------
-- Records of borrower_account
-- ----------------------------

-- ----------------------------
-- Table structure for borrower_account_log
-- ----------------------------
DROP TABLE IF EXISTS `borrower_account_log`;
CREATE TABLE `borrower_account_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `borrower_id` int(10) DEFAULT NULL COMMENT '借款人id',
  `amount` decimal(12,2) DEFAULT '0.00' COMMENT '资金金额',
  `classify` tinyint(2) DEFAULT NULL COMMENT '资金类型',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `project_id` int(10) DEFAULT NULL COMMENT '产品id',
  `order_no` varchar(100) DEFAULT NULL COMMENT '订单编号',
  PRIMARY KEY (`id`),
  KEY `borrower_id_index` (`borrower_id`),
  KEY `borrower_id_type_index` (`classify`,`borrower_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='借款人资金记录表';

-- ----------------------------
-- Records of borrower_account_log
-- ----------------------------

-- ----------------------------
-- Table structure for borrower_extend
-- ----------------------------
DROP TABLE IF EXISTS `borrower_extend`;
CREATE TABLE `borrower_extend` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `borrower_id` int(10) DEFAULT NULL COMMENT '借款人ID',
  `real_name` varchar(20) DEFAULT NULL COMMENT '借款人真实姓名',
  `id_card` varchar(128) DEFAULT NULL COMMENT '身份证号码',
  `address` varchar(100) DEFAULT NULL COMMENT '户籍地址(身份证)',
  `local_address` varchar(100) DEFAULT NULL COMMENT '现居住地址',
  PRIMARY KEY (`id`),
  KEY `index_borrower_id` (`borrower_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='个人借款人扩展信息';

-- ----------------------------
-- Records of borrower_extend
-- ----------------------------

-- ----------------------------
-- Table structure for discount_coupon
-- ----------------------------
DROP TABLE IF EXISTS `discount_coupon`;
CREATE TABLE `discount_coupon` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` int(10) DEFAULT NULL COMMENT '用户id',
  `title` varchar(100) DEFAULT NULL COMMENT '优惠券名称',
  `state` tinyint(1) DEFAULT NULL COMMENT '优惠券状态 0:未使用 1:已使用 2:已冻结,3已过期',
  `classify` tinyint(1) DEFAULT NULL COMMENT '优惠券类型 0:抵扣券 1:加息券',
  `face_value` decimal(10,2) DEFAULT NULL COMMENT '优惠券金额 抵扣券时表示元,加息券时表示%',
  `start_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '有效开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '失效时间 如果为空则永久有效',
  `period_limit` tinyint(2) unsigned DEFAULT '0' COMMENT '期限限制(月)',
  `amount_limit` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '起投金额限制',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '发放时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `user_id_index` (`user_id`),
  KEY `user_id_status_index` (`user_id`,`state`),
  KEY `type_index` (`classify`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户优惠券表';

-- ----------------------------
-- Records of discount_coupon
-- ----------------------------

-- ----------------------------
-- Table structure for discount_coupon_tender
-- ----------------------------
DROP TABLE IF EXISTS `discount_coupon_tender`;
CREATE TABLE `discount_coupon_tender` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `tender_id` int(10) unsigned DEFAULT NULL COMMENT '投标id',
  `discount_coupon_id` int(10) unsigned DEFAULT NULL COMMENT '优惠券id',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间(使用时间)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='投标优惠券关联表';

-- ----------------------------
-- Records of discount_coupon_tender
-- ----------------------------

-- ----------------------------
-- Table structure for help_instruction
-- ----------------------------
DROP TABLE IF EXISTS `help_instruction`;
CREATE TABLE `help_instruction` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `classify` tinyint(2) DEFAULT NULL COMMENT '帮助分类取system_dict表中help_classify字段',
  `state` tinyint(1) DEFAULT '1' COMMENT '状态 0:不显示 1:显示',
  `ask` varchar(50) DEFAULT NULL COMMENT '问',
  `answer` varchar(2000) DEFAULT NULL COMMENT '答 支持',
  `sort` tinyint(4) DEFAULT '0' COMMENT '排序(小<->大)',
  `deleted` bit(1) DEFAULT b'0' COMMENT '删除状态 0:不删除(正常) 1:已删除',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='帮助说明信息表';

-- ----------------------------
-- Records of help_instruction
-- ----------------------------

-- ----------------------------
-- Table structure for image_log
-- ----------------------------
DROP TABLE IF EXISTS `image_log`;
CREATE TABLE `image_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(50) DEFAULT NULL COMMENT '图片名称',
  `classify` tinyint(3) unsigned DEFAULT NULL COMMENT '图片分类 数据字典image_classify',
  `url` varchar(500) DEFAULT NULL COMMENT '文件存放地址',
  `size` bigint(15) unsigned DEFAULT NULL COMMENT '文件大小',
  `remark` varchar(200) DEFAULT NULL COMMENT '备注信息',
  `deleted` bit(1) DEFAULT b'0' COMMENT '删除状态 0:未删除 1:已删除',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='图片上传记录';

-- ----------------------------
-- Records of image_log
-- ----------------------------
INSERT INTO `image_log` VALUES ('1', '首页打字', '1', '/upload/img/2018-11-29/af77cdda-0246-4925-a406-00180d0923cf.png', '166315', '', '\0', '2018-11-29 15:42:53', null);
INSERT INTO `image_log` VALUES ('2', 'sssss', '2', '/upload/img/2018-11-30/5802b358-8f64-4edd-85a4-c5d6b327e10d.jpg', '3636', '', '\0', '2018-11-30 13:40:32', null);
INSERT INTO `image_log` VALUES ('3', 'cccc', '1', '/upload/img/2018-11-30/134f8d13-8c24-474f-9900-f59fea1f2bc3.jpg', '146822', 'asasdxxx', '\0', '2018-11-30 14:14:30', null);

-- ----------------------------
-- Table structure for integral_log
-- ----------------------------
DROP TABLE IF EXISTS `integral_log`;
CREATE TABLE `integral_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` int(10) unsigned DEFAULT NULL COMMENT '用户id',
  `num` smallint(6) unsigned DEFAULT '1' COMMENT '积分数',
  `nid` char(20) NOT NULL COMMENT '积分类型(表integral_type nid)',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '获取积分的时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='积分记录表';

-- ----------------------------
-- Records of integral_log
-- ----------------------------

-- ----------------------------
-- Table structure for integral_type
-- ----------------------------
DROP TABLE IF EXISTS `integral_type`;
CREATE TABLE `integral_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `nid` char(20) DEFAULT NULL COMMENT '积分类型nid',
  `type_name` varchar(100) DEFAULT NULL COMMENT '积分类型名称',
  `state` bit(1) DEFAULT b'1' COMMENT '积分类型状态 0:不可用 1:可用',
  `score` smallint(6) DEFAULT NULL COMMENT '积分个数',
  `manner` tinyint(1) DEFAULT '0' COMMENT '积分类型 0:收入 1:支出',
  `random` bit(1) DEFAULT b'0' COMMENT '是否为随机积分 0:不是 1:是',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(100) DEFAULT NULL COMMENT '备注信息',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='积分类型表';

-- ----------------------------
-- Records of integral_type
-- ----------------------------
INSERT INTO `integral_type` VALUES ('1', 'first_tender', '首投奖励', '1', '10', '0', '\0', '2018-11-15 16:41:42', null, null);
INSERT INTO `integral_type` VALUES ('2', 'max_tender', '最高投奖励', '1', '30', '0', '\0', '2018-11-15 16:42:45', null, null);
INSERT INTO `integral_type` VALUES ('3', 'last_tender', '扫尾奖励', '1', '5', '0', '\0', '2018-11-15 16:43:11', null, null);
INSERT INTO `integral_type` VALUES ('4', 'sign_in', '签到奖励', '1', '5', '0', '1', '2018-11-15 16:44:45', null, null);
INSERT INTO `integral_type` VALUES ('5', 'tender', '投资奖励', '1', '1', '0', '\0', '2018-11-17 14:11:10', null, '积分由系统参数tender_integral来决定,奖励积分=奖励值*(投标金额/tender_integral)');

-- ----------------------------
-- Table structure for message_template
-- ----------------------------
DROP TABLE IF EXISTS `message_template`;
CREATE TABLE `message_template` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(50) DEFAULT NULL COMMENT '消息名称',
  `nid` varchar(50) DEFAULT NULL COMMENT '消息nid',
  `state` bit(1) DEFAULT b'1' COMMENT '状态 0:关闭 1:开启',
  `classify` tinyint(2) unsigned DEFAULT NULL COMMENT '消息类型',
  `content` varchar(1000) DEFAULT NULL COMMENT '消息内容',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `tag` varchar(50) DEFAULT NULL COMMENT '后置处理标示符(消息推送跳转页面)',
  `remark` varchar(200) DEFAULT NULL COMMENT '备注信息',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='消息模板表';

-- ----------------------------
-- Records of message_template
-- ----------------------------

-- ----------------------------
-- Table structure for operation_data_log
-- ----------------------------
DROP TABLE IF EXISTS `operation_data_log`;
CREATE TABLE `operation_data_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `data_time` date DEFAULT NULL COMMENT '统计数据时的时间 不包含时分秒',
  `borrow_amount` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '借款总额(元)',
  `borrow_num` int(10) unsigned DEFAULT '0' COMMENT '总借款个数(借款成功的标的个数)',
  `borrow_people` int(10) unsigned DEFAULT '0' COMMENT '总借款人数',
  `borrow_await` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '总待收金额',
  `tender_earnings` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '累计收益(已回款的利息,包含平台奖励)',
  `tender_people` int(10) unsigned DEFAULT '0' COMMENT '总投资人数',
  `register_people` int(10) unsigned DEFAULT '0' COMMENT '总注册人数',
  `overdue_num` int(10) unsigned DEFAULT '0' COMMENT '总逾期个数(针对标的统计)',
  `now_borrow_num` int(10) unsigned DEFAULT '0' COMMENT '当前借款个数(还在还款中的标的)',
  `now_borrow_people` int(10) unsigned DEFAULT '0' COMMENT '当前借款人数',
  `now_tender_people` int(10) unsigned DEFAULT '0' COMMENT '当前投资人数(在投的人数)',
  `today_borrow_num` int(10) unsigned DEFAULT '0' COMMENT '今日发标个数',
  `today_borrow_amount` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '今日发标金额',
  `today_tender_amount` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '今日投标金额',
  `today_overdue_num` int(10) unsigned DEFAULT '0' COMMENT '今日逾期个数(针对标的统计)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='日运营数据统计日志表';

-- ----------------------------
-- Records of operation_data_log
-- ----------------------------

-- ----------------------------
-- Table structure for operation_report
-- ----------------------------
DROP TABLE IF EXISTS `operation_report`;
CREATE TABLE `operation_report` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `client_type` tinyint(1) DEFAULT NULL COMMENT '客户端类型 0:PC 1:APP',
  `img_url` varchar(500) DEFAULT NULL COMMENT '图片地址URL',
  `link_url` varchar(200) DEFAULT NULL COMMENT '链接地址URL',
  `title` varchar(50) DEFAULT NULL COMMENT '标题',
  `year` year(4) DEFAULT NULL COMMENT '年份',
  `month` date DEFAULT NULL COMMENT '月份(包含年)',
  `deleted` bit(1) DEFAULT b'0' COMMENT '是否已删除 0:未删除,1:已删除',
  `add_time` datetime DEFAULT NULL COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='运营报告表';

-- ----------------------------
-- Records of operation_report
-- ----------------------------

-- ----------------------------
-- Table structure for project
-- ----------------------------
DROP TABLE IF EXISTS `project`;
CREATE TABLE `project` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键标的ID',
  `borrower_id` int(10) unsigned NOT NULL COMMENT '借款人ID',
  `nid` varchar(50) DEFAULT NULL COMMENT '产品编号',
  `state` tinyint(2) DEFAULT '0' COMMENT '产品状态:-2:废弃-1:产品撤回,0:录入中,1待初审,2:待复审,3:募集中,4:满标待复审,5:还款中,6:还款完成,7:逾期结清',
  `classify` tinyint(2) DEFAULT '0' COMMENT '产品类型 0:个人贷,1:企业贷',
  `title` varchar(50) DEFAULT NULL COMMENT '产品名称',
  `amount` decimal(12,2) DEFAULT '100.00' COMMENT '计划募集金额',
  `raise_amount` decimal(12,2) DEFAULT '0.00' COMMENT '已募集金额',
  `min_tender` decimal(12,2) DEFAULT '100.00' COMMENT '单次最小投标金额',
  `apr` decimal(3,1) DEFAULT '0.0' COMMENT '标的基础利率 单位%',
  `platform_apr` decimal(2,1) DEFAULT '0.0' COMMENT '平台加息利率 单位%',
  `period` tinyint(2) DEFAULT '1' COMMENT '期限(月)',
  `repayment_mode` tinyint(1) DEFAULT '0' COMMENT '还款方式,0:等额本息,1:按月付息,到期还本,2:按天计息',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '标的信息录入时间',
  `pre_sale_time` datetime DEFAULT NULL COMMENT '预售时间(默认标的发布时间)',
  `publish_time` datetime DEFAULT NULL COMMENT '产品发布时间(复审通过时间)',
  `recheck_time` datetime DEFAULT NULL COMMENT '满标复审时间',
  `end_time` datetime DEFAULT NULL COMMENT '标的完结时间(废弃,撤标,还款完成,逾期结清)等',
  PRIMARY KEY (`id`),
  KEY `borrower_id_index` (`borrower_id`),
  KEY `status_index` (`state`),
  KEY `period_index` (`period`),
  KEY `name_index` (`title`),
  KEY `repayment_type_index` (`repayment_mode`),
  KEY `nid_index` (`nid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='标的信息表';

-- ----------------------------
-- Records of project
-- ----------------------------

-- ----------------------------
-- Table structure for project_audit_log
-- ----------------------------
DROP TABLE IF EXISTS `project_audit_log`;
CREATE TABLE `project_audit_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `project_id` int(10) unsigned DEFAULT NULL COMMENT '标的ID',
  `state` tinyint(2) DEFAULT NULL COMMENT '审核状态 1:初审通过 2:初审打回 3:复审通过 4:复审拒绝 5:复审打回(直接回到录入中) 6:满标复审通过 7:产品撤回',
  `remark` varchar(200) DEFAULT NULL COMMENT '审核记录',
  `add_time` datetime DEFAULT NULL COMMENT '审核时间',
  `operator_id` int(10) unsigned DEFAULT NULL COMMENT '审核人',
  PRIMARY KEY (`id`),
  KEY `index_project_id` (`project_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='标的审核记录表';

-- ----------------------------
-- Records of project_audit_log
-- ----------------------------

-- ----------------------------
-- Table structure for project_car_ext
-- ----------------------------
DROP TABLE IF EXISTS `project_car_ext`;
CREATE TABLE `project_car_ext` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `project_id` int(10) unsigned NOT NULL COMMENT '标的信息表',
  `content` text COMMENT '项目详细信息(富文本)',
  PRIMARY KEY (`id`),
  KEY `index_project_id` (`project_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='标的汽车附加信息表';

-- ----------------------------
-- Records of project_car_ext
-- ----------------------------

-- ----------------------------
-- Table structure for project_recover
-- ----------------------------
DROP TABLE IF EXISTS `project_recover`;
CREATE TABLE `project_recover` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` int(10) DEFAULT NULL COMMENT '投资人ID',
  `state` tinyint(1) DEFAULT '0' COMMENT '回款状态 0:待回款 1:已回款',
  `tender_id` int(10) DEFAULT NULL COMMENT '投标ID',
  `project_id` int(10) DEFAULT NULL COMMENT '项目ID',
  `period` tinyint(2) DEFAULT NULL COMMENT '第几期回款',
  `periods` tinyint(2) DEFAULT NULL COMMENT '总期数',
  `capital` decimal(12,2) DEFAULT '0.00' COMMENT '应还本金',
  `interest` decimal(12,2) DEFAULT '0.00' COMMENT '预计回款利息(基础利息)',
  `platform_interest` decimal(12,2) DEFAULT '0.00' COMMENT '预计平台加息利息',
  `coupon_interest` decimal(12,2) DEFAULT '0.00' COMMENT '预计加息券利息',
  `receive_time` date DEFAULT NULL COMMENT '预计回款时间(精确到天)',
  `real_receive_time` datetime DEFAULT NULL COMMENT '实际回款时间',
  `receive_month` char(12) DEFAULT NULL COMMENT '预计回款月yyyy-MM',
  `real_receive_month` char(12) DEFAULT NULL COMMENT '实际回款月yyyy-MM',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='投资人回款计划表';

-- ----------------------------
-- Records of project_recover
-- ----------------------------

-- ----------------------------
-- Table structure for project_repayment
-- ----------------------------
DROP TABLE IF EXISTS `project_repayment`;
CREATE TABLE `project_repayment` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `borrower_id` int(10) unsigned DEFAULT NULL COMMENT '借款人ID',
  `project_id` int(10) unsigned DEFAULT NULL COMMENT '标的ID',
  `state` tinyint(1) DEFAULT '0' COMMENT '还款状态 0:未还款 1:正常还款,2:提前还款,3:部分还款,4:逾期还款',
  `period` tinyint(4) unsigned DEFAULT NULL COMMENT '第几期还款',
  `periods` tinyint(3) unsigned DEFAULT NULL COMMENT '总期数',
  `capital` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '预计还款本金',
  `interest` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '基础利息',
  `platform_interest` decimal(12,2) DEFAULT '0.00' COMMENT '平台加息利息',
  `coupon_interest` decimal(12,2) DEFAULT '0.00' COMMENT '加息券利息',
  `repay_time` date DEFAULT NULL COMMENT '预计还款时间(精确到天)',
  `real_repay_time` datetime DEFAULT NULL COMMENT '实际还款时间(精确到秒)',
  `remark` varchar(100) DEFAULT NULL COMMENT '备注信息',
  `repay_month` char(12) DEFAULT NULL COMMENT '预计还款月',
  `real_repay_month` char(12) DEFAULT NULL COMMENT '实际还款月',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `index_user_id` (`borrower_id`),
  KEY `index_project_id` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='借款人还款计划表';

-- ----------------------------
-- Records of project_repayment
-- ----------------------------

-- ----------------------------
-- Table structure for project_tender
-- ----------------------------
DROP TABLE IF EXISTS `project_tender`;
CREATE TABLE `project_tender` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` int(10) DEFAULT NULL COMMENT '用户ID',
  `project_id` int(10) DEFAULT NULL COMMENT '标的id',
  `account` decimal(12,2) unsigned DEFAULT NULL COMMENT '投标金额(元)',
  `base_interest` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '基础收益(预计收益)',
  `platform_interest` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '平台加息收益(预计收益)',
  `coupon_interest` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '加息券收益(预计收益)',
  `voucher_interest` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '抵扣券收益',
  `state` tinyint(2) DEFAULT '0' COMMENT '投标状态:-3标的撤销,-2:已转让,-1:转让申请中,0:投标加入,1:回款中,2:还款完成',
  `channel` char(10) DEFAULT 'pc' COMMENT '投标渠道 pc,android,ios,h5,other',
  `ip` varchar(64) DEFAULT NULL COMMENT '投标ip',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '投标时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户投标表';

-- ----------------------------
-- Records of project_tender
-- ----------------------------

-- ----------------------------
-- Table structure for project_tender_statistics
-- ----------------------------
DROP TABLE IF EXISTS `project_tender_statistics`;
CREATE TABLE `project_tender_statistics` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `project_id` int(10) unsigned DEFAULT NULL COMMENT '产品id',
  `user_id` int(10) unsigned DEFAULT NULL COMMENT '用户id',
  `tender_id` int(10) unsigned DEFAULT NULL COMMENT '投标id',
  `classify` tinyint(1) unsigned DEFAULT NULL COMMENT '类型 0:首投 1:最高 2:扫尾',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  PRIMARY KEY (`id`),
  KEY `project_id_index` (`project_id`),
  KEY `user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='投资统计信息表';

-- ----------------------------
-- Records of project_tender_statistics
-- ----------------------------

-- ----------------------------
-- Table structure for project_tips
-- ----------------------------
DROP TABLE IF EXISTS `project_tips`;
CREATE TABLE `project_tips` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `project_id` int(10) unsigned NOT NULL COMMENT '标的ID',
  `tips_id` int(10) unsigned DEFAULT NULL COMMENT '标签ID',
  PRIMARY KEY (`id`),
  KEY `borrow_id_index` (`project_id`),
  KEY `tips_id_index` (`tips_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='标的标签关系表';

-- ----------------------------
-- Records of project_tips
-- ----------------------------

-- ----------------------------
-- Table structure for push_log
-- ----------------------------
DROP TABLE IF EXISTS `push_log`;
CREATE TABLE `push_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `alias` varchar(100) DEFAULT NULL COMMENT '别名',
  `user_id` int(10) unsigned DEFAULT NULL COMMENT '用户id',
  `title` varchar(50) DEFAULT NULL COMMENT '标题',
  `classify` varchar(50) DEFAULT NULL COMMENT '推送类型',
  `content` varchar(100) DEFAULT NULL COMMENT '正文内容',
  `add_time` datetime DEFAULT NULL COMMENT '结果集',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='消息推送日志';

-- ----------------------------
-- Records of push_log
-- ----------------------------

-- ----------------------------
-- Table structure for recharge_log
-- ----------------------------
DROP TABLE IF EXISTS `recharge_log`;
CREATE TABLE `recharge_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` int(10) DEFAULT NULL COMMENT '用户id',
  `user_type` tinyint(1) DEFAULT NULL COMMENT '用户类型 0:投资人 1:借款人',
  `manner` tinyint(1) DEFAULT NULL COMMENT '充值方式 0:快捷充值 1:网银充值',
  `state` tinyint(1) unsigned DEFAULT '0' COMMENT '状态 0:订单生成 1:充值成功 2:充值失败',
  `amount` decimal(12,2) DEFAULT '0.00' COMMENT '充值金额',
  `real_amount` decimal(12,2) DEFAULT '0.00' COMMENT '实际到账金额',
  `order_no` varchar(128) DEFAULT NULL COMMENT '订单号',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '订单生成时间',
  `update_time` datetime DEFAULT NULL COMMENT '订单更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='充值记录表';

-- ----------------------------
-- Records of recharge_log
-- ----------------------------

-- ----------------------------
-- Table structure for sms_log
-- ----------------------------
DROP TABLE IF EXISTS `sms_log`;
CREATE TABLE `sms_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `classify` varchar(50) DEFAULT NULL COMMENT '短信分类',
  `mobile` char(11) DEFAULT NULL COMMENT '手机号',
  `content` varchar(100) DEFAULT NULL COMMENT '短信内容',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '发送时间',
  `state` tinyint(1) unsigned DEFAULT NULL COMMENT '发送状态 0:失败 1:已发送',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='短信日志记录表';

-- ----------------------------
-- Records of sms_log
-- ----------------------------

-- ----------------------------
-- Table structure for system_config
-- ----------------------------
DROP TABLE IF EXISTS `system_config`;
CREATE TABLE `system_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `nid` varchar(50) NOT NULL COMMENT '参数标示符',
  `title` varchar(50) DEFAULT NULL COMMENT '参数名称',
  `content` varchar(1000) NOT NULL COMMENT '参数值',
  `classify` tinyint(2) unsigned DEFAULT NULL COMMENT '参数类型,见system_dict表nid=config_classify',
  `locked` bit(1) DEFAULT b'0' COMMENT '锁定状态(禁止编辑) 0:未锁定,1:锁定',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `reserve_content` varchar(1000) DEFAULT NULL COMMENT '备用值,如果不在有效期内自动启用备用值',
  `remark` varchar(200) DEFAULT NULL COMMENT '备注信息',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `nid_index` (`nid`),
  KEY `type_index` (`classify`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COMMENT='系统参数配置信息表';

-- ----------------------------
-- Records of system_config
-- ----------------------------
INSERT INTO `system_config` VALUES ('1', 'application_name', '系统名称', '后台管理系统', null, '\0', null, null, null, '', '2018-01-12 10:01:04', '2018-01-29 18:33:32');
INSERT INTO `system_config` VALUES ('2', 'enterprise_name', '企业名称', '二哥很猛', null, '\0', null, null, null, null, '2018-02-08 14:38:59', null);
INSERT INTO `system_config` VALUES ('3', 'enterprise_address', '企业地址', '浙江省杭州市西湖区教工路79号', null, '\0', null, null, null, null, '2018-02-08 14:40:01', null);
INSERT INTO `system_config` VALUES ('4', 'enterprise_phone', '企业电话', '0571-65800000', null, '\0', null, null, null, null, '2018-02-08 14:40:46', null);
INSERT INTO `system_config` VALUES ('5', 'enterprise_email', '企业邮箱', '664956140@qq.com', null, '\0', null, null, null, null, '2018-02-08 14:41:22', null);
INSERT INTO `system_config` VALUES ('6', 'ios_latest_version', 'ios最新版本号', '1.2.3', null, '\0', null, null, null, '最新版本号,格式必须为x.x.x', '2018-09-28 10:50:03', null);
INSERT INTO `system_config` VALUES ('7', 'android_latest_version', 'android最新版本', '1.2.3', null, '\0', null, null, null, '最新版本号,格式必须为x.x.x', '2018-09-28 10:50:41', null);
INSERT INTO `system_config` VALUES ('8', 'min_tender_age', '最小投标年龄', '18', null, '\0', null, null, null, '用户必须满足该年龄后才能进行投标操作', '2018-10-10 15:56:23', null);
INSERT INTO `system_config` VALUES ('9', 'once_min_tender_amount', '单次最小投标金额', '100', null, '\0', null, null, null, '单次最小投标金额', '2018-10-11 09:22:29', null);
INSERT INTO `system_config` VALUES ('10', 'personal_max_loan', '个人借款人最大借款总额', '200000', null, '\0', null, null, null, '借款总额(剩余可借=personal_max_loan-待还本金)', '2018-10-11 09:26:15', null);
INSERT INTO `system_config` VALUES ('11', 'system_domain', '前台系统域名', 'http://www.eghm.top', null, '\0', null, null, null, '前台提供服务的域名', '2018-11-25 21:02:17', null);
INSERT INTO `system_config` VALUES ('12', 'system_ip', '前台系统IP', 'http://127.0.0.1:8080', null, '\0', null, null, null, '前台提供服务的ip', '2018-11-25 21:03:13', null);
INSERT INTO `system_config` VALUES ('13', 'manage_domain', '后台系统域名', 'http://www.baidu.com', null, '\0', null, null, null, null, '2018-11-29 16:41:04', null);

-- ----------------------------
-- Table structure for system_department
-- ----------------------------
DROP TABLE IF EXISTS `system_department`;
CREATE TABLE `system_department` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `parent_code` varchar(64) DEFAULT NULL COMMENT '父级编号',
  `code` varchar(64) DEFAULT NULL COMMENT '部门编号',
  `title` varchar(50) DEFAULT NULL COMMENT '部门名称',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` bit(1) DEFAULT b'0' COMMENT '删除状态 0:未删除 1:已删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_index` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='部门信息表';

-- ----------------------------
-- Records of system_department
-- ----------------------------
INSERT INTO `system_department` VALUES ('1', null, '101', 'CEO', '2018-12-13 16:09:18', null, '\0');
INSERT INTO `system_department` VALUES ('2', '101', '101101', '华中区域总部', '2018-12-13 16:11:47', null, '\0');
INSERT INTO `system_department` VALUES ('3', '101101', '101101101', '郑州金水门店长', '2018-12-13 16:12:41', null, '\0');
INSERT INTO `system_department` VALUES ('4', '101101101', '101101101101', '郑州金水门店经理', '2018-12-13 16:15:06', null, '\0');
INSERT INTO `system_department` VALUES ('5', '101101101101', '101101101101101', '郑州金水门二哥组组长', '2018-12-13 16:15:32', null, '\0');
INSERT INTO `system_department` VALUES ('6', '101101101101101', '101101101101101101', '郑州金水门二哥组业务员', '2018-12-13 16:28:22', null, '\0');

-- ----------------------------
-- Table structure for system_dict
-- ----------------------------
DROP TABLE IF EXISTS `system_dict`;
CREATE TABLE `system_dict` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(50) DEFAULT NULL COMMENT '字典中文名称',
  `nid` varchar(50) DEFAULT NULL COMMENT '数据字典nid(英文名称)',
  `hidden_value` tinyint(2) unsigned DEFAULT NULL COMMENT '数据字典隐藏值 1~∞',
  `show_value` varchar(50) DEFAULT NULL COMMENT '显示值',
  `deleted` bit(1) DEFAULT b'0' COMMENT '删除状态 0:正常,1:已删除',
  `locked` bit(1) DEFAULT b'0' COMMENT '锁定状态(禁止编辑):0:未锁定 1:锁定',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='系统数据字典表';

-- ----------------------------
-- Records of system_dict
-- ----------------------------
INSERT INTO `system_dict` VALUES ('1', '图片分类', 'image_classify', '1', 'pc首页', '\0', '\0', '2018-11-27 17:14:49', null);
INSERT INTO `system_dict` VALUES ('2', '图片分类', 'image_classify', '2', 'app首页', '\0', '\0', '2018-11-27 17:15:33', null);
INSERT INTO `system_dict` VALUES ('3', '图片分类', 'image_classify', '3', 'h5首页', '\0', '\0', '2018-11-27 17:15:55', null);

-- ----------------------------
-- Table structure for system_menu
-- ----------------------------
DROP TABLE IF EXISTS `system_menu`;
CREATE TABLE `system_menu` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(8) NOT NULL COMMENT '菜单名称',
  `nid` varchar(20) NOT NULL COMMENT '菜单标示符 唯一',
  `pid` int(10) unsigned NOT NULL COMMENT '父节点ID,一级菜单默认为0',
  `url` varchar(255) DEFAULT NULL COMMENT '菜单地址',
  `sub_url` varchar(2000) DEFAULT NULL COMMENT '该菜单包含的子url以分号做分割',
  `main_menu` bit(1) DEFAULT b'1' COMMENT '是否为左侧主菜单 0:不是,1:是',
  `sort` int(3) DEFAULT '0' COMMENT '排序规则 小的排在前面',
  `deleted` bit(1) DEFAULT b'0' COMMENT '状态:0:正常,1:已删除',
  `remark` varchar(200) DEFAULT NULL COMMENT '备注信息',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `parent_id` (`pid`)
) ENGINE=InnoDB AUTO_INCREMENT=1011 DEFAULT CHARSET=utf8 COMMENT='系统菜单表';

-- ----------------------------
-- Records of system_menu
-- ----------------------------
INSERT INTO `system_menu` VALUES ('1001', '系统管理', 'systemManage', '0', null, null, '1', '0', '\0', null, '2018-01-25 16:13:54', null);
INSERT INTO `system_menu` VALUES ('1004', '菜单管理', 'menuManage', '1001', '/public/system/menu/menu_manage_page', null, '1', '1', '\0', null, '2018-01-25 16:14:01', null);
INSERT INTO `system_menu` VALUES ('1007', '系统参数', 'systemParamter', '1001', '/public/system/config/config_manage_page', null, '1', '2', '\0', null, '2018-01-25 16:14:31', null);
INSERT INTO `system_menu` VALUES ('1008', '用户管理', 'systemUser', '1001', '/public/system/operator/operator_manage_page', null, '1', '3', '\0', null, '2018-01-25 16:14:40', null);
INSERT INTO `system_menu` VALUES ('1009', '角色管理', 'roleManage', '1001', '/public/system/role/role_manage_page', null, '1', '4', '\0', null, '2018-01-25 16:14:56', null);
INSERT INTO `system_menu` VALUES ('1010', '图片管理', 'imageManage', '1001', '/public/operation/image/image_manage_page', null, '1', '5', '\0', null, '2018-11-28 17:02:36', null);

-- ----------------------------
-- Table structure for system_notice
-- ----------------------------
DROP TABLE IF EXISTS `system_notice`;
CREATE TABLE `system_notice` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(255) NOT NULL COMMENT '公告标题',
  `classify` tinyint(2) unsigned DEFAULT NULL COMMENT '公告类型(数据字典表notice_classify)',
  `content` text COMMENT '公告内容(富文本)',
  `deleted` bit(1) DEFAULT b'0' COMMENT '删除状态 0:正常 1:删除',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='系统公告信息表';

-- ----------------------------
-- Records of system_notice
-- ----------------------------

-- ----------------------------
-- Table structure for system_operator
-- ----------------------------
DROP TABLE IF EXISTS `system_operator`;
CREATE TABLE `system_operator` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `operator_name` varchar(20) NOT NULL COMMENT '用户名称',
  `mobile` varchar(11) NOT NULL COMMENT '手机号码(登陆账户)',
  `state` tinyint(1) unsigned DEFAULT '1' COMMENT '用户状态:0:锁定,1:正常',
  `pwd` varchar(128) DEFAULT NULL COMMENT '登陆密码MD5',
  `init_pwd` varchar(128) DEFAULT NULL COMMENT '初始密码',
  `department` varchar(64) DEFAULT NULL COMMENT '所属部门',
  `deleted` bit(1) DEFAULT b'0' COMMENT '删除状态 0:正常,1:已删除',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(100) DEFAULT NULL COMMENT '备注信息',
  PRIMARY KEY (`id`),
  KEY `name_index` (`operator_name`),
  KEY `mobile_index` (`mobile`),
  KEY `status_index` (`state`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='管理后台用户表';

-- ----------------------------
-- Records of system_operator
-- ----------------------------
INSERT INTO `system_operator` VALUES ('1', '超管', '13000000000', '1', '$2a$10$5r2rvlqCSSwOHRvoBxQNkecRVKOqcIFF3NY3.FHnrTdtTp7Fmhomy', '$2a$10$5r2rvlqCSSwOHRvoBxQNkecRVKOqcIFF3NY3.FHnrTdtTp7Fmh2omy', '0', '\0', '2018-01-26 10:38:20', null, null);

-- ----------------------------
-- Table structure for system_operator_role
-- ----------------------------
DROP TABLE IF EXISTS `system_operator_role`;
CREATE TABLE `system_operator_role` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `operator_id` int(10) unsigned NOT NULL COMMENT '用户id',
  `role_id` int(10) unsigned NOT NULL COMMENT '角色id',
  PRIMARY KEY (`id`),
  KEY `user_id_index` (`operator_id`),
  KEY `role_id_index` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='角色与用户关系表';

-- ----------------------------
-- Records of system_operator_role
-- ----------------------------
INSERT INTO `system_operator_role` VALUES ('1', '1', '1');

-- ----------------------------
-- Table structure for system_role
-- ----------------------------
DROP TABLE IF EXISTS `system_role`;
CREATE TABLE `system_role` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `role_name` varchar(10) DEFAULT NULL COMMENT '角色名称',
  `role_type` varchar(20) DEFAULT NULL COMMENT '角色类型',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` bit(1) DEFAULT b'0' COMMENT '删除状态:0:正常,1:已删除',
  `remark` varchar(200) DEFAULT NULL COMMENT '备注信息',
  PRIMARY KEY (`id`),
  KEY `role_name_index` (`role_name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='角色表';

-- ----------------------------
-- Records of system_role
-- ----------------------------
INSERT INTO `system_role` VALUES ('1', '超级管理员', 'administator', '2018-01-29 13:45:49', null, '\0', null);
INSERT INTO `system_role` VALUES ('2', '部门经理', 'jingli', '2018-11-26 17:00:58', null, '\0', '测试');
INSERT INTO `system_role` VALUES ('3', '测试经理', 'ces', '2018-11-30 15:31:16', null, '\0', null);
INSERT INTO `system_role` VALUES ('4', '开发', 'kaifa', '2018-11-30 15:31:33', null, '\0', null);
INSERT INTO `system_role` VALUES ('5', '销售', 'xiaoshou', '2018-11-30 15:31:40', null, '\0', null);
INSERT INTO `system_role` VALUES ('6', '理财', 'licai', '2018-11-30 15:31:50', null, '\0', null);
INSERT INTO `system_role` VALUES ('7', '测试', '11', '2018-11-30 15:32:44', null, '\0', null);
INSERT INTO `system_role` VALUES ('8', '试试', '22', '2018-11-30 15:32:48', null, '\0', null);

-- ----------------------------
-- Table structure for system_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `system_role_menu`;
CREATE TABLE `system_role_menu` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `role_id` int(10) unsigned DEFAULT NULL COMMENT '角色Id',
  `menu_id` int(10) unsigned DEFAULT NULL COMMENT '菜单Id',
  PRIMARY KEY (`id`),
  KEY `role_id_index` (`role_id`) USING BTREE,
  KEY `menu_id_index` (`menu_id`),
  CONSTRAINT `role_id_FK` FOREIGN KEY (`role_id`) REFERENCES `system_role` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COMMENT='角色与菜单关系表';

-- ----------------------------
-- Records of system_role_menu
-- ----------------------------
INSERT INTO `system_role_menu` VALUES ('2', '1', '1001');
INSERT INTO `system_role_menu` VALUES ('5', '1', '1004');
INSERT INTO `system_role_menu` VALUES ('8', '1', '1007');
INSERT INTO `system_role_menu` VALUES ('9', '1', '1008');
INSERT INTO `system_role_menu` VALUES ('10', '1', '1009');
INSERT INTO `system_role_menu` VALUES ('11', '1', '1010');

-- ----------------------------
-- Table structure for tips
-- ----------------------------
DROP TABLE IF EXISTS `tips`;
CREATE TABLE `tips` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `title` varchar(20) NOT NULL COMMENT '标签名称',
  `remark` varchar(100) DEFAULT NULL COMMENT '标签备注信息',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` bit(1) DEFAULT b'0' COMMENT '删除状态 0:正常,1:已删除',
  PRIMARY KEY (`id`),
  KEY `name_index` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='标签类型表';

-- ----------------------------
-- Records of tips
-- ----------------------------

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `mobile` varchar(11) NOT NULL COMMENT '手机号码',
  `email` varchar(50) DEFAULT NULL COMMENT '电子邮箱',
  `deposit_no` varchar(64) DEFAULT NULL COMMENT '存管账号',
  `deposit_status` tinyint(1) unsigned DEFAULT NULL COMMENT '存管状态',
  `password` varchar(128) NOT NULL COMMENT '登陆密码',
  `state` bit(1) DEFAULT b'1' COMMENT '状态 1正常 0:锁定',
  `channel` tinyint(3) unsigned DEFAULT '0' COMMENT '注册渠道 pc,android,ios,h5,other',
  `register_ip` varchar(32) DEFAULT NULL COMMENT '注册地址',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `mobile_index` (`mobile`),
  KEY `email_index` (`email`),
  KEY `status_index` (`state`),
  KEY `channel_index` (`channel`),
  KEY `deposit_no_index` (`deposit_no`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='投资人基本信息表';

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('1', '15966666666', null, null, null, '12', '1', '0', null, '2018-01-11 15:59:08', null);

-- ----------------------------
-- Table structure for user_address
-- ----------------------------
DROP TABLE IF EXISTS `user_address`;
CREATE TABLE `user_address` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` int(10) unsigned NOT NULL COMMENT '用户ID',
  `state` tinyint(1) unsigned DEFAULT '1' COMMENT '地址状态:0:普通地址 1:默认地址',
  `province_nid` char(10) DEFAULT NULL COMMENT '省份编号',
  `city_nid` char(10) DEFAULT NULL COMMENT '城市编号',
  `address` varchar(255) DEFAULT NULL COMMENT '详细地址',
  `deleted` bit(1) DEFAULT b'0' COMMENT '删除状态 0:正常 1:已删除',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `status_index` (`state`),
  KEY `user_id_index` (`user_id`),
  KEY `province_nid_index` (`province_nid`),
  KEY `city_nid_index` (`city_nid`),
  KEY `deleted_index` (`deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='投资人地址信息表';

-- ----------------------------
-- Records of user_address
-- ----------------------------

-- ----------------------------
-- Table structure for user_extend
-- ----------------------------
DROP TABLE IF EXISTS `user_extend`;
CREATE TABLE `user_extend` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` int(10) unsigned DEFAULT NULL COMMENT '投资人用户ID',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像地址',
  `real_name` varchar(20) DEFAULT NULL COMMENT '真实姓名',
  `id_card` varchar(128) DEFAULT NULL COMMENT '身份证号码(前10位加密[18位身份证],前8位加密[15位身份证])',
  `birthday` char(8) DEFAULT NULL COMMENT '生日yyyyMMdd',
  `integral_num` int(10) unsigned DEFAULT '0' COMMENT '可用积分总数',
  `grade` tinyint(2) unsigned DEFAULT '0' COMMENT '用户等级',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id_index` (`user_id`) USING BTREE COMMENT '唯一索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='投资人扩展信息表';

-- ----------------------------
-- Records of user_extend
-- ----------------------------

-- ----------------------------
-- Table structure for user_message
-- ----------------------------
DROP TABLE IF EXISTS `user_message`;
CREATE TABLE `user_message` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` int(10) unsigned DEFAULT NULL COMMENT '用户id',
  `title` varchar(50) DEFAULT NULL COMMENT '标题',
  `content` varchar(500) DEFAULT NULL COMMENT '内容',
  `state` tinyint(1) unsigned DEFAULT '0' COMMENT '状态 0:未读 1:已读',
  `deleted` bit(1) DEFAULT b'0' COMMENT '删除状态 0:未删除 1:已删除',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='投资人站内信';

-- ----------------------------
-- Records of user_message
-- ----------------------------

-- ----------------------------
-- Table structure for vip_config
-- ----------------------------
DROP TABLE IF EXISTS `vip_config`;
CREATE TABLE `vip_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `vip_name` char(20) DEFAULT NULL COMMENT '等级名称',
  `grade` tinyint(2) unsigned DEFAULT NULL COMMENT 'vip等级',
  `sort` tinyint(2) DEFAULT NULL COMMENT '排序规则:小(前面)<->大(后面)',
  `amount` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '当前等级最小待收金额',
  `state` bit(1) DEFAULT b'1' COMMENT '状态 0:关闭 1:开启',
  `withdraw` tinyint(2) unsigned DEFAULT NULL COMMENT '月免费提现次数',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='vip等级配置表';

-- ----------------------------
-- Records of vip_config
-- ----------------------------
INSERT INTO `vip_config` VALUES ('1', '新手', '0', '0', '0.00', '1', '0');
INSERT INTO `vip_config` VALUES ('2', '青铜会员', '1', '1', '1000.00', '1', '1');
INSERT INTO `vip_config` VALUES ('3', '白银会员', '2', '2', '5000.00', '1', '2');
INSERT INTO `vip_config` VALUES ('4', '黄金会员', '3', '3', '10000.00', '1', '3');
INSERT INTO `vip_config` VALUES ('5', '铂金会员', '4', '4', '50000.00', '1', '4');
INSERT INTO `vip_config` VALUES ('6', '钻石会员', '5', '5', '200000.00', '1', '5');
INSERT INTO `vip_config` VALUES ('7', '至尊会员', '6', '6', '500000.00', '1', '6');
INSERT INTO `vip_config` VALUES ('8', '王者会员', '7', '7', '2000000.00', '1', '7');

-- ----------------------------
-- Table structure for withdraw_log
-- ----------------------------
DROP TABLE IF EXISTS `withdraw_log`;
CREATE TABLE `withdraw_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` int(10) DEFAULT NULL COMMENT '用户id',
  `state` tinyint(1) DEFAULT '0' COMMENT '提现状态 -1:提现撤销 0:录入中 1:提现申请 2:提现成功,3:提现审核失败,4:提现失败',
  `user_type` tinyint(1) DEFAULT NULL COMMENT '用户类型 0:投资人 1:借款人',
  `amount` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '提现金额',
  `real_amount` decimal(12,2) unsigned DEFAULT '0.00' COMMENT '提现到账金额',
  `fee` decimal(6,2) unsigned DEFAULT '0.00' COMMENT '提现手续费',
  `use_free` bit(1) DEFAULT b'1' COMMENT '是否使用免费提现 0:否 1是',
  `bank_num` varchar(32) DEFAULT NULL COMMENT '提现银行卡号',
  `bank_code` char(20) DEFAULT NULL COMMENT '提现银行卡编码',
  `add_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `order_no` varchar(128) DEFAULT NULL COMMENT '订单号',
  `remark` varchar(200) DEFAULT NULL COMMENT '提现备注信息',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='提现记录表';

-- ----------------------------
-- Records of withdraw_log
-- ----------------------------

-- ----------------------------
-- Procedure structure for idata
-- ----------------------------
DROP PROCEDURE IF EXISTS `idata`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `idata`()
  begin
    declare i int;
    set i=1;
    while(i<=100000)do
      insert into t values(i, i, i);
      set i=i+1;
    end while;
  end
;;
DELIMITER ;
