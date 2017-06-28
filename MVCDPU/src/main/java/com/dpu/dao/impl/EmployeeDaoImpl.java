/**
 * 
 */
package com.dpu.dao.impl;

import org.hibernate.Session;
import org.springframework.stereotype.Repository;

import com.dpu.dao.EmployeeDao;
import com.dpu.entity.Employee;
import com.dpu.model.EmployeeModel;

/**
 * @author gagan
 *
 */
@Repository
public class EmployeeDaoImpl extends GenericDaoImpl<Employee> implements EmployeeDao {

	@Override
	public Employee add(Session session, EmployeeModel employeeModel) {

		logger.info("EmployeeDaoImpl: add(): STARTS");
		Employee employee = null;
		try {
			
			employee = setEmployeeValues(employeeModel);
			
			Long employeeId = (Long) session.save(employee);
			employee.setEmployeeId(employeeId);
		} catch (Exception e) {
			logger.fatal("EmployeeDaoImpl: add(): Exception: " + e.getMessage());
		}
		
		logger.info("EmployeeDaoImpl: add(): ENDS");

		return employee;
	}
	
	private Employee setEmployeeValues(EmployeeModel employeeModel) {
		
		logger.info("EmployeeDaoImpl: setEmployeeValues(): STARTS");

		Employee employee = new Employee();
		employee.setFirstName(employeeModel.getFirstName());
		employee.setLastName(employeeModel.getLastName());
		employee.setJobTitle(employeeModel.getJobTitle());
		employee.setUsername(employeeModel.getUsername());
		employee.setPassword(employeeModel.getPassword());
		employee.setEmail(employeeModel.getEmail());
		employee.setPhone(employeeModel.getPhone());
		employee.setHiringDate(employeeModel.getHiringDate());
		employee.setTerminationDate(employeeModel.getTerminationDate());
		employee.setCreatedBy(employeeModel.getCreatedBy());
		employee.setModifiedBy(employeeModel.getModifiedBy());
		
		logger.info("EmployeeDaoImpl: setEmployeeValues(): ENDS");

		return employee;
	}
	
}
