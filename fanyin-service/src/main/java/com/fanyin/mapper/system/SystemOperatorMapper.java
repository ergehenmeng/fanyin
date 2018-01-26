package com.fanyin.mapper.system;


import com.fanyin.model.system.SystemOperator;

/**
 * @author 二哥很猛
 */
public interface SystemOperatorMapper {
    /**
     * 根据主键删除数据库的记录
     *
     * @param id
     * @return
     */
    int deleteByPrimaryKey(Integer id);

    /**
     * 插入数据库记录
     *
     * @param record
     * @return
     */
    int insert(SystemOperator record);

    /**
     * 插入不为空的记录
     *
     * @param record
     * @return
     */
    int insertSelective(SystemOperator record);

    /**
     * 根据主键获取一条数据库记录
     *
     * @param id
     * @return
     */
    SystemOperator selectByPrimaryKey(Integer id);

    /**
     * 根据主键来更新部分数据库记录
     *
     * @param record
     * @return
     */
    int updateByPrimaryKeySelective(SystemOperator record);

    /**
     * 根据主键来更新数据库记录
     *
     * @param record
     * @return
     */
    int updateByPrimaryKey(SystemOperator record);

    /**
     * 根据手机号码查询管理员信息
     * @param mobile 手机号码
     * @return
     */
    SystemOperator getOperatorByMobile(String mobile);
}