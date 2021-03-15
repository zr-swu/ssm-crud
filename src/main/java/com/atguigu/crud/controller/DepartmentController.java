package com.atguigu.crud.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.atguigu.crud.bean.Department;
import com.atguigu.crud.bean.Msg;
import com.atguigu.crud.service.DepartmentService;

/**
 * 处理和部门有关的请求
 * @author Ran
 *
 */

@Controller
public class DepartmentController {
	
	@Autowired
	private DepartmentService departmentService;
	
	/**
	 * 返回所有的部门信息
	 */
	@RequestMapping("/depts")
	@ResponseBody //@ResponseBody 表示该方法的返回结果直接写入 HTTP response body 中
	public Msg getDepts() {
		List<Department> list = departmentService.getDepts();
		
		return Msg.success().add("depts", list);
	}
}
