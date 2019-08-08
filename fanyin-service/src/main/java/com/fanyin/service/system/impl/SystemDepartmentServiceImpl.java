package com.fanyin.service.system.impl;

import com.fanyin.dto.system.department.DepartmentAddRequest;
import com.fanyin.mapper.system.SystemDepartmentMapper;
import com.fanyin.model.system.SystemDepartment;
import com.fanyin.service.system.SystemDepartmentService;
import com.fanyin.utils.BeanCopyUtil;
import com.fanyin.utils.StringUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * @author 二哥很猛
 * @date 2018/12/13 16:49
 */
@Service("systemDepartmentService")
@Transactional(rollbackFor = RuntimeException.class)
public class SystemDepartmentServiceImpl implements SystemDepartmentService {

    @Autowired
    private SystemDepartmentMapper systemDepartmentMapper;

    /**
     * 根节点或子节点的根节点编码
     */
    private static final String ROOT_CODE = "100";

    @Override
    public List<SystemDepartment> getDepartment() {
        return systemDepartmentMapper.getList();
    }

    @Override
    public void addDepartment(DepartmentAddRequest request) {
        SystemDepartment department = BeanCopyUtil.copy(request, SystemDepartment.class);
        String code = this.getNextCode(request.getParentCode());
        department.setCode(code);
        systemDepartmentMapper.insertSelective(department);
    }

    @Override
    public String getNextCode(String code) {
        if(StringUtil.isBlank(code)){
            return ROOT_CODE;
        }
        SystemDepartment child = systemDepartmentMapper.getMaxCodeChild(code);
        if(child == null){
            return code + ROOT_CODE;
        }
        return String.valueOf(Long.parseLong(child.getCode()) + 1);
    }

}
