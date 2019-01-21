package com.fanyin.controller.operator;

import com.fanyin.annotation.Mark;
import com.fanyin.annotation.RequestType;
import com.fanyin.configuration.security.SecurityOperator;
import com.fanyin.controller.AbstractController;
import com.fanyin.dto.operator.OperatorAddRequest;
import com.fanyin.dto.operator.OperatorEditRequest;
import com.fanyin.dto.system.operator.OperatorQueryRequest;
import com.fanyin.dto.system.operator.PasswordEditRequest;
import com.fanyin.ext.Paging;
import com.fanyin.ext.Response;
import com.fanyin.model.system.SystemOperator;
import com.fanyin.service.operator.SystemOperatorService;
import com.fanyin.service.system.SystemRoleService;
import com.github.pagehelper.PageInfo;
import com.google.common.base.Joiner;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * @author 二哥很猛
 * @date 2018/11/26 17:10
 */
@Controller
public class OperatorController extends AbstractController {

    @Autowired
    private SystemOperatorService systemOperatorService;

    @Autowired
    private SystemRoleService systemRoleService;

    /**
     * 修改密码
     * @param request 请求参数
     * @return 成功状态
     */
    @PostMapping("/system/operator/change_password")
    @ResponseBody
    @Mark(RequestType.UPDATE)
    public Response changePassword(HttpSession session, PasswordEditRequest request){
        SecurityOperator operator = getRequiredOperator();
        request.setOperatorId(operator.getId());
        String newPassword = systemOperatorService.updateLoginPassword(request);
        operator.setPwd(newPassword);
        //更新用户权限
        SecurityContext context = (SecurityContext)session.getAttribute(HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY);
        Authentication authentication = context.getAuthentication();
        UsernamePasswordAuthenticationToken token =  new UsernamePasswordAuthenticationToken(operator,authentication,operator.getAuthorities());
        token.setDetails(authentication.getDetails());
        context.setAuthentication(token);

        return Response.getInstance();
    }

    /**
     * 分页查询系统操作人员列表
     * @param request 查询条件
     * @return 列表
     */
    @PostMapping("/system/operator/operator_list_page")
    @ResponseBody
    @Mark(RequestType.SELECT)
    public Paging<SystemOperator> operatorListPage(OperatorQueryRequest request){
        PageInfo<SystemOperator> page = systemOperatorService.getByPage(request);
        return new Paging<>(page);
    }


    /**
     * 添加管理人员
     * @return 成功
     */
    @PostMapping("/system/operator/add_operator")
    @ResponseBody
    @Mark(RequestType.INSERT)
    public Response addOperator(OperatorAddRequest request){
        systemOperatorService.addOperator(request);
        return Response.getInstance();
    }

    /**
     * 管理人员编辑页面
     * @param id 管理人员id
     * @return 页面
     */
    @PostMapping("/public/system/operator/edit_operator_page")
    @Mark(RequestType.PAGE)
    public String editOperatorPage(Model model, Integer id){
        SystemOperator operator = systemOperatorService.getById(id);
        model.addAttribute("operator",operator);
        List<Integer> roleList = systemRoleService.getByOperatorId(id);
        if(roleList != null && roleList.size() > 0){
            String roleIds = Joiner.on(",").join(roleList);
            model.addAttribute("roleIds",roleIds);
        }
        return "public/system/operator/edit_operator_page";
    }

    /**
     * 更新管理人员信息
     * @param request 前台参数
     * @return 成功
     */
    @PostMapping("/system/operator/edit_operator")
    @ResponseBody
    @Mark(RequestType.UPDATE)
    public Response editOperator(OperatorEditRequest request){
        systemOperatorService.updateOperator(request);
        return Response.getInstance();
    }

}
