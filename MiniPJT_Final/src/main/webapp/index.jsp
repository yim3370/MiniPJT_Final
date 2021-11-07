<%@ page contentType="text/html; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<head>

<title>Model2 MVC Shop</title>

<meta charset="EUC-KR">
	
	<meta name="viewport" content="width=device-width, initial-scale=1">
	
	<!-- Latest compiled and minified CSS -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
	<!-- Optional theme -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css">
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<!-- Latest compiled and minified JavaScript -->
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	<!-- <script src="http://code.jquery.com/jquery-2.1.4.min.js"></script> -->
	<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
	<link rel="stylesheet" href="//code.jquery.com/ui/1.13.0/themes/base/jquery-ui.css">

	<script src="https://code.jquery.com/ui/1.13.0/jquery-ui.js"></script>
	<script type="text/javascript">
		$(function(){
				var isActive = true;
				 if (isActive){
					$.ajax(
							{
								url : "/product/rest/listProduct/search",
								method : "POST",
								headers : {
									"Accept" : "application/json",
									"Content-Type" : "application/json"
								},
								dataType : "json",
								data : JSON.stringify({
									currentPage : 1
								}),
								success : function(JSONData,status){
																
									var list = JSONData.list;
									var str ="";
									
									for(var i=0; i<8; i++){
										
										var temp = list[i];
										if(temp == undefined){
											isActive = false;
											break;
										}
										
										var st = '<p><a href="/purchase/addPurchaseView?prodNo='+temp.prodNo+'" id="buy" class="btn btn-danger disabled" role="button">재고없음</a> <a href="/purchase/addPurchaseCart?prodNo='+temp.prodNo+'" id="cart" class="btn btn-default disabled" role="button">장바구니</a></p>';
										if(temp.prodTotal>0){
											st = '<p><a href="/purchase/addPurchaseView?prodNo='+temp.prodNo+'" id="buy" class="btn btn-success" role="button">구매</a> <a href="/purchase/addPurchaseCart?prodNo='+temp.prodNo+'" id="cart" class="btn btn-default" role="button">장바구니</a></p>';
										}
										var stringHtml = 		
											'<div class="col-sm-6 col-md-3">'
									    	+'<div class="thumbnail">'
									    	+'<img class="image" src="/images/uploadFiles/'+temp.fileName+'" border="0px" width="240px" height="180px">'
									      	+'<div class="caption">'
									        +'<h3 class="prodName">'+temp.prodName+'</h3>'
									        +'<h4 class="price">'+temp.price+'</h4>'
									        +'<p class="prodDetail">'+temp.prodDetail+'</p>'
									      	+ st
									        +'</div></div></div>';
									   	str += stringHtml;
									}
									$('#indexForm').append('<div id="productList" class="container-fluid" style="margin: 90px;"><div class="row"><div class="col-md-1"></div><div class="col-md-10"><div class="row">'
											+ str + '</div></div><div class="col-md-1"></div></div></div>');
									isActive = true;
								}
							});
					
				var page = 1;
				
				$(window).scroll(function() {
					//console.log($(window).scrollTop());
					//console.log(e);
				    if (isActive && $(window).scrollTop() == $(document).height() - $(window).height()) {
				    	page += 1;
				    	console.log(page)
				    	$.ajax(
								{
									url : "/product/rest/listProduct/search",
									method : "POST",
									headers : {
										"Accept" : "application/json",
										"Content-Type" : "application/json"
									},
									dataType : "json",
									async : false,
									data : JSON.stringify({
										currentPage : page
									}),
									success : function(JSONData,status){
											
										var str = "";								
										var list = JSONData.list;
										for(var i=0; i<8; i++){
											
											var temp = list[i];
											console.log(temp);
											if(list[i] == undefined){
												isActive = false;
												break;
											}
											var st = '<p><a href="/purchase/addPurchaseView?prodNo='+temp.prodNo+'" id="buy" class="btn btn-danger disabled" role="button">재고없음</a> <a href="/purchase/addPurchaseCart?prodNo='+temp.prodNo+'" id="cart" class="btn btn-default disabled" role="button">장바구니</a></p>';
											if(temp.prodTotal>0){
												st = '<p><a href="/purchase/addPurchaseView?prodNo='+temp.prodNo+'" id="buy" class="btn btn-success" role="button">구매</a> <a href="/purchase/addPurchaseCart?prodNo='+temp.prodNo+'" id="cart" class="btn btn-default" role="button">장바구니</a></p>';
											}
											var stringHtml = 		
												'<div class="col-sm-6 col-md-3">'
										    	+'<div class="thumbnail">'
										    	+'<img class="image" src="/images/uploadFiles/'+temp.fileName+'" border="0px" width="240px" height="180px">'
										      	+'<div class="caption">'
										        +'<h3 class="prodName">'+temp.prodName+'</h3>'
										        +'<h4 class="price">'+temp.price+'</h4>'
										        +'<p class="prodDetail">'+temp.prodDetail+'</p>'
										        + st
										        +'</div></div></div>';
										   	str += stringHtml;
										   					   	
										}
										
										$('#indexForm').append('<div id="productList" class="container-fluid" style="margin: 90px;"><div class="row"><div class="col-md-1"></div><div class="col-md-10"><div class="row">'
										+ str + '</div></div><div class="col-md-1"></div></div></div>');		
									}
								});
				    		}
					});
				 }
				
			
			$('input[name="searchKeyword"]').keyup(function(key){
				
				var searchKeyword = $(this).val();
				var isflag = false;
				isActive = false;
				$.ajax(
					{
						url : "/product/rest/productAutoComplete/"+searchKeyword+"/1",
						method : "GET",
						headers : {
							"Accept" : "application/json",
							"Content-Type" : "application/json"
						},
						dataType:"json",
						success : function(JSONData,status){
							var availableTags = JSONData;
						
							$(function(){
								$('input[name="searchKeyword"]').autocomplete({
									source: availableTags
								});							
							});
						},
				});
				
				 if(key.keyCode==13) {	
					 $('#productList').remove();
							$.ajax(
									{
										url : "/product/rest/listProduct/search",
										method : "POST",
										headers : {
											"Accept" : "application/json",
											"Content-Type" : "application/json"
										},
										dataType : "json",
										async : false,
										data : JSON.stringify({
											currentPage : 1,
											searchKeyword : searchKeyword
										}),
										success : function(JSONData,status){								
											var list = JSONData.list;
											var str ="";
											
											for(var i=0; i<8; i++){
												
												var temp = list[i];
												if(temp == undefined){
													isflag = false;
													break;
												}
												var st = '<p><a href="/purchase/addPurchaseView?prodNo='+temp.prodNo+'" id="buy" class="btn btn-danger disabled" role="button">재고없음</a> <a href="/purchase/addPurchaseCart?prodNo='+temp.prodNo+'" id="cart" class="btn btn-default disabled" role="button">장바구니</a></p>';
												if(temp.prodTotal>0){
													st = '<p><a href="/purchase/addPurchaseView?prodNo='+temp.prodNo+'" id="buy" class="btn btn-success" role="button">구매</a> <a href="/purchase/addPurchaseCart?prodNo='+temp.prodNo+'" id="cart" class="btn btn-default" role="button">장바구니</a></p>';
												}										
												var stringHtml = 		
													'<div class="col-sm-6 col-md-3">'
											    	+'<div class="thumbnail">'
											    	+'<img class="image" src="/images/uploadFiles/'+temp.fileName+'" border="0px" width="240px" height="180px">'
											      	+'<div class="caption">'
											        +'<h3 class="prodName">'+temp.prodName+'</h3>'
											        +'<h4 class="price">'+temp.price+'</h4>'
											        +'<p class="prodDetail">'+temp.prodDetail+'</p>'
											        + st
											        +'</div></div></div>';
											   	str += stringHtml;
											}
											$('#indexForm').append('<div id="productList" class="container-fluid" style="margin: 90px;"><div class="row"><div class="col-md-1"></div><div class="col-md-10"><div class="row">'
													+ str + '</div></div><div class="col-md-1"></div></div></div>');
											isflag = true;
										}
										
							});
							$(window).scroll(function() {
								var page=1;
								if (isflag && $(window).scrollTop() == $(document).height() - $(window).height()) {
							    	page += 1;
							    	console.log(page)
							    	$.ajax(
											{
												url : "/product/rest/listProduct/search",
												method : "POST",
												headers : {
													"Accept" : "application/json",
													"Content-Type" : "application/json"
												},
												dataType : "json",
												async : false,
												data : JSON.stringify({
													currentPage : page,
													searchKeyword : searchKeyword
												}),
												success : function(JSONData,status){
													
													var str = "";								
													var list = JSONData.list;
													for(var i=0; i<8; i++){
														
														var temp = list[i];
														console.log(temp);
														if(list[i] == undefined){
															console.log('실행');
															isflag = false;
															break;
														}
														var st = '<p><a href="/purchase/addPurchaseView?prodNo='+temp.prodNo+'" id="buy" class="btn btn-danger disabled" role="button">재고없음</a> <a href="/purchase/addPurchaseCart?prodNo='+temp.prodNo+'" id="cart" class="btn btn-default disabled" role="button">장바구니</a></p>';
														if(temp.prodTotal>0){
															st = '<p><a href="/purchase/addPurchaseView?prodNo='+temp.prodNo+'" id="buy" class="btn btn-success" role="button">구매</a> <a href="/purchase/addPurchaseCart?prodNo='+temp.prodNo+'" id="cart" class="btn btn-default" role="button">장바구니</a></p>';
														}
														var stringHtml = 		
															'<div class="col-sm-6 col-md-3">'
													    	+'<div class="thumbnail">'
													    	+'<img class="image" src="/images/uploadFiles/'+temp.fileName+'" border="0px" width="240px" height="180px">'
													      	+'<div class="caption">'
													        +'<h3 class="prodName">'+temp.prodName+'</h3>'
													        +'<h4 class="price">'+temp.price+'</h4>'
													        +'<p class="prodDetail">'+temp.prodDetail+'</p>'
													       	+ st
													        +'</div></div></div>';
													   	str += stringHtml;	
													   	
													   	
													}
													
													$('#indexForm').append('<div id="productList" class="container-fluid" style="margin: 90px;"><div class="row"><div class="col-md-1"></div><div class="col-md-10"><div class="row">'
													+ str + '</div></div><div class="col-md-1"></div></div></div>');		
												}
											});
							    		}
							});
						}
			});
						
					
			$('.searchContainer').css('margin','50px');
			
			$('.search').css('display','flex');
			
			$('.thumbnail-container').css('margin','90px');
			
			$(document).on('click','#cart',function(){
				
				var href = $(this).attr('href');
				
				if(${empty user.role}){
					alert('로그인을 해주세요');
					$(this).attr('href',"/user/loginView.jsp");
				}else{
					if(confirm('상품이 담겼습니다. 장바구니로 이동하시겠습니까?') == true){
						$(this).attr('href',href);

					}else{
						$(this).attr('href','/index.jsp');
					}					
				}
			});
			
			$(document).on('click','#buy',function(){
				if(${empty user.role}){
					alert('로그인을 해주세요');
					$(this).attr('href',"/user/loginView.jsp");
				}
			});
		});
		
		
		
	</script>
	
	<style>
		body{
			padding-top:70px;
		}
	</style>
</head>
<body>

	<div class="container-fluid searchContainer">
		<div class="row">
			<div class="col-md-3"></div>
			<div class="col-md-6">
				<div class="form-group form-group-lg search">
					<input class="form-control" type="text" id="formGroupInputLarge" name="searchKeyword" value="" placeholder="SearchKeyword...">
					<input type="hidden">
				</div>
			</div>
			<div class="col-md-3"></div>
		</div>
	</div>
	
	<jsp:include page="/header.jsp"></jsp:include>
	
	<form id="indexForm">
	</form>
</body>
</html>