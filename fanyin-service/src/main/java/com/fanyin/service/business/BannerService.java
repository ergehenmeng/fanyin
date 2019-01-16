package com.fanyin.service.business;

import com.fanyin.enums.Source;
import com.fanyin.model.business.Banner;

import java.util.List;

/**
 * @author 二哥很猛
 * @date 2018/10/17 9:20
 */
public interface BannerService {

    /**
     * 根据客户端类型及模板获取轮播图信息
     * @param source 客户端类型
     * @param type banner所属模块,数据字典的值
     * @return 轮播图列表
     */
    List<Banner> getBanner(Source source, Byte type);

}

