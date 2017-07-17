/**
 * 
 */
package com.dpu.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.stereotype.Repository;

import com.dpu.dao.HandlingDao;
import com.dpu.dao.IssueDao;
import com.dpu.entity.Handling;
import com.dpu.entity.Issue;

@Repository
public class IssueDaoImpl extends GenericDaoImpl<Issue> implements IssueDao{

	@SuppressWarnings("unchecked")
	@Override
	public List<Issue> findAll(Session session) {
		
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

	/*@SuppressWarnings("unchecked")
	@Override
	public List<Handling> getHandlingByHandlingName(Session session, String handlingName) {
		StringBuilder sb = new StringBuilder(" select h from Handling h join fetch h.status where h.name like :handlingName ");
		Query query = session.createQuery(sb.toString());
		query.setParameter("handlingName", "%"+handlingName+"%");
		return query.list();
	}*/

	@SuppressWarnings("unchecked")
	@Override
	public List<Object> getUnitNos(Long categoryId, Session session) {
		StringBuilder sb = new StringBuilder(" SELECT unit_no FROM `newtruckmaster` truck WHERE category_id = :categoryId ")
		.append(" UNION ")
		.append(" SELECT unit_no FROM `trailer` WHERE category_id = :categoryId ");
		
		Query query = session.createSQLQuery(sb.toString());
		query.setParameter("categoryId", categoryId);
		return query.list();
		
	}

	@Override
	public List<Issue> getIssueByIssueName(Session session, String issueName) {
		// TODO Auto-generated method stub
		return null;
	}

}
