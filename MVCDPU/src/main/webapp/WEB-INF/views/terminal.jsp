<%@page import="org.springframework.beans.factory.annotation.Autowired"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Terminal</title>
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
		document.getElementById("frm1").action = "updateterminal";
		document.getElementById("btnSave").value = "Update";
		$("#modelTitle").html("Edit Terminal");
	}
	else if(field == 'add') {
		//$("#cke_1_contents").html('');
		$(":text").val("");
   		//document.getElementById('categoryId').selectedIndex = 0;
		document.getElementById("btnSave").value = "Save";
		$("#modelTitle").html("Add Terminal");
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
        		document.getElementById("locationId").innerHTML = "";
            	document.getElementById("serviceIds").innerHTML = "";
            	$.get("terminal/getopenadd", function(data) {
    	           
    	            var shipperLocation = document.getElementById("locationId");
    	            for(var i = 0;i < data.shipperList.length;i++) {
    	            	shipperLocation.options[shipperLocation.options.length] = new Option(data.shipperList[i].locationName);
    	            	shipperLocation.options[i].value = data.shipperList[i].shipperId;
    	            } 
    	            
    	            var shipperService = document.getElementById("serviceIds");
    	            for(var i = 0;i < data.serviceList.length;i++) {
    	            	shipperService.options[shipperService.options.length] = new Option(data.serviceList[i].serviceName);
    	            	shipperService.options[i].value = data.serviceList[i].serviceId;
    	            }
    	        });
        	} else {
        		$.get("getterminal/terminalId",{"terminalId" : quesId}, function(data) {
        			document.getElementById("terminalid").value = data.terminalId;
                    $("#terminalName").val(data.terminalName);
                    
                    var shipperLocation = document.getElementById("locationId");
                    var shipperList = data.shipperList;
                    for(var i = 0;i < shipperList.length;i++) {
                    	shipperLocation.options[shipperLocation.options.length] = new Option(shipperList[i].locationName);
                    	shipperLocation.options[i].value = shipperList[i].shipperId;
                    	if(shipperList[i].shipperId == data.shipperId) {
                    		document.getElementById("locationId").selectedIndex = i;
                    	}
                    }
                    
                    var shipperService = document.getElementById("serviceIds");
                    var serviceList = data.serviceList;
                    for(var i = 0;i < serviceList.length;i++) {
                    	shipperService.options[shipperService.options.length] = new Option(serviceList[i].serviceName);
                    	shipperService.options[i].value = serviceList[i].serviceId;
                    	
                    	var sId = serviceList[i].serviceId;
                    	for(var j=0;j<data.serviceIds.length;j++) {
	                    	if(sId == data.serviceIds[j]) {
	                    		$("#serviceIds > [value=" + sId + "]").attr("selected", "true");
	                    	}
                    	}
                    }
               	});
        	}
        }
        
        function clearAll() {
            $("#terminalName").val("");
        	document.getElementById("locationId").innerHTML = "";
        	document.getElementById("serviceIds").innerHTML = "";
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
						<form action="saveterminal" method="POST" name="terminal" id="frm1">
						<input type="hidden" id = "terminalid" name= "terminalid" value = "" />					
						<input type="hidden" id = "addUpdateFlag" value = "" />					
	
					      <!-- Modal content-->
					      <div class="modal-content">
					        <div class="modal-header">
					          <button type="button" class="close" data-dismiss="modal">&times;</button>
					          <h4 class="modal-title"><p id ="modelTitle">Add Terminal</p></h4>
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
												<input type="text" class="form-control" placeHolder="Enter TerminalName" id="terminalName" name="terminalName" value="" autofocus />
											</div>
											</div>
										</div>
									</div>
									<div class="form-group">
										<div class="row">
											<div class="col-sm-12">
												<div class="input-group">
													<span class="input-group-addon">
														 <i class="glyphicon glyphicon-list-alt"></i>												
													</span>
													<select class="form-control" name="shipperId" id="locationId">
													</select>
												</div>
											</div>
										</div>
									</div>
									<div class="form-group">
										<div class="row">
											<div class="col-sm-12">
												<div class="input-group">
													<span class="input-group-addon">
														 <i class="glyphicon glyphicon-list-alt"></i>												
													</span>
													<select id="serviceIds" class="form-control" multiple="multiple" name="serviceIds">
													</select>
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
						<th>Terminal</th>
						<th>Location</th>
						<th>Links</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${LIST_TERMINAL}" var="obj">
						<tr class="info">
							<td>${obj.terminalName}</td>							
							<td>${obj.shipperName}</td>
							<td><a href = "#" data-toggle="modal" data-target="#myModal" onclick="checkFlag('update');onClickMethodQuestion('${obj.terminalId}')">Update</a> / <a href="deleteterminal/${obj.terminalId}">Delete</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>