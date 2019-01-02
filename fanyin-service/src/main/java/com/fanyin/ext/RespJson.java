package com.fanyin.ext;

import com.fanyin.enums.ErrorCodeEnum;

import java.io.Serializable;

/**
 * 用于返回前台的结果集
 * @author 二哥很猛
 * @date 2018/1/12 17:41
 */
public class RespJson<T> implements Serializable {

    private static final long serialVersionUID = 1574813862539970945L;

    /**
     * 代码 默认200为成功
     */
    private int code = 200;
    /**
     * 信息
     */
    private String msg;

    /**
     * 结果集 键值对或者非基本类型对象
     */
    private T data;
    
    private RespJson(){
    }

    public static <T> RespJson<T> getInstance(){
        return new RespJson<>();
    }

    public RespJson<T> setError(ErrorCodeEnum error){
        this.code = error.getCode();
        this.msg = error.getMsg();
        return this;
    }

    public T getData() {
        return data;
    }

    public RespJson<T> setData(T data) {
        this.data = data;
        return this;
    }

    public String getMsg() {
        return msg;
    }

    public RespJson<T> setMsg(String msg) {
        this.msg = msg;
        return this;
    }

    public int getCode() {
        return code;
    }

    public RespJson<T> setCode(int code) {
        this.code = code;
        return this;
    }
}
