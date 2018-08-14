package com.fanyin.service.system;

import com.fanyin.model.system.Token;

/**
 * 会话令牌service
 * @author 王艳兵
 * @date 2018/8/14 17:35
 */
public interface AccessTokenService {

    /**
     * 根据accessKey查找token
     * @param accessKey accessKey
     * @return token
     */
    Token getToken(String accessKey);

    /**
     * 保存token 30分钟超时时间
     * @param token token对象
     */
    void saveToken(Token token);
}

