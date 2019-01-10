package com.fanyin.controller.system;


import com.fanyin.controller.AbstractController;
import com.fanyin.dto.system.config.ConfigAddRequest;
import com.fanyin.dto.system.config.ConfigEditRequest;
import com.fanyin.dto.system.config.ConfigQueryRequest;
import com.fanyin.ext.Paging;
import com.fanyin.ext.Response;
import com.fanyin.model.system.SystemConfig;
import com.fanyin.service.system.SystemConfigService;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;


/**
 * @author 二哥很猛
 * @date 2018/1/12 17:40
 */
@Controller
public class ConfigController extends AbstractController {

    @Autowired
    private SystemConfigService systemConfigService;

    @PostMapping("/system/config/edit_config")
    @ResponseBody
    public Response editConfig(ConfigEditRequest request){
        systemConfigService.updateConfig(request);
        return Response.getInstance();
    }

    /**
     * 参数编辑页面
     * @param model 存放参数对象
     * @param id 主键
     * @return 页面
     */
    @PostMapping("/public/system/config/edit_config_page")
    public String editConfigPage(Model model, Integer id){
        SystemConfig config = systemConfigService.getById(id);
        model.addAttribute("config",config);
        return "public/system/config/edit_config_page";
    }

    /**
     * 分页获取系统参数配置
     * @param request 查询
     * @return 分页列表
     */
    @PostMapping("/system/config/config_list_page")
    @ResponseBody
    public Paging<SystemConfig> configListPage(ConfigQueryRequest request){
        PageInfo<SystemConfig> listByPage = systemConfigService.getByPage(request);
        return new Paging<>(listByPage);
    }

    /**
     * 添加系统参数
     * @return 成功或失败的结果集
     */
    @PostMapping("/system/config/add_config")
    @ResponseBody
    public Response addConfig(ConfigAddRequest request){
        systemConfigService.addConfig(request);
        return Response.getInstance();
    }
}
