package com.fanyin.configuration.security;

import com.fanyin.constant.CommonConstant;
import com.fanyin.ext.ResultJson;
import com.fanyin.utils.WebUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;


/**
 * 校验失败处理方式 直接返回前台json
 * @author 二哥很猛
 * @date 2018/1/25 18:21
 */
@Slf4j
public class LoginFailureHandler implements AuthenticationFailureHandler {

    @Override
    public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response, AuthenticationException exception) throws IOException{
        if (exception instanceof SystemAuthenticationException){
            SystemAuthenticationException exc = (SystemAuthenticationException) exception;
            ResultJson<Object> resultJson = ResultJson.getInstance().setCode(exc.getCode()).setMsg(exc.getMessage());
            WebUtils.printJson(response,resultJson);
        }else{
            log.error("权限校验异常",exception);
            ResultJson<Object> resultJson = ResultJson.getInstance().setCode(CommonConstant.CODE).setMsg("权限校验异常,请联系管理人员");
            WebUtils.printJson(response,resultJson);
        }
    }
}