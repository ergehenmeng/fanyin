package com.fanyin.controller;


import com.fanyin.dto.security.DataMessage;
import com.fanyin.enums.ErrorCodeEnum;
import com.fanyin.exception.BusinessException;
import com.fanyin.interceptor.MessageHandlerInterceptor;

/**
 * @author 二哥很猛
 * @date 2018/1/12 17:59
 */
public class AbstractController {

    /**
     * 前后端分离方式:获取登陆用户的id,必须在Controller中添加@AccessToken(access=true)注解,否则获取时会抛异常
     * @return id
     */
    protected int getUserId(){
        int userId = this.getMessage().getUserId();
        if(userId == 0){
            throw new BusinessException(ErrorCodeEnum.USER_LOGIN_TIMEOUT);
        }
        return userId;
    }

    private DataMessage getMessage(){
        return MessageHandlerInterceptor.getMessage();
    }

    /**
     * 前后端分离方式:获取访问来源
     * @return android ios h5 pc
     */
    protected String getRequestType(){
        return this.getMessage().getRequestType();
    }

    /**
     * 前后端分离方式:获取软件版本号 针对android和ios
     * @return v1.0.0
     */
    protected String getVersion(){
        return this.getMessage().getVersion();
    }

    /**
     * 前后端分离方式:获取系统版本号 针对android和ios
     * @return ios 10.4.1
     */
    protected String getOsVersion(){
        return this.getMessage().getOsVersion();
    }


}
