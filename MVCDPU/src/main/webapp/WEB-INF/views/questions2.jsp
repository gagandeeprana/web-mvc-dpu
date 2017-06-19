<%@page import="org.springframework.beans.factory.annotation.Autowired"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Question/ Answer</title>
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
			document.getElementById("btnSave").value = "Save";			
			$("#modelTitle").html("Add New Question");		
		}
		else if(field == 'search') {
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
	            	document.getElementById('answer').value = data.answer;
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
        	else {
           		document.getElementById('question').value = "";
           		document.getElementById('answer').value = "";
           		document.getElementById('status').selectedIndex = 0;            		
        	}
        }
</script>
<script>
	$(document).ready(function(){
		//alert("111");
		$('#answer').keyup(function(){
			//alert("222");
			var ans = $('#answer').val();
			if(ans.indexOf("  ") >= 0) {
				$('#answer').focus();
				$('#divMsg').show();
			}
			if(ans.indexOf("  ") < 0) {
				$('#divMsg').hide();
			}
		});
	});
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
		<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal" onclick="checkFlag('add');onClickMethodQuestion('0')" >Add New</button>
		<div class="form-group">
		<div class="row">
			<div class="col-sm-8">
					<div class="modal fade" id="myModal" role="dialog">
					    <div class="modal-dialog">
						<form action="saveQues" method="POST" name="ques" id="frm1">
						<input type="hidden" id = "questionid" name= "quesid" value = "" />					
						<input type="hidden" id = "addUpdateFlag" value = "" />					
	
					      <!-- Modal content-->
					      <div class="modal-content">
					        <div class="modal-header">
					          <button type="button" class="close" data-dismiss="modal">&times;</button>
					          <h4 class="modal-title"><p id ="modelTitle">Add New Question</p></h4>
					        </div>
					        <div class="modal-body">
								<div class = "row">
									<div class="col-sm-12">
										<div class="form-group">
											<div class="input-group">
												<span class="input-group-addon">
													 <i class="glyphicon glyphicon-inbox"></i>												
												</span>
												<input type="text" class="form-control" placeHolder="Enter Question..." id="question" name="question" value="" />
											</div>
										</div>
										<div class="form-group">
										<div class="alert alert-warning" style="display: none;" id = "divMsg">
  											<strong>Warning!</strong> Answer in Invalid Format.
										</div>
											<div class="input-group">
												<span class="input-group-addon">
													 <i class="glyphicon glyphicon-inbox"></i>												
												</span>
												<textarea class="form-control" placeHolder="Enter Answer" id="answer" name="answer"></textarea>
											</div>
										</div>
										<div class = "row">
											<div class="col-sm-4">
												<div class="form-group">
													<div class="input-group">
														<span class="input-group-addon">
															 <i class="glyphicon glyphicon-list-alt"></i>												
														</span>
														<select class="form-control" name="status" id="status">
															<option value="1">Active</option>
															<option value="0">Inactive</option>
														</select>
													</div>
												</div>
											
											</div>
											<div class="col-sm-4">
												<div class="form-group">
													<div class="input-group">
														<span class="input-group-addon">
															 <i class="glyphicon glyphicon-list"></i>												
														</span>
														<select class="form-control" name="categoryId" id="categoryId">
															<c:forEach items="${LIST_CAT}" var="obj">
																<option value="${obj.categoryId}">${obj.title}</option>
															</c:forEach>
														</select>
													</div>
												</div>
											</div>
											<div class="col-sm-4" >
												<div class="form-group">
														 <input type="button" class="btn btn-primary" style="width:40%" data-dismiss="modal" value="Save" id="btnSave" />
								  						 <button type="button" class="btn btn-default" style="width:40%" data-dismiss="modal">Close</button>
												</div>
											</div>
										</div>
									</div>
					        	</div>
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
		<div class="row">
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
		</div>
		</form>
	</div>
	<div class="container">
		<div class="table-responsive">
			<c:forEach items="${LIST_QUES}" var="obj">
				<div class="row">
					<div class="col-sm-12">
						<div class="row">
							<div class="col-sm-12 btn-info">
								<label style="font-weight: bold;color: black;">Question</label>
								<c:if test="${obj.question.length() <= 60}">
									<c:set var="ques" value="${obj.question}" />
								</c:if>
								<c:if test="${obj.question.length() > 60}">
									<c:set var="ques"
										value="${fn:substring(obj.question, 0, 59)}..." />
								</c:if>
								<p style="color: black;">${ques}</p>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<label style="font-weight: bold;">Answer</label>
								<c:if test="${obj.answer.length() <= 300}">
									<c:set var="ans" value="${obj.answer}" />
								</c:if>
								<c:if test="${obj.answer.length() > 300}">
									<c:set var="ans" value="${fn:substring(obj.answer, 0, 299)}..." />
								</c:if>
								<p style="background-color:	#FFFFE0">${ans}</p>
							</div>
						</div>
					</div>
				</div>
			</c:forEach>
		</div>
	</div>
</body>
</html>