<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>数据字典管理</title>
    <#include "../../../resources.ftl">
    <script type="text/javascript">
        var dataGrid;

        var winWidth = 480;
        var winHeight = 400;

        var addTitle = "添加数据字典";
        var addUrl = "/public/system/dict/add_dict_page";

        var editTitle = "编辑数据字典";
        var editUrl = "/public/system/dict/edit_dict_page";

        var  delMsg = "删除数据字典可能导致相关人员无法使用系统,确定要执行该操作";
        var delUrl = "/system/dict/delete_dict";

        $(function() {
            dataGrid = $("#dataGrid").datagrid({
                url : "/system/dict/dict_list_page",
                border : false,
                fit : true,
                fitColumns : false,
                idField : 'id',
                nowrap : false,//可以换行显示
                pagination:true,
                pageSize : pageSize,
                pageList : pageList,
                singleSelect : true,
                columns : [ [
                    {
                        field : "action",
                        title : "操作",
                        width : 90,
                        align : "center",
                        formatter : function(value, row) {
                            var str = '';
                            str += '<dl>';
                            str += '<dt><a href="javascript:void(0);">详情<i class="fa fa-angle-down fa-fw"></i></a></dt>';
                            str += '<dd>';
                            str += '<a href="javascript:void(0);" onclick="$.fn.dataGridOptions.editFun('+row.id+',editTitle,winWidth,winHeight,editUrl);" title="编辑"> 编辑</a>';
                            str += '<a href="javascript:void(0);" onclick="$.fn.dataGridOptions.confirm('+row.id+',delUrl,delMsg);" title="删除"> 删除</a>';
                            str += '</dd>';
                            str += '</dl>';
                            return str;
                        }
                    },
                    {field : "title",title : "字典名称",width : 150,align : "center"},
                    {field : "nid",title : "标示符",width : 150,align : "center"},
                    {field : "hiddenValue",title : "隐藏值",width : 100,align : "center"},
                    {field : "showValue",title : "显示值",width : 150,align : "center"},
                    {field : "locked",title : "编辑状态",width : 80,align : "center",
                        formatter : function(value) {
                            return value ? "锁定" : "正常";
                        }
                    },
                    {field : "addTime",title : "添加时间",width : 180,align : "center",
                        formatter : function(value) {
                            return getLocalTime(value, 4);
                        }
                    },
                    {field : "updateTime",title : "更新时间",width : 180,align : "center",
                        formatter : function(value) {
                            return getLocalTime(value, 4);
                        }
                    },
                    {field : "remark",title : "备注",align : "center",width : 300 }
                ] ]
            });
        });

    </script>
</head>
<body class="tabs_body">
<div class="easyui-layout" data-options="fit:true">
    <div data-options="region:'north',border:false" class="condition_bar">
        <div class="layout_norths">
            <div class="left">
                <form id="queryForm" method="post">
                    <input name="queryName" placeholder="字典名称、标示符" /><a href="#" onclick="$.fn.dataGridOptions.searchFun('#queryForm');" class="searchBtn"><i class="fa fa-search"></i>&nbsp;查询</a>
                    <a href="#" class="dropBtn">查询条件<i class="fa fa-angle-double-down"></i></a>
                </form>
            </div>
            <div class="right">
                <a href="#" class="searchBtn" onclick="$.fn.dataGridOptions.editFun(0,addTitle,winWidth,winHeight,addUrl);"><i class="fa fa-plus"></i>&nbsp;添加</a>
            </div>
            <form id="showAdw" method="post">
                <ul class="showAdw" style="display: none;">
                    <a href="javascript:void(0);" class="close"><i class="fa fa-remove fa-lg"></i></a>
                    <li>
                        <span>编辑状态</span>
                        <select name="locked" class="type" title="编辑状态">
                            <option value="">全部</option>
                            <option value="true">锁定</option>
                            <option value="false">正常</option>
                        </select>
                    </li>
                    <li>
                        <div class="submitBtn">
                            <a href="javascript:void(0);" class="searchBtn"
                               onclick="$.fn.dataGridOptions.searchFun('#showAdw');">确定</a>
                            <a href="javascript:void(0);" class="searchBtn"
                               onclick="$.fn.dataGridOptions.cleanFun('#searchForm');">重置</a>
                        </div>
                    </li>
                </ul>
            </form>
        </div>
    </div>
    <div data-options="region:'center'">
        <table id="dataGrid" ></table>
    </div>
</div>
</body>
<script type="text/javascript" src="/static/js/search.js?v=${version!}"></script>
</html>