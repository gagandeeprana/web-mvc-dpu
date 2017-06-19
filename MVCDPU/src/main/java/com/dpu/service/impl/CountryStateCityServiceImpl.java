package com.dpu.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.exception.ConstraintViolationException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.dpu.dao.CountryStateCityDao;
import com.dpu.dao.HandlingDao;
import com.dpu.entity.Handling;
import com.dpu.entity.Status;
import com.dpu.model.CountryStateCityModel;
import com.dpu.model.Failed;
import com.dpu.model.HandlingModel;
import com.dpu.model.Success;
import com.dpu.service.CountryStateCityService;
import com.dpu.service.HandlingService;
import com.dpu.service.StatusService;

@Component
public class CountryStateCityServiceImpl implements CountryStateCityService {

	Logger logger = Logger.getLogger(CountryStateCityServiceImpl.class);

	@Autowired
	CountryStateCityDao countryStateCityDao;

	@Autowired
	StatusService statusService;

	@Autowired
	SessionFactory sessionFactory;

	@Value("${handling_added_message}")
	private String handling_added_message;

	@Value("${handling_unable_to_add_message}")
	private String handling_unable_to_add_message;

	@Value("${handling_deleted_message}")
	private String handling_deleted_message;

	@Value("${handling_unable_to_delete_message}")
	private String handling_unable_to_delete_message;

	@Value("${handling_updated_message}")
	private String handling_updated_message;

	@Value("${handling_unable_to_update_message}")
	private String handling_unable_to_update_message;

	@Value("${handling_already_used_message}")
	private String handling_already_used_message;

	@Override
	public List<CountryStateCityModel> getAll() {

		logger.info("HandlingServiceImpl getAll() starts ");
		Session session = null;
		List<CountryStateCityModel> countryStateCityList = new ArrayList<CountryStateCityModel>();

		try {
			session = sessionFactory.openSession();
			List<Object[]> countryData = countryStateCityDao.findAllCountries(session);

			if (countryData != null && !countryData.isEmpty()) {
				for (Object[] row : countryData) {
					CountryStateCityModel countryStateCityModel = new CountryStateCityModel();
					countryStateCityModel.setCountryId((Long) row[0]);
					countryStateCityModel.setCountryName(String.valueOf(row[1]));
					countryStateCityModel.setCountryCode(String.valueOf(row[2]));
					countryStateCityList.add(countryStateCityModel);
				}
			}
		} finally {
			if (session != null) {
				session.close();
			}
		}

		logger.info("HandlingServiceImpl getAll() ends ");
		return countryStateCityList;
	}

	private Object createSuccessObject(String msg) {

		Success success = new Success();
		success.setMessage(msg);
		success.setResultList(getAll());
		return success;
	}

	private Object createFailedObject(String msg) {

		Failed failed = new Failed();
		failed.setMessage(msg);
		// failed.setResultList(getAll());
		return failed;
	}

	private Handling setHandlingValues(HandlingModel handlingModel) {

		Handling handling = new Handling();
		handling.setName(handlingModel.getName());
		Status status = statusService.get(handlingModel.getStatusId());
		handling.setStatus(status);
		return handling;
	}


}
