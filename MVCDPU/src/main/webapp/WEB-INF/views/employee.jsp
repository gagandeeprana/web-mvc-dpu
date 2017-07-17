<%@page import="org.springframework.beans.factory.annotation.Autowired"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Users</title>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@page isELIgnored="false"%>
<link rel="stylesheet"
	href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
	<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	<!-- <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
  	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script> -->
 	<link rel = "stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.7.0/css/bootstrap-datepicker.css"/>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.7.0/js/bootstrap-datepicker.js"></script>
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
		document.getElementById("frm1").action = "updateuser";
		document.getElementById("btnSave").value = "Update";
		$("#modelTitle").html("Edit User");
	}
	else if(field == 'add') {
		//$("#cke_1_contents").html('');
		$(":text").val("");
   		//document.getElementById('categoryId').selectedIndex = 0;
		document.getElementById("btnSave").value = "Save";
		$("#modelTitle").html("Add User");
	} else if (field == 'search') {
		/* document.getElementById("frm1").method = "GET";
		document.getElementById("frm1").action = "showques";
		document.getElementById("frm1").submit(); */
	}
}
</script>
<script type="text/javascript">
        function onClickMethodQuestion(quesId){
        	
        	clearAll();
        	if(quesId == 0) {
				// nothing to do on openadd.. may to be added later on..
        	} else {
        		$.get("getuser/userId",{"userId" : quesId}, function(data) {
        			document.getElementById("employeeid").value = data.employeeId;
                   	$("#firstName").val(data.firstName);
                   	$("#lastName").val(data.lastName);
                   	$("#jobTitle").val(data.jobTitle);
                   	$("#username").val(data.username);
                   	$("#password").val("*********");
                   	$("#password").prop("readonly", true);                 	
                   	$("#email").val(data.email);
                   	$("#phone").val(data.phone);
                   	var hrDt = data.hiringdate;
                   	var hrArr = hrDt.split("-");
                   	$("#hiringDate").val(hrArr[1]+"/"+hrArr[2]+"/"+hrArr[0]);
                   	var trDt = data.terminationdate;
                   	var trArr = trDt.split("-");
                   	$("#terminationDate").val(trArr[1]+"/"+trArr[2]+"/"+trArr[0]);
               	});
        	}
        }
        
        function clearAll() {
           	$("#firstName").val("");
           	$("#lastName").val("");
           	$("#jobTitle").val("");
           	$("#username").val("");
           	$("#password").val("");
           	$("#email").val("");
           	$("#phone").val("");
           	$("#hiringDate").val("");
           	$("#terminationDate").val("");
        }
</script>
<script>
$(document).ready(function(){
	$('.datepicker').datepicker({
		dateFormat: "yy-mm-dd"
	})
});
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
						<form action="saveuser" method="POST" name="user" id="frm1">
						<input type="hidden" id = "employeeid" name= "employeeid" value = "" />					
						<input type="hidden" id = "addUpdateFlag" value = "" />					
	
					      <!-- Modal content-->
					      <div class="modal-content">
					        <div class="modal-header">
					          <button type="button" class="close" data-dismiss="modal">&times;</button>
					          <h4 class="modal-title"><p id ="modelTitle">Add User</p></h4>
					        </div>
					        <div class="modal-body">
								<div class = "row">
								<div class="col-sm-12">
									<div class="form-group">
										<div class="row">
											<div class="col-sm-12">
												<div class="input-group">
												<span class="input-group-addon">
													 <i class="glyphicon glyphicon-inbox"></i>												
												</span>
												<input type="text" class="form-control" placeHolder="Enter FirstName" id="firstName" name="firstName" value="" autofocus />
											</div>
											</div>
										</div>
									</div>
									
									<div class="form-group">
										<div class="row">
											<div class="col-sm-12">
												<div class="input-group">
												<span class="input-group-addon">
													 <i class="glyphicon glyphicon-inbox"></i>												
												</span>
												<input type="text" class="form-control" placeHolder="Enter LastName" id="lastName" name="lastName" value="" />
											</div>
											</div>
										</div>
									</div>
									<div class="form-group">
										<div class="row">
											<div class="col-sm-12">
												<div class="input-group">
												<span class="input-group-addon">
													 <i class="glyphicon glyphicon-inbox"></i>												
												</span>
												<input type="text" class="form-control" placeHolder="Enter JobTitle" id="jobTitle" name="jobTitle" value="" />
											</div>
											</div>
										</div>
									</div>
									
									<div class="form-group">
										<div class="row">
											<div class="col-sm-12">
												<div class="input-group">
												<span class="input-group-addon">
													 <i class="glyphicon glyphicon-inbox"></i>												
												</span>
												<input type="text" class="form-control" placeHolder="Enter Username" id="username" name="username" value="" />
											</div>
											</div>
										</div>
									</div>

									<div class="form-group">
										<div class="row">
											<div class="col-sm-12">
												<div class="input-group">
												<span class="input-group-addon">
													 <i class="glyphicon glyphicon-inbox"></i>												
												</span>
												<input type="password" class="form-control" placeHolder="Enter Password" id="password" name="password" value="" />
											</div>
											</div>
										</div>
									</div>
									
									<div class="form-group">
										<div class="row">
											<div class="col-sm-12">
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
											<div class="col-sm-12">
												<div class="input-group">
												<span class="input-group-addon">
													 <i class="glyphicon glyphicon-inbox"></i>												
												</span>
												<input type="text" class="form-control" placeHolder="Enter Phone" id="phone" name="phone" value="" />
											</div>
											</div>
										</div>
									</div>
									
									<div class="form-group">
										<div class="row">
											<div class="col-sm-12">
												<div class="input-group date" data-provide="datepicker">
											    <div class="input-group-addon">
											        <span class="glyphicon glyphicon-th"></span>
											    </div>
											    <input type="text" class="form-control datepicker" placeHolder = " Hiring Date" name="hiringdate" id="hiringDate">
											</div>
										</div>
									</div>
								</div>
									
									<div class="form-group">
										<div class="row">
											<div class="col-sm-12">
												<div class="input-group date" data-provide="datepicker">
											    <div class="input-group-addon">
											        <span class="glyphicon glyphicon-th"></span>
											    </div>
											    <input type="text" class="form-control datepicker" placeHolder = " Termination Date" name = "terminationdate" id ="terminationDate">
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
						<th>FirstName</th>
						<th>LastName</th>
						<th>Job Title</th>
						<th>Username</th>
						<th>Email</th>
						<th>Phone</th>
						<th>Hiring Date</th>
						<th>Termination Date</th>
						<th>Links</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${LIST_EMPLOYEE}" var="obj">
						<tr class="info">
							<td>${obj.firstName}</td>							
							<td>${obj.lastName}</td>
							<td>${obj.jobTitle}</td>
							<td>${obj.username}</td>
							<td>${obj.email}</td>
							<td>${obj.phone}</td>
							<td>${obj.hiringdate}</td>
							<td>${obj.terminationdate}</td>
							<td><a href = "#" data-toggle="modal" data-target="#myModal" onclick="checkFlag('update');onClickMethodQuestion('${obj.employeeId}')">Update</a> / <a href="deleteuser/${obj.employeeId}">Delete</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>