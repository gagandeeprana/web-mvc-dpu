package com.dpu.dao;

import java.util.List;

import org.hibernate.Session;

import com.dpu.entity.Handling;
import com.dpu.entity.Issue;

public interface IssueDao extends GenericDao<Issue> {

	List<Issue> findAll(Session session);

	Handling findById(Long id, Session session);

	/*List<Handling> getHandlingByHandlingName(Session session, String handlingName);*/

	List<Object> getUnitNos(Long categoryId, Session session);

	List<Issue> getIssueByIssueName(Session session, String issueName);
}
