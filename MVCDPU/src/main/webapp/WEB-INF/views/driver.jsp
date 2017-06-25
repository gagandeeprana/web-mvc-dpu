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
		/* document.getElementById("addUpdateFlag").value = field;
		if(field == 'update') {
			document.getElementById("frm1").action = "updateQuestion";
			document.getElementById("btnSave").value = "Update";
			$("#modelTitle").html("Edit Question");
		}
		else if(field == 'add') {
			//$("#cke_1_contents").html('');
			CKEDITOR.instances['answer'].setData('');
       		document.getElementById('question').value = "";
       		document.getElementById('status').selectedIndex = 0;
       		document.getElementById('categoryId').selectedIndex = 0;
			document.getElementById("btnSave").value = "Save";
			$("#modelTitle").html("Add New Question");
		} else if (field == 'search') {
			document.getElementById("frm1").method = "GET";
			document.getElementById("frm1").action = "showques";
			document.getElementById("frm1").submit();
		} */
	}
</script>
<script type="text/javascript">
        function onClickMethodQuestion(quesId){
        	document.getElementById("statusId").innerHTML = "";
        	document.getElementById("divisionId").innerHTML = "";
        	document.getElementById("terminalId").innerHTML = "";
        	document.getElementById("categoryId").innerHTML = "";
        	document.getElementById("roleId").innerHTML = "";
        	document.getElementById("classId").innerHTML = "";        	
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
        }
</script>
</head>
<body>
	<jsp:include page="header.jsp"></jsp:include>
	<div class="container">
		<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal" onclick="checkFlag('add'); onClickMethodQuestion('0');" >Add New</button>
		<div class="form-group">
		<div class="row">
			<div class="col-sm-8">
					<div class="modal fade" id="myModal" role="dialog">
					    <div class="modal-dialog">
						<form action="savedriver" method="POST" name="driver" id="frm1">
						<input type="hidden" id = "questionid" name= "quesid" value = "" />					
						<input type="hidden" id = "addUpdateFlag" value = "" />					
	
					      <!-- Modal content-->
					      <div class="modal-content">
					        <div class="modal-header">
					          <button type="button" class="close" data-dismiss="modal">&times;</button>
					          <h4 class="modal-title"><p id ="modelTitle">Add Driver</p></h4>
					        </div>
					        <div class="modal-body">
								<div class = "row">
								<div class="col-sm-12">
									<div class="form-group">
										<div class="row">
											<div class="col-sm-6">
												<div class="input-group">
												<span class="input-group-addon">
													 <i class="glyphicon glyphicon-inbox"></i>												
												</span>
												<input type="text" class="form-control" placeHolder="Enter DriverCode" id="driverCode" name="driverCode" value="" autofocus />
											</div>
											</div>
											<div class="col-sm-6">
												<div class="input-group">
													<span class="input-group-addon">
														 <i class="glyphicon glyphicon-inbox"></i>												
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
														 <i class="glyphicon glyphicon-inbox"></i>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter FirstName" id="firstName" name="firstName" value="" />
												</div>
											</div>
											<div class="col-sm-6">
												<div class="row">
													<div class="col-sm-6">
														<div class="input-group">
															<span class="input-group-addon">
																 <i class="glyphicon glyphicon-inbox"></i>												
															</span>
															<input type="text" class="form-control" placeHolder="Enter Home" id="home" name="home" value="" />
														</div>
													</div>
													<div class="col-sm-6">
														<div class="input-group">
													<span class="input-group-addon">
														 <i class="glyphicon glyphicon-inbox"></i>												
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
														 <i class="glyphicon glyphicon-inbox"></i>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter LastName" id="lastName" name="lastName" value="" />
												</div>
											</div>
											<div class="col-sm-6">
												<div class="row">
													<div class="col-sm-6">
														<div class="input-group">
													<span class="input-group-addon">
														 <i class="glyphicon glyphicon-inbox"></i>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Cellular" id="cellular" name="cellular" value="" />
													</div>
													</div>
													<div class="col-sm-6">
													<div class="input-group">
													<span class="input-group-addon">
														 <i class="glyphicon glyphicon-inbox"></i>												
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
														 <i class="glyphicon glyphicon-inbox"></i>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Address" id="address" name="address" value="" />
												</div>
											</div>	
											<div class="col-sm-6">
												<div class="input-group">
													<span class="input-group-addon">
														 <i class="glyphicon glyphicon-list-alt"></i>												
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
														 <i class="glyphicon glyphicon-inbox"></i>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter City" id="city" name="city" value="" />
												</div>
											</div>	
											<div class="col-sm-6">
												<div class="input-group">
													<span class="input-group-addon">
														 <i class="glyphicon glyphicon-list-alt"></i>												
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
														 <i class="glyphicon glyphicon-inbox"></i>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Zip" id="zip" name="postalCode" value="" />
													</div>
													</div>
													<div class="col-sm-6">
													<div class="input-group">
													<span class="input-group-addon">
														 <i class="glyphicon glyphicon-inbox"></i>												
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
															 <i class="glyphicon glyphicon-list-alt"></i>												
														</span>
														<select class="form-control" name="categoryId" id="categoryId">
														</select>
													</div>
													</div>
													<div class="col-sm-6">
													<div class="input-group">
														<span class="input-group-addon">
															 <i class="glyphicon glyphicon-list-alt"></i>												
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
															 <i class="glyphicon glyphicon-list-alt"></i>												
														</span>
														<select class="form-control" name="statusId" id="statusId">
														</select>
													</div>
													</div>
													<div class="col-sm-6">
													<div class="input-group">
														<span class="input-group-addon">
															 <i class="glyphicon glyphicon-list-alt"></i>												
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
														 <i class="glyphicon glyphicon-inbox"></i>												
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
					          <input type="button" class="btn btn-primary" data-dismiss="modal" id= "btnSave" value="Save" />
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
				<tbody>
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
							<td>${obj.pvs}</td>
							
							<td>${obj.faxNo}</td>
							<td>${obj.cellular}</td>
							<td>${obj.pager}</td>
							<td>${obj.email}</td>
							<td><a href = "#" data-toggle="modal" data-target="#myModal" onclick="checkFlag('update');onClickMethodQuestion('${obj1.questionId}')">Update</a> / <a href="deleteQues/sta/${status}/quesId/${obj1.questionId}">Change Status</a> / <a href="<c:url value='/showquestionbyid/${obj1.questionId}'/>">View Detail</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>