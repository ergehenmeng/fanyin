package com.fanyin.test.timer;

/**
 * @author 王艳兵
 * @date 2018/9/11 11:56
 */
public class TimerTaskOperation extends TimerTask {

    /**
     * 构造方法
     *
     * @param delayMs 延迟多长时间执行
     */
    public TimerTaskOperation(long delayMs) {
        super(delayMs);
    }

    @Override
    public void execute() {
        System.out.println("任务执行:" + System.currentTimeMillis());
    }
}
