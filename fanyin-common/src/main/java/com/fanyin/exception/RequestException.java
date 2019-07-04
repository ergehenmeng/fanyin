package com.fanyin.exception;

import com.fanyin.enums.ErrorCodeEnum;

/**
 * 请求校验等异常
 * @author 王艳兵
 * @date 2019/7/4 15:20
 */
public class RequestException extends SystemException {

    public RequestException(ErrorCodeEnum error) {
        super(error);
    }

    public RequestException(int code, String msg) {
        super(code, msg);
    }
}
