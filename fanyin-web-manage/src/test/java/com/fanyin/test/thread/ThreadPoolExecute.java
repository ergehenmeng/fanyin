package com.fanyin.test.thread;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * @author 二哥很猛
 * @date 2018/10/9 14:05
 */
public class ThreadPoolExecute {
    public static void main(String[] args) {
        ExecutorService service = Executors.newFixedThreadPool(10);
        for (int i = 0; i < 11; i++){
            final int j = i;
            service.execute(() -> {
                System.out.println(Thread.currentThread() + " 执行:" + j);
                throw new RuntimeException("自动异常");
            });
        }
        try {
            Thread.sleep(10000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        service.execute(() -> System.out.println("我是新任务"));
    }
}
