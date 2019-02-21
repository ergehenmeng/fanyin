package com.fanyin.utils;

import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author 二哥很猛
 * @date 2019/2/21 15:07
 */
public class HolidayUtil {
    public static void main(String[] args) {

        //生成来年节假日
        generateHoliday(2019,
                Arrays.asList("2019-01-01","2019-02-04","2019-02-05","2019-02-06","2019-02-07","2019-02-08","2019-04-05","2019-05-01","2019-06-07","2019-09-07",
                        "2019-10-01","2019-10-02","2019-10-03","2019-10-04","2019-10-05"),
                Arrays.asList("2019-02-02","2019-02-03","2019-09-29","2019-10-12"));
    }

    /**
     * 生成来年节假日SQL
     * @param year 要生成节假日列表的年份 2019等
     * @param holiday 国家法定假日 格式:yyyy-MM-dd
     * @param overtime 法定假日加班时间(注意:必须是周六,周日,如果非周六,周日会强制删除),例如 周日~周二法定假日,周六会加班,则填写周六  格式:yyyy-MM-dd
     */
    private static void generateHoliday(int year, List<String> holiday, List<String> overtime){
        //周一~周五的法定假日
        List<String> holidayList = filterWeekend(holiday);
        //周末调休加班
        List<String> overtimeList = filterWorkday(overtime);

        Calendar calendar = Calendar.getInstance();
        calendar.set(year - 1,Calendar.DECEMBER,31);

        //52个周末均显示
        for (int i = 0; i < 365; i++){
            calendar.add(Calendar.DAY_OF_WEEK,1);
            int week = calendar.get(Calendar.DAY_OF_WEEK);
            String format = DateUtil.format(calendar.getTime(),"yyyy-MM-dd");
            String formatMonth = DateUtil.format(calendar.getTime(),"yyyy-MM");
            if(week == 1 || week == 7){
                if(!overtimeList.contains(format)){
                    System.out.println("insert into holiday(calendar,date_month,state)values('" + format + "','" + formatMonth + "',1); ");
                    continue;
                }
            }else{
                if(holidayList.contains(format)){
                    System.out.println("insert into holiday(calendar,date_month,state)values('" + format + "','" + formatMonth + "',1); ");
                    continue;
                }
            }
            System.out.println("insert into holiday(calendar,date_month,state)values('" + format + "','" + formatMonth + "',0); ");
        }
    }

    /**
     * 过滤周六周日
     * @param holiday 法定节假日
     * @return 不包含周六周日的节假日
     */
    private static List<String> filterWeekend(List<String> holiday){
        Calendar instance = Calendar.getInstance();
        return holiday.stream().filter(s -> {
            Date date = DateUtil.parseShort(s);
            instance.setTime(date);
            int week = instance.get(Calendar.DAY_OF_WEEK);
            return week != 1 && week != 7;
        }).collect(Collectors.toList());
    }

    /**
     * 过滤周六周日
     * @param holiday 法定节假日
     * @return 不包含周六周日的节假日
     */
    private static List<String> filterWorkday(List<String> holiday){
        Calendar instance = Calendar.getInstance();
        return holiday.stream().filter(s -> {
            Date date = DateUtil.parseShort(s);
            instance.setTime(date);
            int week = instance.get(Calendar.DAY_OF_WEEK);
            return week == 1 || week == 7;
        }).collect(Collectors.toList());
    }
}
