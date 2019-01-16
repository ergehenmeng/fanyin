package com.fanyin.model.business;

import lombok.Data;

import java.io.Serializable;
import java.util.Date;

/**
 * 帮助说明
 * @author 二哥很猛
 */
@Data
public class HelpInstruction implements Serializable {
    private static final long serialVersionUID = -4932713062851231007L;
    /**
     * 主键<br>
     * 表 : help_instruction<br>
     * 对应字段 : id<br>
     */
    private Integer id;

    /**
     * 帮助分类取system_dict表中help_type字段<br>
     * 表 : help_instruction<br>
     * 对应字段 : classify<br>
     */
    private Byte classify;

    /**
     * 状态 0:不显示 1:显示<br>
     * 表 : help_instruction<br>
     * 对应字段 : state<br>
     */
    private Byte state;

    /**
     * 问<br>
     * 表 : help_instruction<br>
     * 对应字段 : ask<br>
     */
    private String ask;

    /**
     * 答 支持<br>
     * 表 : help_instruction<br>
     * 对应字段 : answer<br>
     */
    private String answer;

    /**
     * 排序(小<->大)<br>
     * 表 : help_instruction<br>
     * 对应字段 : sort<br>
     */
    private Byte sort;

    /**
     * 添加时间<br>
     * 表 : help_instruction<br>
     * 对应字段 : add_time<br>
     */
    private Date addTime;

    /**
     * 更新时间<br>
     * 表 : help_instruction<br>
     * 对应字段 : update_time<br>
     */
    private Date updateTime;

    /**
     * 删除状态 0:不删除(正常) 1:已删除<br>
     * 表 : help_instruction<br>
     * 对应字段 : deleted<br>
     */
    private Boolean deleted;


}