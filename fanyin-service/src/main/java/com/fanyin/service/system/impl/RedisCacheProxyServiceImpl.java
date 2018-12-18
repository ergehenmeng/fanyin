package com.fanyin.service.system.impl;

import com.fanyin.model.system.SystemDict;
import com.fanyin.service.system.RedisCacheProxyService;
import com.fanyin.service.system.SystemDictService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 该类为全局Bean在Aop中无效时,额外存放类
 * 由于@Async,@CachePut等相关aop注解在同一个类方法间进行调用时无法生效
 * 可全部放到本类中维护
 * @author 二哥很猛
 * @date 2018/10/11 13:47
 */
@Service("redisCacheProxyService")
public class RedisCacheProxyServiceImpl implements RedisCacheProxyService {

    @Autowired
    private SystemDictService systemDictService;

    @Override
    public String getDictValue(String nid, Byte hiddenValue) {
        List<SystemDict> dictList = systemDictService.getDictByNid(nid);
        for (SystemDict dict : dictList){
            if(dict.getHiddenValue().equals(hiddenValue)){
                return dict.getShowValue();
            }
        }
        return null;
    }
}
