package com.fanyin.enums;

import com.fanyin.exception.ParameterException;

import java.net.InetAddress;
import java.net.UnknownHostException;

/**
 * 分布式id workId生成类型
 * @author 二哥很猛
 */
public enum  WorkIdType {

    /**
     * 主机名称方式,该方式要求主机序号以数字开始或结尾,且中间不能包含数字
     */
    HOSTNAME{
        @Override
        public long getWorkId() {
            return HOSTNAME_WORK_ID;
        }
    },

    /**
     * ip方式
     */
    IP{
        @Override
        public long getWorkId() {
            return IP_WORK_ID;
        }
    };

    /**
     * 根据机器名最后的数字编号获取工作进程Id.如果线上机器命名有统一规范,建议使用此种方式.
     * 例如机器的HostName为:db-dev-01(公司名-部门名-服务名-环境名-编号)
     * ,会截取HostName最后的编号01作为workerId.
     **/
    private final static long HOSTNAME_WORK_ID = 0L;

    /**
     * 根据机器IP获取工作进程Id,如果线上机器的IP二进制表示的最后10位不重复,建议使用此种方式
     * ,列如机器的IP为192.168.1.108,二进制表示:11000000 10101000 00000001 01101100
     * ,截取最后10位 01 01101100,转为十进制364,设置workerId为364.
     */
    private static long IP_WORK_ID;

    static {
        InetAddress address;
        try {
            address = InetAddress.getLocalHost();
        } catch (final UnknownHostException e) {
            throw new ParameterException(ErrorCodeEnum.UN_KNOW_HOST_ADDRESS);
        }
        byte[] ipAddressByteArray = address.getAddress();
        IP_WORK_ID = (long) (((ipAddressByteArray[ipAddressByteArray.length - 2] & 0B11) << Byte.SIZE) + (ipAddressByteArray[ipAddressByteArray.length - 1] & 0xFF));
    }

    /**
     * 获取机器id [0,1024)
     * @return id
     */
    public long getWorkId() {
        throw new ParameterException(ErrorCodeEnum.NOT_IMPLEMENT);
    }
}
