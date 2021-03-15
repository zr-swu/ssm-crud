package com.atguigu.crud.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.bean.EmployeeExample;
import com.atguigu.crud.bean.EmployeeExample.Criteria;
import com.atguigu.crud.dao.EmployeeMapper;

@Service
public class EmployeeService {
	@Autowired
	EmployeeMapper employeeMapper;
	
	/**
	 * ��ѯ����Ա��
	 * @return
	 */
	public List<Employee> getAll() {
		EmployeeExample example = new EmployeeExample();
		example.setOrderByClause("emp_id");
		return employeeMapper.selectByExampleWithDept(example);
	}
	
	/**
	 * Ա������
	 */
	public void saveEmp(Employee employee) {
		// TODO Auto-generated method stub
		employeeMapper.insertSelective(employee);
	}

	/**
	 * �����û����Ƿ����
	 * @param empName
	 * @return
	 */
	public boolean checkUser(String empName) {
		// TODO Auto-generated method stub
		EmployeeExample example = new EmployeeExample();
		Criteria criteria = example.createCriteria();//������ѯ����
		criteria.andEmpNameEqualTo(empName);//ƴװҪ������
		
		long count = employeeMapper.countByExample(example);
		return count == 0;
	}

	/**
	 * ����Ա��id��ѯԱ��
	 * @param id
	 * @return
	 */
	public Employee getEmp(Integer id) {
		// TODO Auto-generated method stub
		Employee employee = employeeMapper.selectByPrimaryKeyWithDept(id);
		return employee;
	}
	
	/**
	 * ����Ա����Ϣ
	 * @param employee
	 */
	public void updateRmp(Employee employee) {
		// TODO Auto-generated method stub
		employeeMapper.updateByPrimaryKeySelective(employee);
	}
	
	/**
	 * Ա��ɾ��
	 * @param id
	 */
	public void deleteEmp(Integer id) {
		// TODO Auto-generated method stub
		employeeMapper.deleteByPrimaryKey(id);
	}

	public void deleteBatch(List<Integer> ids) {
		// TODO Auto-generated method stub
		EmployeeExample  example = new EmployeeExample();
		Criteria criteria = example.createCriteria();
		criteria.andEmpIdIn(ids);
		employeeMapper.deleteByExample(example);
	}

}
