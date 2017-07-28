<%@page import="org.springframework.beans.factory.annotation.Autowired"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Issue</title>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@page isELIgnored="false"%>
<link rel="stylesheet"
	href=" //maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
 <script src=" //code.jquery.com/jquery-1.12.4.js"></script>
<script src=" //code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script
	src=" //maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	 <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
 	<!--  <script type="text/javascript" src="/WEB-INF/bootstrap-typeahead.js">
 	</script>-->
  
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
.ui-autocomplete{
z-index: 99999!important;
}

</style>
<script type="text/javascript">
	$(document).ready(function(){
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
		document.getElementById("frm1").action = "updateissue";
		document.getElementById("btnNew").value = "Update";
		//$("#btnExit").hide();
		$("#modelTitle").html("Edit Issue");
	}
	else if(field == 'add') {
		//$("#cke_1_contents").html('');
		$(":text").val("");
   		//document.getElementById('categoryId').selectedIndex = 0;
		document.getElementById("btnNew").value = "Save&New";
		//$("#btnExit").show();
		$("#modelTitle").html("Add Issue");
	} else if (field == 'search') {
		/* document.getElementById("frm1").method = "GET";
		document.getElementById("frm1").action = "showques";
		document.getElementById("frm1").submit(); */
	}
}
</script>

<script type="text/javascript">

		function getUnitNo() {
			var unitTypeId = $('#unitType :selected').val();
			var categoryId = $('#issueCategory :selected').val();
			$.get("issue/getunitno/category/"+categoryId+"/unittype/"+unitTypeId, function(data) {
 	           
	            var unitNo = document.getElementById("unitNo");
	            $("#unitNo").empty();
	            for(var i = 0;i < data.unitNos.length;i++) {
	            	unitNo.options[unitNo.options.length] = new Option(data.unitNos[i]);
	            	unitNo.options[i].value = data.unitNos[i];
	            }
			});
		}

        function onClickMethodQuestion(quesId){
        	emptyMessageDiv();
        	clearAll();
        	if(quesId == 0) {
            	$.get("issue/getopenadd", function(data) {
            		
    	            var vmc = document.getElementById("vmcId");
    	           	var countries = "['Andorra','United Arab Emirates','Afghanistan']"

    	                // applied typeahead to the text input box
    	               /* $('#vmcId').typeahead({

    	                  // data source
    	                  source: countries,

    	                  // max item numbers list in the dropdown
    	                  limit: 10
    	                });
    	            */
    	            
    	           	 var arrList = []
    	           	for(var i=0;i<data.vmcList.length;i++){
    	           		arrList.push({label:data.vmcList[i]['name'],value:data.vmcList[i]['id']})
    	           	}
    	           	
    	        	$("#vmcId").autocomplete({
   	        	      source: arrList,
   	        	   minLength: 0,	 
		   	        	
   	        	      select: function (event, ui) {
   	        	    	   $( "#vmcId" ).val( ui.item.label );
   	        	           $("#vmcIdhidden").val(ui.item.value); 
   	        	    		return false;
   	        	           
   	        	        }
   	        	    }).autocomplete("instance")._renderItem = function(ul, item) {
   	        	      return $( "<li>" )
   	        	        .append("<div>" + item.label + "</div>")
   	        	        .appendTo(ul);
   	        	    }; 
            	
            	
    	            var unitType = document.getElementById("unitType");
    	            for(var i = 0;i < data.unitTypeList.length;i++) {
    	            	unitType.options[unitType.options.length] = new Option(data.unitTypeList[i].typeName);
    	            	unitType.options[i].value = data.unitTypeList[i].typeId;
    	            }
    	            
    	            var reportedBy = document.getElementById("reportedBy");
    	            for(var i = 0;i < data.reportedByList.length;i++) {
    	            	reportedBy.options[reportedBy.options.length] = new Option(data.reportedByList[i].fullName);
    	            	reportedBy.options[i].value = data.reportedByList[i].driverId;
    	            }
    	            
    	            var category = document.getElementById("issueCategory");
    	            for(var i = 0;i < data.categoryList.length;i++) {
    	            	category.options[category.options.length] = new Option(data.categoryList[i].name);
    	            	category.options[i].value = data.categoryList[i].categoryId;
    	            }
    	            
    	            var status = document.getElementById("status");
    	            for(var i = 0;i < data.statusList.length;i++) {
    	            	status.options[status.options.length] = new Option(data.statusList[i].typeName);
    	            	status.options[i].value = data.statusList[i].typeId;
    	            }
    	            
    	        });
        	} else {
        		 $.get("getissue/issueId",{"issueId" : quesId}, function(data) {
        			document.getElementById("issueid").value = data.id;
                    $("#title").val(data.title);
                    
                    var vmc = document.getElementById("vmcId");
                    var vmcList = data.vmcList;
                    for(var i = 0;i < vmcList.length;i++) {
                    	vmc.options[vmc.options.length] = new Option(vmcList[i].name);
                    	vmc.options[i].value = vmcList[i].id;
                    	if(vmcList[i].id == data.vmcId) {
                    		document.getElementById("vmcId").selectedIndex = i;
                    	}
                    }
                    
                    var unitType = document.getElementById("unitType");
                    var unitTypeList = data.unitTypeList;
                    for(var i = 0;i < unitTypeList.length;i++) {
                    	unitType.options[unitType.options.length] = new Option(unitTypeList[i].typeName);
                    	unitType.options[i].value = unitTypeList[i].typeId;
                    	if(unitTypeList[i].typeId == data.unitTypeId) {
                    		document.getElementById("unitType").selectedIndex = i;
                    	}
                    }
                    
                    var category = document.getElementById("issueCategory");
                    var categoryList = data.categoryList;
                    for(var i = 0;i < categoryList.length;i++) {
                    	category.options[category.options.length] = new Option(categoryList[i].name);
                    	category.options[i].value = categoryList[i].categoryId;
                    	if(categoryList[i].categoryId == data.categoryId) {
                    		document.getElementById("issueCategory").selectedIndex = i;
                    	}
                    }
                    
                    var unitNo = document.getElementById("unitNo");
                    var unitNos = data.unitNos;
                    for(var i = 0;i < unitNos.length;i++) {
                    	unitNo.options[unitNo.options.length] = new Option(unitNos[i]);
                    	unitNo.options[i].value = unitNos[i];
                    	if(unitNos[i] == data.unitNo) {
                    		document.getElementById("unitNo").selectedIndex = i;
                    	}
                    }
                    
                    var reportedBy = document.getElementById("reportedBy");
                    var reportedByList = data.reportedByList;
                    for(var i = 0;i < reportedByList.length;i++) {
                    	reportedBy.options[reportedBy.options.length] = new Option(reportedByList[i].fullName);
                    	reportedBy.options[i].value = reportedByList[i].driverId;
                    	if(reportedByList[i].driverId == data.reportedById) {
                    		document.getElementById("reportedBy").selectedIndex = i;
                    	}
                    }
                    
                    var status = document.getElementById("status");
                    var statusList = data.statusList;
    	            for(var i = 0;i < data.statusList.length;i++) {
    	            	status.options[status.options.length] = new Option(data.statusList[i].typeName);
    	            	status.options[i].value = data.statusList[i].typeId;
    	            	if(statusList[i].typeId == data.statusId) {
                    		document.getElementById("status").selectedIndex = i;
                    	}
    	            }
               	}); 
        	}
        }
        
        function clearAll() {
            $("#title").val("");
        	document.getElementById("vmcId").innerHTML = "";
        	document.getElementById("unitType").innerHTML = "";
        	document.getElementById("issueCategory").innerHTML = "";
        	document.getElementById("unitNo").innerHTML = "";
        	document.getElementById("reportedBy").innerHTML = "";
        	document.getElementById("status").innerHTML = "";
        }
</script>

<script type="text/javascript">
function check() {
	var title = $("#title").val();
	var msg = $("#msg");
	var msgvalue = $("#msgvalue");
	msg.hide();
	msgvalue.val("");
	if(title == "") {
		msg.show();
		msgvalue.text("Title cannot be left blank.");
		$("#title").focus();
		return false;
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
						<form action="saveissue" method="POST" name="issue" id="frm1" onsubmit="return check()">
						<input type="hidden" id = "issueid" name= "issueid" value = "" />					
						<input type="hidden" id = "addUpdateFlag" value = "" />					
	
					      <!-- Modal content-->
					      <div class="modal-content">
					        <div class="modal-header">
					          <button type="button" class="close" data-dismiss="modal">&times;</button>
					          <h4 class="modal-title"><p id ="modelTitle">Add Issue</p></h4>
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
												<div class="input-group ui-widget"  >
												<span class="input-group-addon">
													 <i class="glyphicon glyphicon-inbox"></i>												
												</span>
												<input type="text" class="form-control" placeHolder="Enter Title" id="title" name="title" value="" autofocus />
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
													<input type="text" placeHolder="Enter VMC" id="vmcId" name="vmcId"  />
													<input type="hidden" id="vmcIdhidden" />
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
													<select id="unitType" class="form-control" name="unitTypeId">
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
													<select id="issueCategory" class="form-control" name="categoryId" onchange="getUnitNo()">
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
													<select id="unitNo" class="form-control" name="unitNo">
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
													<select id="reportedBy" class="form-control" name="reportedById">
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
													<select id="status" class="form-control" name="statusId">
													</select>
												</div>
											</div>
										</div>
									</div>
								</div>
				        	</div>
					        </div>
					        <div class="modal-footer">
					          <input type="button" class="btn btn-primary" id= "btnNew" value="Save&New" />
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
						<th>Title</th>
						<th>VMC</th>
						<th>Type</th>
						<th>UnitNo</th>
						<th>ReportedBy</th>
						<th>Status</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${LIST_ISSUE}" var="obj">
						<tr class="info">
							<td>${obj.title}</td>							
							<td>${obj.vmcName}</td>
							<td>${obj.unitTypeName}</td>
							<td>${obj.unitNo}</td>
							<td>${obj.reportedByName}</td>
							<td>${obj.statusName}</td>
							<td><a href = "#" data-toggle="modal" data-target="#myModal" onclick="checkFlag('update');onClickMethodQuestion('${obj.id}')">Update</a> / <a href="deleteissue/${obj.id}">Delete</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>