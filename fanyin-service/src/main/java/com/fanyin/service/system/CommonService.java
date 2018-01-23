package com.fanyin.service.system;

/**
 * @author: 二哥很猛
 * @date: 2018/1/18
 * @time: 14:16
 */
public interface CommonService {

    /**
     * 对密码进行二次Md5加密
     * @param password 密码md5
     * @param random 随机串
     * @return 二次加密后字符串
     */
    String encryptPassword(String password, String random);
}
