<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="multipart/form-data; charset=UTF-8">
<title>员工列表</title>

<!-- web路径
不以/开始的相对路径  找资源 以当前资源的路径为基准
以/开始的相对路径 找资源 以服务器的路径为标准 http://localhost:8080/crud
-->
<%
	pageContext.setAttribute("APP_PATH",request.getContextPath());
%>

<!-- 先引jquery再引bootstrap -->
<script src="https://cdn.bootcdn.net/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
<script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>


</head>

<body>
	<!-- 员工添加模态框 -->
	<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="myModalLabel">员工添加</h4>
	      </div>
	      <div class="modal-body">
	        <form class="form-horizontal" method="post">
	        
			  <div class="form-group">
			    <label  class="col-sm-2 control-label">empName</label>
			    <div class="col-sm-10">
			      <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="empName">
			   	  <span class="help-block"></span>
			    </div>
			  </div>
			  
			  <div class="form-group">
			    <label  class="col-sm-2 control-label">email</label>
			    <div class="col-sm-10">
			      <input type="text" name="email" class="form-control" id="email_add_input" placeholder="email@atguigu.com">
			      <span class="help-block"></span>
			    </div>
			  </div>
			  
			  <div class="form-group">
			    <label  class="col-sm-2 control-label">gender</label>
			    <div class="col-sm-10">
			      <label class="radio-inline">
					  <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
				  </label>
				  <label class="radio-inline">
					  <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
				  </label>
			    </div>
			  </div>
			
			  <div class="form-group">
			    <label  class="col-sm-2 control-label">deptName</label>
			    <div class="col-sm-4">
			    	<!-- 部门提交部门id即可 -->
			    	<select name="dId" class="form-control" id="dept_add_select">
					 <!--  <option>1</option>--> 
					</select>
			    </div>
			  </div>
			  			  
			</form>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	        <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
	      </div>
	    </div>
	  </div>
	</div>
	
	<!-- 员工修改模态框 -->
	<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="myModalLabel">员工修改</h4>
	      </div>
	      <div class="modal-body">
	        <form class="form-horizontal" method="post">
	        
			  <div class="form-group">
			    <label  class="col-sm-2 control-label">empName</label>
			    <div class="col-sm-10">
			       <p class="form-control-static" id="empName_update_static"></p>
			   	  <span class="help-block"></span>
			    </div>
			  </div>
			  
			  <div class="form-group">
			    <label  class="col-sm-2 control-label">email</label>
			    <div class="col-sm-10">
			      <input type="text" name="email" class="form-control" id="email_update_input" placeholder="email@atguigu.com">
			      <span class="help-block"></span>
			    </div>
			  </div>
			  
			  <div class="form-group">
			    <label  class="col-sm-2 control-label">gender</label>
			    <div class="col-sm-10">
			      <label class="radio-inline">
					  <input type="radio" name="gender" id="gender1_update_input" value="M" checked="checked"> 男
				  </label>
				  <label class="radio-inline">
					  <input type="radio" name="gender" id="gender2_update_input" value="F"> 女
				  </label>
			    </div>
			  </div>
			
			  <div class="form-group">
			    <label  class="col-sm-2 control-label">deptName</label>
			    <div class="col-sm-4">
			    	<!-- 部门提交部门id即可 -->
			    	<select name="dId" class="form-control" id="dept_update_select">
					 <!--  <option>1</option>--> 
					</select>
			    </div>
			  </div>
			  			  
			</form>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	        <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
	      </div>
	    </div>
	  </div>
	</div>

	<!-- 搭建显示页面 -->
	<div class="container">
		<!-- 标题 -->
		<div class="row">
			<div class="col-md-12">
				<h1>SSM-CRUD</h1>
			</div>
		</div>
		
		<!-- 按钮 -->
		<div class="row">
			<div class="col-md-4 col-md-offset-8">
				<button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
				<button class="btn btn-danger" id="emp_delete_all">删除</button>
			</div>
		</div>
		
		<!-- 显示表格数据 -->
		<div class="row">
			<div class="col-md-12">
				<table class="table table-hover" id="emps_tables">
					<thead>
						<tr>
							<th>
								<input type="checkbox" id="check_all"/>
							</th>
							<th>#</th>
							<th>empName</th>
							<th>gender</th>
							<th>email</th>
							<th>deptName</th>	
							<th>操作</th>	
						</tr>
					</thead>
					
					<tbody>
					</tbody>
				</table>
			</div>
		</div>
		
		<!-- 显示分页信息 -->
		<div class="row">
			<!-- 分页文字信息 -->
			<div class="col-md-6" id="page_info_area">
				
			</div>
			
			<!-- 分页条 -->
			<div class="col-md-6" id="page_nav_area">
				
			</div>
		</div>
	</div>
	
	<script type="text/javascript">
	
		var currentPage;
		//1、页面加载完成后 直接发送ajax请求 要到分页的数据
		$(function(){
			to_page(1);
		});
		
		function to_page(pn){
			$.ajax({
				url:"${APP_PATH}/emps",
				data:"pn="+pn,
				type:"get",
				success:function(result){
					//console.log(result);
					//1、解析并显示员工数据
					build_emps_table(result);
					//2、解析并显示分页信息
					build_page_info(result)
					//3、解析并显示分页条
					build_page_nav(result)
				}
			});
		}
		
		function build_emps_table(result){
			
			//首先要清空内容
			$("#emps_tables tbody").empty();
			
			 var emps = result.extend.pageInfo.list;
			//jquery提供的each方法
			 $.each(emps,function(index,item){
				 //alert(item.empName);
				 var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>")
				 //构建td对象
				 var empIdTd = $("<td></td>").append(item.empId);
				 var empNameTd = $("<td></td>").append(item.empName);
				 var gender = item.gender=='M'?"男":"女";
				 var genderTd = $("<td></td>").append(gender);
				 var emailTd = $("<td></td>").append(item.email);
				 var deptNameTd = $("<td></td>").append(item.department.deptName);
				 /**
				 <button class="btn btn-primary btn-sm">
					<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
									编辑
				</button>
				<button class="btn btn-danger btn-sm">
					<span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
						删除
				</button>
					*/
				 var editBtn = $("<button></button>")
				 .addClass("btn btn-primary btn-sm edit_btn")
				 .append($("<span></span>").addClass("glyphicon glyphicon-pencil"))
				 .append("编辑");
				 
				editBtn.attr("edit-id",item.empId);
				
				var delBtn = $("<button></button>")
				 .addClass("btn btn-danger btn-sm delete_btn")
				 .append($("<span></span>").addClass("glyphicon glyphicon-trash"))
				 .append("删除");
				
				delBtn.attr("del-id",item.empId);
				
				var btnTd = $("<td></td>")
				.append(editBtn)
				.append(" ")
				.append(delBtn);
				
				 //append方法执行完成以后还是返回原来的元素 所以能链式操作
				 $("<tr></tr>").append(checkBoxTd)
				 .append(empIdTd)
				 .append(empNameTd)
				 .append(genderTd)
				 .append(emailTd)
				 .append(deptNameTd)
				 .append(btnTd)
				 .appendTo("#emps_tables tbody");			 
			 });
		}
		
		//解析显示分页信息
		function build_page_info(result){
			$("#page_info_area").empty();
			$("#page_info_area").append("当前"+result.extend.pageInfo.pageNum+
					"页,总"+result.extend.pageInfo.pages+"页，总"+
					result.extend.pageInfo.total+"记录");
			
			currentPage = result.extend.pageInfo.pageNum;
		}
		
		//解析显示分页条
		function build_page_nav(result){
			//page_nav_area
			
			$("#page_nav_area").empty();
			
			var ul = $("<ul></ul>").addClass("pagination");
			
			
			var firstPageLi = $("<li></li>")
			.append($("<a></a>").append("首页").attr("href","#"));
			
			var  prePageLi = $("<li></li>")
			.append($("<a></a>").append("&laquo;"));
			
			if(result.extend.pageInfo.hasPreviousPage == false){
				firstPageLi.addClass("disabled");
				prePageLi.addClass("disabled");
			}else{
				firstPageLi.click(function(){
					to_page(1);
				});
				
				prePageLi.click(function(){
					to_page(result.extend.pageInfo.pageNum-1);
				});
			}
			
			
			
			var  nextPageLi = $("<li></li>")
			.append($("<a></a>").append("&raquo;"));
			
			var lastPageLi = $("<li></li>")
			.append($("<a></a>").append("末页").attr("href","#"));
		
			
			
			if(result.extend.pageInfo.hasNextPage == false){
				nextPageLi.addClass("disabled");
				lastPageLi.addClass("disabled");
			}else{
				nextPageLi.click(function(){
					to_page(result.extend.pageInfo.pageNum+1);
				});
				
				lastPageLi.click(function(){
					to_page(result.extend.pageInfo.pages);
				});
			}
			
			//添加首页和前一页
			ul.append(firstPageLi).append(prePageLi);
			
			$.each(result.extend.pageInfo.navigatepageNums,function(index,item){
				var numLi = $("<li></li>")
				.append($("<a></a>").append(item));
				
				if(result.extend.pageInfo.pageNum == item)
					numLi.addClass("active");
				
				numLi.click(function(){
					to_page(item);
				});//绑定点击事件
				
				ul.append(numLi);
			});
			
			ul.append(nextPageLi).append(lastPageLi);
			
			var navEle = $("<nav></nav>").append(ul);
			
			navEle.appendTo("#page_nav_area");
		}
		
		function reset_form(ele){
			//清空内容
			$(ele)[0].reset();
			
			//清空样式
			$(ele).find("*").removeClass("has-error has-success");
			$(ele).find(".help-block").text("");
		}
		
		//点击新增按钮弹出模态框
		$("#emp_add_modal_btn").click(function(){
			//表单重置
			reset_form("#empAddModal form");
			//发送ajax请求 查出部门信息 显示在下拉列表中
			getDepts("#dept_add_select");
			
			$("#empAddModal").modal({
				backdrop:"static"
			});
		});
		
		function getDepts(ele){
			$(ele).empty();
			$.ajax({
				url:"${APP_PATH}/depts",
				type:"GET",
				success:function(result){
	//{"code":100,"msg":"处理成功！","extend":{"depts":[{"deptId":1,"deptName":"开发部"},{"deptId":2,"deptName":"测试部"}]}}
					//console.log(result);
					
					//显示在下拉列表中
					$.each(result.extend.depts,function(){
						var optionEle = $("<option></option").append(this.deptName)
						.attr("value",this.deptId);
						optionEle.appendTo(ele);
					});
				
				}
			});
		}
		
		function validate_add_form(){
			//1、拿到要校验的数据 使用正则表达式
			var empName = $("#empName_add_input").val();
			var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
			if(!regName.test(empName)){
				//alert("用户名可以实2-5位中文或者6-16位英文和数字的组合");
				//要清空旧样式
				$("#empName_add_input").parent().removeClass("has-success has-error");
				$("#empName_add_input").next("span").text("");
				
				$("#empName_add_input").parent().addClass("has-error");
				$("#empName_add_input").next("span").text("用户名可以实2-5位中文或者6-16位英文和数字的组合");
				return false;
			}else{
				//要清空旧样式
				$("#empName_add_input").parent().removeClass("has-success has-error");
				$("#empName_add_input").next("span").text("");
				
				$("#empName_add_input").parent().addClass("has-success");
				$("#empName_add_input").next("span").text("");
			}
			
			//2、校验邮箱
			var email = $("#email_add_input").val();
			var regEmail = /^([a-z0-9_\.-]+)@(\da-z\.-]+)\.([a-z\.]{2,6})$/;
			if(!regEmail.test(email)){
				//alert("邮箱格式不正确");
				//要清空旧样式
				$("#email_add_input").parent().removeClass("has-success has-error");
				$("#email_add_input").next("span").text("");
				
				$("#email_add_input").parent().addClass("has-error");
				$("#email_add_input").next("span").text("邮箱格式不正确");
				return false;
			}else{
				//要清空旧样式
				$("#email_add_input").parent().removeClass("has-success has-error");
				$("#email_add_input").next("span").text("");
				
				$("#email_add_input").parent().addClass("has-success");
				$("#email_add_input").next("span").text("");
			}
			
			return true;
		}
		
		//绑定事件 检验用户名是否可用
		$("#empName_add_input").change(function(){
			var empName = this.value;
			$.ajax({
				url:"${APP_PATH}/checkuser",
				data:"empName="+empName,
				type:"POST",
				success:function(result){
					if(result.code==100){
						$("#empName_add_input").parent().removeClass("has-success has-error");
						$("#empName_add_input").next("span").text("");
						
						$("#empName_add_input").parent().addClass("has-success");
						$("#empName_add_input").next("span").text("用户名可用");
						
						$("emp_save_btn").attr("ajax-va","success");
					}else{
						$("#empName_add_input").parent().removeClass("has-success has-error");
						$("#empName_add_input").next("span").text("");
						
						$("#empName_add_input").parent().addClass("has-error");
						$("#empName_add_input").next("span").text(result.extend.va_msg);
						
						$("emp_save_btn").attr("ajax-va","error");
					}
						
				}
			});
		});
		
		$("#emp_save_btn").click(function(){
			//模态框中填写的表单数据提交给服务器进行保存
			//alert($("#empAddModal form").serialize());
			
			//提交给服务器进行数据校验
			
			if(!validate_add_form()){
				return false;
			};
			
			//之前的ajax验证是否成功 成功才往下走
			if($(this).attr("ajax.va") == "error")
				return false;
			
			//发送ajax请求保存员工
			$.ajax({
				url:"${APP_PATH}/emp",
				type:"POST",
				data:$("#empAddModal form").serialize(),
				success:function(result){
					//alert(result.msg);
					if(result.code==100){						
						//员工保存成功
						//1、关闭模态框
						$("#empAddModal").modal('hide');
						//2、来到最后一页 显示
						to_page(99999);
					}else{
						//显示失败信息
						//console.log(result);
						if(undefined != result.extend.errorFields.email){
							$("#email_add_input").parent().removeClass("has-success has-error");
							$("#email_add_input").next("span").text("");
							
							$("#email_add_input").parent().addClass("has-error");
							$("#email_add_input").next("span").text(result.extend.errorFields.email);
						}
						if(undefined != result.extend.errorFields.empName){
							$("#empName_add_input").parent().removeClass("has-success has-error");
							$("#empName_add_input").next("span").text("");
							
							$("#empName_add_input").parent().addClass("has-error");
							$("#empName_add_input").next("span").text(result.extend.errorFields.empName);
						}
					}
				}
			});
		});
		
		$(document).on("click",".edit_btn",function(){
			//查出员工信息 显示员工信息
			//查出部门信息 显示部门信息
			getDepts("#empUpdateModal select");
			getEmp($(this).attr("edit-id"));
			
			
			//员工id传给更新按钮
			$("#emp_update_btn").attr("edit-id",$(this).attr("edit-id"));
			
			$("#empUpdateModal").modal({
				backdrop:"static"
			});
		});
		
		function getEmp(id){
			$.ajax({
				url:"${APP_PATH}/emp/"+id,
				type:"GET",
				success:function(result){
					//console.log(result);
					var empData = result.extend.emp;
					$("#empName_update_static").text(empData.empName);	
					$("#email_update_input").val(empData.email);
					$("#empUpdateModal input[name=gender]").val([empData.gender]);
					$("#empUpdateModal select").val([empData.dId]);
				}
			});
		}
		
		
		//点击更新按钮
		$("#emp_update_btn").click(function(){
			//2、校验邮箱
			var email = $("#email_update_input").val();
			var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
			if(!regEmail.test(email)){
				//alert("邮箱格式不正确");
				//要清空旧样式
				$("#email_update_input").parent().removeClass("has-success has-error");
				$("#email_update_input").next("span").text("");
				
				$("#email_update_input").parent().addClass("has-error");
				$("#email_update_input").next("span").text("邮箱格式不正确");
				return false;
			}else{
				//要清空旧样式
				$("#email_update_input").parent().removeClass("has-success has-error");
				$("#email_update_input").next("span").text("");
				
				$("#email_update_input").parent().addClass("has-success");
				$("#email_update_input").next("span").text("");
			}
			
			//发送ajax请求保存更新的员工共信息
			$.ajax({
				url:"${APP_PATH}/emp/"+$(this).attr("edit-id"),
				type:"PUT",
				data:$("#empUpdateModal form").serialize(),
				success:function(result){
					//alert(result.msg);
					
					//关闭模态框
					$("#empUpdateModal").modal("hide");
					
					//回到本页面
					to_page(currentPage);
				}
			});
		});
		
		//单个删除
		$(document).on("click",".delete_btn",function(){
			//1、弹出是否确认删除对话框
			var empName = $(this).parents("tr").find("td:eq(2)").text();
			var empId = $(this).attr("del-id");
			if(confirm("确认删除【"+empName+"】吗？")){
				$.ajax({
					url:"${APP_PATH}/emp/"+empId,
					type:"DELETE",
					success:function(result){
						alert(result.msg);
						to_page(currentPage);
					}
				});
			}
		});
		
		//完成全选/全不选功能
		$("#check_all").click(function(){
			//attr获取自定义属性的值 prop获取dom原生的属性
			$(".check_item").prop("checked",$(this).prop("checked"));
		});
		
		$(document).on("click",".check_item",function(){
			//判断当前选中的元素是否5个
		var flag = $(".check_item:checked").length == $(".check_item").length;
		$("#check_all").prop("checked",flag);
			
		});
		
		$("#emp_delete_all").click(function(){
			var empNames = "";
			var del_idstr = "";
			
			$.each($(".check_item:checked"),function(){
				empNames += $(this).parents("tr").find("td:eq(2)").text()+",";
				del_idstr += $(this).parents("tr").find("td:eq(1)").text()+"-";
			});
			empNames = empNames.substring(0,empNames.length-1);
			del_idstr = del_idstr.substring(0,del_idstr.length-1);
			if(confirm("确认删除【"+empNames+"】吗？")){
				//发送ajax请求删除
				$.ajax({
					url:"${APP_PATH}/emp/" + del_idstr,
					type:"DELETE",
					success:function(result){
						alert(result.msg);
						to_page(currentPage);
					}
				});
			}
		});
	</script>
	
</body>
</html>