<%@page import="org.springframework.beans.factory.annotation.Autowired"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Categories</title>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>
<link rel="stylesheet"
	href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script
	src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<style type="text/css">
textarea{ 
  width: 100%; 
  min-width:100%; 
  max-width:100%; 

  height:360px; 
  min-height:360px;  
  max-height:360px;
}
</style>
<script src="//cdn.ckeditor.com/4.5.11/basic/ckeditor.js"></script>
</head>
<body>
	<jsp:include page="header2.jsp"></jsp:include>
	<div class="container">
		<div class="form-group">
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<div class="input-group">
							<span class="input-group-addon"> 
								<i><b>Question</b></i>
							</span>
							<input type="text" class="form-control" placeHolder="Enter Question..." id="question" name="question" value="${question}" />
						</div>
					</div>
					<div class="form-group">
						<div class="input-group">
							<span class="input-group-addon">
								<i><b>Answer</b>&nbsp;</i>
							</span>
							<textarea class="form-control" placeHolder="Enter Answer" id="answer" name="answer">${answer}</textarea>
							<script>
								CKEDITOR.replace("answer", {
									height : 320
								});
			            	</script>
						</div>
					</div>
					<div class="form-group" align="right">
						<div class="input-group">
							<input type= "button" value = "Back" class="btn btn-primary" onclick = "history.go(-1)"/>
						</div>
					</div>
				</div>
			</div>
		</div>
</div>
</body>
</html>