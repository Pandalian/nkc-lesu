<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.nkang.kxmoment.util.*"%>
<%@ page import="com.nkang.kxmoment.util.MongoDBBasic"%>
<%@ page import="java.util.*,org.json.JSONObject"%>
<%
	String category = request.getParameter("category");
	String uid = request.getParameter("UID");
	String level="";
	if(uid!=null&&uid!=""){
	HashMap<String, String> res=MongoDBBasic.getWeChatUserFromOpenID(uid);
	level=res.get("level");}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>乐数启蒙-看算练习</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport" />
<script src="../Jsp/JS/fusioncharts/fusioncharts.js"></script>
<script src="../Jsp/JS/fusioncharts/fusioncharts.widgets.js"></script>
<script src="../Jsp/JS/fusioncharts/fusioncharts.theme.fint.js"></script>
<script src="../Jsp/JS/fusioncharts/fusioncharts.charts.js"></script>
<link rel="stylesheet" type="text/css"
	href="../Jsp/JS/leshu/bootstrap.min.css" />
<link href="../Jsp/JS/leshu/font-awesome/css/font-awesome.min.css"
	rel="stylesheet">
<link rel="stylesheet" type="text/css"
	href="http://www.jq22.com/jquery/jquery-ui-1.11.0.css">
<link rel="stylesheet"
	href="../Jsp/JS/speedTab/jquery-ui-slider-pips.min.css" />
<script src="../Jsp/JS/speedTab/jquery-plus-ui.min.js"></script>
<link rel="stylesheet" type="text/css"
	href="../MetroStyleFiles/sweetalert.css" />
<script src="../MetroStyleFiles/sweetalert.min.js"></script>
<script src="../Jsp/JS/speedTab/jquery-ui-slider-pips.js"></script>
<script src="../Jsp/JS/speedTab/examples.js"></script>
<link rel="stylesheet" href="../Jsp/JS/speedTab/app.min.css" />
<link rel="stylesheet" type="text/css" href="../Jsp/JS/leshu/custom.css" />
<script src="../Jsp/JS/leshu/custom.js"></script>
<style type="text/css">
#processPanel,#endPanel,#right,#wrong,#chart-container,#chart-container2 {
	display: none;
}
.form_edit {    
width: 95%;
margin-left: 4%;
}
</style>
</head>
<body>
	<div id="data_model_div" style="height: 80px">
		<i class="icon"
			style="position: absolute; top: 20px; left: 20px; z-index: 100;">
			<img class="exit" src="http://leshu.bj.bcebos.com/icon/EXIT1.png"
			style="width: 30px; height: 30px;">
		</i> <img
			style="position: absolute; top: 8px; right: 20px; z-index: 100; height: 60px;"
			class="HpLogo"
			src="http://leshu.bj.bcebos.com/standard/leshuLogo.png" alt="Logo">
		<div
			style="width: 100%; height: 80px; background: white; position: absolute; border-bottom: 4px solid #20b672;">
		</div>
	</div>
<input type="text" id="timestext" class="niput" value="" style="position: absolute;width: 30%;left: 0px;text-align: left;top: 80px;z-index: -2;">
	<section id="startPanel">
		<div class="selectPanel">
			<div class="circle start bigger">看数开始</div>
		</div>
	</section>
	<section id="processPanel">
		<div id="questionInput"  style="width:40%;margin-left:30%;margin-top: 0px;padding-top: 20px;padding-bottom:0" class="selectPanel"></div>
		<input id='answer' placeholder='请输入答案' style='border-top: 1px solid black;width: 70%;font-size:25px;color:black;' type='text' class='niput sxt' disabled />
<div class="form_edit clearfix">
				<div class="num">1</div>
				<div class="num">2</div>
				<div class="num">3</div>
				<div class="num">4</div>
				<div class="num">5</div>
				<div class="num">6</div>
				<div class="num">7</div>
				<div class="num">8</div>
				<div class="num">9</div>
				<div id="remove">删除</div>
				<div class="num">0</div>
				<div id="remove" class="end">提交</div>
				</div>
	</section>
	<section id="answerPanel" class="white intro" style="display: none;margin-top:15px;">
		<div class="selectPanel" style="margin-top: 0px;padding-top: 0;">
			<div id="right">
				<i class="fa fa-smile-o fa-3x"></i> <span
					style="font-size: 18px; display: inline-block; height: 30px; position: relative; top: -5px; margin-left: 10px;">真棒</span>
			</div>
			<div id="wrong">
				<i class="fa fa-frown-o fa-3x" style="color: #F94082;"></i> <span
					style="font-size: 18px; display: inline-block; height: 30px; position: relative; top: -5px; margin-left: 10px;">加油</span>
			</div>
			<div id="answerInput" style="width:40%;margin-left:30%;"></div>
			<div style="border-top: 1px solid black;width: 40%;margin-left: 30%;">
			<input type="text" style="width:40%;margin:0;padding:0;height:40px;text-align:right;padding-right:10px;" class="niput" value="" disabled/>
			<input id="total" type="text" style="width:50%;margin:0;padding:0;height:40px;text-align:center;font-size:25px;padding-right:10%" class="niput sxt" value="" disabled />
			</div>
		<!-- 	<div style="text-align: center; margin: 15px;">
				<input id="next" type="button" class="btn btn-primary start middleBtn"
					value="下一题">
			</div> -->
		</div>


	</section>
	<div id="chart-container2">FusionCharts will render here</div>
	<script src="../Jsp/JS/jquery-1.8.0.js"></script>
	<script>
	var uid='<%=uid%>';
	var category='<%=category%>';
	var level='<%=level%>';
	var rightQ=0;
	var wrongQ=0;
	var questions=null;
	var questionNumber=0;
	var questionObj = null;
	var answers="";
	var tempSequence = 0;
	getQuestions();
	getHistoryQuestion();
	$('.form_edit .num').click(function(){
		var oDiv = $("#answer");
		var answer=oDiv.val()+this.innerHTML;
		oDiv.val(answer);
	});
	$('#remove').click(function(){
		var oDiv = $("#answer");
		var oDivHtml = oDiv.val();
		oDiv.val(oDivHtml.substring(0,oDivHtml.length-1));
	});
	$(".start").on("click", function(){
		start();
	});
		function start() {
			if(questionNumber!=0&&questionNumber%10==0&&questionNumber<totalQuestion){
			 	$.ajax({
					type : "GET",
					url : "../AbacusQuiz/getAbacusQuizPoolBycategory",
					data : {
						category : category
					},
					cache : false,
					success : function(data) {
						if(data){
							total=data.length;

					    	$.ajax({
							type : "GET",
							url : "../AbacusQuiz/findHistoryQuizByOpenidAndCategory",
							data : {
								category : category,
								openid : uid
							},
							cache : false,
							success : function(data) {
								if(data&&data.questionSequence!=0&&data.questionSequence!=null){
									var answerArray=data.answers.split(",");
									var tempChar;
									var right=0;
									var wrong=0;
									var count=0;
									for(var i=answerArray.length-2;i>answerArray.length-12;i--){
										if(answerArray[i]!='MISS'&&answerArray[i]!=""){
											count++;
											tempChar=answerArray[i].split("/");
											if(tempChar[2]!=0){
												right++;
											}
											else{
												wrong++;
											}
										}
									}
							    	text="<p style='width:40%;float:left;height:40px;line-height:40px;'>正确：</p><input style='margin-top:0px;width:50%;height:35px;display:block;float:left;color: black;' type='text' value='"+right+"题' disabled='true'/>"
							        	+"<p style='width:40%;float:left;height:40px;line-height:40px;'>错误：</p><input style='margin-top:0px;width:50%;height:35px;display:block;float:left;color: black;' type='text' value='"+wrong+"题' disabled='true'/>";
							        var reminder="";
							        	if(right>=8){
							        		reminder="真棒!";
							        	}
							        	else{
							        		reminder="加油哦~";
							        	}

									swal({  
								        title:reminder+"休息一下吧？",  
								        text:text,
								        html:"true",
								        showConfirmButton:"true", 
										showCancelButton: true,   
										closeOnConfirm: false,  
								        confirmButtonText:"我要休息",  
								        cancelButtonText:"我要继续",
								        animation:"slide-from-top"  
								      }, 
										function(inputValue){
											if (inputValue === false){

												questionNumber++;
												$("#answer").val("");
												questionNumber=getQuestion(questionNumber);
												$("#timestext").val(questionNumber);
												$("#answerPanel").hide();
												$("#startPanel").hide();
												$("#processPanel").show();
												return false;
											}
											else{
												window.location.href = "NavigatorForBasic.jsp?UID=" + uid;
											}
								      });
								}
							}
						});
						}
					}
				});

			
			}else if(questionNumber!=0&&questionNumber%10==0&&questionNumber>=totalQuestion){

				$("#timestext").val("");
				$("#answerPanel").hide();
				$("#startPanel").hide();
				$("#processPanel").hide();
				$.ajax({
					type : "GET",
					url : "../AbacusQuiz/getAbacusQuizPoolBycategory",
					data : {
						category : category
					},
					cache : false,
					success : function(data) {
						if(data){
							total=data.length;

					    	$.ajax({
							type : "GET",
							url : "../AbacusQuiz/findHistoryQuizByOpenidAndCategory",
							data : {
								category : category,
								openid : uid
							},
							cache : false,
							success : function(data) {
								if(data&&data.questionSequence!=0&&data.questionSequence!=null){
									var answerArray=data.answers.split(",");
									var tempChar;
									var right=0;
									var wrong=0;
									var count=0;
									for(var i=answerArray.length-2;i>answerArray.length-12;i--){
										if(answerArray[i]!='MISS'&&answerArray[i]!=""){
											count++;
											tempChar=answerArray[i].split("/");
											if(tempChar[2]!=0){
												right++;
											}
											else{
												wrong++;
											}
										}
									}
							    	text="<p style='width:40%;float:left;height:40px;line-height:40px;'>正确：</p><input style='margin-top:0px;width:50%;height:35px;display:block;float:left;color: black;' type='text' value='"+right+"题' disabled='true'/>"
							        	+"<p style='width:40%;float:left;height:40px;line-height:40px;'>错误：</p><input style='margin-top:0px;width:50%;height:35px;display:block;float:left;color: black;' type='text' value='"+wrong+"题' disabled='true'/>";
									swal({  
								        title:"没有更多的题了，需要重置吗？",  
								        text:text,
								        html:"true",
								        showConfirmButton:"true", 
										showCancelButton: true,   
										closeOnConfirm: false,  
								        confirmButtonText:"是",  
								        cancelButtonText:"否",
								        animation:"slide-from-top"  
								      }, 
										function(inputValue){
								    	  if (inputValue === false){
												 return false;}
												else{$.ajax({
													type : "GET",
													url : "../AbacusQuiz/updateHistoryQuiz",
													data : {
														openID:uid,
														category : category,
														batchId:1,
														questionSequence:0,
														answers:""
													},
													cache : false,
													success : function(data) {
														if(data){
															window.location.href="ShowNumberForBasic.jsp?category="+category+"&UID="+uid;
														}
													}
												});
												}
								      });
								}
							}
						});
						}
					}
				});
			}
			
			else{
			questionNumber++;
			$("#answer").val("");
			questionNumber=getQuestion(questionNumber);
			$("#timestext").val(questionNumber);
			$("#answerPanel").hide();
			$("#startPanel").hide();
			$("#processPanel").show();}
		};

		var charQ = 0;
		var chars;
		var tempTotal = 0;
		function count(chara, oldNumer, newNumber) {
			var result;
			if (chara == '+') {
				result = oldNumer + newNumber;
			} else {

				result = oldNumer - newNumber;
			}
			return result;
		}
		function getQuestions(){
			$.ajax({
				type : "GET",
				url : "../AbacusQuiz/getAbacusQuizPoolBycategory",
				data : {
					category : category
				},
				cache : false,
				success : function(data) {
					if(data){
						questions=data;
						totalQuestion=data.length;
					}
				}
			});
		}
		function getHistoryQuestion(){
			$.ajax({
				type : "GET",
				url : "../AbacusQuiz/findHistoryQuizByOpenidAndCategory",
				data : {
					category : category,
					openid : uid
				},
				cache : false,
				success : function(data) {
					if(data&&data.questionSequence!=0&&data.questionSequence!=null){
						answers=data.answers;
						var b=parseInt(data.batchId);
						var s=parseInt(data.questionSequence);
						var ts=(b-1)*10+s;
						questionNumber=ts;
					}
				}
			});
		}

		var batchId=0;
		var sequence=0;
		var index=0;
		function getQuestion(questionNumber) {
			$("#questionInput").html("");
			if(questionNumber>totalQuestion){	

				swal({  
		        title:"没有更多的题了，需要重置吗？",  
		        text:"<input type='hidden'>",
		        html:"true",
		        showConfirmButton:"true", 
				showCancelButton: true,   
				closeOnConfirm: false,  
		        confirmButtonText:"是",  
		        cancelButtonText:"否",
		        animation:"slide-from-top"  
		      }, 
				function(inputValue){
					if (inputValue === false){
					$("#processPanel").hide();
					 return false;}
					else{$.ajax({
						type : "GET",
						url : "../AbacusQuiz/updateHistoryQuiz",
						data : {
							openID:uid,
							category : category,
							batchId:1,
							questionSequence:0,
							answers:""
						},
						cache : false,
						success : function(data) {
							if(data){
								window.location.href="ShowNumberForBasic.jsp?category="+category+"&UID="+uid;
							}
						}
					});
					}});

				return false;
			}
			questionNumber=findNextQuestion(questionNumber);
			var question = questionObj.question;
			var operator = questionObj.operator;
			var operatorArray = operator.split(",");
			for (var i = 0; i < question.length; i++) {
				if (operatorArray[i] == "+") {

					$("#questionInput")
							.append(
									"<input type='text' style='width:40%;margin:0;padding:0;height:40px;text-align:right;padding-right:10px;' class='niput sxt' value='' disabled />"
											+ "<input type='text' style='width:50%;margin:0;padding:0;font-size:25px;height:40px;text-align:center;padding-right:10%' class='niput sxt' value="
											+ question[i] + " disabled />");
				} else {

					$("#questionInput")
							.append(
									"<input type='text' style='width:40%;margin:0;padding:0;height:40px;text-align:right;padding-right:10px;font-size:30px;font-weight:600;' class='niput sxt' value="
											+ operatorArray[i]
											+ " disabled />"
											+ "<input type='text' style='width:50%;margin:0;padding:0;font-size:25px;height:40px;text-align:center;padding-right:10%' class='niput sxt' value="
											+ question[i] + " disabled />");
				}
			}
			return questionNumber;
		}
		
		function findNextQuestion(questionNumber){

			for (var q = 0; q < questions.length; q++) {
				batchId = parseInt(questions[q].batchId);
				sequence = parseInt(questions[q].questionSequence);
				tempSequence = (batchId - 1) * 10 + sequence;
				if (tempSequence == questionNumber) {
					questionObj = questions[q];
					index = q;
					break;
				}
			}
			if(questionObj==null){
				batchId=Math.floor(questionNumber/10)+1;
				sequence=questionNumber%10;
				answers=answers+"MISS,";
				$.ajax({
					type : "GET",
					url : "../AbacusQuiz/updateHistoryQuiz",
					data : {
						openID : uid,
						category : category,
						batchId : batchId,
						questionSequence : sequence,
						answers : answers
					},
					cache : false,
					success : function(data) {
						if (data) {
						}
					}
				});
				questionNumber++;
				findNextQuestion(questionNumber);
			}
			return questionNumber;
			
		}
		var total = 0;
		var currentAnswer;
		function showAnswer(questionNumber) {
			$("#answerInput").html("");
			var questionObj = questions[questionNumber];
			var question = questionObj.question;
			var operator = questionObj.operator;
			var operatorArray = operator.split(",");
			for (var i = 0; i < question.length; i++) {
				if (operatorArray[i] == "+") {

					$("#answerInput")
							.append(
									"<input type='text' style='width:40%;margin:0;padding:0;height:40px;text-align:right;font-size:30px;font-weight:600;padding-right:10px;' class='niput sxt' value='' disabled />"
											+ "<input type='text' style='width:50%;margin:0;padding:0;height:40px;text-align:center;font-size:25px;padding-right:10%' class='niput sxt' value="
											+ question[i] + " disabled />");
				} else {

					$("#answerInput")
							.append(
									"<input type='text' style='width:40%;margin:0;padding:0;height:40px;text-align:right;font-size:30px;font-weight:600;padding-right:10px;' class='niput sxt' value="
											+ operatorArray[i]
											+ " disabled />"
											+ "<input type='text' style='width:50%;margin:0;padding:0;height:40px;text-align:center;font-size:25px;padding-right:10%' class='niput sxt' value="
											+ question[i] + " disabled />");
				}
			}
			currentAnswer = questionObj.answer;
			$("#total").val(currentAnswer);

		}
		$(".end").on("click", function() {

			var answer = $("#answer").val();
			if (answer == "") {
				swal("未答题", "请输入你的答案哦~！", "error");
				return;
			}

			showAnswer(index);
			if (answer == currentAnswer) {
				$("#right").show();
				$("#wrong").hide();
				answers += batchId + "/" + sequence + "/" + "1,";
				rightQ++;
			} else {
				$("#wrong").show();
				$("#right").hide();
				wrongQ++;
				answers += batchId + "/" + sequence + "/" + "0,";
			}
			$.ajax({
				type : "GET",
				url : "../AbacusQuiz/updateHistoryQuiz",
				data : {
					openID : uid,
					category : category,
					batchId : batchId,
					questionSequence : sequence,
					answers : answers
				},
				cache : false,
				success : function(data) {
					if (data) {
					}
				}
			});
			$("#processPanel").hide();
			$("#answerPanel").show();
			setTimeout("start()",1000);

		});
		$(".exit").on("click", function() {
			if (level == 'basic') {
				window.location.href = "NavigatorForBasic.jsp?UID=" + uid;
			} else {
				window.location.href = "Navigator.jsp?UID=" + uid;
			}
		});
	</script>
</body>
</html>