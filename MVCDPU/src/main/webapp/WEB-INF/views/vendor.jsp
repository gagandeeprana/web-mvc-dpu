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
	if(province == "") {
		msg.show();
		msgvalue.text("Province cannot be left blank.");
		$("#province").focus();
		return false;
	}
	if(zip == "") {
		msg.show();
		msgvalue.text("Zip cannot be left blank.");
		$("#zip").focus();
		return false;
	}
	if(afterHours == "") {
		msg.show();
		msgvalue.text("AfterHours cannot be left blank.");
		$("#afterHours").focus();
		return false;
	}
	if(email == "") {
		msg.show();
		msgvalue.text("Email cannot be left blank.");
		$("#email").focus();
		return false;
	}
	if(tollFree == "") {
		msg.show();
		msgvalue.text("TollFree cannot be left blank.");
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
	if(pager == "") {
		msg.show();
		msgvalue.text("Pager cannot be left blank.");
		$("#pager").focus();
		return false;
	}
	$('#modal').modal('toggle');
	return true;
}
</script>
</head>
<body>
	<%
		/*List<QuestionBean> lstQuestions = ((List<QuestionBean>) request.getAttribute("LIST_QUES"));
		pageContext.setAttribute("LIST_QUES", lstQuestions);
		List<CategoryBean> lstCategories = ((List<CategoryBean>) request.getAttribute("LIST_CAT"));
		pageContext.setAttribute("LIST_CAT", lstCategories); */
	%>
	<jsp:include page="header.jsp"></jsp:include>
	<div class="container">
		<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal" onclick="checkFlag('add'); onClickMethodQuestion('0');" >Add New</button>
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
													 <i class="glyphicon glyphicon-inbox"></i>												
												</span>
												<input type="text" class="form-control" placeHolder="Enter VendorName" id="vendorName" name="name" value="" autofocus />
											</div>
											</div>
											<div class="col-sm-6">
												<div class="input-group">
													<span class="input-group-addon">
														 <i class="glyphicon glyphicon-inbox"></i>												
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
														 <i class="glyphicon glyphicon-inbox"></i>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Address" id="address" name="address" value="" />
												</div>
											</div>
											<div class="col-sm-6">
												<div class="input-group">
													<span class="input-group-addon">
														 <i class="glyphicon glyphicon-inbox"></i>												
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
														 <i class="glyphicon glyphicon-inbox"></i>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Ext" id="ext" name="ext" value="" />
												</div>
											</div>
											<div class="col-sm-6">
												<div class="input-group">
													<span class="input-group-addon">
														 <i class="glyphicon glyphicon-inbox"></i>												
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
														 <i class="glyphicon glyphicon-inbox"></i>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter UnitNo" id="unitNo" name="unitNo" value="" />
												</div>
											</div>
											<div class="col-sm-6">
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
														 <i class="glyphicon glyphicon-inbox"></i>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Fax" id="fax" name="fax" value="" />
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
													<input type="text" class="form-control" placeHolder="Enter Province" id="province" name="provinceState" value="" />
													</div>
													</div>
													<div class="col-sm-6">
													<div class="input-group">
													<span class="input-group-addon">
														 <i class="glyphicon glyphicon-inbox"></i>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Zip" id="zip" name="zip" value="" />
													</div>
													</div>												
												</div>
											</div>
											<div class="col-sm-6">
												<div class="input-group">
													<span class="input-group-addon">
														 <i class="glyphicon glyphicon-inbox"></i>												
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
														 <i class="glyphicon glyphicon-inbox"></i>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Email" id="email" name="email" value="" />
												</div>
											</div>
											<div class="col-sm-6">
												<div class="input-group">
													<span class="input-group-addon">
														 <i class="glyphicon glyphicon-inbox"></i>												
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
														 <i class="glyphicon glyphicon-inbox"></i>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Website" id="website" name="website" value="" />
												</div>
											</div>
											<div class="col-sm-6">
												<div class="input-group">
													<span class="input-group-addon">
														 <i class="glyphicon glyphicon-inbox"></i>												
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
														 <i class="glyphicon glyphicon-inbox"></i>												
													</span>
													<input type="text" class="form-control" placeHolder="Enter Pager" id="pager" name="pager" value="" />
												</div>
											</div>
											<div class="col-sm-6">
												<div class="form-group text-left">
													<input type="checkbox" tabindex="3" class="" name="remember" id="remember">Order
													<input type="checkbox" tabindex="3" class="" name="remember" id="remember">PickUp ETA
													<input type="checkbox" tabindex="3" class="" name="remember" id="remember">PickUp
													<input type="checkbox" tabindex="3" class="" name="remember" id="remember">Deliver ETA
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
							<td>${obj.provinceState}</td>
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