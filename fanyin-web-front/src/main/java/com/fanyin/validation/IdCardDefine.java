package com.fanyin.validation;

import com.fanyin.utils.RegExpUtil;
import com.fanyin.validation.annotation.IdCard;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

/**
 * @author 二哥很猛
 * @date 2018/8/14 11:59
 */
public class IdCardDefine implements ConstraintValidator<IdCard,String> {

    /**
     * 是否必填
     */
    private boolean required;

    @Override
    public void initialize(IdCard constraintAnnotation) {
        this.required = constraintAnnotation.required();
    }

    @Override
    public boolean isValid(String value, ConstraintValidatorContext context) {
        return (!required && value == null) || RegExpUtil.idCard(value);
    }
}
