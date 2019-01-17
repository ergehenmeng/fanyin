<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>部门管理</title>
    <#include "../../../resources.ftl">

    <script type="text/javascript">
        var dataGrid;
        var winTitle = "响应信息";
        var winWidth = 480;
        var winHeight = 300;
        var url = "/public/system/operation/query_operation_page";

        $(function() {
            dataGrid = $.fn.treeGridOptions.treeGrid("#treeGrid",{
                url : "/system/department/department_list_page",
                loadFilter : pageFilter,
                columns : [[
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
                            str += '<a href="javascript:void(0);" onclick="$.fn.treeGridOptions.editFun('+row.id+',addTitle,winWidth,winHeight,addUrl);"> 添加</a>';
                            str += '<a href="javascript:void(0);" onclick="$.fn.treeGridOptions.editFun('+row.id+',editTitle,winWidth,winHeight,editUrl);"> 编辑</a>';
                            str += '<a href="javascript:void(0);" onclick="$.fn.treeGridOptions.confirm('+row.id+',delUrl,delMsg);"> 删除</a>';
                            str += '</dd>';
                            str += '</dl>';
                            return str;
                        }
                    },
                    {field : "text",title : "部门名称",width : 200,align : "center"},
                    {field : "code",title : "部门编号",width : 150,align : "center"},
                    {field : "addTime",title : "添加时间",width : 180,align : "center",
                        formatter : function(value) {
                            return getLocalTime(value, 4);
                        }
                    },
                    {field : "remark",title : "备注",align : "center",width : 300 }
                ]]
            });

            function pageFilter(rows) {
                if (!rows || !rows.data){
                    return;
                }
                return $.fn.treeGridOptions.dataFilter(rows.data,"code","title","parentCode","100",null);
            }
        });
    </script>
</head>
<body class="tabs_body">
<div class="easyui-layout" data-options="fit:true">
    <div data-options="region:'north',border:false" class="condition_bar">
        <div class="layout_norths">
            <div class="right">
                <a href="#" class="searchBtn" onclick="$.fn.treeGridOptions.editFun(0,addTitle,winWidth,winHeight,addUrl)"><i class="fa fa-plus"></i>&nbsp;添加</a>
            </div>
        </div>
    </div>
    <div data-options="region:'center'">
        <table id="treeGrid" ></table>
    </div>
</div>
</body>
</html>