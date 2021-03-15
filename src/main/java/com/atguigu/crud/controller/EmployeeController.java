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
 * ����Ա����CRUD����
 * @author Ran
 *
 */

@Controller
public class EmployeeController {
	
	@Autowired
	EmployeeService employeeService;
	
	/**
	 * ResponseBodyҪ�������� ��Ҫ����jackson��
	 * @param pn
	 * @param model
	 * @return
	 */
	@RequestMapping("/emps")
	@ResponseBody
	public Msg getEmpsWithJson(@RequestParam(value="pn",defaultValue = "1") Integer pn,Model model) {
		//�ⲻ��һ����ҳ��ѯ
		//Ϊ�˼� ����PageHelper��ҳ���
		//�ڲ�ѯ֮ǰֻ��Ҫ����  ����ҳ���Լ�ÿҳ�Ĵ�С
		PageHelper.startPage(pn,5);
		//startpage��������������ѯ����һ����ҳ��ѯ
		List<Employee> emps = employeeService.getAll();
		//ʹ��pageInfo��װ��ѯ��Ľ�� ֻ��Ҫ��pageinfo����ҳ�������
		//��װ����ϸ�ķ�ҳ��Ϣ�����������ǲ�ѯ������
		PageInfo page = new PageInfo(emps,5);//��������5ҳ
		model.addAttribute("pageInfo", page);
		//return page; //����listҳ�����չʾ  ͨ����ͼ������/WEB-INF/views .jsp
		
		//�Զ���Msg��װ��pageinfo
		return Msg.success().add("pageInfo", page);
	}
	/**
	 * ��ѯԱ�����ݣ���ҳ��ѯ��
	 * @return
	 */
	//@RequestMapping("/emps")
	public String getEmps(@RequestParam(value="pn",defaultValue = "1") Integer pn,Model model) {
		//�ⲻ��һ����ҳ��ѯ
		//Ϊ�˼� ����PageHelper��ҳ���
		//�ڲ�ѯ֮ǰֻ��Ҫ����  ����ҳ���Լ�ÿҳ�Ĵ�С
		PageHelper.startPage(pn,5);
		//startpage��������������ѯ����һ����ҳ��ѯ
		List<Employee> emps = employeeService.getAll();
		//ʹ��pageInfo��װ��ѯ��Ľ�� ֻ��Ҫ��pageinfo����ҳ�������
		//��װ����ϸ�ķ�ҳ��Ϣ�����������ǲ�ѯ������
		PageInfo page = new PageInfo(emps,5);//��������5ҳ
		model.addAttribute("pageInfo", page);
		return "list"; //����listҳ�����չʾ  ͨ����ͼ������/WEB-INF/views .jsp
	}
	
	/**
	 * Ա������
	 * @ValidУ��
	 * 1��֧��JSR303У��
	 * 2������Hibernate-Validator��
	 * @param employee
	 * @return
	 */
	@RequestMapping(value="/emp",method=RequestMethod.POST)
	@ResponseBody
	public Msg saveEmp(@Valid Employee employee,BindingResult result) {
		if(result.hasErrors()) {
			//У��ʧ��
			Map<String,Object> map = new HashMap<>();
			List<FieldError> errors = result.getFieldErrors();
			for(FieldError fieldError : errors) {
				System.out.println("�����ֶ�����"+fieldError.getField());
				System.out.println("������Ϣ��"+fieldError.getDefaultMessage());
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
		//���ж��û����Ƿ�Ϸ� ʹ��������ʽ
		String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})";
		if(!empName.matches(regx)) {
			return Msg.fail().add("va_msg", "�û���������2-5λ���Ļ���6-16λӢ�ĺ����ֵ����");
		}
		
		//���ݿ�У��
		boolean b = employeeService.checkUser(empName);
		if(b)
			return Msg.success();
		else
			return Msg.fail().add("va_msg", "�����û�ʹ�ø��û���");
	}
	
	
	/**
	 * ����id��ѯԱ��
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
	 * tomcat��
	 * 	���������е����� ��װһ��map
	 * 	request.getParameter���Ǵ�map��ȡֵ
	 * 	springMVC��װPOJO�����ʱ�� ���POJO��ÿ�����Ե�ֵ ����request.getParameter�õ�
	 * 
	 * AJAX����PUT����  ����ֱ�ӷ�  �������е�����  request.getParameter���ò���
	 * TOMCATһ����PUT���� �����װ�������е�����Ϊmap ֻ��POST�Ż�
	 * 
	 * Ҫ��֧��ֱ�ӷ���PUT֮�������Ҫ��װ�������е�����
	 * ������HttpPutFormContentFilter
	 * ���������ǽ��������е����ݽ�����װ��һ��map
	 * request�����°�װ  request.getParameter()����д �ͻ���Լ���װ��map��ȡ����
	 * 
	 * ����Ա����Ϣ
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
	 * ���� ���� ����һ
	 * ����ɾ����1-2-3
	 * ����ɾ����1
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
