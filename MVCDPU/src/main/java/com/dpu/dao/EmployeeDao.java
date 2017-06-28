package com.dpu.dao;

import org.hibernate.Session;

import com.dpu.entity.Employee;
import com.dpu.model.EmployeeModel;

public interface EmployeeDao extends GenericDao<Employee> {

	Employee add(Session session, EmployeeModel employeeModel);

}
