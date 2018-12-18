package com.fanyin.dto.recharge;

import com.fanyin.ext.PageQuery;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;
import java.util.Date;

/**
 * 充值记录查询
 * @author 二哥很猛
 * @date 2018/11/22 19:10
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class RechargeRequest extends PageQuery implements Serializable {

    private static final long serialVersionUID = 3529685228136720003L;

    /**
     * 用户id
     */
    private Integer userId;

    /**
     * 充值方式 0:快捷充值 1:网银充值
     */
    private Byte manner;

    /**
     * 用户类型 0:投资人 1:借款人
     */
    private Byte userType;

    /**
     * 充值状态 0:订单生成 1:充值成功 2:充值失败
     */
    private Byte state;

    /**
     * 查询起始时间
     */
    private Date startTime;

    /**
     * 查询结束时间
     */
    private Date endTime;


}
