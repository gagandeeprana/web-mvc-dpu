<%@page import="org.springframework.beans.factory.annotation.Autowired"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>PO</title>
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

  height:100px; 
  min-height:100px;  
  max-height:100px;
}
</style>
<jsp:include page="Include.jsp"></jsp:include>
 <script src="<c:url value="/resources/validations.js" />"></script>
<script type="text/javascript">
	$(document).ready(function(){
		var url = window.location.href;
		if(url.indexOf("Active")) {
			$("#btnActive").removeClass("btn btn-default").addClass("btn btn-info");
			$("#btnComplete").addClass("btn btn-default");; 
			$("#btnInvoiced").addClass("btn btn-default");; 
		}
		$("#btnNew").click(function(){
			$("#frm1").submit();
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
		document.getElementById("btnNew").value = "Update";
		//$("#btnExit").hide();
		$("#modelTitle").html("Edit PO");
	}
	else if(field == 'add') {
		//$("#cke_1_contents").html('');
		$(":text").val("");
		document.getElementById("frm1").action = '<%=request.getContextPath()%>'+"/savepo";
   		//document.getElementById('categoryId').selectedIndex = 0;
		document.getElementById("btnNew").value = "Save";
		//$("#btnExit").show();
		$("#modelTitle").html("Add PO");
	} else if (field == 'search') {
		/* document.getElementById("frm1").method = "GET";
		document.getElementById("frm1").action = "showques";
		document.getElementById("frm1").submit(); */
	}
}
</script>
<script type="text/javascript">
		var editInitialValue = "";
		function getUnitNo() {
			var unitTypeId = $('#unitTypeId :selected').val();
			var categoryId = $('#categoryId :selected').val();
			$.get('<%=request.getContextPath()%>' + "/po/getissues/category/"+categoryId+"/unittype/"+unitTypeId, function(issuesResponse) {
 	           
				//$("#issuesTable").html();
	            if(issuesResponse.length > 0) {
	            	var tableValue = "";
					//$("#mainDiv").show();
	            	for(var i=0;i<issuesResponse.length;i++) {
	            		var obj = issuesResponse[i];
	            		if($("#addUpdateFlag").val() == 'update') {
		            		if(!editIssueIds.includes(obj.id)) {
			            		tableValue = tableValue + ("<tr class='info'>");
			            		tableValue = tableValue + ("<td><div class='form-group'><input type='checkbox' class='form-control issueIds' value='"+(obj.id)+"' id='issueIds' name='issueIds' /></div></td>");
			            		tableValue = tableValue + ("<td>"+(obj.title)+"</td>");
			            		tableValue = tableValue + ("<td>"+(obj.vmcName)+"</td>");
			            		tableValue = tableValue + ("<td>"+(obj.categoryName)+"</td>");
			            		tableValue = tableValue + ("<td>"+(obj.unitTypeName)+"</td>");
			            		tableValue = tableValue + ("<td>"+(obj.unitNo)+"</td>");
			            		tableValue = tableValue + ("<td>"+(obj.reportedByName)+"</td>");
			            		tableValue = tableValue + ("<td>"+(obj.statusName)+"</td>");
			            		//tableValue = tableValue + "<td><a href = '#' data-toggle='modal' data-target='#myModal' onclick='checkFlag('update');onClickMethodQuestion('"+${obj.id}+"')>Update</a> / <a href='deleteissue/${obj.id}">Delete</a></td>"
			            		tableValue = tableValue + ("</tr>");
		            		}
	            		} else {
		            		tableValue = tableValue + ("<tr class='info'>");
		            		tableValue = tableValue + ("<td><div class='form-group'><input type='checkbox' class='form-control issueIds' value='"+(obj.id)+"' id='issueIds' name='issueIds' /></div></td>");
		            		tableValue = tableValue + ("<td>"+(obj.title)+"</td>");
		            		tableValue = tableValue + ("<td>"+(obj.vmcName)+"</td>");
		            		tableValue = tableValue + ("<td>"+(obj.categoryName)+"</td>");
		            		tableValue = tableValue + ("<td>"+(obj.unitTypeName)+"</td>");
		            		tableValue = tableValue + ("<td>"+(obj.unitNo)+"</td>");
		            		tableValue = tableValue + ("<td>"+(obj.reportedByName)+"</td>");
		            		tableValue = tableValue + ("<td>"+(obj.statusName)+"</td>");
		            		//tableValue = tableValue + "<td><a href = '#' data-toggle='modal' data-target='#myModal' onclick='checkFlag('update');onClickMethodQuestion('"+${obj.id}+"')>Update</a> / <a href='deleteissue/${obj.id}">Delete</a></td>"
		            		tableValue = tableValue + ("</tr>");
	            		}
	            	}
	            	if($("#addUpdateFlag").val() == 'update') {
		            	$("#issuesTable").html($("#issuesTable").html() + tableValue);
	            	} else {
						$("#mainDiv").show();
		            	$("#issuesTable").html(""+tableValue);	            		
	            	}
	            } else {
	            	//$("#mainDiv").hide();
					$("#issuesTable").html(editInitialValue);
	            }
			});
		}
		
		/* function showInvoiceNo() {
			if($('#statusId :selected').val() == "110") {
				$("#invoceNoDiv").show();
			} else {
				$("#invoceNoDiv").hide();				
			}
		} */

		var editIssueIds = new Array();
        function onClickMethodQuestion(quesId){
        	emptyMessageDiv();
        	clearAll();
        	if(quesId == 0) {
        		$("#mainDiv").hide();
       			$("#issueIds").html("");
       			$("#invoceNoDiv").hide();
            	$("#invoiceNo").val("");
            	$.get('<%=request.getContextPath()%>'+"/po/getopenadd", function(data) {
    	           
    	            var vendor = document.getElementById("vendorId");
    	            for(var i = 0;i < data.vendorList.length;i++) {
    	            	vendor.options[vendor.options.length] = new Option(data.vendorList[i].name);
    	            	vendor.options[i].value = data.vendorList[i].vendorId;
    	            }

    	            var category = document.getElementById("categoryId");
    	            for(var i = 0;i < data.categoryList.length;i++) {
    	            	category.options[category.options.length] = new Option(data.categoryList[i].name);
    	            	category.options[i].value = data.categoryList[i].categoryId;
    	            }

    	            var unitType = document.getElementById("unitTypeId");
    	            for(var i = 0;i < data.unitTypeList.length;i++) {
    	            	unitType.options[unitType.options.length] = new Option(data.unitTypeList[i].typeName);
    	            	unitType.options[i].value = data.unitTypeList[i].typeId;
    	            }
    	            
    	            /* var status = document.getElementById("statusId");
    	            for(var i = 0;i < data.statusList.length;i++) {
    	            	status.options[status.options.length] = new Option(data.statusList[i].typeName);
    	            	status.options[i].value = data.statusList[i].typeId;
    	            } */
    	        });
        	} else {
        		$("#mainDiv").hide();
       			$("#issueIds").html("");
       			$("#invoceNoDiv").hide();
            	$("#invoiceNo").val("");
        		$.get('<%=request.getContextPath()%>'+"/getpo/poId",{"poId" : quesId}, function(data) {
        			document.getElementById("poid").value = data.id;
                    
        			var vendor = document.getElementById("vendorId");
                    var vendorList = data.vendorList;
    	            for(var i = 0;i < data.vendorList.length;i++) {
    	            	vendor.options[vendor.options.length] = new Option(data.vendorList[i].name);
    	            	vendor.options[i].value = data.vendorList[i].vendorId;
                    	if(vendorList[i].vendorId == data.vendorId) {
                    		document.getElementById("vendorId").selectedIndex = i;
                    	}
    	            }
                    
                    var unitType = document.getElementById("unitTypeId");
                    var unitTypeList = data.unitTypeList;
                    for(var i = 0;i < unitTypeList.length;i++) {
                    	unitType.options[unitType.options.length] = new Option(unitTypeList[i].typeName);
                    	unitType.options[i].value = unitTypeList[i].typeId;
                    	if(unitTypeList[i].typeId == data.unitTypeId) {
                    		document.getElementById("unitTypeId").selectedIndex = i;
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
                    
                   /*  var status = document.getElementById("statusId");
                    var statusList = data.statusList;
    	            for(var i = 0;i < data.statusList.length;i++) {
    	            	status.options[status.options.length] = new Option(data.statusList[i].typeName);
    	            	status.options[i].value = data.statusList[i].typeId;
    	            	if(statusList[i].typeId == data.statusId) {
                    		document.getElementById("statusId").selectedIndex = i;
                    	}
    	            } */
    	            
    	           /*  var status = document.getElementById("statusId"); */
                    var issueList = data.issueList;
	            	var tableValue = "";
					$("#issuesTable").html("");
					if(data.issueList.length > 0) {
						$("#mainDiv").show();
	    	            for(var i = 0;i < data.issueList.length;i++) {
	    	            	var obj = data.issueList[i];
	    	            	editIssueIds.push(obj.id);
		            		tableValue = tableValue + ("<tr class='info'>");
		            		if(obj.statusName == "Assigned") {
			            		tableValue = tableValue + ("<td><div class='form-group'><input type='checkbox' class='form-control issueIds' value='"+(obj.id)+"' id='issueIds' name='issueIds' checked /></div></td>");
		            		} else {
			            		tableValue = tableValue + ("<td><div class='form-group'><input type='checkbox' class='form-control issueIds' value='"+(obj.id)+"' id='issueIds' name='issueIds' /></div></td>");		            			
		            		}
		            		tableValue = tableValue + ("<td>"+(obj.title)+"</td>");
		            		tableValue = tableValue + ("<td>"+(obj.vmcName)+"</td>");
		            		tableValue = tableValue + ("<td>"+(obj.categoryName)+"</td>");
		            		tableValue = tableValue + ("<td>"+(obj.unitTypeName)+"</td>");
		            		tableValue = tableValue + ("<td>"+(obj.unitNo)+"</td>");
		            		tableValue = tableValue + ("<td>"+(obj.reportedByName)+"</td>");
		            		tableValue = tableValue + ("<td>"+(obj.statusName)+"</td>");
		            		//tableValue = tableValue + "<td><a href = '#' data-toggle='modal' data-target='#myModal' onclick='checkFlag('update');onClickMethodQuestion('"+${obj.id}+"')>Update</a> / <a href='deleteissue/${obj.id}">Delete</a></td>"
		            		tableValue = tableValue + ("</tr>");
	    	            }
					}
					editInitialValue = tableValue;
	            	$("#issuesTable").html(tableValue);

                    if(data.invoiceNo != null) {
                    	$("#invoceNoDiv").show();
                    	$("#invoiceNo").val(data.invoiceNo);
                    } else {
                    	$("#invoceNoDiv").hide();
                    }

                    $("#message").val(data.message);

               	}); 
        	}
        }
        
        function clearAll() {
        	document.getElementById("vendorId").innerHTML = "";
        	document.getElementById("unitTypeId").innerHTML = "";
        	document.getElementById("categoryId").innerHTML = "";
        	/* document.getElementById("statusId").innerHTML = ""; */
            $("#invoiceNo").val("");
            $("#message").val("");
        }
</script>

<script type="text/javascript">
function check() {
	var title = $("#issueIds");
	var msg = $("#msg");
	var msgvalue = $("#msgvalue");
	msg.hide();
	msgvalue.val("");
	if(title.length == 0) {
		msg.show();
		$("#categoryId").focus();
		msgvalue.text("Assign Some Issues to PO");
		return false;
	} else if(title.length != 0){
		var issues = $(".issueIds");
		var flag = false;
		for(var i=0;i<issues.length;i++){
			if(issues[i].checked) {
				flag = true;
			}
		}
		if(!flag) {
			msg.show();
			msgvalue.text("Choose any issue");
			return false;
		}
	}
	
	var invoiceNo = $("#invoiceNo");
	var invoceNoDiv = $("#invoceNoDiv");
	if(invoceNoDiv.is(':visible') && invoiceNo.length != 0) {
		if(invoiceNo.val() == "") {
			msg.show();
			invoiceNo.focus();
			msgvalue.text("Invoice no is mandatory");
			return false;			
		}
	}
	/* $('#modal').modal('toggle'); */
	return true;
}
function emptyMessageDiv(){
	var msg = $("#msg");
	var msgvalue = $("#msgvalue");
	msg.hide();
	msgvalue.val("");
}
function changeToCompleteStatus() {
	
	 $.ajax({url: BASE_URL + "/{poId}/complete/{statusId}" + driverId,
	      type:"GET",
	      success: function(result){
   	  try{	
				var list = result.resultList;
				fillDriverData(list);
				
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

</script>

</head>
<body>
	<jsp:include page="header.jsp"></jsp:include>
	<div class="container">
		<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal" onclick="checkFlag('add'); onClickMethodQuestion('0'); emptyMessageDiv();" >Add New</button>
		<div class="form-group">
		<div class="row">
			<div class="col-sm-4">
			</div>
			<div class="col-sm-8" align= "right">
	          <input type="button" class="btn btn-default" id= "btnActive" value="Active" />
	          <input type="button" class="btn btn-default" id= "btnComplete" value="Complete" />
	          <input type="button" class="btn btn-default" id= "btnInvoiced" value="Invoiced" />
			</div>			
		</div>
		<div class="row">
			<div class="col-sm-8">
					<div class="modal fade" id="myModal" role="dialog">
					    <div class="modal-dialog">
						<form method="POST" name="po" id="frm1" onsubmit="return check()">
						<input type="hidden" id = "poid" name= "poid" value = "" />					
						<input type="hidden" id = "addUpdateFlag" value = "" />					
	
					      <!-- Modal content-->
					      <div class="modal-content">
					        <div class="modal-header">
					          <button type="button" class="close" data-dismiss="modal">&times;</button>
					          <h4 class="modal-title"><p id ="modelTitle">Add PO</p></h4>
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
											<div class="col-sm-12">
												<div class="input-group">
												<span class="input-group-addon">
													<b>Vendor</b>												
												</span>
												<select class="form-control" name="vendorId" id="vendorId">
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
														 <b>UnitType</b>												
													</span>
													<select id="unitTypeId" class="form-control" name="unitTypeId">
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
														 <b>Category</b>												
													</span>
													<select class="form-control" name="categoryId" id="categoryId" onchange="getUnitNo()">
													</select>
												</div>
											</div>
										</div>
									</div>
									<div class="form-group" style="display: none;" id="mainDiv">
										<div class="row">
											<div class="col-sm-12">
												<div class="input-group">
													<div class="container">
														<div class="table-responsive">
															<table class="table table-striped table-hover table-condensed">
																<thead>
																	<tr>
																		<th></th>
																		<th>Title</th>
																		<th>VMC</th>
																		<th>Category</th>
																		<th>Unit Type</th>
																		<th>UnitNo</th>
																		<th>ReportedBy</th>
																		<th>Status</th>
																	</tr>
																</thead>
																<tbody id = "issuesTable">
																
																</tbody>
															</table>
														</div>
													</div>								
												</div>
											</div>
										</div>
									</div>
									<!-- <div class="form-group" id="statusDiv">
										<div class="row">
											<div class="col-sm-12">
												<div class="input-group">
													<span class="input-group-addon">
														 <b>Status</b>												
													</span>
													<select id="statusId" class="form-control" name="statusId" onchange="showInvoiceNo()">
													</select>
												</div>
											</div>
										</div>
									</div> -->
									<div class="form-group" style="display: none;" id = "invoceNoDiv">
										<div class="row">
											<div class="col-sm-12">
												<div class="input-group">
													<span class="input-group-addon">
													 <b>InvoiceNo</b>												
												</span>
												<input type="text" class="form-control" placeHolder="Enter InvoiceNo" id="invoiceNo" name="invoiceNo" value="" />
												</div>
											</div>
										</div>
									</div>
									<div class="form-group">
										<div class="row">
											<div class="col-sm-12">
												<div class="input-group">
													<span class="input-group-addon">
														 <b>Message</b>												
													</span>
													<textarea class="form-control" rows="1" cols="1" placeholder="Enter Message" name="message" id = "message"></textarea>
												</div>
											</div>
										</div>
									</div>
								</div>
				        	</div>
					        </div>
					        <div class="modal-footer">
					          <input type="button" class="btn btn-primary" id= "btnNew" value="Save" />
					    	  <!-- <input type="button" class="btn btn-primary" id= "btnExit" value="Save&Exit" /> -->
					    	  <input type="reset" class="btn btn-primary" id= "btnReset" value="Reset" />
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
						<th>PO No.</th>
						<th>Title</th>
						<th>Category</th>
						<th>Status</th>
						<th>UnitType</th>
						<th>Vendor</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${LIST_PO}" var="obj">
						<tr class="info">
							<td>${obj.poNo}</td>							
							<td>${obj.message}</td>
							<td>${obj.categoryName}</td>
							<td>${obj.statusName}</td>
							<td>${obj.unitTypeName}</td>
							<td>${obj.vendorName}</td>
							
							<td><a href = "#" data-toggle="modal" data-target="#myModal" onclick="checkFlag('update');onClickMethodQuestion('${obj.id}')">Update</a> / <a href="deletepo/${obj.id}">Delete</a> 
							<c:if test="${obj.isComplete == true}">
								/ <a href="#" id="changeStatus">Change to Complete</a>
							</c:if>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>