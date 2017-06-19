/**
 * 
 */

package com.dpu.dao.impl;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.dpu.dao.ShipperDao;
import com.dpu.entity.Shipper;
import com.dpu.entity.Trailer;

/**
 * @author jagvir
 *
 */
@Repository
public class ShipperDaoImpl extends GenericDaoImpl<Shipper> implements
		ShipperDao {

	@Autowired
	SessionFactory sessionFactory;

	@SuppressWarnings("unchecked")
	@Override
	public List<Shipper> findByLoactionName(String locationName, Session session) {
		StringBuilder sb = new StringBuilder(
				" select t from Shipper t where t.locationName =:locationname");
		Query query = session.createQuery(sb.toString());
		query.setParameter("locationname", locationName);
		return query.list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Shipper> findAll(Session session) {
		StringBuilder sb = new StringBuilder(
				" select s from Shipper s join fetch s.status ");
		Query query = session.createQuery(sb.toString());
		return query.list();
	}

	@Override
	public Shipper findById(Long id, Session session) {
		StringBuilder sb = new StringBuilder(
				" select s from Shipper s join fetch s.status where s.shipperId =:shipperId ");
		Query query = session.createQuery(sb.toString());
		query.setParameter("shipperId", id);
		return (Shipper) query.uniqueResult();
	}

}
