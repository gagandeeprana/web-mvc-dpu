<%@page import="org.springframework.beans.factory.annotation.Autowired"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Location</title>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@page isELIgnored="false"%>
<link rel="stylesheet"
	href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script
	src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<style type="text/css">
.modal-dialog {
  width: 98%;
  height: 100%;
  padding: 0;
}

.modal-content {
  height: auto;
  min-height: 100%;
  border-radius: 5;
}
textarea{ 
  width: 100%; 
  min-width:100%; 
  max-width:100%; 

  height:90x; 
  min-height:90px;  
  max-height:90px;
}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		$('#btnSave').click(function(){
			$('#frm1').submit();
		});
		$('#btnSearch').click(function(){
			$("#frmSearch").change(function() {
			  $("#frmSearch").attr("action", "showques");
			});
			$('#frmSearch').submit();
		});
	});
</script>
<script type="text/javascript">
	function checkFlag(field) {
		document.getElementById("addUpdateFlag").value = field;
		if(field == 'update') {
			document.getElementById("frm1").action = "updateshipper";
			document.getElementById("btnSave").value = "Update";
			$("#modelTitle").html("Edit Location");
		}
		else if(field == 'add') {
			//$("#cke_1_contents").html('');
			$(":text").val("");
	   		//document.getElementById('categoryId').selectedIndex = 0;
			document.getElementById("btnSave").value = "Save";
			$("#modelTitle").html("Add Location");
		} else if (field == 'search') {
			/* document.getElementById("frm1").method = "GET";
			document.getElementById("frm1").action = "showques";
			document.getElementById("frm1").submit(); */
		}
	}
</script>
<script type="text/javascript">
    function onClickMethodQuestion(quesId){
    	emptyMessageDiv();
    	clearAll();
    	if(quesId == 0) {
	     	$.get("shipper/getopenadd", function(data) {
	          var status = document.getElementById("statusId");
	          for(var i = 0;i < data.statusList.length;i++) {
	          	status.options[status.options.length] = new Option(data.statusList[i].status);
	          	status.options[i].value = data.statusList[i].id;
	          } 
	      });
    	} else {
    		$.get("getshipper/shipperId",{"shipperId" : quesId}, function(data) {
    			document.getElementById("shipperid").value = data.shipperId;
            	$("#location").val(data.locationName);
            	$("#contact").val(data.contact);
            	$("#address").val(data.address);
            	$("#position").val(data.position);
            	$("#unitNo").val(data.unit);
            	$("#phone").val(data.phone);
            	$("#ext").val(data.ext);
            	$("#city").val(data.city);
            	$("#fax").val(data.fax);
            	$("#prefix").val(data.prefix);
            	$("#province").val(data.provinceState);
            	$("#tollfree").val(data.tollFree);
            	$("#plant").val(data.plant);
            	$("#cellnumber").val(data.cellNumber);
            	$("#zone").val(data.zone);
            	$("#email").val(data.email);
            	$("#leadTime").val(data.leadTime);
            	$("#timeZone").val(data.timeZone);
            	$("#importer").val(data.importer);
            	$("#internalNotes").val(data.internalNotes);
            	$("#standardNotes").val(data.standardNotes);
                
                var status = document.getElementById("statusId");
                var statusList = data.statusList;
                for(var i = 0;i < statusList.length;i++) {
                	status.options[status.options.length] = new Option(statusList[i].status);
                	status.options[i].value = statusList[i].id;
                	if(statusList[i].id == data.statusId) {
                		document.getElementById("statusId").selectedIndex = i;
                	}
                }
           	});
    	}
    }
    function clearAll() {
    	$("#location").val("");
    	$("#contact").val("");
    	$("#address").val("");
    	$("#position").val("");
    	$("#unitNo").val("");
    	$("#phone").val("");
    	$("#ext").val("");
    	$("#city").val("");
    	$("#fax").val("");
    	$("#prefix").val("");
    	$("#province").val("");
    	$("#tollfree").val("");
    	$("#plant").val("");
    	$("#cellnumber").val("");
    	$("#zone").val("");
    	$("#email").val("");
    	$("#leadTime").val("");
    	$("#timeZone").val("");
    	$("#importer").val("");
    	$("#internalNotes").val("");
    	$("#standardNotes").val("");
       	document.getElementById("statusId").innerHTML = "";
    }
</script>

<script type="text/javascript">
function check() {
	var shipperLocation = $("#location").val();
	var contact = $("#contact").val();
	var address = $("#address").val();
	var position = $("#position").val();
	var unitNo = $("#unitNo").val();
	var phone = $("#phone").val();
	var ext = $("#ext").val();
	var city = $("#city").val();
	var fax = $("#fax").val();
	var prefix = $("#prefix").val();
	var province = $("#province").val();
	var tollFree = $("#tollfree").val();
	var plant = $("#plant").val();
	var cellNumber = $("#cellnumber").val();
	var zone = $("#zone").val();
	var email = $("#email").val();
	var leadTime = $("#leadTime").val();
	var timeZone = $("#timeZone").val();
	var importer = $("#importer").val();
 	var internalNotes = $("#internalNotes").val();
 	var standardNotes = $("#standardNotes").val();
	var msg = $("#msg");
	var msgvalue = $("#msgvalue");
	msg.hide();
	msgvalue.val("");
	if(shipperLocation == "") {
		msg.show();
		msgvalue.text("Location cannot be left blank.");
		$("#location").focus();
		return false;
	}
	if(contact == "") {
		msg.show();
		msgvalue.text("Contact cannot be left blank.");
		$("#contact").focus();
		return false;
	}
	if(address == "") {
		msg.show();
		msgvalue.text("Address cannot be left blank.");
		$("#address").focus();
		return false;
	}
	if(position == "") {
		msg.show();
		msgvalue.text("Position cannot be left blank.");
		$("#position").focus();
		return false;
	}
	if(unitNo == "") {
		msg.show();
		msgvalue.text("UnitNo cannot be left blank.");
		$("#unitNo").focus();
		return false;
	}
	if(phone == "") {
		msg.show();
		msgvalue.text("Phone cannot be left blank.");
		$("#phone").focus();
		return false;
	}
	if(ext == "") {
		msg.show();
		msgvalue.text("Ext cannot be left blank.");
		$("#ext").focus();
		return false;
	}
	if(city == "") {
		msg.show();
		msgvalue.text("City cannot be left blank.");
		$("#city").focus();
		return false;
	}
	if(fax == "") {
		msg.show();
		msgvalue.text("Fax cannot be left blank.");
		$("#fax").focus();
		return false;
	}
	if(prefix == "") {
		msg.show();
		msgvalue.text("Prefix cannot be left blank.");
		$("#prefix").focus();
		return false;
	}
	if(province == "") {
		msg.show();
		msgvalue.text("Province cannot be left blank.");
		$("#province").focus();
		return false;
	}
	if(tollFree == "") {
		msg.show();
		msgvalue.text("TollFree cannot be left blank.");
		$("#tollfree").focus();
		return false;
	}
	if(plant == "") {
		msg.show();
		msgvalue.text("Plant cannot be left blank.");
		$("#plant").focus();
		return false;
	}
	if(cellNumber == "") {
		msg.show();
		msgvalue.text("CellNumber cannot be left blank.");
		$("#cellnumber").focus();
		return false;
	}
	if(tollFree == "") {
		msg.show();
		msgvalue.text("TollFree cannot be left blank.");
		$("#tollfree").focus();
		return false;
	}
	if(zone == "") {
		msg.show();
		msgvalue.text("Zone cannot be left blank.");
		$("#zone").focus();
		return false;
	}
	if(email == "") {
		msg.show();
		msgvalue.text("Email cannot be left blank.");
		$("#email").focus();
		return false;
	}
	if(leadTime == "") {
		msg.show();
		msgvalue.text("LeadTime cannot be left blank.");
		$("#leadTime").focus();
		return false;
	}
	if(timeZone == "") {
		msg.show();
		msgvalue.text("TimeZone cannot be left blank.");
		$("#timeZone").focus();
		return false;
	}
	if(importer == "") {
		msg.show();
		msgvalue.text("Importer cannot be left blank.");
		$("#importer").focus();
		return false;
	}
	if(internalNotes == "") {
		msg.show();
		msgvalue.text("InternalNotes cannot be left blank.");
		$("#internalNotes").focus();
		return false;
	}
	if(standardNotes == "") {
		msg.show();
		msgvalue.text("StandardNotes cannot be left blank.");
		$("#standardNotes").focus();
		return false;
	}
	$('#modal').modal('toggle');
	return true;
}

function emptyMessageDiv(){
	var msg = $("#msg");
	var msgvalue = $("#msgvalue");
	msg.hide();
	msgvalue.val("");	
}
</script>

</head>
<body>
	<jsp:include page="header.jsp"></jsp:include>
	<div class="container">
		<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal" onclick="checkFlag('add'); onClickMethodQuestion('0'); emptyMessageDiv(); emptyMessageDiv();" >Add New</button>
		<div class="form-group">
		<div class="row">
			<div class="col-sm-8">
					<div class="modal fade" id="myModal" role="dialog">
					    <div class="modal-dialog">
						<form action="saveshipper" method="POST" name="shipper" id="frm1" onsubmit="return check()">
						<input type="hidden" id = "shipperid" name= "shipperid" value = "" />					
						<input type="hidden" id = "addUpdateFlag" value = "" />					
	
					      <!-- Modal content-->
					      <div class="modal-content">
					        <div class="modal-header">
					          <button type="button" class="close" data-dismiss="modal">&times;</button>
					          <h4 class="modal-title"><p id ="modelTitle">Add Location</p></h4>
					           <div class="alert alert-danger fade in" id="msg" style="display: none;">
									<a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
									<strong id = "msgvalue"></strong>
							  </div>
					        </div>
					        <div class="modal-body">
								<div class = "row">
								<div class="col-sm-12">
									<div class="form-group">
										<div class="row">
											<div class="col-sm-6">
												<div class="input-group">
												<span class="input-group-addon">
													 <b>LocationName</b>												
												</span>
												<input type="text" class="form-control" placeHolder="Enter Location" id="location" name="locationName" value="" autofocus />
											</div>
											</div>
											<div class="col-sm-6">
												<div class="input-group">
													<span class="input-group-addon">
														 <b>Contact</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Contact" id="contact" name="contact" value="" />
												</div>
											</div>
										</div>
									</div>
									<div class="form-group">
										<div class="row">
											<div class="col-sm-6">
												<div class="input-group">
													<span class="input-group-addon">
														 <b>Address</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Address" id="address" name="address" value="" />
												</div>
											</div>
											<div class="col-sm-6">
												<div class="input-group">
													<span class="input-group-addon">
														 <b>Position</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Position" id="position" name="position" value="" />
												</div>
											</div>
										</div>
									</div>
									
									<div class="form-group">
										<div class="row">
											<div class="col-sm-6">
												<div class="input-group">
													<span class="input-group-addon">
														 <b>UnitNo</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter UnitNo" id="unitNo" name="unit" value="" />
												</div>
											</div>
											<div class="col-sm-6">
												<div class="row">
													<div class="col-sm-6">
														<div class="input-group">
													<span class="input-group-addon">
														 <b>Phone</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Phone" id="phone" name="phone" value="" />
													</div>
													</div>
													<div class="col-sm-6">
													<div class="input-group">
													<span class="input-group-addon">
														 <b>Ext</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Ext" id="ext" name="ext" value="" />
													</div>
													</div>												
												</div>
											</div>
										</div>
									</div>

									<div class="form-group">
										<div class="row">
											<div class="col-sm-6">
												<div class="input-group">
													<span class="input-group-addon">
														 <b>City</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter City" id="city" name="city" value="" />
												</div>
											</div>	
											<div class="col-sm-6">
												<div class="row">
													<div class="col-sm-6">
														<div class="input-group">
													<span class="input-group-addon">
														 <b>Fax</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Fax" id="fax" name="fax" value="" />
													</div>
													</div>
													<div class="col-sm-6">
													<div class="input-group">
													<span class="input-group-addon">
														 <b>Prefix</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Prefix" id="prefix" name="prefix" value="" />
													</div>
													</div>												
												</div>
											</div>
										</div>
									</div>
									
									<div class="form-group">
										<div class="row">
											<div class="col-sm-6">
												<div class="input-group">
													<span class="input-group-addon">
														 <b>Province</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Province/State" id="province" name="provinceState" value="" />
												</div>
											</div>	
											<div class="col-sm-6">
												<div class="row">
													<div class="col-sm-6">
														<div class="input-group">
													<span class="input-group-addon">
														 <b>TollFree</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter TollFree" id="tollfree" name="tollFree" value="" />
													</div>
													</div>
													<div class="col-sm-6">
													<div class="input-group">
													<span class="input-group-addon">
														 <b>Plant</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Plant" id="plant" name="plant" value="" />
													</div>
													</div>												
												</div>
											</div>	
										</div>
									</div>
									
									
									<div class="form-group">
										<div class="row">
											<div class="col-sm-6">
												<div class="row">
													<div class="col-sm-6">
														<div class="input-group">
															<span class="input-group-addon">
																 <b>Status</b>												
															</span>
															<select class="form-control" name="statusId" id="statusId">
															</select>
														</div>
													</div>
													<div class="col-sm-6">
														<div class="input-group">
															<span class="input-group-addon">
																 <b>CellNumber</b>												
															</span>
															<input type="text" class="form-control" placeHolder="Enter CellNumber" id="cellnumber" name="cellnumber" value="" />
														</div>
													</div>												
												</div>
											</div>	
											<div class="col-sm-6">
												<div class="row">
													<div class="col-sm-6">
														<div class="input-group">
															<span class="input-group-addon">
																 <b>Zone</b>												
															</span>
															<input type="text" class="form-control" placeHolder="Enter Zone" id="zone" name="zone" value="" />
														</div>
													</div>
													<div class="col-sm-6">
														<div class="input-group">
															<span class="input-group-addon">
																 <b>Email</b>												
															</span>
															<input type="text" class="form-control" placeHolder="Enter Email" id="email" name="email" value="" />
														</div>
													</div>												
												</div>
											</div>	
										</div>
									</div>
									
									<div class="form-group">
										<div class="row">
											<div class="col-sm-6">
												<div class="row">
													<div class="col-sm-6">
														<div class="input-group">
															<span class="input-group-addon">
																 <b>LeadTime</b>												
															</span>
															<input type="text" class="form-control" placeHolder="Enter LeadTime" id="leadTime" name="leadTime" value="" />
														</div>
													</div>
													<div class="col-sm-6">
														<div class="input-group">
															<span class="input-group-addon">
																 <b>TimeZone</b>												
															</span>
															<input type="text" class="form-control" placeHolder="Enter TimeZone" id="timeZone" name="timeZone" value="" />
														</div>
													</div>												
												</div>
											</div>	
											<div class="col-sm-6">
												<div class="row">
													<div class="col-sm-6">
														<div class="input-group">
															<div class="form-group text-left">
																<input type="checkbox" tabindex="3" class="" name="remember" id="remember">ETA To PickUp Alert
																<input type="checkbox" tabindex="3" class="" name="remember" id="remember">ETA To Deliver Alert
															</div>
														</div>
													</div>												
												</div>
											</div>	
										</div>
									</div>
									
									<div class="form-group">
										<div class="row">
											<div class="col-sm-6">
												<div class="input-group">
													<span class="input-group-addon">
														 <b>Importer</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Importer" id="importer" name="importer" value="" />
												</div>
											</div>	
											<div class="col-sm-6">
												<div class="row">
													<div class="col-sm-12">
														<div class="input-group">
															<div class="form-group text-left">
																<input type="checkbox" tabindex="1" class="" name="remember" id="remember">Registered C.S.A Facility
																<input type="checkbox" tabindex="1" class="" name="remember" id="remember">Registered C-TPAT Facility
																<input type="checkbox" tabindex="1" class="" name="remember" id="remember">Warehouse or Cross-Dock Facility
															</div>
														</div>
													</div>												
												</div>
											</div>	
										</div>
									</div>
									
									<div class="form-group">
										<div class="row">
											<div class="col-sm-6">
												<div class="input-group">
													<span class="input-group-addon">
														 <b>InternalNotes</b>												
													</span>
													<textarea class="form-control" rows="1" cols="1" placeholder="Internal Notes" name="internalNotes" id = "internalNotes"></textarea>
												</div>
											</div>	
											<div class="col-sm-6">
												<div class="input-group">
													<span class="input-group-addon">
														 <b>StandardNotes</b>												
													</span>
													<textarea class="form-control" rows="1" cols="1" placeholder="Standard Notes" name="standardNotes" id="standardNotes"></textarea>
												</div>
											</div>	
										</div>
									</div>
									
								</div>
				        	</div>
					        </div>
					         <div class="modal-footer">
						          <input type="button" class="btn btn-default" data-dismiss="modal" value="Directions"/>
								  <button type="button" class="btn btn-default" data-dismiss="modal">Hours</button>
								  <input type="button" class="btn btn-default" data-dismiss="modal"  value="Notes" />
								  <button type="button" class="btn btn-default" data-dismiss="modal">Reports</button>
								  <input type="button" class="btn btn-default" data-dismiss="modal" value="AC" />
						          <input type="button" class="btn btn-primary" id= "btnSave" value="Save" />
								  <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
					        </div>
					      </div>
					      </form>
					    </div>
					  </div>
				</div>
				<div class="col-sm-4">
				</div>
		</div>
		</div>	
		<form action="showques" method="GET" name="ques" id="frmSearch">
		<%-- <div class="row">
			<div class="col-sm-4">
				<input type="text" name="question" placeholder="Write Question to Search..." class="form-control" />
			</div>
			<div class="col-sm-4">
				<input type="text" name="answer" placeholder="Write Answer to Search..." class="form-control" />
			</div>
			<div class="col-sm-2">
				<select class="form-control" name="categoryId">
					<option value="0">Select</option>
					<c:forEach items="${LIST_CAT}" var="obj">
						<option value="${obj.categoryId}">${obj.title}</option>
					</c:forEach>
				</select>
			</div>
			<div class="col-sm-2">
				<button type="button" id = "btnSearch" class="btn btn-info"><span class="glyphicon glyphicon-search"></span>&nbsp;&nbsp;&nbsp;Search</button>
			</div>
		</div> --%>
		</form>
	</div>
	<div class="container">
		<div class="table-responsive">
			<table class="table table-striped table-hover table-condensed">
				<thead>
					<tr>
						<th>Company</th>
						<th>address</th>
						<th>Unit</th>
						<th>City</th>
						<th>Province</th>
						<th>Phone</th>
						<th>Prefix</th>
						<th>Tollfree</th>
						<th>Plant</th>
						<th>CellNumber</th>
						<th>Email</th>
						<th>Importer</th>
						<th>Links</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${LIST_LOCATION}" var="obj">
						<tr class="info">
							<td>${obj.locationName}</td>
							<td>${obj.address}</td>
							<td>${obj.unit}</td>
							<td>${obj.city}</td>
							<td>${obj.provinceState}</td>
							<td>${obj.phone}</td>
							<td>${obj.prefix}</td>
							<td>${obj.tollFree}</td>
							<td>${obj.plant}</td>
							<td>${obj.phone}</td>
							<td>${obj.email}</td>
							<td>${obj.importer}</td>
							<td><a href = "#" data-toggle="modal" data-target="#myModal" onclick="checkFlag('update'); onClickMethodQuestion('${obj.shipperId}');">Update</a> / <a href="deleteshipper/${obj.shipperId}">Delete</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>