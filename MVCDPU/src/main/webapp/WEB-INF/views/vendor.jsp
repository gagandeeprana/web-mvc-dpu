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
		}
	}
</script>
<script type="text/javascript">
        function onClickMethodQuestion(quesId){
        	var cId = 0;
        	if(quesId != 0) {
				$.get("getQues/quesId",{"quesId" : quesId}, function(data) {
		            cId = data.categoryBean.categoryId;
	            	document.getElementById('question').value = data.question;
	            	CKEDITOR.instances['answer'].setData(data.answer);
	            	//$("#cke_1_contents").html(data.answer);
		            document.getElementById("questionid").value = data.questionId;
		            if(data.status == 1) {
		               	document.getElementById('status').selectedIndex = 0;            		
		            }
		            else {
		               	document.getElementById('status').selectedIndex = 1;            		            		
		            }
		            
		            var cats = document.getElementById("categoryId");
		            for(var i = 0;i < cats.length;i++) {
		            	if(cats[i].value == cId) {
		            		document.getElementById("categoryId").selectedIndex = i;
		            		break;
		            	}
		            } 
            	});
        	}
        }
</script>
<script src="//cdn.ckeditor.com/4.5.11/basic/ckeditor.js"></script>
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
						<form action="savevendor" method="POST" name="vendor" id="frm1">
						<input type="hidden" id = "questionid" name= "quesid" value = "" />					
						<input type="hidden" id = "addUpdateFlag" value = "" />					
	
					      <!-- Modal content-->
					      <div class="modal-content">
					        <div class="modal-header">
					          <button type="button" class="close" data-dismiss="modal">&times;</button>
					          <h4 class="modal-title"><p id ="modelTitle">Add Vendor</p></h4>
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
							<td><a href = "#" data-toggle="modal" data-target="#myModal" onclick="checkFlag('update');onClickMethodQuestion('${obj1.questionId}')">Update</a> / <a href="deleteQues/sta/${status}/quesId/${obj1.questionId}">Delete</a> / <a href="<c:url value='/showquestionbyid/${obj1.questionId}'/>">View Detail</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>