<%@page import="org.springframework.beans.factory.annotation.Autowired"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Trailer</title>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@page isELIgnored="false"%>
<link rel="stylesheet"
	href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
	<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
  	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
 	<link rel = "stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.7.0/css/bootstrap-datepicker.css"/>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.7.0/js/bootstrap-datepicker.js"></script>
  	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
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
        	document.getElementById("trailerTypeId").innerHTML = "";
        	$.get("trailer/getopenadd", function(data) {
	           
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
	            
	            var trailerType = document.getElementById("trailerTypeId");
	            for(var i = 0;i < data.trailerTypeList.length;i++) {
	            	trailerType.options[trailerType.options.length] = new Option(data.trailerTypeList[i].typeName);
	            	trailerType.options[i].value = data.trailerTypeList[i].typeId;
	            }
	        });
        }
</script>
<script>
$(document).ready(function(){
$('.datepicker').datepicker({
    format: "dd/mm/yyyy",
    autoclose: true,
}).on('changeDate', function (ev) {
    $(this).datepicker('hide');
});
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
						<form action="savetrailer" method="POST" name="trailer" id="frm1">
						<input type="hidden" id = "questionid" name= "quesid" value = "" />					
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
												<input type="password" class="form-control" placeHolder="Enter Email" id="email" name="email" value="" />
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
												<input type="password" class="form-control" placeHolder="Enter Phone" id="phone" name="phone" value="" />
											</div>
											</div>
										</div>
									</div>
									
									<div class="form-group">
										<div class="row">
											<div class="col-sm-12">
												<div class="input-group date" data-provide="datepicker">
											    <input type="text" class="form-control datepicker">
											    <div class="input-group-addon">
											        <span class="glyphicon glyphicon-th"></span>
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
							<td>${obj.hiringDate}</td>
							<td>${obj.terminationDate}</td>
							<td><a href = "#" data-toggle="modal" data-target="#myModal" onclick="checkFlag('update');onClickMethodQuestion('${obj1.questionId}')">Update</a> / <a href="deleteQues/sta/${status}/quesId/${obj1.questionId}">Change Status</a> / <a href="<c:url value='/showquestionbyid/${obj1.questionId}'/>">View Detail</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>