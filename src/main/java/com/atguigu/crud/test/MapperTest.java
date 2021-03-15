package com.atguigu.crud.test;

import java.util.UUID;

import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.dao.DepartmentMapper;
import com.atguigu.crud.dao.EmployeeMapper;

/**
 * ����dao�㹤��
 * @author Ran
 * �Ƽ�Spring����Ŀ�Ϳ���ʹ��Spring�ĵ�Ԫ���� �����Զ�ע��������Ҫ�����
 * 
 * 1������SpringTest
 * 2��@ContextConfigurationָ��Spring�����ļ���λ��
 * 3��ֱ��autowiredҪʹ�õ����
 */

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {
	
	@Autowired
	DepartmentMapper departmentMapper;
	
	@Autowired
	EmployeeMapper employeeMapper;
	
	@Autowired
	SqlSession sqlSession;
	/**
	 * ����DepartmentMapper
	 */
	@Test
	public void testCRUD() {
		/*
		//1������SpringIOC����
		ApplicationContext ioc = new ClassPathXmlApplicationContext("applicationContext.xml");
		//2���������л�ȡmapper
		DepartmentMapper bean = ioc.getBean(DepartmentMapper.class);
		 */
		//System.out.println("1111");
		System.out.println(departmentMapper);
		
		//1�����뼸������	
//		departmentMapper.insertSelective(new Department(null,"������"));
//		departmentMapper.insertSelective(new Department(null,"���Բ�"));
//		
		//2������Ա������
//		employeeMapper.insertSelective(new Employee(null,"Jerry", "M", "Jerry@atguigu.com", 1));
		
		//3������������Ա��   ���� ʹ�ÿ���ִ������������sqlSession
		EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
		for(int i=0;i<1000;i++) {
			String uid = UUID.randomUUID().toString().substring(0,5)+i;
			mapper.insertSelective(new Employee(null, uid, "M", uid+"@atguigu.com", 1));
		}
	}
}
