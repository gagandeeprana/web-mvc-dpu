package com.dpu.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.stereotype.Repository;

import com.dpu.dao.TrailerDao;
import com.dpu.entity.Trailer;

@Repository
public class TrailerDaoImpl extends GenericDaoImpl<Trailer> implements TrailerDao{

	@SuppressWarnings("unchecked")
	@Override
	public List<Trailer> findAll(Session session) {
		StringBuilder sb = new StringBuilder(" select t from Trailer t join fetch t.division join fetch t.terminal join fetch t.category join fetch t.type " )
		.append(" join fetch t.status ");
		Query query = session.createQuery(sb.toString());
		return query.list();
	}

	@Override
	public Trailer findById(Long trailerId, Session session) {
		StringBuilder sb = new StringBuilder(" select t from Trailer t join fetch t.division join fetch t.terminal join fetch t.category join fetch t.type " )
		.append(" join fetch t.status where t.trailerId =:trailerId");
		Query query = session.createQuery(sb.toString());
		query.setParameter("trailerId", trailerId);
		return (Trailer) query.uniqueResult();
	}

}
