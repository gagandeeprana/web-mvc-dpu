package com.dpu.service;

import java.util.List;

import com.dpu.entity.Trailer;
import com.dpu.model.TrailerRequest;

public interface TrailerService {

	Object add(TrailerRequest trailerRequest);
	
	Object delete(Long trailerId);
	
	Object update(Long trailerId, TrailerRequest trailerRequest);
	
	List<TrailerRequest> getAll();
	
	TrailerRequest get(Long id);

	TrailerRequest getOpenAdd();
	
	List<TrailerRequest> getSpecificData();
}
