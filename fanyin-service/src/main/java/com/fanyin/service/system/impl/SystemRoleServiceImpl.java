package com.fanyin.service.system.impl;

import com.fanyin.dto.system.role.RoleAddRequest;
import com.fanyin.dto.system.role.RoleEditRequest;
import com.fanyin.dto.system.role.RoleQueryRequest;
import com.fanyin.mapper.system.SystemOperatorRoleMapper;
import com.fanyin.mapper.system.SystemRoleMapper;
import com.fanyin.model.system.SystemOperatorRole;
import com.fanyin.model.system.SystemRole;
import com.fanyin.service.system.SystemRoleService;
import com.fanyin.utils.BeanCopyUtil;
import com.fanyin.utils.DateUtil;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.google.common.base.Splitter;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

/**
 * @author 二哥很猛
 * @date 2018/11/26 15:33
 */
@Service("systemRoleService")
@Transactional(rollbackFor = RuntimeException.class)
public class SystemRoleServiceImpl implements SystemRoleService {

    @Autowired
    private SystemRoleMapper systemRoleMapper;

    @Autowired
    private SystemOperatorRoleMapper systemOperatorRoleMapper;

    @Override
    public PageInfo<SystemRole> getByPage(RoleQueryRequest request) {
        PageHelper.startPage(request.getPage(),request.getRows());
        List<SystemRole> list = systemRoleMapper.getList(request);
        return new PageInfo<>(list);
    }

    @Override
    public SystemRole getById(int id) {
        return systemRoleMapper.selectByPrimaryKey(id);
    }

    @Override
    public void updateRole(RoleEditRequest request) {
        SystemRole role = BeanCopyUtil.copy(request, SystemRole.class);
        role.setUpdateTime(DateUtil.getNow());
        systemRoleMapper.updateByPrimaryKeySelective(role);
    }

    @Override
    public void deleteRole(int id) {
        SystemRole role = new SystemRole();
        role.setUpdateTime(DateUtil.getNow());
        role.setDeleted(true);
        systemRoleMapper.updateByPrimaryKeySelective(role);
    }

    @Override
    public void addRole(RoleAddRequest request) {
        SystemRole role = BeanCopyUtil.copy(request, SystemRole.class);
        role.setDeleted(false);
        role.setAddTime(DateUtil.getNow());
        systemRoleMapper.insertSelective(role);
    }

    @Override
    public List<SystemRole> getList() {
        RoleQueryRequest request = new RoleQueryRequest();
        return systemRoleMapper.getList(request);
    }

    @Override
    public List<Integer> getByOperatorId(Integer operatorId) {
        return systemOperatorRoleMapper.getByOperatorId(operatorId);
    }

    @Override
    public List<Integer> getRoleMenu(Integer roleId) {
        return systemRoleMapper.getRoleMenu(roleId);
    }

    @Override
    public void authMenu(Integer roleId, String menuIds) {
        systemRoleMapper.deleteRoleMenu(roleId);
        if(StringUtils.isNotEmpty(menuIds)){
            List<Integer> menuIdList = Splitter.on(",").splitToList(menuIds).stream().mapToInt(Integer::parseInt).boxed().collect(Collectors.toList());
            systemRoleMapper.batchInsertRoleMenu(roleId,menuIdList);
        }
    }
}
