package com.fanyin.configuration.security;

import com.fanyin.model.system.SystemOperator;
import org.springframework.beans.BeanUtils;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;


/**
 * 组装校验的基础参数信息 账户,密码,权限列表
 * @author 二哥很猛
 * @date 2018/1/25 10:13
 */
public class SecurityOperator extends SystemOperator implements UserDetails{

    private static final long serialVersionUID = -7835234722564262280L;

    private Collection<? extends GrantedAuthority> authorities;

    SecurityOperator(SystemOperator operator,Collection<GrantedAuthority> authorityList){
        BeanUtils.copyProperties(operator,this);
        this.authorities = authorityList;
    }

    @Override
    public String getPassword() {
        return super.getPwd();
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    @Override
    public String getUsername() {
        return super.getMobile();
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return super.getState();
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
}
