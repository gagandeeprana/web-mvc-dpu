<%@page import="org.springframework.beans.factory.annotation.Autowired"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Truck</title>
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
			document.getElementById("frm1").action = "updatetruck";
			document.getElementById("btnSave").value = "Update";
			$("#modelTitle").html("Edit Truck");
		}
		else if(field == 'add') {
			//$("#cke_1_contents").html('');
			$(":text").val("");
	   		//document.getElementById('categoryId').selectedIndex = 0;
			document.getElementById("btnSave").value = "Save";
			$("#modelTitle").html("Add Truck");
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
        		$.get("truck/getopenadd", function(data) {
     	           
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
    	            
    	            var truckType = document.getElementById("truckTypeId");
    	            for(var i = 0;i < data.truckTypeList.length;i++) {
    	            	truckType.options[truckType.options.length] = new Option(data.truckTypeList[i].typeName);
    	            	truckType.options[i].value = data.truckTypeList[i].typeId;
    	            }
    	        });
        	} else {
        		$.get("gettruck/truckId",{"truckId" : quesId}, function(data) {
    	            document.getElementById("truckid").value = data.truckId;
                   	$("#unitNo").val(data.unitNo);
                   	$("#usage").val(data.truchUsage);
                   	$("#owner").val(data.owner);
                   	$("#oOName").val(data.oOName);
                   	$("#finance").val(data.finance);
                   	
                   	var division = document.getElementById("divisionId");
                    var divisionList = data.divisionList;
                    for(var i = 0;i < divisionList.length;i++) {
                    	division.options[division.options.length] = new Option(divisionList[i].divisionName);
                    	division.options[i].value = divisionList[i].divisionId;
                    	if(divisionList[i].divisionId == data.divisionId) {
                    		document.getElementById("divisionId").selectedIndex = i;
                    	}
                    }
                    
                    var terminal = document.getElementById("terminalId");
                    var terminalList = data.terminalList;
                    for(var i = 0;i < terminalList.length;i++) {
                    	terminal.options[terminal.options.length] = new Option(terminalList[i].terminalName);
                    	terminal.options[i].value = terminalList[i].terminalId;
                    	if(terminalList[i].terminalId == data.terminalId) {
                    		document.getElementById("terminalId").selectedIndex = i;
                    	}
                    }
                    
                    var truckType = document.getElementById("truckTypeId");
                    var truckTypeList = data.truckTypeList;
                    for(var i = 0;i < truckTypeList.length;i++) {
                    	truckType.options[truckType.options.length] = new Option(truckTypeList[i].typeName);
                    	truckType.options[i].value = truckTypeList[i].typeId;
                    	if(truckTypeList[i].typeId == data.truckTypeId) {
                    		document.getElementById("truckTypeId").selectedIndex = i;
                    	}
                    }
                    
                    
                    var category = document.getElementById("categoryId");
                    var categoryList = data.categoryList;
                    for(var i = 0;i < categoryList.length;i++) {
                    	category.options[category.options.length] = new Option(categoryList[i].name);
                    	category.options[i].value = categoryList[i].categoryId;
                    	if(categoryList[i].categoryId == data.categoryId) {
                    		document.getElementById("categoryId").selectedIndex = i;
                    	}
                    }
                    
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
        	$("#unitNo").val("");
           	$("#usage").val("");
           	$("#owner").val("");
           	$("#oOName").val("");
           	$("#finance").val("");
        	document.getElementById("statusId").innerHTML = "";
        	document.getElementById("divisionId").innerHTML = "";
        	document.getElementById("terminalId").innerHTML = "";
        	document.getElementById("categoryId").innerHTML = "";
        	document.getElementById("truckTypeId").innerHTML = "";
        }
</script>

<script type="text/javascript">
function check() {
	var unitNo = $("#unitNo").val();
	var usage = $("#usage").val();
	var owner = $("#owner").val();
	var oOName = $("#oOName").val();
	var finance = $("#finance").val();
	var msg = $("#msg");
	var msgvalue = $("#msgvalue");
	msg.hide();
	msgvalue.val("");
	if(unitNo == "") {
		msg.show();
		msgvalue.text("UnitNo cannot be left blank.");
		$("#unitNo").focus();
		return false;
	}
	if(usage == "") {
		msg.show();
		msgvalue.text("Usage cannot be left blank.");
		$("#usage").focus();
		return false;
	}
	if(owner == "") {
		msg.show();
		msgvalue.text("Owner cannot be left blank.");
		$("#owner").focus();
		return false;
	}
	if(oOName == "") {
		msg.show();
		msgvalue.text("OOName cannot be left blank.");
		$("#oOName").focus();
		return false;
	}
	if(finance == "") {
		msg.show();
		msgvalue.text("Finance cannot be left blank.");
		$("#finance").focus();
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
						<form action="savetruck" method="POST" name="truck" id="frm1" onsubmit="return check()">
						<input type="hidden" id = "truckid" name= "truckid" value = "" />					
						<input type="hidden" id = "addUpdateFlag" value = "" />					
	
					      <!-- Modal content-->
					      <div class="modal-content">
					        <div class="modal-header">
					          <button type="button" class="close" data-dismiss="modal">&times;</button>
					          <h4 class="modal-title"><p id ="modelTitle">Add Truck</p></h4>
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
													 <b>UnitNo</b>												
												</span>
												<input type="text" class="form-control" placeHolder="Enter UnitNo" id="unitNo" name="unitNo" value="" autofocus />
											</div>
											</div>
											<div class="col-sm-6">
												<div class="input-group">
													<span class="input-group-addon">
														 <b>Usage</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Usage" id="usage" name="truchUsage" value="" />
												</div>
											</div>
										</div>
									</div>
									<div class="form-group">
										<div class="row">
											<div class="col-sm-6">
												<div class="input-group">
													<span class="input-group-addon">
														 <b>Owner</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Owner" id="owner" name="owner" value="" />
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
														 <b>OOName</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter oOName" id="oOName" name="oOName" value="" />
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
														<b>TruckType</b>												
													</span>
													<select class="form-control" name="truckTypeId" id="truckTypeId">
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
														<b>Status</b>												
													</span>
													<select class="form-control" name="statusId" id="statusId">
														<option value="1">Active</option>
														<option value="0">Inactive</option>
													</select>
												</div>
											</div>	
											<div class="col-sm-6">
												<div class="input-group">
													<span class="input-group-addon">
														 <b>Finance</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Finance" id="finance" name="finance" value="" />
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
						<th>Owner</th>
						<th>O/O's Name</th>
						<th>Category</th>
						<th>Status</th>
						<th>Usage</th>
						<th>Division</th>
						<th>Terminal</th>
						<th>Truck Type</th>
						<th>Finance</th>
						<th>Links</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${LIST_TRUCK}" var="obj">
						<tr class="info">
							<td>${obj.unitNo}</td>							
							<td>${obj.owner}</td>
							<td>${obj.oOName}</td>
							<td>${obj.catogoryName}</td>
							<td>${obj.statusName}</td>
							<td>${obj.truchUsage}</td>
							<td>${obj.divisionName}</td>
							<td>${obj.terminalName}</td>
							<td>${obj.truckType}</td>
							<td>${obj.finance}</td>
							<td><a href = "#" data-toggle="modal" data-target="#myModal" onclick="checkFlag('update');onClickMethodQuestion('${obj.truckId}')">Update</a> / <a href="deletetruck/${obj.truckId}">Delete</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>