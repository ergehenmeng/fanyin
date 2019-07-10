package com.fanyin.advice;

import com.alibaba.fastjson.JSONObject;
import com.fanyin.annotation.Mark;
import com.fanyin.configuration.security.SecurityOperator;
import com.fanyin.constants.ConfigConstant;
import com.fanyin.controller.AbstractController;
import com.fanyin.enums.ErrorCodeEnum;
import com.fanyin.exception.BusinessException;
import com.fanyin.model.system.SystemOperationLog;
import com.fanyin.queue.TaskQueue;
import com.fanyin.queue.task.OperationLogTask;
import com.fanyin.service.system.impl.SystemConfigApi;
import com.fanyin.utils.DateUtil;
import com.fanyin.utils.IpUtil;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.ui.Model;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;

/**
 * 操作日志
 * @author 二哥很猛
 * @date 2019/1/15 16:19
 */
@Component
@Aspect
@Slf4j
public class OperationLogHandler {


    @Autowired
    private SystemConfigApi systemConfigApi;

    /**
     * 操作日志,如果仅仅想请求或者响应某些参数不想入库可以在响应字段上添加
     * {@link com.alibaba.fastjson.annotation.JSONField} serialize = false
     * @param joinPoint 切入点
     * @param mark 操作日志标示注解
     * @return aop方法调用结果对象
     * @throws Throwable 异常
     */
    @Around("@annotation(mark) && within(com.fanyin.controller..*)")
    public Object around(ProceedingJoinPoint joinPoint,Mark mark)throws Throwable{
        boolean logSwitch = systemConfigApi.getBoolean(ConfigConstant.OPERATION_LOG_SWITCH);
        if(logSwitch){
            RequestAttributes requestAttributes = RequestContextHolder.getRequestAttributes();
            if(requestAttributes == null){
                return joinPoint.proceed();
            }
            HttpServletRequest request = ((ServletRequestAttributes) requestAttributes).getRequest();
            SecurityOperator operator = AbstractController.getOperator();
            if(operator == null){
                log.warn("操作日志无法查询到登陆用户 url:[{}]",request.getRequestURI());
                return joinPoint.proceed();
            }
            SystemOperationLog systemOperationLog = new SystemOperationLog();

            systemOperationLog.setOperatorId(operator.getId());
            systemOperationLog.setIp(IpUtil.getIpAddress(request));

            if(mark.request()){
                Object[] args = joinPoint.getArgs();
                if(args != null && args.length > 0){
                    systemOperationLog.setRequest(formatRequest(args));
                }
            }
            systemOperationLog.setUrl(request.getRequestURI());
            Date now = DateUtil.getNow();
            systemOperationLog.setAddTime(now);
            Object proceed = joinPoint.proceed();
            long end = System.currentTimeMillis();
            systemOperationLog.setBusinessTime(end - now.getTime());
            systemOperationLog.setClassify((byte)mark.value().ordinal());
            if(mark.response() && proceed != null){
                systemOperationLog.setResponse(JSONObject.toJSONString(proceed));
            }
            TaskQueue.executeOperation(new OperationLogTask(systemOperationLog));
            return proceed;
        }
        return joinPoint.proceed();
    }


    /**
     * 格式化请求参数 逗号分割
     * @param args 请求参数
     * @return requestParam
     */
    private String formatRequest(Object[] args){
        StringBuilder builder = new StringBuilder();
        for (Object object : args){
            if(builder.length() > 0){
                builder.append(",");
            }
            //request,response,文件上传过滤掉
            if(object instanceof HttpServletRequest){
                continue;
            }
            if(object instanceof HttpServletResponse){
                continue;
            }
            if(object instanceof MultipartFile){
                continue;
            }
            if(object instanceof Model){
                continue;
            }
            builder.append(JSONObject.toJSONString(object));
        }
        return builder.toString();
    }
}
