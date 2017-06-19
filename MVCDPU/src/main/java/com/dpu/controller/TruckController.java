package com.dpu.controller;

import java.util.List;
import org.apache.log4j.Logger;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import com.dpu.model.Success;
import com.dpu.model.TruckResponse;
import com.dpu.service.TruckService;
import com.dpu.util.MessageProperties;

@RestController
@RequestMapping(value = "truck")
public class TruckController extends MessageProperties {

	Logger logger = Logger.getLogger(TruckController.class);

	@Autowired
	TruckService truckService;

	ObjectMapper mapper = new ObjectMapper();

	// get List Of All Truck
	@RequestMapping(produces = MediaType.APPLICATION_JSON_VALUE, method = RequestMethod.GET)
	public Object getAllTrucks() {
		logger.info("[getAllTrucks]:Controller:  Enter");
		String json = null;
		try {
			List<TruckResponse> listOfTrucks = truckService.getAllTrucks("");
			if (listOfTrucks != null && listOfTrucks.size() > 0) {
				json = mapper.writeValueAsString(listOfTrucks);
			}
		} catch (Exception e) {
			logger.error(e);
			logger.error("[getAllTrucks]:Controller " + e);
		}
		logger.info("[getAllTrucks]:Controller: Exit");
		return json;
	}

	// Add new Truck
	@RequestMapping(produces = MediaType.APPLICATION_JSON_VALUE, method = RequestMethod.POST)
	public Object addTruck(@RequestBody TruckResponse truckResponse) {
		logger.info("[TruckController] [addTruck] : addTruck");
		ResponseEntity<Object> obj = null;
		try {

			Object result = truckService.add(truckResponse);
			if (result instanceof Success) {
				obj = new ResponseEntity<Object>(result, HttpStatus.OK);
			} else {
				obj = new ResponseEntity<Object>(result, HttpStatus.BAD_REQUEST);

			}
		} catch (Exception e) {
			logger.fatal("[TruckController]: add(): Exception: ", e);

		}

		logger.info("[TruckController]: add(): ENDS");

		return obj;
	}

	// get Truck by Id
	@RequestMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE, method = RequestMethod.GET)
	public Object getTruckById(@PathVariable("id") Long id) {
		logger.info("[TruckController] [getTruckById] : getTruckById");

		String json = null;
		try {
			TruckResponse truckResponse = truckService.get(id);
			ObjectMapper mapper = new ObjectMapper();
			json = mapper.writeValueAsString(truckResponse);
		} catch (Exception e) {
			logger.error("[getTruckById]:" + e);
		}
		return json;
	}

	// private Truck setTruckValues(TruckResponse truckResponse) {
	// Truck truck = new Truck();
	// truck.setUnitNo(truckResponse.getUnitNo());
	// truck.setOwner(truckResponse.getOwner());
	// truck.setoOName(truckResponse.getoOName());
	// truck.setCategory(truckResponse.getCategory());
	// truck.setStatus(truckResponse.getStatus());
	// truck.setUsage(truckResponse.getUsage());
	// truck.setDivision(truckResponse.getDivision());
	// truck.setTerminal(truckResponse.getTerminal());
	// truck.setTruckType(truckResponse.getTruckType());
	// truck.setFinance(truckResponse.getFinance());
	// return truck;
	// }
	//
	// delete Truck
	@RequestMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE, method = RequestMethod.DELETE)
	public Object deleteTruck(@PathVariable("id") Long id) {
		logger.info("[deleteTruck] : controller : Enter : driverCode " + id);
		Object obj = null;
		try {
			Object result = truckService.delete(id);
			if (result instanceof Success) {
				obj = new ResponseEntity<Object>(result, HttpStatus.OK);
			} else {
				obj = new ResponseEntity<Object>(result, HttpStatus.BAD_REQUEST);
			}

		} catch (Exception e) {
			logger.error("Exception inside TruckController deleteTruck() :", e);

		}
		logger.info("[deleteTruck] : controller : Exit ");
		return obj;
	}

	//
	// Update Truck
	@RequestMapping(value = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE, method = RequestMethod.PUT)
	public Object updateTruck(@PathVariable("id") Long id,
			@RequestBody TruckResponse truckResponse) {

		logger.info("[TruckController] [updateTruck] : Enter");
		Object obj = null;
		try {
			truckResponse.setTruckId(id);
			Object result = truckService.update(id, truckResponse);
			if (result instanceof Success) {
				obj = new ResponseEntity<Object>(result, HttpStatus.OK);
			} else {
				obj = new ResponseEntity<Object>(result, HttpStatus.BAD_REQUEST);
			}

		} catch (Exception e) {
			logger.error("EquipmentController : update " + e);

		}
		logger.info("[TruckController] [update] :Exit   ");
		return obj;
	}

	@RequestMapping(value = "/openAdd", produces = MediaType.APPLICATION_JSON_VALUE, method = RequestMethod.GET)
	public Object openAdd() {
		logger.info("[TruckController] [openAdd] : Enter");
		String json = null;
		try {
			TruckResponse truckResponse = truckService.getOpenAdd();
			ObjectMapper mapper = new ObjectMapper();
			json = mapper.writeValueAsString(truckResponse);
		} catch (Exception e) {
			System.out.println(e);
		}
		logger.info("[TruckController] [openAdd] : End");
		return json;
	}

	/**
	 * this method is used to return Specific data (truckId, owner)
	 * @return List<TruckResponse>
	 * @author lakhvir.bansal
	 */
	@RequestMapping(value = "/specificData", produces = MediaType.APPLICATION_JSON_VALUE, method = RequestMethod.GET)
	public Object getSpecificData() {

		logger.info("Inside TruckController getSpecificData() Starts");
		String json = new String();

		try {
			List<TruckResponse> truckData = truckService.getSpecificData();
			if (truckData != null && truckData.size() > 0) {
				json = mapper.writeValueAsString(truckData);
			}
		} catch (Exception e) {
			logger.error("Exception inside TruckController getSpecificData() is :"+ e.getMessage());
		}

		logger.info("Inside TruckController getSpecificData() ends");
		return json;
	}
}
