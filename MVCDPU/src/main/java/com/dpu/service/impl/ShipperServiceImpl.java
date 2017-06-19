package com.dpu.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.exception.ConstraintViolationException;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.dpu.dao.CompanyDao;
import com.dpu.dao.ShipperDao;
import com.dpu.entity.Shipper;
import com.dpu.entity.Status;
import com.dpu.model.Failed;
import com.dpu.model.ShipperResponse;
import com.dpu.model.Success;
import com.dpu.service.CompanyService;
import com.dpu.service.ShipperService;
import com.dpu.service.StatusService;

@Component
public class ShipperServiceImpl implements ShipperService {

	Logger logger = Logger.getLogger(ShipperServiceImpl.class);
	@Autowired
	ShipperDao shipperDao;

	@Autowired
	CompanyService companyService;

	@Autowired
	CompanyDao companyDao;

	@Autowired
	StatusService statusService;

	@Autowired
	SessionFactory sessionFactory;

	@Override
	public Object add(ShipperResponse shipperResponse) {
		Object obj = null;
		try {
			Shipper shipper = new Shipper();
			BeanUtils.copyProperties(shipperResponse, shipper);
			shipper.setStatus(statusService.get(shipperResponse.getStatusId()));
			shipperDao.save(shipper);
			obj = createSuccessObject("Shipper Added Successfully", Long.parseLong("1030"));
		} catch (Exception e) {
			obj = createFailedObject("Error while adding shipper", Long.parseLong("1031"));
		}
		return obj;
	}

	private Object createSuccessObject(String message, long code) {
		Success success = new Success();
		success.setMessage(message);
		success.setCode(code);
		success.setResultList(getAll());
		return success;
	}

	private Object createFailedObject(String errorMessage, long code) {
		Failed failed = new Failed();
		failed.setMessage(errorMessage);
		failed.setCode(code);
		failed.setResultList(getAll());
		return failed;
	}

	public Object createAlreadyExistObject(String msg, long code) {
		Failed failed = new Failed();
		failed.setCode(code);
		failed.setMessage(msg);
		failed.setResultList(getAll());
		return failed;
	}

	@Override
	public Object update(Long id, ShipperResponse shipperResponse) {

		Object obj = null;
		try {
			Shipper shipper = shipperDao.findById(id);
			if (shipper != null) {
				String[] ignoreProp = new String[1];
				ignoreProp[0] = "shipperId";
				BeanUtils.copyProperties(shipperResponse, shipper, ignoreProp);
				shipper.setStatus(statusService.get(shipperResponse.getStatusId()));
				shipperDao.update(shipper);
				obj = createSuccessObject("Shipper Updated Successfully", Long.parseLong("1026"));
			}
		} catch (Exception e) {
			logger.error("Exception inside ShipperServiceImpl update() :" + e.getMessage());
			obj = createFailedObject("Error while updating shipper", Long.parseLong("1027"));
		}
		return obj;
	}

	@Override
	public Object delete(Long id) {

		logger.info("ShipperServiceImpl delete() starts.");
		Session session = null;
		Transaction tx = null;
		try {
			session = sessionFactory.openSession();
			tx = session.beginTransaction();
			Shipper shipper = (Shipper) session.get(Shipper.class, id);
			if (shipper != null) {
				session.delete(shipper);
				tx.commit();
			} else {
				return createFailedObject("Shipper Unable to Delete", Long.parseLong("2644"));
			}
		} catch (Exception e) {
			logger.info("Exception inside ShipperServiceImpl delete() : " + e.getMessage());
			if (tx != null) {
				tx.rollback();
			}
			if (e instanceof ConstraintViolationException) {
				return createAlreadyExistObject("Shipper already in Use", Long.parseLong("9888"));
			}
			return createFailedObject("Shipper Unable to Delete", Long.parseLong("2644"));
		} finally {

			if (session != null) {
				session.close();
			}
		}

		logger.info("ShipperServiceImpl delete() ends.");
		return createSuccessObject("Shipper Deleted Successfully", Long.parseLong("1023"));
	}

	// @Override
	// public Object delete(Long shipperId) {
	// Object obj = null;
	// try {
	// Shipper shipper = shipperDao.findById(shipperId);
	// shipperDao.deleteShipper(shipper);
	// obj = createSuccessObject("Shipper deleted successfully",
	// Long.parseLong("1028"));
	// } catch (ConstraintViolationException em) {
	// logger.info("Exception inside ShipperServiceImpl delete() : "
	// + em.getMessage());
	// obj = createFailedObject("Shipper already in Use ",
	// Long.parseLong("1056"));
	//
	// } catch (Exception e) {
	// logger.info("Exception inside ShipperServiceImpl delete() : "
	// + e.getMessage());
	// obj = createFailedObject("Unable to Delete Shipper",
	// Long.parseLong("1029"));
	// }
	// return obj;
	// }

	@Override
	public List<ShipperResponse> getAll() {

		Session session = null;
		List<ShipperResponse> responses = new ArrayList<ShipperResponse>();
		try {
			session = sessionFactory.openSession();
			List<Shipper> shipperlist = shipperDao.findAll(session);

			if (shipperlist != null && !shipperlist.isEmpty()) {
				for (Shipper shipper : shipperlist) {
					ShipperResponse shipperResponse = new ShipperResponse();
					BeanUtils.copyProperties(shipper, shipperResponse);
					/*
					 * shipperResponse.setCompany(shipper.getCompany().getName()
					 * ) ;
					 */
					shipperResponse.setStatus(shipper.getStatus().getStatus());
					responses.add(shipperResponse);
				}
			}
		} finally {
			if (session != null) {
				session.close();
			}
		}

		return responses;
	}

	@Override
	public ShipperResponse get(Long id) {

		Session session = null;
		ShipperResponse response = new ShipperResponse();

		try {
			session = sessionFactory.openSession();
			Shipper shipper = shipperDao.findById(id, session);
			if (shipper != null) {
				BeanUtils.copyProperties(shipper, response);
				/*
				 * response.setCompanyId(shipper.getCompany().getCompanyId());
				 */
				response.setStatusId(shipper.getStatus().getId());
				/* response.setCompanyList(companyService.getCompanyData()); */
				List<Status> statusList = statusService.getAll();
				response.setStatusList(statusList);
			}
		} finally {
			if (session != null) {
				session.close();
			}
		}

		return response;
	}

	@Override
	public ShipperResponse getParticularData(Long id) {

		Session session = null;
		ShipperResponse response = new ShipperResponse();

		try {
			session = sessionFactory.openSession();
			Shipper shipper = (Shipper) session.get(Shipper.class, id);
			if (shipper != null) {
				BeanUtils.copyProperties(shipper, response);
			}
		} finally {
			if (session != null) {
				session.close();
			}
		}

		return response;
	}

	@Override
	public ShipperResponse getMasterData() {

		ShipperResponse response = new ShipperResponse();
		/* response.setCompanyList(companyService.getCompanyData()); */
		List<Status> statusList = statusService.getAll();
		response.setStatusList(statusList);
		return response;
	}

	@Override
	public List<ShipperResponse> getShipperByCompanyName(String companyName) {

		Session session = null;
		List<Shipper> shipperList = null;
		List<ShipperResponse> responses = new ArrayList<ShipperResponse>();
		try {
			session = sessionFactory.openSession();
			if (companyName != null && companyName.length() > 0) {
				shipperList = shipperDao.findByLoactionName(companyName, session);
			}

			if (shipperList != null && !shipperList.isEmpty()) {
				for (Shipper shipper : shipperList) {
					ShipperResponse shipperResponse = new ShipperResponse();
					BeanUtils.copyProperties(shipper, shipperResponse);
					/*
					 * shipperResponse.setCompany(shipper.getCompany().getName()
					 * ) ;
					 */
					shipperResponse.setStatus(shipper.getStatus().getStatus());
					responses.add(shipperResponse);
				}
			}
		} catch (Exception e) {

		} finally {
			if (session != null) {
				session.close();
			}
		}
		return responses;
	}

	@Override
	public List<ShipperResponse> getSpecificData(Session session) {

		List<ShipperResponse> categories = new ArrayList<ShipperResponse>();

		try {
			List<Object[]> shipperData = shipperDao.getSpecificData(session, "Shipper", "shipperId", "locationName");

			if (shipperData != null && !shipperData.isEmpty()) {
				for (Object[] row : shipperData) {
					ShipperResponse shipper = new ShipperResponse();
					shipper.setShipperId((Long) row[0]);
					shipper.setLocationName(String.valueOf(row[1]));
					categories.add(shipper);
				}
			}
		} catch (Exception e) {

		}

		return categories;
	}

}
