/**
 * 
 */
package com.dpu.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.stereotype.Repository;

import com.dpu.dao.CountryStateCityDao;
import com.dpu.dao.HandlingDao;
import com.dpu.entity.Handling;

@Repository
public class CountryStateCityDaoImpl implements CountryStateCityDao{

	@Override
	public List<Object[]> findAllCountries(Session session) {

		String countryQuery = "SELECT country_id, country_name, country_code FROM country ";
		Query query = session.createSQLQuery(countryQuery);
		return query.list();
	}

	/*@SuppressWarnings("unchecked")
	@Override
	public List<Handling> findAll(Session session) {
		
		StringBuilder sb = new StringBuilder(" select h from Handling h join fetch h.status ");
		Query query = session.createQuery(sb.toString());
		return query.list();
	}

	@Override
	public Handling findById(Long id, Session session) {
		StringBuilder sb = new StringBuilder(" select h from Handling h join fetch h.status where h.id =:handlingId ");
		Query query = session.createQuery(sb.toString());
		query.setParameter("handlingId", id);
		return (Handling) query.uniqueResult();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Handling> getHandlingByHandlingName(Session session, String handlingName) {
		StringBuilder sb = new StringBuilder(" select h from Handling h join fetch h.status where h.name like :handlingName ");
		Query query = session.createQuery(sb.toString());
		query.setParameter("handlingName", "%"+handlingName+"%");
		return query.list();
	}*/

}
