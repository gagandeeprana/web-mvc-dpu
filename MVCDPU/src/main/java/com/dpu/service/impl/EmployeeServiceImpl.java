/**
 * 
 */
package com.dpu.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.dpu.common.CommonProperties;
import com.dpu.dao.EmployeeDao;
import com.dpu.dao.EquipmentDao;
import com.dpu.entity.Employee;
import com.dpu.model.EmployeeModel;
import com.dpu.model.Failed;
import com.dpu.model.Success;
import com.dpu.service.EmployeeService;
import com.dpu.service.TypeService;

/**
 * @author gagan
 *
 */
@Component
public class EmployeeServiceImpl implements EmployeeService {

	Logger logger = Logger.getLogger(EmployeeServiceImpl.class);

	@Autowired
	EmployeeDao employeeDao;
	
	@Autowired
	EquipmentDao equipmentDao;

	@Autowired
	SessionFactory sessionFactory;

	@Autowired
	TypeService typeService;

	private Object createSuccessObject(String msg, long code) {
		Success success = new Success();
		success.setCode(code);
		success.setMessage(msg);
		success.setResultList(getAll());
		return success;
	}

	private Object createFailedObject(String msg, long code) {
		Failed failed = new Failed();
		failed.setCode(code);
		failed.setMessage(msg);
		failed.setResultList(getAll());
		return failed;
	}

	//TODO
	/**
	 * error code needs to be changed...
	 */
	@Override
	public Object add(EmployeeModel employeeModel) {

		logger.info("EmployeeServiceImpl: add():  STARTS");
		Session session = null;
		Transaction tx = null;

		try {

			session = sessionFactory.openSession();
			tx = session.beginTransaction();
			employeeDao.add(session, employeeModel);
			if (tx != null) {
				tx.commit();
			}

		} catch (Exception e) {
			logger.fatal("EmployeeServiceImpl: add(): Exception: "
					+ e.getMessage());
			if (tx != null) {
				tx.rollback();
			}
			return createFailedObject(
					CommonProperties.employee_unable_to_add_message,
					Long.parseLong(CommonProperties.Equipment_unable_to_add_code));
		} finally {
			logger.info("EmployeeServiceImpl: add():  finally block");
			if (session != null) {
				session.close();
			}
		}

		logger.info("EmployeeServiceImpl: add():  ENDS");

		return createSuccessObject(CommonProperties.employee_added_message,
				Long.parseLong(CommonProperties.Equipment_added_code));
	}

	/*@Override
	public Object update(Long id, EquipmentReq equipmentReq) {
		logger.info("EquipmentServiceImpl: update():  Enter");
		Equipment equipmentObj = null;
		try {
			equipmentObj = equipmentDao.findById(id);
			// if (equipmentObj != null) {
			equipmentObj.setEquipmentName(equipmentReq.getEquipmentName());
			equipmentObj.setDescription(equipmentReq.getDescription());
			equipmentObj.setModifiedBy("gagan");
			equipmentObj.setModifiedOn(new Date());
			Type type = typeService.get(equipmentReq.getTypeId());
			equipmentObj.setType(type);
			equipmentDao.update(equipmentObj);
			// }

		} catch (Exception e) {

			logger.info("Exception inside DivisionServiceImpl update() :"
					+ e.getMessage());
			return createFailedObject(
					CommonProperties.Equipment_unable_to_update_message,
					Long.parseLong(CommonProperties.Equipment_unable_to_update_code));
		}
		logger.info("EquipmentServiceImpl: update():  Exit");
		return createSuccessObject(CommonProperties.Equipment_updated_message,
				Long.parseLong(CommonProperties.Equipment_updated_code));
	}

	@Override
	public Object delete(Long id) {
		logger.info("EquipmentServiceImpl: delete():  Enter");
		Equipment equipment = null;
		try {
			equipment = equipmentDao.findById(id);
			equipmentDao.delete(equipment);

		} catch (Exception e) {
			logger.error("EquipmentServiceImpl: delete(): Exception  : ", e);
			return createFailedObject(
					CommonProperties.Equipment_unable_to_delete_message,
					Long.parseLong(CommonProperties.Equipment_unable_to_delete_code));

		}
		logger.info("EquipmentServiceImpl: delete():  Exit");
		return createSuccessObject(CommonProperties.Equipment_deleted_message,
				Long.parseLong(CommonProperties.Equipment_deleted_code));
	}*/

	@Override
	public List<EmployeeModel> getAll() {
		List<Employee> employees = null;
		List<EmployeeModel> employeeResponse = new ArrayList<EmployeeModel>();
		employees = employeeDao.findAll();
		if (employees != null && employees.size() > 0) {
			for (Employee employee : employees) {
				EmployeeModel employeeModel = new EmployeeModel();
				employeeModel.setEmployeeId(employee.getEmployeeId());
				employeeModel.setFirstName(employee.getFirstName());
				employeeModel.setLastName(employee.getLastName());
				employeeModel.setUsername(employee.getUsername());
				employeeModel.setJobTitle(employee.getJobTitle());
				employeeModel.setEmail(employee.getEmail());
				employeeModel.setPhone(employee.getPhone());
				employeeModel.setHiringDate(employee.getHiringDate());
				employeeModel.setTerminationDate(employee.getTerminationDate());
				employeeResponse.add(employeeModel);
			}
		}
		return employeeResponse;
	}
	
	@Override
	public Object getUserById(Long userId) {

		logger.info("Inside EmployeeServiceImpl getUserById() starts, userId :"
				+ userId);
		Session session = null;
		Object obj = null;
		String message = "User data get Successfully";

		try {
			session = sessionFactory.openSession();
			Employee employee = employeeDao.findById(userId);
			EmployeeModel employeeModel = null;
			
			if (employee != null) {
				employeeModel = new EmployeeModel();
				BeanUtils.copyProperties(employee, employeeModel);
				
			} else {
				message = "Error while getting record";
				obj = createFailedObject(message);
			}
		} catch (Exception e) {
			message = "Error while getting record";
			obj = createFailedObject(message);
		} finally {
			if (session != null) {
				session.close();
			}
		}
		return obj;
	}
	
	private Object createFailedObject(String errorMessage) {
		Failed failed = new Failed();
		failed.setMessage(errorMessage);
		return failed;
	}

	/*@Override
	public EquipmentReq get(Long id) {
		Equipment equipment = equipmentDao.findById(id);
		EquipmentReq response = null;
		if (equipment != null) {
			response = new EquipmentReq();
			response.setEquipmentId(equipment.getEquipmentId());
			response.setTypeId(equipment.getType().getTypeId());
			response.setEquipmentName(equipment.getEquipmentName());
			response.setDescription(equipment.getDescription());

			List<TypeResponse> typeList = typeService.getAll(1l);

			if (typeList != null && !typeList.isEmpty()) {
				response.setTypeList(typeList);
			}

		}

		return response;
	}
*/
}
