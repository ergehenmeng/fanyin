package com.fanyin.service.system.impl;

import com.fanyin.mapper.system.SystemAddressMapper;
import com.fanyin.model.system.SystemAddress;
import com.fanyin.service.system.SystemAddressService;
import com.fanyin.utils.StringUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author 二哥很猛
 * @date 2019/2/13 10:25
 */
@Service("systemAddressService")
public class SystemAddressServiceImpl implements SystemAddressService {

    @Autowired
    private SystemAddressMapper systemAddressMapper;


    @Override
    public void calcInitial() {
        List<SystemAddress> list = systemAddressMapper.getList();
        list.forEach(systemAddress -> {
            String title = systemAddress.getTitle();
            String initial = StringUtil.getInitial(title);
            systemAddress.setMark(initial);
            systemAddressMapper.updateByPrimaryKeySelective(systemAddress);
        });
    }
}
