package com.atguigu.crud.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.bean.Msg;
import com.atguigu.crud.service.EmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

/**
 * 处理员工的CRUD请求
 * @author Ran
 *
 */

@Controller
public class EmployeeController {
	
	@Autowired
	EmployeeService employeeService;
	
	/**
	 * ResponseBody要正常工作 需要导入jackson包
	 * @param pn
	 * @param model
	 * @return
	 */
	@RequestMapping("/emps")
	@ResponseBody
	public Msg getEmpsWithJson(@RequestParam(value="pn",defaultValue = "1") Integer pn,Model model) {
		//这不是一个分页查询
		//为了简单 引入PageHelper分页插件
		//在查询之前只需要调用  传入页码以及每页的大小
		PageHelper.startPage(pn,5);
		//startpage后面紧跟的这个查询就是一个分页查询
		List<Employee> emps = employeeService.getAll();
		//使用pageInfo包装查询后的结果 只需要将pageinfo交给页面就行了
		//封装了详细的分页信息，包括有我们查询的数据
		PageInfo page = new PageInfo(emps,5);//连续传入5页
		model.addAttribute("pageInfo", page);
		//return page; //来到list页面进行展示  通过视图解析器/WEB-INF/views .jsp
		
		//自定义Msg封装了pageinfo
		return Msg.success().add("pageInfo", page);
	}
	/**
	 * 查询员工数据（分页查询）
	 * @return
	 */
	//@RequestMapping("/emps")
	public String getEmps(@RequestParam(value="pn",defaultValue = "1") Integer pn,Model model) {
		//这不是一个分页查询
		//为了简单 引入PageHelper分页插件
		//在查询之前只需要调用  传入页码以及每页的大小
		PageHelper.startPage(pn,5);
		//startpage后面紧跟的这个查询就是一个分页查询
		List<Employee> emps = employeeService.getAll();
		//使用pageInfo包装查询后的结果 只需要将pageinfo交给页面就行了
		//封装了详细的分页信息，包括有我们查询的数据
		PageInfo page = new PageInfo(emps,5);//连续传入5页
		model.addAttribute("pageInfo", page);
		return "list"; //来到list页面进行展示  通过视图解析器/WEB-INF/views .jsp
	}
	
	/**
	 * 员工保存
	 * @Valid校验
	 * 1、支持JSR303校验
	 * 2、导入Hibernate-Validator包
	 * @param employee
	 * @return
	 */
	@RequestMapping(value="/emp",method=RequestMethod.POST)
	@ResponseBody
	public Msg saveEmp(@Valid Employee employee,BindingResult result) {
		if(result.hasErrors()) {
			//校验失败
			Map<String,Object> map = new HashMap<>();
			List<FieldError> errors = result.getFieldErrors();
			for(FieldError fieldError : errors) {
				System.out.println("错误字段名："+fieldError.getField());
				System.out.println("错误信息："+fieldError.getDefaultMessage());
				map.put(fieldError.getField(), fieldError.getDefaultMessage());
			}
			return Msg.fail().add("errorFields", map);
		}
		else {			
			employeeService.saveEmp(employee);
			return Msg.success();
		}
	}
	
	@RequestMapping("/checkuser")
	@ResponseBody
	public Msg checkuser(@RequestParam("empName")String empName) {
		//先判断用户名是否合法 使用正则表达式
		String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})";
		if(!empName.matches(regx)) {
			return Msg.fail().add("va_msg", "用户名必须是2-5位中文或者6-16位英文和数字的组合");
		}
		
		//数据库校验
		boolean b = employeeService.checkUser(empName);
		if(b)
			return Msg.success();
		else
			return Msg.fail().add("va_msg", "已有用户使用该用户名");
	}
	
	
	/**
	 * 根据id查询员工
	 * @param id
	 * @return
	 */
	@RequestMapping(value="/emp/{id}",method=RequestMethod.GET)
	@ResponseBody
	public Msg getEmp(@PathVariable("id") Integer id) {
		Employee employee = employeeService.getEmp(id);
		return Msg.success().add("emp", employee);
	}
	
	
	/**
	 * tomcat：
	 * 	将请求体中的数据 封装一个map
	 * 	request.getParameter就是从map中取值
	 * 	springMVC封装POJO对象的时候 会把POJO中每个属性的值 调用request.getParameter拿到
	 * 
	 * AJAX发送PUT请求  不能直接发  请求体中的数据  request.getParameter都拿不到
	 * TOMCAT一看是PUT请求 不会封装请求体中的数据为map 只有POST才会
	 * 
	 * 要能支持直接发送PUT之类的请求还要封装请求体中的数据
	 * 配置上HttpPutFormContentFilter
	 * 它的作用是将请求体中的数据解析包装成一个map
	 * request被重新包装  request.getParameter()被重写 就会从自己封装的map中取数据
	 * 
	 * 更新员工信息
	 * @param employee
	 * @return
	 */
	@RequestMapping(value="/emp/{empId}",method = RequestMethod.PUT)
	@ResponseBody
	public Msg updateEmp(Employee employee) {
		employeeService.updateRmp(employee);
		return Msg.success();
	} 
	
	
	/**
	 * 单个 批量 二合一
	 * 批量删除：1-2-3
	 * 单个删除：1
	 * @param id
	 * @return
	 */
	@RequestMapping(value="/emp/{ids}",method = RequestMethod.DELETE)
	@ResponseBody
	public Msg deleteEmp(@PathVariable("ids") String ids) {
		if(ids.contains("-")) {
			List<Integer> del_ids = new ArrayList<>();
			String[] str_ids = ids.split("-");
			for(String string : str_ids) {
				del_ids.add(Integer.parseInt(string));
			}
			employeeService.deleteBatch(del_ids);
		}else {
			Integer id = Integer.parseInt(ids);
			employeeService.deleteEmp(id);
		}

		return Msg.success();
	}

}
