package com.fanyin.service.business;

import com.fanyin.dto.business.HelpAddRequest;
import com.fanyin.dto.business.HelpEditRequest;
import com.fanyin.dto.business.HelpQueryRequest;
import com.fanyin.model.business.HelpInstruction;
import com.github.pagehelper.PageInfo;

/**
 * @author 帮助说明
 * @date 2018/11/20 20:20
 */
public interface HelpInstructionService {

    /**
     * 添加帮助说明
     * @param request 前台参数
     */
    void addHelpInstruction(HelpAddRequest request);

    /**
     * 更新帮助说明
     * @param request 前台参数
     */
    void updateHelpInstruction(HelpEditRequest request);

    /**
     * 删除帮助说明
     * @param request 前台参数 id
     */
    void deleteHelpInstruction(HelpEditRequest request);

    /**
     * 分页获取帮助说明
     * @param request 前台参数
     * @return 分页列表
     */
    PageInfo<HelpInstruction> getByPage(HelpQueryRequest request);
}

