package com.fanyin.controller.system;

import com.fanyin.annotation.Mark;
import com.fanyin.annotation.RequestType;
import com.fanyin.controller.AbstractController;
import com.fanyin.model.system.SystemMenu;
import com.fanyin.model.system.SystemOperator;
import com.fanyin.service.system.SystemMenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

/**
 * 首页及登陆
 * @author 二哥很猛
 * @date 2018/1/8 14:41
 */
@Controller
public class LoginController extends AbstractController {

    @Autowired
    private SystemMenuService systemMenuService;

    /**
     * 未登录的首页
     * @return 首页index.ftl
     */
    @GetMapping("/")
    public String index(){
        return "index";
    }

    /**
     * 登陆后的首页
     * @return home页面
     */
    @GetMapping("/home")
    public String home(Model model){
        SystemOperator operator = getRequiredOperator();
        List<SystemMenu> list = systemMenuService.getMenuList(operator.getId());
        model.addAttribute("menuList", list);
        model.addAttribute("isInit",operator.getPwd().equals(operator.getInitPwd()));
        return "home";
    }

    /**
     * 首页门户框
     * @return 门户页面
     */
    @GetMapping("/portal")
    public String portal(){
        return "portal";
    }

    /**
     * 全局页面定向
     * @param modules 所属模块
     * @param page 页面名称
     * @return 对应的页面
     */
    @RequestMapping("/public/{modules}/{function}/{page}")
    @Mark(RequestType.PAGE)
    public String modules(@PathVariable("modules")String modules,@PathVariable("function")String function,@PathVariable("page")String page){
        return "public/" + modules + "/" + function +"/" + page;
    }

}
