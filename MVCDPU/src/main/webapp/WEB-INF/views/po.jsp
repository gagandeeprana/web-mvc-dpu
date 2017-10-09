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
	 <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
 	 <script src="//code.jquery.com/jquery-1.12.4.js"></script>
	 <script src="//code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	 <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	 <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	 <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.min.js"></script>
	 <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/css/bootstrap-multiselect.css" />
<style type="text/css">
	.ui-front {
	    z-index: 9999;
	}
	.multiselect-container>li>a>label {
  padding: 4px 30px 3px 20px;
  margin-left:5px;
}

.multiselect-container>li{
margin-left: 10px;
}
#unitNo{
    max-height: 33px;
    max-width: 130px
}
</style>
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
function navigate() {
	var flag = $("#addUpdateFlag").val();
	if(flag == 'add') {
		createPO('savepo','POST');
	} else if(flag == 'update') {
		createPO('updatepo','PUT');			
	}
}
function createPO(urlToHit,methodType){
	 
		 if(!check()){
			 return false;
		 }

	 	var vendorId = $('#vendorId :selected').val();
	   	var unitTypeId = $('#unitTypeId :selected').val();
	   	var categoryId = $('#categoryId :selected').val();
	   	var message = $("#message").val();
	   	var poIssues = $('.poIssueIds:checkbox:checked');
	   	var unitNo = $('#unitNo').val();
	    var issueIds = new Array();
	    var issueStatusIds = new Array();
	    for(var i=0;i<poIssues.length;i++) {
	    	var valIssue = poIssues[i].value;
		   	var issueStatusId = $("#issueStatusId" + valIssue + " :selected").val();
		   	issueIds.push(valIssue);
		   	issueStatusIds.push(issueStatusId);
	    }
		
	   	var poId;
	   	if(methodType == 'PUT') {
	   		poId = $('#poid').val();
	   	}
		  $.ajax({url: BASE_URL + urlToHit,
			      async:false,
			      type:"POST",
			      data:{
			    	vendorId:vendorId,
			    	unitTypeId:unitTypeId,
			    	categoryId:categoryId,
			    	message:message,
			    	issueIds:issueIds.toString(),
			    	issueStatusIds:issueStatusIds.toString(),
			    	selectedUnitNos:unitNo.toString(),
			    	poid:poId
			      },
			      success: function(result){
		        try{
		        	$('#myModal').modal('toggle');
		        	var list = result.resultList;
					fillPOData(list);

			        toastr.success(result.message, 'Success!')
				} catch(e){
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

function fillPOData(list) {
	var tableValue = "";
	if(list.length > 0) {
		 for(var i=0;i<list.length;i++) {
			var obj = list[i];
			tableValue = tableValue + ("<tr class='info'>");
    		var poNo = "";
    		if(obj.PoNo != null) {
    			poNo = obj.PoNo;
    		}
    		var message = "";
    		if(obj.message != null) {
    			message = obj.message;
    		}
    		var categoryName = "";
    		if(obj.categoryName != null) {
    			categoryName = obj.categoryName;
    		}
    		var statusName = "";
    		if(obj.statusName != null) {
    			statusName = obj.statusName;
    		}
    		var unitTypeName = "";
    		if(obj.unitTypeName != null) {
    			unitTypeName = obj.unitTypeName;
    		}
    		var vendorName = "";
    		if(obj.vendorName != null) {
    			vendorName = obj.vendorName;
    		}
    		
    		tableValue = tableValue + ("<td>"+(poNo)+"</td>");
    		tableValue = tableValue + ("<td>"+(message)+"</td>");
    		tableValue = tableValue + ("<td>"+(categoryName)+"</td>");
    		tableValue = tableValue + ("<td>"+(statusName)+"</td>");
    		tableValue = tableValue + ("<td>"+(unitTypeName)+"</td>");
    		tableValue = tableValue + ("<td>"+(vendorName)+"</td>");
    		tableValue = tableValue + "<td><a href = '#' data-toggle='modal' data-target='#myModal'  onclick=checkFlag('update');onClickMethodQuestion('"+(obj.id)+"')>Update</a> / <a href='#' onclick=deletePO('"+(obj.id)+"')>Delete</a>";
    		if($("#statusFlag").val() == 'Complete') {
	    		tableValue = tableValue + " / <a href='#' data-toggle='modal' data-target='#invoiceModal' onclick=pastePoNo('"+(poNo)+"');pastePoIdAndStatusId('"+(obj.id)+"','"+(obj.invoiceStatusId)+"')>Change to Invoice</a>";	    			
    		}
    		if(obj.isComplete == true) {
    			tableValue = tableValue + " / <a href='#' onclick=changeStatusToComplete('"+ (obj.id) + "','" + (obj.completeStatusId) + "') id='changeStatus'>Change to Complete</a>";
    		}
    		tableValue = tableValue + ("</td></tr>");
		}
		$("#poData").html(tableValue);
	} else {
		$("#poData").html("No records found.");		
	}
}

function deletePO(terminalId){
	  $.ajax({url: BASE_URL + "deletepo/" + terminalId,
		      type:"GET",
		      success: function(result){
	    	  try{	
					var list = result.resultList;
					fillPOData(list);
					
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
		$("#btnActive").css('background','pink');
		$("#btnInvoiced").css('background','white');
		$("#btnComplete").css('background','white');
		$("#btnActive").click(function () {
			showActivePOs();
			$("#btnActive").css('background','pink');
			$("#btnInvoiced").css('background','white');
			$("#btnComplete").css('background','white');
			$("#statusFlag").val("Active");
		});
		$('#message').keyup(function() {
		    if($('#message').val().length > 200) {
				toastr.error('Only 200 words allowed', 'Error!')
				return false;
		    }
		});
		if($("#statusFlag").val() == 'Active') {
			$("#btnActive").focus();
			/* $("#btnComplete").addClass("btn btn-default"); 
			$("#btnInvoiced").addClass("btn btn-default"); */
		}
		$("#btnComplete").click(function () {
			$("#btnActive").css('background','white');
			$("#btnInvoiced").css('background','white');
			$("#btnComplete").css('background','pink');
			showCompletePOs();
			$("#statusFlag").val("Complete");
		});
		
		$("#btnInvoiced").click(function () {
			$("#btnActive").css('background','white');
			$("#btnInvoiced").css('background','pink');
			$("#btnComplete").css('background','white');
			showInvoicedPOs();
			$("#statusFlag").val("Invoiced");
		});
		if($("#statusFlag").val() == 'Complete') {
			$("#btnComplete").focus();
		}
		var url = window.location.href;
		if(url.indexOf("Active") > 0) {
			$("#btnActive").removeClass("btn btn-default").addClass("btn btn-info");
			$("#btnComplete").addClass("btn btn-default"); 
			$("#btnInvoiced").addClass("btn btn-default");
		}
		
		if(url.indexOf("Complete") > 0) {
			$("#btnActive").addClass("btn btn-default"); 
			$("#btnComplete").removeClass("btn btn-default").addClass("btn btn-info"); 
			$("#btnInvoiced").addClass("btn btn-default"); 
		}
		
		$('#btnSearch').click(function(){
			$("#frmSearch").change(function() {
			  $("#frmSearch").attr("action", "showques");
			});
			$('#frmSearch').submit();
		});
	});
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

function showIssueDetail(quesId) {
	$("#title").val("");
    $("#description").val("");
	document.getElementById("vmcId").innerHTML = "";
	document.getElementById("unitType").innerHTML = "";
	document.getElementById("issueCategory").innerHTML = "";
	document.getElementById("unitNo").innerHTML = "";
	document.getElementById("reportedBy").innerHTML = "";
	document.getElementById("status").innerHTML = "";
	$.get("getissue/issueId",{"issueId" : quesId}, function(data) {
        
		$("#title").val(data.title);
        $("#description").val(data.description);
        
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
		var editInitialValue = "";
		
		var issuesFroDropDown;
		function getUnitNo() {
			var unitTypeId = $('#unitTypeId :selected').val();
			var categoryId = $('#categoryId :selected').val();
			if(unitTypeId > 0 && categoryId > 0 ) {
				
				$.get("<%=request.getContextPath()%>" + "/po/getissues/category/"+ categoryId + "/unittype/" + unitTypeId, function(issuesResponse) {
	 	           
					issuesFroDropDown = issuesResponse;
		            if(issuesResponse.length > 0) {
		            	var tableValue = "";
						$("#mainDiv").show();
		            	for(var i=0;i<issuesResponse.length;i++) {
		            		var obj = issuesResponse[i];
		            		if($("#addUpdateFlag").val() == 'update') {
			            		if(!editIssueIds.includes(obj.id)) {
				            		tableValue = tableValue + ("<tr class='info'>");
				            		tableValue = tableValue + ("<td><div style='margin-top: -11px;'><input type='checkbox' class='form-control poIssueIds' value='"+(obj.id)+"' id='issueId" + (obj.id) + "' name='issueIds' /></div></td>");
				            		tableValue = tableValue + ("<td><a href='#' onclick=showIssueDetail('"+(obj.id) + "') data-toggle='modal' data-target='#issueModal'>" + (obj.title)+"</a></td>");
				            		tableValue = tableValue + ("<td>"+(obj.vmcName)+"</td>");
				            		tableValue = tableValue + ("<td>"+(obj.categoryName)+"</td>");
				            		tableValue = tableValue + ("<td>"+(obj.unitTypeName)+"</td>");
				            		tableValue = tableValue + ("<td>"+(obj.unitNo)+"</td>");
				            		tableValue = tableValue + ("<td>"+(obj.reportedByName)+"</td>");
				            		tableValue = tableValue + ("<td><select class='form-control issueStatusClass' id='issueStatusId" + (obj.id)+"'><option value='-1'>Please Select</option><option value='104'>Complete</option><option value='105'>Incomplete</option><option value='106'>Assigned</option></select></td>");
				            		tableValue = tableValue + ("</tr>");
			            		}
		            		}
		            		else {
			            		tableValue = tableValue + ("<tr class='info'>");
			            		tableValue = tableValue + ("<td><div style='margin-top: -11px;'><input type='checkbox' class='form-control poIssueIds' value='"+(obj.id) + "' id='issueId" + (obj.id) + "' name='issueIds' /></div></td>");
			            		tableValue = tableValue + ("<td><a href='#' onclick=showIssueDetail('"+(obj.id) + "') data-toggle='modal' data-target='#issueModal'>"+(obj.title)+"</a></td>");
			            		tableValue = tableValue + ("<td>"+(obj.vmcName)+"</td>");
			            		tableValue = tableValue + ("<td>"+(obj.categoryName)+"</td>");
			            		tableValue = tableValue + ("<td>"+(obj.unitTypeName)+"</td>");
			            		tableValue = tableValue + ("<td>"+(obj.unitNo)+"</td>");
			            		tableValue = tableValue + ("<td>"+(obj.reportedByName)+"</td>");
			            		tableValue = tableValue + ("<td><select class='form-control issueStatusClass' id='issueStatusId" + (obj.id)+"'><option value='-1'>Please Select</option><option value='104'>Complete</option><option value='105'>Incomplete</option><option value='106'>Assigned</option></select></td>");
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
		            	toastr.error("No Open/ Deferred/ Incomplete Issue related to unittype and category exists.", 'Message!');
						$("#issuesTable").html(editInitialValue);
		            }
		            
					for(var k=0;k<issuesFroDropDown.length;k++) {
						var obj = issuesFroDropDown[k];
						$("#issueId" + obj.id).click(function (){
						    if ($(this).is(':checked') )
						   		document.getElementById("issueStatusId" + $(this).val()).selectedIndex = 3;
						});
					}
				});
			}
		}
		
		var editIssueIds = new Array();
		var editIssueHtml = "";
        function onClickMethodQuestion(quesId){
        	emptyMessageDiv();
        	clearAll();
        	if(quesId == 0) {
        		$("#mainDiv").hide();
       			$("#issueIds").html("");
       			$("#invoceNoDiv").hide();
            	$("#invoiceNo").val("");
            	$.get("<%=request.getContextPath()%>"+"/po/getopenadd", function(data) {
    	           
    	            var vendor = document.getElementById("vendorId");
    	            for(var i = 0;i < data.vendorList.length;i++) {
    	            	vendor.options[vendor.options.length] = new Option(data.vendorList[i].name);
    	            	vendor.options[i+1].value = data.vendorList[i].vendorId;
    	            }

    	           /*  var category = document.getElementById("categoryId");
    	            for(var i = 0;i < data.categoryList.length;i++) {
    	            	category.options[category.options.length] = new Option(data.categoryList[i].name);
    	            	category.options[i].value = data.categoryList[i].categoryId;
    	            } */

    	            var unitType = document.getElementById("unitTypeId");
    	            for(var i = 0;i < data.unitTypeList.length;i++) {
    	            	unitType.options[unitType.options.length] = new Option(data.unitTypeList[i].typeName);
    	            	unitType.options[i+1].value = data.unitTypeList[i].typeId;
    	            }
    	            
    	            //getUnitNo();
    	             
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
    	            	vendor.options[i+1].value = data.vendorList[i].vendorId;
                    	if(vendorList[i].vendorId == data.vendorId) {
                    		document.getElementById("vendorId").selectedIndex = i+1;
                    	}
    	            }
                    
                    var unitType = document.getElementById("unitTypeId");
                    var unitTypeList = data.unitTypeList;
                    for(var i = 0;i < unitTypeList.length;i++) {
                    	unitType.options[unitType.options.length] = new Option(unitTypeList[i].typeName);
                    	unitType.options[i+1].value = unitTypeList[i].typeId;
                    	if(unitTypeList[i].typeId == data.unitTypeId) {
                    		document.getElementById("unitTypeId").selectedIndex = i+1;
                    	}
                    }
                    
                    var category = document.getElementById("categoryId");
                    var categoryList = data.categoryList;
                    for(var i = 0;i < categoryList.length;i++) {
                    	category.options[category.options.length] = new Option(categoryList[i].name);
                    	category.options[i+1].value = categoryList[i].categoryId;
                    	if(categoryList[i].categoryId == data.categoryId) {
                    		document.getElementById("categoryId").selectedIndex = i+1;
                    	}
                    }
                    
                    
                    var unitNo = document.getElementById("unitNo");
                    var unitNos = data.allUnitNos;
                    var opt = "";
                    for(var i = 0;i < unitNos.length;i++) {
 			         	opt += "<option value='"+unitNos[i]+"' id='chk" + unitNos[i]+"'>" + unitNos[i]+"</option>"
                    }
                    

                    var selectedUnitNos = data.selectedUnitNos;

                    $("#unitNo").html(opt);
   		      		$("#unitNo").val(selectedUnitNos);
   		      		setTimeout(function(){
			         	$('#unitNo').multiselect({
				 			includeSelectAllOption: true
					 	});
   		      		})
                    var issueList = data.issueList;
	            	var tableValue = "";
					$("#issuesTable").html("");
					if(data.issueList.length > 0) {
						$("#mainDiv").show();
	    	            for(var i = 0;i < data.issueList.length;i++) {
	    	            	var obj = data.issueList[i];
	    	            	editIssueIds.push(obj.id);
		            		tableValue = tableValue + ("<tr class='info " + unitNo + "'>");
		            		var assigned,complete,incomplete;
		            		if(obj.statusName == "Assigned") {
		            			assigned = "selected";
		            			complete = "";
		            			incomplete = "";
		            		}
		            		else if(obj.statusName == "Complete") {
		            			assigned = "";
		            			complete = "selected";
		            			incomplete = "";
		            		}
		            		else if(obj.statusName == "Incomplete") {
		            			assigned = "";
		            			complete = "";
		            			incomplete = "selected";
		            		} else {
		            			assigned = "";
		            			complete = "";
		            			incomplete = "";
		            		}
		            		if((obj.statusName == "Assigned") || (obj.statusName == "Complete") || (obj.statusName == "Incomplete")) {
			            		tableValue = tableValue + ("<td><div style='margin-top: -11px;'><input type='checkbox' on class='form-control poIssueIds' value='"+(obj.id) + "' id='issueId" + (obj.id) + "' name='issueIds' checked /></div></td>");
		            		} else {
			            		tableValue = tableValue + ("<td><div style='margin-top: -11px;'><input type='checkbox' class='form-control poIssueIds' value='"+(obj.id) + "' id='issueId" + (obj.id) + "' name='issueIds' /></div></td>");		            			
		            		}
     						tableValue = tableValue + ("<td><a href='#' onclick=showIssueDetail('"+(obj.id) + "') data-toggle='modal' data-target='#issueModal'>" + (obj.title)+"</a></td>");
		            		tableValue = tableValue + ("<td>"+(obj.vmcName)+"</td>");
		            		tableValue = tableValue + ("<td>"+(obj.categoryName)+"</td>");
		            		tableValue = tableValue + ("<td>"+(obj.unitTypeName)+"</td>");
		            		tableValue = tableValue + ("<td>"+(obj.unitNo)+"</td>");
		            		tableValue = tableValue + ("<td>"+(obj.reportedByName)+"</td>");
		            		tableValue = tableValue + ("<td><select class='form-control issueStatusClass' id='issueStatusId" + (obj.id)+"'><option value='-1'>Please Select</option><option value='104' " + complete + ">Complete</option><option value='105' " + incomplete +">Incomplete</option><option value='106' " + assigned +">Assigned</option></select></td>");
		            		tableValue = tableValue + ("</tr>");
		            		
	    	            }
	    	            editIssueHtml = tableValue;
					} else {
						toastr.error("No Open/ Deferred/ Incomplete Issue related to unittype and category exists.", 'Message!');
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
                    
                    for(var i=0;i<issueList.length;i++) {
		            	var obj = issueList[i];
		     			$("#issueId" + obj.id).on('click',function (){
		     				if ($(this).is(':checked')) {
		     					document.getElementById("issueStatusId" + obj.id).selectedIndex = 3;
		     				} else {
		     					document.getElementById("issueStatusId" + obj.id).selectedIndex = 0;		     					
		     				}
		     			});
	            	}
               	}); 
        	}
        	
        	$("#unitNo").change(function() {
	        	if($("#unitNo").val() != "Please Select") {
	        		var msg = $("#msg");
	        		msg.show();
	        		var msgvalue = $("#msgvalue");
	        		msgvalue.show();
	        		msgvalue.text("Click on Go to fetch latest issues.");
	        	} 
	        	
	        	if($("#unitNo").val() == null) {
	        		var msg = $("#msg");
	        		msg.hide();
	        		var msgvalue = $("#msgvalue");
	        		msgvalue.hide();
	        		msgvalue.text("");
	        		$("#mainDiv").hide();
	            	$("#issuesTable").html("");
	        	}
        	});
        	$("#btnGo").click(function() {
        		var msg = $("#msg");
        		msg.hide();
        		var msgvalue = $("#msgvalue");
        		msgvalue.hide();
        		msgvalue.text("");        		
        	});
        }
        
        function clearAll() {
        	document.getElementById("vendorId").innerHTML = "<option>Please Select</option>";
        	document.getElementById("unitTypeId").innerHTML = "<option>Please Select</option>";        	
        	document.getElementById("categoryId").innerHTML = "<option>Please Select</option>";
        	$('#unitNo').multiselect('destroy');
       	    $("#unitNo").html("<option>Please Select</option>");
            $("#invoiceNo").val("");
            $("#message").val("");
        }
        
function check() {
	var title = $(".poIssueIds");
	var msg = $("#msg");
	var msgvalue = $("#msgvalue");
	msg.hide();
	msgvalue.val("");
	/* if(title.length == 0) {
		msg.show();
		$("#categoryId").focus();
		msgvalue.text("Assign Some Issues to PO");
		return false;
	} else if(title.length != 0){
		var issues = $(".poIssueIds");
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
	}  */
	if($('#message').val().length > 200) {
		msg.show();
		$("#message").focus();
		msgvalue.text("Only 200 words allowed in message");
		return false;

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
 function changeStatusToComplete(poId, statusId) {
	
	 $.ajax({url: BASE_URL + poId + "/complete/"+statusId,
	      type:"GET",
	      success: function(result){
   	  try{	
				var list = result.resultList;
				fillPOData(list);
				
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
 
 function pastePoNo(poNo) {
	 $("#invoicePoNo").val(poNo);
 }
 
 var invoicePoId;
 var invoiceStatusId;
 function pastePoIdAndStatusId(poId,statusId) {
	 invoicePoId=poId;
	 invoiceStatusId = statusId;
	 $("#invoicePoId").val(poId);
	 $("#invoiceStatusId").val(statusId);	 
 }
 
 function changeStatusToInvoice() {
		var poId = invoicePoId;
		var statusId = invoiceStatusId;
	 	var amount = $("#invoiceAmount").val();
	 	var invoiceNo = $("#invoiceNo").val();
	 	var invoiceDate = $("#invoiceDate").val();
	 $.ajax({url: BASE_URL + poId + "/complete/" + statusId + "/invoiced",
	      type:"GET",
	      data:{
		    	invoiceDate:invoiceDate,
		    	invoiceNo:invoiceNo,
		    	invoiceAmount:amount
		      },
	      success: function(result){
   	  try{	
      	$('#invoiceModal').modal('toggle');

				var list = result.resultList;
				fillPOData(list);
				
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

  function showCompletePOs() {
	 $.ajax({url: BASE_URL + "showpo/status/Complete",
	      type:"GET",
	      success: function(result){
  	  try{	
				var list = result;
				fillPOData(list);
				
  		  //toastr.success(result.message, 'Success!')
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
  
  function showInvoicedPOs() {
		 $.ajax({url: BASE_URL + "showpo/status/Invoiced",
		      type:"GET",
		      success: function(result){
	  	  try{	
					var list = result;
					fillPOData(list);
					
	  		  //toastr.success(result.message, 'Success!')
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
  
  function showActivePOs() {
		 $.ajax({url: BASE_URL + "showpo/status/Active",
		      type:"GET",
		      success: function(result){
	  	  try{	
	  			$("#poData").html("");
					var list = result;
					fillPOData(list);
					
	  		  //toastr.success(result.message, 'Success!')
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
 function getUnitNos() {
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
 
 function getCategories() {
	 var unitTypeName = $('#unitTypeId :selected').text();

	 if(unitTypeName != "Please Select") {
		 $.get("getcategories/unittype/"+unitTypeName, function(data) {
	      
		      var category = document.getElementById("categoryId");
		      $("#categoryId").empty();
		      category.options[0] = new Option("Please Select");		      
		      
		      if(data != null && data.length > 0) {
		    	  for(var i = 0;i < data.length;i++) {
			    	  category.options[category.options.length] = new Option(data[i].name);
			    	  category.options[i+1].value = data[i].categoryId;
			      }
		      } else {
		    	  var category = document.getElementById("categoryId");
			      $("#categoryId").empty();
			      category.options[0] = new Option("Please Select");
				  toastr.error("No such Category exist for this Unit Type", 'Error!');
		      }
		 });
	 } else {
		 var category = document.getElementById("categoryId");
	      $("#categoryId").empty();
	      category.options[0] = new Option("Please Select");
	 }
 }
 
//To-Do
function getOnlyUnitNosOnUnitTypeChange() {
 	
 	 var unitTypeId = $('#unitTypeId :selected').val();
 	 var categoryId = 0;
 	 
 	if(unitTypeId != "Please Select") {

 		$.get("<%=request.getContextPath()%>"+"/issue/getunitno/category/" + categoryId + "/unittype/" + unitTypeId, function(data) {
 	        
 			 var unitNo = document.getElementById("unitNo");
 	         $("#unitNo").empty();
 	         var opt = "";
 	         if(data.unitNos != null && data.unitNos.length > 0) {
 		         if(data.unitNos != null && data.unitNos.length > 0) {
 			         for(var i = 0;i < data.unitNos.length;i++) {
 			         	opt += "<option value='"+data.unitNos[i]+"' id='chk"+data.unitNos[i]+"'>"+data.unitNos[i]+"</option>"
 			         }
 		         } else {
 					toastr.error('No such UnitNo. exists for selected UnitType and Category', 'Error!')
 		         }
 		         
		 		 $('#unitNo').multiselect('destroy');
 		         $("#unitNo").html(opt);
 		         $('#unitNo').multiselect({
 			 		  	includeSelectAllOption: true
 				 });
 		         
 		         var issuesFroDropDown;
 		         var selectedUnitNos = [];
 		         
 		         var allUnitNos = data.unitNos;
 		        
 	         } else {
 	        	$('#unitNo').multiselect('destroy');
 				$("#unitNo").html("<option>Please Select</option>");
 	         }
 	    });
 	} else {
 		$('#unitNo').multiselect('destroy');
		$("#unitNo").html("<option>Please Select</option>");
 	}
 }

 function getOnlyUnitNos() {
 	
 	 var unitTypeId = $('#unitTypeId :selected').val();
 	 var categoryId = $('#categoryId :selected').val();
 	 
 	if(categoryId == "Please Select") {
 		categoryId = 0;
 	}
 	if(unitTypeId != "Please Select") {

 		$.get("<%=request.getContextPath()%>"+"/issue/getunitno/category/" + categoryId + "/unittype/" + unitTypeId, function(data) {
 	        
 			 var unitNo = document.getElementById("unitNo");
 	         $("#unitNo").empty();
 	         var opt = "";
 	         if(data.unitNos != null && data.unitNos.length > 0) {
 		         if(data.unitNos != null && data.unitNos.length > 0) {
 			         for(var i = 0;i < data.unitNos.length;i++) {
 			         	opt += "<option value='"+data.unitNos[i]+"' id='chk"+data.unitNos[i]+"'>"+data.unitNos[i]+"</option>"
 			         }
 		         } else {
 					toastr.error('No such UnitNo. exists for selected UnitType and Category', 'Error!')
 		         }
 		         
		 		 $('#unitNo').multiselect('destroy');
 		         $("#unitNo").html(opt);
 		         $('#unitNo').multiselect({
 			 		  	includeSelectAllOption: true
 				 });
 		         
 		         var issuesFroDropDown;
 		         var selectedUnitNos = [];
 		         
 		         var allUnitNos = data.unitNos;
 		        
 	         } else {
 	        	$('#unitNo').multiselect('destroy');
 				$("#unitNo").html("<option>Please Select</option>");
 	         }
 	    });
 	} else {
 		$('#unitNo').multiselect('destroy');
		$("#unitNo").html("<option>Please Select</option>");
 	}
 }
function functionToBeCalledOnGo() {
	
	 var unitTypeId = $('#unitTypeId :selected').val();
	 var unitNo1 = $('#unitNo').val();
	 if(unitNo1 != null) {
		 
      var issuesFroDropDown;
      $.ajax({url: BASE_URL + "/getissuesbasedonunitnoandunittype/unittypeid/" + unitTypeId,
		      async:false,
		      type:"POST",
		      data:{
		    	  selectedUnitNos:unitNo1.toString(),
		      },
		      success: function(issuesResponse){
	        try{

	        	issuesFroDropDown = issuesResponse;
	     		if(issuesResponse.length > 0) {
	     			var tableValue = "";
	     			$("#mainDiv").show();
	     			for(var i=0;i<issuesResponse.length;i++) {
	     				var obj = issuesResponse[i];
	     				if($("#addUpdateFlag").val() == 'update') {
	     					if(!editIssueIds.includes(obj.id)) {
	     						tableValue = tableValue + ("<tr class='info " + unitNo + "'>");
	     						tableValue = tableValue + ("<td><div style='margin-top: -11px;'><input type='checkbox' class='form-control poIssueIds' value='"+(obj.id)+"' id='issueId" + (obj.id) + "' name='issueIds' /></div></td>");
	     						tableValue = tableValue + ("<td><a href='#' onclick=showIssueDetail('"+(obj.id) + "') data-toggle='modal' data-target='#issueModal'>" + (obj.title)+"</a></td>");
	     						tableValue = tableValue + ("<td>"+(obj.vmcName)+"</td>");
	     						tableValue = tableValue + ("<td>"+(obj.categoryName)+"</td>");
	     						tableValue = tableValue + ("<td>"+(obj.unitTypeName)+"</td>");
	     						tableValue = tableValue + ("<td>"+(obj.unitNo)+"</td>");
	     						tableValue = tableValue + ("<td>"+(obj.reportedByName)+"</td>");
	     						tableValue = tableValue + ("<td><select class='form-control issueStatusClass' id='issueStatusId" + (obj.id)+"'><option value='-1'>Please Select</option><option value='104'>Complete</option><option value='105'>Incomplete</option><option value='106'>Assigned</option></select></td>");
	     						tableValue = tableValue + ("</tr>");
	     					}
	     				}
	     				else {
	     					tableValue = tableValue + ("<tr class='info " + unitNo + "'>");
	     					tableValue = tableValue + ("<td><div style='margin-top: -11px;'><input type='checkbox' class='form-control poIssueIds' value='"+(obj.id) + "' id='issueId" + (obj.id) + "' name='issueIds' /></div></td>");
	     					tableValue = tableValue + ("<td><a href='#' onclick=showIssueDetail('"+(obj.id) + "') data-toggle='modal' data-target='#issueModal'>"+(obj.title)+"</a></td>");
	     					tableValue = tableValue + ("<td>"+(obj.vmcName)+"</td>");
	     					tableValue = tableValue + ("<td>"+(obj.categoryName)+"</td>");
	     					tableValue = tableValue + ("<td>"+(obj.unitTypeName)+"</td>");
	     					tableValue = tableValue + ("<td>"+(obj.unitNo)+"</td>");
	     					tableValue = tableValue + ("<td>"+(obj.reportedByName)+"</td>");
	     					tableValue = tableValue + ("<td><select class='form-control issueStatusClass' id='issueStatusId" + (obj.id)+"'><option value='-1'>Please Select</option><option value='104'>Complete</option><option value='105'>Incomplete</option><option value='106'>Assigned</option></select></td>");
	     					tableValue = tableValue + ("</tr>");
	     				}
	     			}
	     			if($("#addUpdateFlag").val() == 'update') {
	     				$("#issuesTable").html(editIssueHtml + tableValue);
	     			} else {
	     				$("#mainDiv").show();
	     				$("#issuesTable").html(""+tableValue);	            		
	     			}
	     			
	     		} else {
	     			toastr.error("No Open/ Deferred/ Incomplete Issue related to unittype and category exists.", 'Message!');
	     			$("#issuesTable").html(editInitialValue);
	     		}
	     		
	     		for(var k=0;k<issuesFroDropDown.length;k++) {
	     			var obj = issuesFroDropDown[k];
	     			$("#issueId" + obj.id).click(function (){
	     				if ($(this).is(':checked')) {
	     					document.getElementById("issueStatusId" + $(this).val()).selectedIndex = 3;
	     				} else {
	     					document.getElementById("issueStatusId" + $(this).val()).selectedIndex = 0;	     					
	     				}
	     			});
	     		}
	        	
			} catch(e){
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
	 }
}
</script>

</head>
<body>
	<jsp:include page="header.jsp"></jsp:include>
	<div class="container">
	<div class="form-group">
				<div class="row">
					<div class="col-sm-12" align="center">
						<b class = "pageHeading">Purchase Order (PO)</b>
					</div>
				</div>
			</div>
		<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal" onclick="checkFlag('add'); onClickMethodQuestion('0'); emptyMessageDiv();" >Add New</button>
		<div class="form-group">
		<div class="row">
			<div class="col-sm-12" align= "center">
			<input type="hidden" id="statusFlag" value="Active"/>
	          <input type="button" class="btn btn-default" id= "btnActive" value="Active" />
	          <input type="button" class="btn btn-default" id= "btnComplete" value="Complete" />
	          <input type="button" class="btn btn-default" id= "btnInvoiced" value="Invoiced" />
			</div>			
		</div>
		<div class="row">
			<div class="col-sm-8">
					<div class="modal fade" id="myModal" role="dialog">
					    <div class="modal-dialog">
						<form id="frm1">
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
													<option>Please Select</option>
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
													<select id="unitTypeId" class="form-control" name="unitTypeId" onchange="getCategories();getOnlyUnitNosOnUnitTypeChange();">
														<option>Please Select</option>
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
													<select class="form-control" name="categoryId" id="categoryId" onchange="getOnlyUnitNos();">
														<option>Please Select</option>
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
														 <b>Unit No.</b>												
													</span>
													<!-- <input type="text" id="searchedUnitNos" name="searchedUnitNos" />
													<input type="hidden" id="searchedUnitNoshidden" /> -->
													<select id="unitNo" class="form-control" name="unitNo" multiple="multiple">
														<option>Please select</option>
													</select>
													<button type="button" class="btn btn-danger" id = "btnGo" onclick="functionToBeCalledOnGo()">Go</button>
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
																		<th>&nbsp;</th>
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
					          <input type="button" class="btn btn-primary" id= "btnNew" value="Save" onclick="navigate()" />
					    	  <!-- <input type="button" class="btn btn-primary" id= "btnExit" value="Save&Exit" /> -->
					    	  <input type="reset" class="btn btn-primary" id= "btnReset" value="Reset" />
							  <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
					        </div>
					      </div>
					      </form>
					    </div>
					  </div>
					  <div class="modal fade" id="invoiceModal" role="dialog">
					    <div class="modal-dialog">
						<form method="POST" name="po" id="frm2">
						<input type="hidden" id = "invoicePoId" value = "" />					
						<input type="hidden" id = "invoiceStatusId" value = "" />					
	
					      <!-- Modal content-->
					      <div class="modal-content">
					        <div class="modal-header">
					          <button type="button" class="close" data-dismiss="modal">&times;</button>
					          <h4 class="modal-title"><p id ="invoiceTitle">Create Invoice</p></h4>
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
													<b>PO No</b>												
												</span>
												<input type="text" class="form-control" disabled="disabled" id="invoicePoNo" name="PoNo" value="" />
											</div>
											</div>
										</div>
									</div>
									<div class="form-group">
										<div class="row">
											<div class="col-sm-12">
												<div class="input-group">
													<span class="input-group-addon">
														 <b>Invoice Amount</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter InvoiceAmount" id="invoiceAmount" name="amount" value="" />
												</div>
											</div>
										</div>
									</div>
									<div class="form-group">
										<div class="row">
											<div class="col-sm-12">
												<div class="input-group">
													<span class="input-group-addon">
														 <b>Invoice No</b>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter InvoiceNo" id="invoiceNo" name="invoiceNo" value="" />
												</div>
											</div>
										</div>
									</div>
									<div class="form-group">
										<div class="row">
											<div class="col-sm-12">
												<div class="input-group date" data-provide="datepicker">
													<span class="input-group-addon">
														 <b>Invoice Date</b>												
													</span>
													<input type="text" class="form-control datepicker" placeHolder="Enter InvoiceDate" id="invoiceDate" name="invoiceDate" value="" />
												</div>
											</div>
										</div>
									</div>
								</div>
				        	</div>
					        </div>
					        <div class="modal-footer">
					          <input type="button" class="btn btn-primary" id= "btnChangeToInvoice" value="Create" onclick="changeStatusToInvoice()" />
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
		<div class="row">
			<div class="col-sm-8">
					<div class="modal fade" id="issueModal" role="dialog">
					    <div class="modal-dialog">
					      <!-- Modal content-->
					      <div class="modal-content">
					        <div class="modal-header">
					          <button type="button" class="close" data-dismiss="modal">&times;</button>
					          <h4 class="modal-title"><p id ="modelTitle">View Issue</p></h4>
					        </div>
					        <div class="modal-body">
								<div class = "row">
								<div class="col-sm-12">
									<div class="form-group">
										<div class="row">
											<div class="col-sm-12">
												<div class="input-group ui-widget"  >
												<span class="input-group-addon">
													 <b>Title</b>												
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
													<!-- <span class="input-group-addon">
														 <b>VMC</b>												
													</span>
													<input type="text" placeHolder="Enter VMC" id="vmcId" name="vmcId" class="form-control"/>
													<input type="hidden" id="vmcIdhidden" /> -->
													<span class="input-group-addon">
														 <b>VMC</b>												
													</span>
													<select class="form-control" name="vmcId" id="vmcId">
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
														 <b>Category</b>												
													</span>
													<select id="issueCategory" class="form-control" name="categoryId" onchange="getUnitNos()">
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
														 <b>UnitNo</b>												
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
														 <b>ReportedBy</b>												
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
														 <b>Status</b>												
													</span>
													<select id="status" class="form-control" name="statusId">
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
														 <b>Description</b>												
													</span>
														<textarea class="form-control" rows="1" cols="1" placeholder="Enter Description" name="description" id = "description"></textarea>
												</div>
											</div>
										</div>
									</div>
								</div>
				        	</div>
					        </div>
					        <div class="modal-footer">
					    	  <input type="button" class="btn btn-primary" id= "btnIssueReset" value="Reset" onclick="clearAll()" />
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
				<tbody id="poData">
					<c:choose>
						<c:when test="${LIST_PO.size() > 0}" >
							<c:forEach items="${LIST_PO}" var="obj">
								<tr class="info">
									<td>${obj.poNo}</td>							
									<td>${obj.message}</td>
									<td>${obj.categoryName}</td>
									<td>${obj.statusName}</td>
									<td>${obj.unitTypeName}</td>
									<td>${obj.vendorName}</td>
									
									<td><a href = "#" data-toggle="modal" data-target="#myModal" onclick="checkFlag('update');onClickMethodQuestion('${obj.id}')">Update</a> / <a href="#" onclick="deletePO('${obj.id}')">Delete</a> 
									<c:if test="${obj.isComplete == true}">
										/ <a href="#" onclick="changeStatusToComplete('${obj.id}','${obj.completeStatusId}')" id="changeStatus">Change to Complete</a>
									</c:if>
									</td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr><td colspan="7">No records found.</td></tr>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>