package com.fanyin.validation;

import com.fanyin.validation.annotation.Section;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

/**
 * @author 王艳兵
 * @date 2018/8/14 13:46
 */
public class SectionDefine implements ConstraintValidator<Section,Integer> {

    /**
     * 取值列表
     */
    private int[] values;

    /**
     * 是否必填
     */
    private boolean required;

    @Override
    public void initialize(Section constraintAnnotation) {
        this.values = constraintAnnotation.value();
        this.required = constraintAnnotation.required();
    }

    @Override
    public boolean isValid(Integer value, ConstraintValidatorContext context) {
        if(!required && value == null){
            return true;
        }
        for (int v : values){
            if(v == value){
                return true;
            }
        }
        return false;
    }
}
