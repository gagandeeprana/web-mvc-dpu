<%@page import="org.springframework.beans.factory.annotation.Autowired"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Driver</title>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@page isELIgnored="false"%>
<link rel="stylesheet"
	href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script
	src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/css/toastr.css" >
	<script  src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/js/toastr.min.js" ></script>
	
	
	<jsp:include page="Include.jsp"></jsp:include>
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
<script type="text/javascript">

	function deleteDriver(driverId){
		 
		  $.ajax({url: BASE_URL + "deletedriver/" + driverId,
			      type:"GET",
			      success: function(result){
		    	  try{	
						var list = result.resultList;
						var tableValue = "";
						if(list.length > 0) {
							 for(var i=0;i<list.length;i++) {
								var obj = list[i];
								tableValue = tableValue + ("<tr class='info'>");
								var driverCode = "";
			            		if(obj.driverCode != null) {
			            			driverCode = obj.driverCode;
			            		}
			            		var firstName = "";
			            		if(obj.firstName != null) {
			            			firstName = obj.firstName;
			            		}
			            		var lastName = "";
			            		if(obj.lastName != null) {
			            			lastName = obj.lastName;
			            		}
			            		var address = "";
			            		if(obj.address != null) {
			            			address = obj.address;
			            		}
			            		var unit = "";
			            		if(obj.unit != null) {
			            			unit = obj.unit;
			            		}
			            		var city = "";
			            		if(obj.city != 'undefined') {
			            			city = obj.city;
			            		}
			            		var stateName = "";
			            		if(obj.stateName != null) {
			            			stateName = obj.stateName;
			            		}
			            		var faxNo = "";
			            		if(obj.faxNo != 'undefined') {
			            			faxNo = obj.faxNo;
			            		}
			            		var cellular = "";
			            		if(obj.cellular != 'undefined') {
			            			cellular = obj.cellular;
			            		}
			            		var pager = "";
			            		if(obj.pager != 'undefined') {
			            			pager = obj.pager;
			            		}
			            		var email = "";
			            		if(obj.email != 'undefined') {
			            			email = obj.email;
			            		}
			            		
			            		tableValue = tableValue + ("<td>"+(driverCode)+"</td>");
			            		
			            		tableValue = tableValue + ("<td>"+(firstName)+"</td>");
			            		tableValue = tableValue + ("<td>"+(lastName)+"</td>");
			            		tableValue = tableValue + ("<td>"+(address)+"</td>");
			            		tableValue = tableValue + ("<td>"+(unit)+"</td>");
			            		tableValue = tableValue + ("<td>"+(city)+"</td>");
			            		tableValue = tableValue + ("<td>"+ (stateName)+"</td>");
			            		tableValue = tableValue + ("<td>"+(faxNo)+"</td>");
			            		tableValue = tableValue + ("<td>"+(cellular)+"</td>");
			            		tableValue = tableValue + ("<td>"+(pager)+"</td>");
			            		tableValue = tableValue + ("<td>"+(email)+"</td>");
			            		tableValue = tableValue + "<td><a href = '#' data-toggle='modal' data-target='#myModal'  onclick='checkFlag('update');onClickMethodQuestion('"+(obj.driverId)+"')>Update</a> / <a href='#' onclick=deleteDriver('"+(obj.driverId)+"')>Delete</a></td>";
			            		 tableValue = tableValue + ("</tr>");
							}
							$("#driverData").html(tableValue);
						}
						
		    		  toastr.success(result.message, 'Success!')
				  }catch(e){
					toastr.error('Something went wrong', 'Error!')
				  }
		  },error:function(result){
			  try{
				  	var obj = JSON.parse(result.responseText);
				  	toastr.error(obj.message, 'Error!')
				  }catch(e){
					  toastr.error('Something went wrong', 'Error!')
				  }
		  }});
		  return true;
	}
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
			document.getElementById("frm1").action = "updatedriver";
			document.getElementById("btnSave").value = "Update";
			$("#modelTitle").html("Edit Driver");
		}
		else if(field == 'add') {
			//$("#cke_1_contents").html('');
			//$(":text").val("");
       		//document.getElementById('categoryId').selectedIndex = 0;
			document.getElementById("btnSave").value = "Save";
			$("#modelTitle").html("Add Driver");
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
	        	$.get("driver/getopenadd", function(data) {
		           
		            var status = document.getElementById("statusId");
		            for(var i = 0;i < data.statusList.length;i++) {
		            	status.options[status.options.length] = new Option(data.statusList[i].status);
		            	status.options[i].value = data.statusList[i].id;
		            } 
		            
		            var division = document.getElementById("divisionId");
		            for(var i = 0;i < data.divisionList.length;i++) {
		            	division.options[division.options.length] = new Option(data.divisionList[i].divisionName);
		            	division.options[i].value = data.divisionList[i].divisionId;
		            }
		            
		            var terminal = document.getElementById("terminalId");
		            for(var i = 0;i < data.terminalList.length;i++) {
		            	terminal.options[terminal.options.length] = new Option(data.terminalList[i].terminalName);
		            	terminal.options[i].value = data.terminalList[i].terminalId;
		            }
		            
		            var category = document.getElementById("categoryId");
		            for(var i = 0;i < data.categoryList.length;i++) {
		            	category.options[category.options.length] = new Option(data.categoryList[i].name);
		            	category.options[i].value = data.categoryList[i].categoryId;
		            }
		            
		            var role = document.getElementById("roleId");
		            for(var i = 0;i < data.roleList.length;i++) {
		            	role.options[role.options.length] = new Option(data.roleList[i].typeName);
		            	role.options[i].value = data.roleList[i].typeId;
		            }
		            
		            var driverClass = document.getElementById("classId");
		            for(var i = 0;i < data.driverClassList.length;i++) {
		            	driverClass.options[driverClass.options.length] = new Option(data.driverClassList[i].typeName);
		            	driverClass.options[i].value = data.driverClassList[i].typeId;
		            }
		        });
        	} else {
        		$.get("getdriver/driverId",{"driverId" : quesId}, function(data) {
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
            	});
        	}
        }
        function clearAll() {
        	$("#driverCode").val("");
        	$("#email").val("");
        	$("#firstName").val("");
        	$("#home").val("");
        	$("#fax").val("");
        	$("#lastName").val("");
        	$("#cellular").val("");
        	$("#pager").val("");
        	$("#address").val("");
        	$("#city").val("");
        	$("#zip").val("");
        	$("#province").val("");
        	$("#unit").val("");
        	$("#zip").val("");
        	$("#province").val("");
        	document.getElementById("statusId").innerHTML = "";
        	document.getElementById("divisionId").innerHTML = "";
        	document.getElementById("terminalId").innerHTML = "";
        	document.getElementById("categoryId").innerHTML = "";
        	document.getElementById("roleId").innerHTML = "";
        	document.getElementById("classId").innerHTML = ""; 
        }
        function emptyMessageDiv(){
        	var msg = $("#msg");
        	var msgvalue = $("#msgvalue");
        	msg.hide();
        	msgvalue.val("");	
        }

</script>
<script type="text/javascript">
function check() {
	var driverCode = $("#driverCode").val();
	var email = $("#email").val();
	var firstName =	$("#firstName").val();
	var home = $("#home").val();
	var fax = $("#fax").val();
	var lastName = $("#lastName").val();
	var cellular = $("#cellular").val();
	var pager =	$("#pager").val();
	var address = $("#address").val();
	var city = $("#city").val();
	var zip = $("#zip").val();
	var unit = $("#unit").val();
	var province = $("#province").val();
	var msg = $("#msg");
	var msgvalue = $("#msgvalue");
	msg.hide();
	msgvalue.val("");
	if(driverCode == "") {
		msg.show();
		msgvalue.text("DriverCode cannot be left blank.");
		$("#driverCode").focus();
		return false;
	}
	if(email == "") {
		msg.show();
		msgvalue.text("Email cannot be left blank.");
		$("#email").focus();
		return false;
	}
	if(firstName == "") {
		msg.show();
		msgvalue.text("FirstName cannot be left blank.");
		$("#firstName").focus();
		return false;
	}
	if(home == "") {
		msg.show();
		msgvalue.text("Home cannot be left blank.");
		$("#home").focus();
		return false;
	}
	if(fax == "") {
		msg.show();
		msgvalue.text("Fax cannot be left blank.");
		$("#fax").focus();
		return false;
	}
	if(lastName == "") {
		msg.show();
		msgvalue.text("LastName cannot be left blank.");
		$("#lastName").focus();
		return false;
	}
	if(cellular == "") {
		msg.show();
		msgvalue.text("Cellular cannot be left blank.");
		$("#cellular").focus();
		return false;
	}
	if(pager == "") {
		msg.show();
		msgvalue.text("Pager cannot be left blank.");
		$("#pager").focus();
		return false;
	}
	if(address == "") {
		msg.show();
		msgvalue.text("Address cannot be left blank.");
		$("#address").focus();
		return false;
	}
	if(city == "") {
		msg.show();
		msgvalue.text("City cannot be left blank.");
		$("#city").focus();
		return false;
	}
	if(zip == "") {
		msg.show();
		msgvalue.text("Zip cannot be left blank.");
		$("#zip").focus();
		return false;
	}
	if(unit == "") {
		msg.show();
		msgvalue.text("Unit cannot be left blank.");
		$("#unit").focus();
		return false;
	}
	if(province == "") {
		msg.show();
		msgvalue.text("Province cannot be left blank.");
		$("#province").focus();
		return false;
	}
	$('#modal').modal('toggle');
	return true;
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
						<form action="savedriver" method="POST" name="driver" id="frm1" onsubmit="return check()">
						<input type="hidden" id = "driverid" name= "driverid" value = "" />					
						<input type="hidden" id = "addUpdateFlag" value = "" />					
	
					      <!-- Modal content-->
					      <div class="modal-content">
					        <div class="modal-header">
					          <button type="button" class="close" data-dismiss="modal">&times;</button>
					          <h4 class="modal-title"><p id ="modelTitle">Add Driver</p></h4>
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
													 <b>Code</b>												
												</span>
												<input type="text" class="form-control" placeHolder="Enter DriverCode" id="driverCode" name="driverCode" value="" autofocus />
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
									<div class="form-group">
										<div class="row">
											<div class="col-sm-6">
												<div class="input-group">
													<span class="input-group-addon">
														 <b>FirstName</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter FirstName" id="firstName" name="firstName" value="" />
												</div>
											</div>
											<div class="col-sm-6">
												<div class="row">
													<div class="col-sm-6">
														<div class="input-group">
															<span class="input-group-addon">
																 <b>Home</b>												
															</span>
															<input type="text" class="form-control" placeHolder="Enter Home" id="home" name="home" value="" />
														</div>
													</div>
													<div class="col-sm-6">
														<div class="input-group">
													<span class="input-group-addon">
														 <b>Fax</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Fax" id="fax" name="faxNo" value="" />
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
														 <b>LastName</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter LastName" id="lastName" name="lastName" value="" />
												</div>
											</div>
											<div class="col-sm-6">
												<div class="row">
													<div class="col-sm-6">
														<div class="input-group">
													<span class="input-group-addon">
														 <b>Cellular</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Cellular" id="cellular" name="cellular" value="" />
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
														 <b>Division</b>												
													</span>
													<select class="form-control" name="divisionId" id="divisionId">
													</select>
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
														 <b>Terminal</b>												
													</span>
													<select class="form-control" name="terminalId" id="terminalId">
													</select>
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
														 <b>Zip</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Zip" id="zip" name="postalCode" value="" />
													</div>
													</div>
													<div class="col-sm-6">
													<div class="input-group">
													<span class="input-group-addon">
														 <b>Province</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Province" id="province" name="pvs" value="" />
													</div>
													</div>												
												</div>
											</div>
											<div class="col-sm-6">
												<div class="row">
													<div class="col-sm-6">
													<div class="input-group">
														<span class="input-group-addon">
															 <b>Category</b>												
														</span>
														<select class="form-control" name="categoryId" id="categoryId">
														</select>
													</div>
													</div>
													<div class="col-sm-6">
													<div class="input-group">
														<span class="input-group-addon">
															 <b>Role</b>												
														</span>
														<select class="form-control" name="roleId" id="roleId">
														</select>
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
															 <b>Class</b>												
														</span>
														<select class="form-control" name="driverClassId" id="classId">
														</select>
													</div>
													</div>													
												</div>
											</div>
											<div class="col-sm-6">
												<div class="input-group">
													<span class="input-group-addon">
														 <b>Unit</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Unit" id="unit" name="unit" value="" />
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
						<th>DriverCode</th>
						<th>FirstName</th>
						<th>LastName</th>
						<th>Address</th>
						<th>Unit</th>
						<th>City</th>
						<th>P/S</th>
						<!-- <th>ZipCode</th>
						<th>Home</th> -->
						<th>Fax</th>
						<th>Cellular</th>
						<th>Pager</th>
						<th>Email</th>
						<th>Links</th>
					</tr>
				</thead>
				<tbody id="driverData">
					<c:forEach items="${LIST_DRIVER}" var="obj">
						<tr class="info">
							<c:if test = "${obj.firstName.length() <= 20}">
								<c:set var = "firstName" value="${obj.firstName}"/>
							</c:if>
							<c:if test = "${obj.lastName.length() > 20}">
								<c:set var = "firstName" value="${fn:substring(obj.firstName, 0, 19)}..."/>
							</c:if>

							<td>${obj.driverCode}</td>							
							<td>${firstName}</td>
							
							<c:if test = "${obj.lastName.length() <= 20}">
								<c:set var = "lastName" value="${obj.lastName}"/>
							</c:if>
							<c:if test = "${obj.lastName.length() > 20}">
								<c:set var = "lastName" value="${fn:substring(obj.lastName, 0, 19)}..."/>
							</c:if>
							<td>${lastName}</td>
							<td>${obj.address}</td>
							<td>${obj.unit}</td>
							<td>${obj.city}</td>
							<td>${obj.stateName}</td>
							
							<td>${obj.faxNo}</td>
							<td>${obj.cellular}</td>
							<td>${obj.pager}</td>
							<td>${obj.email}</td>
							<td><a href = "#" data-toggle="modal" data-target="#myModal" onclick="checkFlag('update');onClickMethodQuestion('${obj.driverId}')">Update</a> / <a href="#" onclick="deleteDriver('${obj.driverId}')">Delete</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>