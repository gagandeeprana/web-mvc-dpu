package com.dpu.dao;

import java.util.List;

import org.hibernate.Session;

import com.dpu.entity.Trailer;


public interface TrailerDao extends GenericDao<Trailer> {

	List<Trailer> findAll(Session session);

	Trailer findById(Long trailerId, Session session);

	
}
