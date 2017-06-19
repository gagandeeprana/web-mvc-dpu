package com.dpu.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.dpu.dao.DriverDao;
import com.dpu.entity.Driver;

@Repository
@Transactional
public class DriverDaoImpl extends GenericDaoImpl<Driver> implements DriverDao {

	@Autowired
	SessionFactory sessionFactory;
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Driver> searchDriverByDriverCodeOrName(String driverCodeOrName) {

		Session session = null;
		List<Driver> driverList = null;
		try{
			session = sessionFactory.openSession();
			StringBuilder sb = new StringBuilder("");
			sb.append(" select d from Driver d join fetch d.division join fetch d.terminal join fetch d.category join fetch d.role ")
			.append(" join fetch d.status join fetch d.driverClass driverclass where d.driverCode like :driverCodeOrName or d.firstName like :driverCodeOrName or d.lastName like :driverCodeOrName ");
			
			Query query = session.createQuery(sb.toString());
			query.setParameter("driverCodeOrName", "%"+driverCodeOrName+"%");
			driverList = query.list();
			
		} catch(Exception e){
			
		} finally{
			if(session != null){
				session.close();
			}
		}
		return driverList;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Driver> findAll(Session session) {
		
		StringBuilder sb = new StringBuilder(" select d from Driver d join fetch d.division join fetch d.terminal join fetch d.category join fetch d.role " )
		.append(" join fetch d.status join fetch d.driverClass driverclass ");
		Query query = session.createQuery(sb.toString());
		return query.list();
	}

	@Override
	public Driver findById(Long driverId, Session session) {
		StringBuilder sb = new StringBuilder(" select d from Driver d join fetch d.division join fetch d.terminal join fetch d.category join fetch d.role " )
		.append(" join fetch d.status join fetch d.driverClass driverclass where d.driverId =:driverId ");
		Query query = session.createQuery(sb.toString());
		query.setParameter("driverId", driverId);
		return (Driver) query.uniqueResult();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Object[]> getDriverIdAndName() {
		
		List<Object[]> data = null;
		Session session = sessionFactory.openSession();
		try {
			Query query = session.createQuery(" select d.driverId, d.firstName, d.lastName from Driver d ");
			data = query.list();

		} catch (Exception e) {
			
		} finally {
			if (session != null) {
				session.close();
			}
		}

		return data;
	}

}
