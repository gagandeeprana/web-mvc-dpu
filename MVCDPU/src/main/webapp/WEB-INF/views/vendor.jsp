<%@page import="org.springframework.beans.factory.annotation.Autowired"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Vendor</title>
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

  height:360px; 
  min-height:360px;  
  max-height:360px;
}
</style>
 <script src="<c:url value="/resources/validations.js" />"></script>
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
		document.getElementById("frm1").action = "updatevendor";
		document.getElementById("btnSave").value = "Update";
		$("#modelTitle").html("Edit Vendor");
	}
	else if(field == 'add') {
		//$("#cke_1_contents").html('');
		$(":text").val("");
   		//document.getElementById('categoryId').selectedIndex = 0;
		document.getElementById("btnSave").value = "Save";
		$("#modelTitle").html("Add Vendor");
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
   		$.get("getvendor/vendorId",{"vendorId" : quesId}, function(data) {
            document.getElementById("vendorid").value = data.vendorId;
           	$("#vendorName").val(data.name);
           	$("#contact").val(data.contact);
           	$("#address").val(data.address);
           	$("#position").val(data.position);
           	$("#ext").val(data.ext);
           	$("#prefix").val(data.vendorPrefix);
           	$("#unitNo").val(data.unitNo);
           	$("#phone").val(data.phone);
           	$("#city").val(data.city);
           	$("#fax").val(data.fax);
           	$("#province").val(data.provinceState);
           	$("#zip").val(data.zip);
           	$("#afterHours").val(data.afterHours);
           	$("#email").val(data.email);
           	$("#tollfree").val(data.tollfree);
           	$("#website").val(data.website);
           	$("#cellular").val(data.cellular);
           	$("#pager").val(data.pager);
       	});
    }
    function clearAll() {
    	$("#vendorName").val("");
    	$("#contact").val("");
    	$("#address").val("");
    	$("#position").val("");
    	$("#ext").val("");
    	$("#prefix").val("");
    	$("#unitNo").val("");
    	$("#phone").val("");
    	$("#city").val("");
    	$("#fax").val("");
    	$("#province").val("");
    	$("#zip").val("");
    	$("#afterHours").val("");
    	$("#email").val("");
    	$("#tollfree").val("");
    	$("#website").val("");
    	$("#cellular").val("");
    	$("#pager").val("");
    }
</script>
<script type="text/javascript">
function changeStateLabel() {
	
	var country = $('#countryId :selected').text();
	if(country == 'USA') {
		$("#zipLabel").text("Zip");
		$("#zip").attr("placeholder","Enter Zip");
		$("#stateLabel").text("State");
	} else if(country == 'Canada'){
		$("#zipLabel").text("PostalCode");
		$("#zip").attr("placeholder","Enter PostalCode");
		$("#stateLabel").text("Province");
	}
}

function getStates() {
	
	var countryId = $('#countryId :selected').val();
	document.getElementById("stateId").innerHTML = "";
	$.get("states/" + countryId, function(response) {
           
        if(response.length > 0) {
            var state = document.getElementById("stateId");
        	for(var i = 0;i < response.length;i++) {
        		state.options[state.options.length] = new Option(response[i].stateName);
        		state.options[i].value = response[i].stateId;
            }
        }
	});
}
function onClickMethodQuestion(quesId){
	emptyMessageDiv();
	clearAll();
	if(quesId == 0) {
    	$.get("driver/getopenadd", function(data) {

    		var country = document.getElementById("countryId");
            for(var i = 0;i < data.countryList.length;i++) {
            	country.options[country.options.length] = new Option(data.countryList[i].countryName);
            	country.options[i].value = data.countryList[i].countryId;
            }
        });
	} else {
		/* $.get("getdriver/driverId",{"driverId" : quesId}, function(data) {
            document.getElementById("driverid").value = data.resultList.driverId;
            $("#driverCode").val(data.resultList.driverCode);
        	$("#email").val(data.resultList.email);
        	$("#firstName").val(data.resultList.firstName);
        	$("#home").val(data.resultList.home);
        	$("#fax").val(data.resultList.faxNo);
        	$("#lastName").val(data.resultList.lastName);
        	$("#cellular").val(data.resultList.cellular);
        	$("#pager").val(data.resultList.pager);
        	$("#address").val(data.resultList.address);
        	$("#city").val(data.resultList.city);
        	$("#zip").val(data.resultList.zip);
        	$("#province").val(data.resultList.province);
        	$("#unit").val(data.resultList.unit);
        	$("#zip").val(data.resultList.postalCode);
        	$("#province").val(data.resultList.pvs);
        	
            var division = document.getElementById("divisionId");
            var divisionList = data.resultList.divisionList;
            for(var i = 0;i < divisionList.length;i++) {
            	division.options[division.options.length] = new Option(divisionList[i].divisionName);
            	division.options[i].value = divisionList[i].divisionId;
            	if(divisionList[i].divisionId == data.resultList.divisionId) {
            		document.getElementById("divisionId").selectedIndex = i;
            	}
            }
            
            var terminal = document.getElementById("terminalId");
            var terminalList = data.resultList.terminalList;
            for(var i = 0;i < terminalList.length;i++) {
            	terminal.options[terminal.options.length] = new Option(terminalList[i].terminalName);
            	terminal.options[i].value = terminalList[i].terminalId;
            	if(terminalList[i].terminalId == data.resultList.terminalId) {
            		document.getElementById("terminalId").selectedIndex = i;
            	}
            }
            
            var category = document.getElementById("categoryId");
            var categoryList = data.resultList.categoryList;
            for(var i = 0;i < categoryList.length;i++) {
            	category.options[category.options.length] = new Option(categoryList[i].name);
            	category.options[i].value = categoryList[i].categoryId;
            	if(categoryList[i].categoryId == data.resultList.categoryId) {
            		document.getElementById("categoryId").selectedIndex = i;
            	}
            }
            
            var role = document.getElementById("roleId");
            var roleList = data.resultList.roleList;
            for(var i = 0;i < roleList.length;i++) {
            	role.options[role.options.length] = new Option(roleList[i].typeName);
            	role.options[i].value = roleList[i].typeId;
            	if(roleList[i].typeId == data.resultList.roleId) {
            		document.getElementById("roleId").selectedIndex = i;
            	}
            }
            
            var status = document.getElementById("statusId");
            var statusList = data.resultList.statusList;
            for(var i = 0;i < statusList.length;i++) {
            	status.options[status.options.length] = new Option(statusList[i].status);
            	status.options[i].value = statusList[i].id;
            	if(statusList[i].id == data.resultList.statusId) {
            		document.getElementById("statusId").selectedIndex = i;
            	}
            }
            
            var driverClass = document.getElementById("classId");
            var driverClassList = data.resultList.driverClassList;
            for(var i = 0;i < driverClassList.length;i++) {
            	driverClass.options[driverClass.options.length] = new Option(driverClassList[i].typeName);
            	driverClass.options[i].value = driverClassList[i].typeId;
            	if(driverClassList[i].typeId == data.resultList.driverClassId) {
            		document.getElementById("classId").selectedIndex = i;
            	}
            }
    	}); */
	}
}

function check() {
	var vendorName = $("#vendorName").val();
	var contact = $("#contact").val();
	var address = $("#address").val();
	var position = $("#position").val();
	var ext = $("#ext").val();
	var prefix = $("#prefix").val();
	var unitNo = $("#unitNo").val();
	var phone = $("#phone").val();
	var city = $("#city").val();
	var fax = $("#fax").val();
	var province = $("#province").val();
	var zip = $("#zip").val();
	var afterHours = $("#afterHours").val();
	var email = $("#email").val();
	var tollFree = $("#tollfree").val();
	var website = $("#website").val();
	var cellular = $("#cellular").val();
	var pager = $("#pager").val();
	var msg = $("#msg");
	var msgvalue = $("#msgvalue");
	msg.hide();
	msgvalue.val("");
	if(vendorName == "") {
		msg.show();
		msgvalue.text("VendorName cannot be left blank.");
		$("#vendorName").focus();
		return false;
	}
	if(contact == "") {
		msg.show();
		msgvalue.text("Contact cannot be left blank.");
		$("#contact").focus();
		return false;
	}
	if(!isNumeric(contact)) {
		msg.show();
		msgvalue.text("Only numerics allowed in contact");
		$("#contact").focus();
		return false;
	}
	if(contact.length != 10) {
		msg.show();
		msgvalue.text("Length 10 allowed in contact");
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
	if(ext == "") {
		msg.show();
		msgvalue.text("Ext cannot be left blank.");
		$("#ext").focus();
		return false;
	}
	if(prefix == "") {
		msg.show();
		msgvalue.text("Prefix cannot be left blank.");
		$("#prefix").focus();
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
	if(!isNumeric(phone)) {
		msg.show();
		msgvalue.text("Only numerics allowed in phone");
		$("#phone").focus();
		return false;
	}
	if(phone.length != 10) {
		msg.show();
		msgvalue.text("Length 10 allowed in phone");
		$("#phone").focus();
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
	if(!isNumeric(fax)) {
		msg.show();
		msgvalue.text("Only numerics allowed in fax");
		$("#fax").focus();
		return false;
	}
	if(fax.length != 10) {
		msg.show();
		msgvalue.text("Length 10 allowed in fax");
		$("#fax").focus();
		return false;
	}
	if(province == "") {
		msg.show();
		msgvalue.text("Province cannot be left blank.");
		$("#province").focus();
		return false;
	}
	var country = $('#countryId :selected').text();
	if(country == 'USA') {
		if(zip == "") {
			msg.show();
			msgvalue.text("Zip cannot be left blank.");
			$("#zip").focus();
			return false;
		}
		if(!isNumeric(zip)) {
			msg.show();
			msgvalue.text("Only numerics allowed in Zip");
			$("#zip").focus();
			return false;
		}
		if(zip.length != 5) {
			msg.show();
			msgvalue.text("Length 5 allowed in Zip");
			$("#zip").focus();
			return false;
		}
	}
	var country = $('#countryId :selected').text();
	if(country == 'Canada') {
		if(zip == "") {
			msg.show();
			msgvalue.text("PostalCode cannot be left blank.");
			$("#zip").focus();
			return false;
		}
		if(!isAlphaNumeric(zip)) {
			msg.show();
			msgvalue.text("Only alphanumerics allowed in PostalCode");
			$("#zip").focus();
			return false;
		}
		if(zip.length != 6) {
			msg.show();
			msgvalue.text("Length 6 allowed in PostalCode");
			$("#zip").focus();
			return false;
		}
		if((!isNameWithoutSpace(zip[0])) || (!isNumeric(zip[1])) || (!isNameWithoutSpace(zip[2])) || (!isNumeric(zip[3])) || (!isNameWithoutSpace(zip[4])) || (!isNumeric(zip[5]))) {
			msg.show();
			msgvalue.text("Invalid pattern PostalCode");
			$("#zip").focus();
			return false;
		}
	}
	if(afterHours == "") {
		msg.show();
		msgvalue.text("AfterHours cannot be left blank.");
		$("#afterHours").focus();
		return false;
	}
	if(!isNumeric(afterHours)) {
		msg.show();
		msgvalue.text("Only numerics allowed in afterHours");
		$("#afterHours").focus();
		return false;
	}
	if(afterHours.length != 10) {
		msg.show();
		msgvalue.text("Length 10 allowed in afterHours");
		$("#afterHours").focus();
		return false;
	}
	if(email == "") {
		msg.show();
		msgvalue.text("Email cannot be left blank.");
		$("#email").focus();
		return false;
	}
	if(!isEmail(email)) {
		msg.show();
		msgvalue.text("Invalid email pattern");
		$("#email").focus();
		return false;
	}
	if(tollFree == "") {
		msg.show();
		msgvalue.text("TollFree cannot be left blank.");
		$("#tollfree").focus();
		return false;
	}
	if(!isNumeric(tollFree)) {
		msg.show();
		msgvalue.text("Only numerics allowed in tollFree");
		$("#tollfree").focus();
		return false;
	}
	if(tollFree.length != 10) {
		msg.show();
		msgvalue.text("Length 10 allowed in tollFree");
		$("#tollfree").focus();
		return false;
	}
	if(website == "") {
		msg.show();
		msgvalue.text("Website cannot be left blank.");
		$("#website").focus();
		return false;
	}
	if(cellular == "") {
		msg.show();
		msgvalue.text("Cellular cannot be left blank.");
		$("#cellular").focus();
		return false;
	}
	if(!isNumeric(cellular)) {
		msg.show();
		msgvalue.text("Only numerics allowed in cellular");
		$("#cellular").focus();
		return false;
	}
	if(cellular.length != 10) {
		msg.show();
		msgvalue.text("Length 10 allowed in cellular");
		$("#cellular").focus();
		return false;
	}
	if(pager == "") {
		msg.show();
		msgvalue.text("Pager cannot be left blank.");
		$("#pager").focus();
		return false;
	}
	if(!isNumeric(pager)) {
		msg.show();
		msgvalue.text("Only numerics allowed in pager");
		$("#pager").focus();
		return false;
	}
	if(pager.length != 10) {
		msg.show();
		msgvalue.text("Length 10 allowed in pager");
		$("#pager").focus();
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
		<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal" onclick="checkFlag('add'); onClickMethodQuestion('0'); emptyMessageDiv();" >Add New</button>
		<div class="form-group">
		<div class="row">
			<div class="col-sm-8">
					<div class="modal fade" id="myModal" role="dialog">
					    <div class="modal-dialog">
						<form action="savevendor" method="POST" name="vendor" id="frm1" onsubmit="return check()">
						<input type="hidden" id = "vendorid" name= "vendorid" value = "" />					
						<input type="hidden" id = "addUpdateFlag" value = "" />					
	
					      <!-- Modal content-->
					      <div class="modal-content">
					        <div class="modal-header">
					          <button type="button" class="close" data-dismiss="modal">&times;</button>
					          <h4 class="modal-title"><p id ="modelTitle">Add Vendor</p></h4>
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
													 <b>VendorName</b>												
												</span>
												<input type="text" class="form-control" placeHolder="Enter VendorName" id="vendorName" name="name" value="" autofocus />
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
														 <b>Unit No</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter UnitNo" id="unitNo" name="unitNo" value="" />
												</div>
											</div>
											
											<div class="col-sm-6">
												<div class="input-group">
													<span class="input-group-addon">
														 <b>Prefix</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Prefix" id="prefix" name="vendorPrefix" value="" />
												</div>
											</div>
										</div>
									</div>
									
									<div class="form-group">
										<div class="row">
											<div class="col-sm-6">
												<div class="input-group">
													<span class="input-group-addon">
														 <b>Ext</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Ext" id="ext" name="ext" value="" />
												</div>
											</div>
											<div class="col-sm-6">
												<div class="input-group">
													<span class="input-group-addon">
														 <b>Phone</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Phone" id="phone" name="phone" value="" />
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
																 <b>Country</b>												
															</span>
															<select class="form-control" name="countryId" id="countryId" onchange="getStates();changeStateLabel()">
															</select>
														</div>
													</div>
													<div class="col-sm-6">
														<div class="input-group">
															<span class="input-group-addon">
																 <b id="stateLabel">Province</b>												
															</span>
															<select class="form-control" name="stateId" id="stateId">
															</select>
														</div>
													</div>												
												</div>
											</div>	
											<div class="col-sm-6">
												<div class="input-group">
													<span class="input-group-addon">
														 <b>Fax</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Fax" id="fax" name="fax" value="" />
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
												<div class="input-group">
													<span class="input-group-addon">
														 <b>AfterHours</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter AfterHours" id="afterHours" name="afterHours" value="" />
												</div>
											</div>
										</div>
									</div>

									<div class="form-group">
										<div class="row">
													<div class="col-sm-6">
													<div class="input-group">
													<span class="input-group-addon">
														 <b id="zipLabel">Zip</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Zip" id="zip" name="zip" value="" />
													</div>
													</div>	
											<div class="col-sm-6">
												<div class="input-group">
													<span class="input-group-addon">
														 <b>TollFree</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter TollFree" id="tollfree" name="tollfree" value="" />
												</div>
											</div>												
										</div>
									</div>
									
									<div class="form-group">
										<div class="row">
											<div class="col-sm-6">
												<div class="input-group">
													<span class="input-group-addon">
														 <b>Email</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Email" id="email" name="email" value="" />
												</div>
											</div>
											<div class="col-sm-6">
												<div class="input-group">
													<span class="input-group-addon">
														 <b>Cellular</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Cellular" id="cellular" name="cellular" value="" />
												</div>
											</div>												
										</div>
									</div>
									
									<div class="form-group">
										<div class="row">
											<div class="col-sm-6">
												<div class="input-group">
													<span class="input-group-addon">
														 <b>Website</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Website" id="website" name="website" value="" />
												</div>
											</div>
											<div class="col-sm-6">
												<div class="input-group">
													<span class="input-group-addon">
														<b>Pager</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Pager" id="pager" name="pager" value="" />
												</div>
											</div>
										</div>
									</div>
				        	</div>
				        	</div>
				        	</div>
				        	<div class="modal-footer">
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
						<th>Unit No</th>
						<th>Name</th>
						<th>Email</th>
						<th>City</th>
						<th>P/S</th>
						<th>Phone</th>
						<th>Fax</th>
						<th>After Hours</th>
						<th>Links</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${LIST_VENDOR}" var="obj">
						<tr class="info">
							<td>${obj.unitNo}</td>							
							<td>${obj.name}</td>
							<td>${obj.email}</td>
							<td>${obj.city}</td>
							<td>${obj.stateName}</td>
							<td>${obj.phone}</td>
							<td>${obj.fax}</td>
							<td>${obj.afterHours}</td>
							<td><a href = "#" data-toggle="modal" data-target="#myModal" onclick="checkFlag('update');onClickMethodQuestion('${obj.vendorId}')">Update</a> / <a href="deletevendor/${obj.vendorId}">Delete</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>