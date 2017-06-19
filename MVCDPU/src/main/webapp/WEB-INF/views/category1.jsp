<%@page import="com.dpu.model.DriverReq"%>
<%@page import="java.util.List"%>
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

<style>
	.btn-file {
	    position: relative;
	    overflow: hidden;
	}
	.btn-file input[type=file] {
	    position: absolute;
	    top: 0;
	    right: 0;
	    min-width: 100%;
	    min-height: 100%;
	    font-size: 100px;
	    text-align: right;
	    filter: alpha(opacity=0);
	    opacity: 0;
	    outline: none;
	    background: white;
	    cursor: inherit;
	    display: block;
	}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		$('#btnSave').click(function(){
			/* $('#frm1').attr("enctype","multipart/form-data");
			$('#frm1').attr("method","POST");
			$('#frm1').attr("action","saveCat"); */
			$('#frm1').submit();
		});
	});
</script>

<script type="text/javascript">
	function checkFlag(field) {
		document.getElementById("addUpdateFlag").value = field;
		if(field == 'update') {
			document.getElementById("btnSave").value = "Update";
			document.getElementById("frm1").action = "updateCat";
			$("#modelTitle").html("Edit Category");		
		}
		else if(field == 'add') {
			document.getElementById("btnSave").value = "Save";			
			$("#modelTitle").html("Add New Category");		
		}
	}
</script>
<script type="text/javascript">
        function onClickMethod(catId){
        	if(catId != 0) {
				$.get("getCat/catId",{"catId" : catId}, function(data) {
	            	document.getElementById('title').value = data.title;
		            document.getElementById('categoryid').value = data.categoryId;
		            document.getElementById('fileUpload').value = data.imageName;
		            if(data.status == 1) {
		               	document.getElementById('status').selectedIndex = 0;            		
		            }
		            else {
		               	document.getElementById('status').selectedIndex = 1;            		            		
		            }
            	});
        	}
        	else {
           		document.getElementById('title').value = "";
           		document.getElementById('status').selectedIndex = 0;            		
        	}	
        }
</script>
<script>
$(function() {

	  // We can attach the `fileselect` event to all file inputs on the page
	  $(document).on('change', ':file', function() {
	    var input = $(this),
	        numFiles = input.get(0).files ? input.get(0).files.length : 1,
	        label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
	    input.trigger('fileselect', [numFiles, label]);
	  });

	  // We can watch for our custom `fileselect` event like this
	  $(document).ready( function() {
	      $(':file').on('fileselect', function(event, numFiles, label) {

	          var input = $(this).parents('.input-group').find(':text'),
	              log = numFiles > 1 ? numFiles + ' files selected' : label;

	          if( input.length ) {
	              input.val(log);
	          } else {
	              if( log ) alert(log);
	          }

	      });
	  });
	  
});
</script>
</head>
<body>
	<%
		String imagePath = "http://35.154.6.180:8080/CategoryImages/";
		pageContext.setAttribute("imagePath", imagePath);
		//List<DriverReq> lstDrivers = 
				//((List<DriverReq>) request.getAttribute("LIST_DRIVER"));
		//pageContext.setAttribute("LIST_CAT1", lstCategory);
	%>
	<jsp:include page="header.jsp"></jsp:include>
	<div class="container">
	
		<div class="row">
			<div class="col-sm-12">
				<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal" onclick="checkFlag('add');onClickMethod('0')" >Add New</button>
					<div class="modal fade" id="myModal" role="dialog">
					    <div class="modal-dialog">

					      <!-- Modal content-->
					      	<form action="saveCat" method="POST" name="cat" id="frm1" enctype = "multipart/form-data">
							<input type="hidden" id = "addUpdateFlag" value = "" />
							<input type="hidden" id = "categoryid" name = "categoryid" value = "" />					      
					      <div class="modal-content">
					        <div class="modal-header">
					          <button type="button" class="close" data-dismiss="modal">&times;</button>
					          <h4 class="modal-title"><p id ="modelTitle">Add New Category</p></h4>
											
					        </div>
					        <div class="modal-body">
					        	
								<div class = "row">
									<div class="col-sm-12">
										<div class="form-group">
											<div class="input-group">
												<span class="input-group-addon">
													 <i class="glyphicon glyphicon-inbox"></i>												
												</span>
												<input type="text" class="form-control" placeHolder="Enter CategoryName" id="title" name="title" value="" autofocus />
											</div>
										</div>
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
										<div class="form-group">
												<!-- <span class="btn btn-default btn-file">
												    Browse <input type="file">
												</span> -->
												<div class="input-group">
												<span class="input-group-addon">
													 <i class="glyphicon glyphicon-upload"></i>												
												</span>
								                <input type="text" class="form-control" readonly>
								                <label class="input-group-btn">
								                    <span class="btn btn-primary">
								                        Browse&hellip; <input type="file" name = "uploadFile" style="display: none;" multiple id = "fileUpload" value = "" />
								                    </span>
								                </label>
								            </div>
											<!--<input type = "file" name="uploadImage" id="uploadImage" class = "file" data-show-preview="false" /> -->
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
		</div>
		<div class="table-responsive">
			<table class="table table-hover table-condensed">
				<thead>
					<tr>
						<th>Title</th>
						<th>Status</th>
						<th>Links</th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${LIST_DRIVER}" var="obj" varStatus="i">
						<c:if test="${obj ne null}">
							<c:if test="${i.index%2 == 0}">
							<c:set var = "color" value = "danger"/>
							</c:if>
							<c:if test="${i.index%2 != 0}">
							<c:set var = "color" value = ""/>
							</c:if>
							<tr class="${color}">
								<td >${obj.firstName}</td>
								<td >${obj.lastName}</td>
								<c:if test="${obj1.status == 1}">
									<c:set var="status" value="0"/>
								</c:if>
								<c:if test="${obj1.status == 0}">
									<c:set var="status" value="1"/>
								</c:if>
								<td><a href = "#" data-toggle="modal" data-target="#myModal" onclick="checkFlag('update');onClickMethod('${obj1.categoryId}')">Update</a> / <a href="deleteCat/sta/${status}/catId/${obj1.categoryId}">Change Status</a></td>
								<c:choose>
									<c:when test="${obj1.imageName ne null}">
										<c:set var = "srcPath" value = "${imagePath}${obj1.title}/${obj1.imageName}"/>
									</c:when>
									<c:otherwise>
										<c:set var = "srcPath" value = "${imagePath}no-category-image.jpg"/>
									</c:otherwise>
								</c:choose>
								
								<td><img src = "${srcPath}" height = "80px" width = "70px" alt = "Image Loading..." /></td>
							</tr>
						</c:if>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>