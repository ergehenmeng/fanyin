package com.fanyin.service.system.impl;

import com.fanyin.dto.system.menu.MenuAddRequest;
import com.fanyin.dto.system.menu.MenuEditRequest;
import com.fanyin.enums.ErrorCodeEnum;
import com.fanyin.enums.MenuClassify;
import com.fanyin.exception.BusinessException;
import com.fanyin.mapper.system.SystemMenuMapper;
import com.fanyin.model.system.SystemMenu;
import com.fanyin.service.system.SystemMenuService;
import com.fanyin.utils.BeanCopyUtil;
import com.google.common.base.Joiner;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

/**
 * @author 二哥很猛
 * @date 2018/1/26 16:15
 */
@Service
@Transactional(rollbackFor = RuntimeException.class)
public class SystemMenuServiceImpl implements SystemMenuService {

    @Autowired
    private SystemMenuMapper systemMenuMapper;

    private final Comparator<SystemMenu> comparator = Comparator.comparing(SystemMenu::getSort);

    @Override
    @Transactional(readOnly = true,rollbackFor = RuntimeException.class)
    public List<SystemMenu> getMenuList(Integer operatorId) {
        List<SystemMenu> list = systemMenuMapper.getMenuList(operatorId,MenuClassify.MENU);
        List<SystemMenu> parentList = new ArrayList<>();

        for (SystemMenu parent : list) {
            if (parent.getPid() == 0) {
                setChild(parent,list);
                parentList.add(parent);
            }
        }
        parentList.sort(comparator);
        return parentList;
    }

    @Override
    @Transactional(readOnly = true,rollbackFor = RuntimeException.class)
    public List<SystemMenu> getMenuList(Integer operatorId,MenuClassify classify) {
        return systemMenuMapper.getMenuList(operatorId,classify);
    }

    @Override
    @Transactional(readOnly = true,rollbackFor = RuntimeException.class)
    public SystemMenu getMenuById(Integer id) {
        return systemMenuMapper.selectByPrimaryKey(id);
    }

    @Override
    @Transactional(readOnly = true,rollbackFor = RuntimeException.class)
    public List<SystemMenu> getAllList() {
        return systemMenuMapper.getAllList();
    }

    @Override
    public void addMenu(MenuAddRequest request) {
        SystemMenu copy = BeanCopyUtil.copy(request, SystemMenu.class);
        if(request.getPid() != 0){
            copy.setNid(Joiner.on("-").join(request.getNid(),request.getPidNid()));
        }
        systemMenuMapper.insertSelective(copy);
    }



    @Override
    public void updateMenu(MenuEditRequest request) {

        SystemMenu copy = BeanCopyUtil.copy(request, SystemMenu.class);
        if(request.getPid() != 0){
            copy.setNid(Joiner.on("-").join(request.getNid(),request.getPidNid()));
        }

        int index;
        try{
            index = systemMenuMapper.updateByPrimaryKeySelective(copy);
        }catch (Exception e){
            //唯一索引会导致异常
            throw new BusinessException(ErrorCodeEnum.MENU_NID_ERROR);
        }
        if(index != 1){
            throw new BusinessException(ErrorCodeEnum.UPDATE_MENU_ERROR);
        }
    }

    @Override
    public void deleteMenu(Integer id) {
        systemMenuMapper.deleteById(id);
    }

    @Override
    public List<GrantedAuthority> getAuthorityByOperatorId(Integer operator) {
        List<SystemMenu> list = systemMenuMapper.getMenuList(operator,null);
        List<GrantedAuthority> authorities = new ArrayList<>();
        if(!CollectionUtils.isEmpty(list)){
            for (SystemMenu menu : list){
                GrantedAuthority authority = new SimpleGrantedAuthority(menu.getNid());
                authorities.add(authority);
            }
        }
        return authorities;
    }

    /**
     * 设置子菜单列表
     * @param parent 当前菜单
     * @param list 所有用户可操作的菜单
     */
    private void setChild(SystemMenu parent,List<SystemMenu> list){
        List<SystemMenu> childList = getChild(parent.getId(),list);
        if(!childList.isEmpty()){
            for(SystemMenu child : childList){
                setChild(child,list);
            }
            childList.sort(comparator);
            parent.setSubList(childList);
        }
    }

    /**
     * 根据ID查看是否存在子元素
     * @param id 相当于子元素的pid
     * @param list 所有菜单列表
     * @return 子菜单列表
     */
    private List<SystemMenu> getChild(int id,List<SystemMenu> list){
        List<SystemMenu> childList = new ArrayList<>();
        for(SystemMenu menu : list){
            if(menu.getPid() == id){
                childList.add(menu);
            }
        }
        return childList;
    }
}
