﻿<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,org.json.JSONObject"%>
<%@ page import="com.nkang.kxmoment.baseobject.GeoLocation"%>
<%@ page import="com.nkang.kxmoment.util.*"%>
<%@ page import="com.nkang.kxmoment.util.MongoDBBasic"%>
<%@ page import="com.nkang.kxmoment.baseobject.WeChatUser"%>
<%@ page import="com.nkang.kxmoment.baseobject.ClientMeta"%>
<%@ page import="com.nkang.kxmoment.util.Constants"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
String uid = request.getParameter("UID");
String code = uid;
String price = request.getParameter("TOTALFEE");
String notifyURL = Constants.notifyURL;
String name = "";
String headImgUrl ="";
String phone="";
HashMap<String, String> res=MongoDBBasic.getWeChatUserFromOpenID(uid);
if(res!=null){
	if(res.get("HeadUrl")!=null){
		headImgUrl=res.get("HeadUrl");
	}
	if(res.get("NickName")!=null){
		name=res.get("NickName");
	}

	if(res.get("phone")!=null){
		phone=res.get("phone");
	}
}
%>
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title>购买课时</title>
	<meta content="width=device-width, initial-scale=1.0" name="viewport" />

<link rel="stylesheet" type="text/css" href="../MetroStyleFiles/sweetalert.css" />
<script src="../MetroStyleFiles/sweetalert.min.js"></script>
	<script type="text/javascript" src="../Jsp/JS/jquery-1.8.0.js"></script>
	<style>
	*{padding:0;margin: 0;}
body{
  background: #FEFEFE;
  margin-bottom: 50px;
  height: auto;
}
a{
  text-decoration: none;
  color:black;
}
a:visited{
  color:black;
}
.infoPanel
{
  padding:0 2%;
  width: 96%;
}
.infoArea,.imgArea{
  width:100%;
  height:40px;
  border-bottom: 1px solid #EFEFEF;
}
.imgArea{
  background: white;
  height:90px;
  position: relative;
}
.imgContainer
{
  position: absolute;
  left:40%;
  top:10px;
  width:70px;
  height:70px;
  overflow: hidden;
  border-radius: 50%;
}
.imgContainer img
{
  width:100%;
  height: 100%;
}
.infoTitle
{
  width:29%;
  text-align: left;
  padding-left:1%;
  height: 100%;
  line-height: 45px;
  float: left;
  font-weight:bold;
}
.infoVal
{
  float: right;
  width:68%;
  text-align: right;
  padding-right:2%;
  height: 100%;
  line-height: 45px;
}
.pay{
    text-align: center;
    height:50px;
    line-height: 50px;
    background: #20b672;
    color: white;
    position:fixed;
    bottom:30px;}
.infoPay{
height:150px;
/* border-bottom:1px solid #EFEFEF; */
}
.payTitle{
    text-align: left;
    line-height: 40px;
    color: black;
    padding-left: 10px;
    border: none;
    font-weight:bolder;
}
.infoItem{
margin-top:15px;
width:30%;
margin-left:2%;
height:50px;
float:left;
border:1px solid #20b672;
color:#20b672;
border-radius:5px;
line-height:25px;
font-size:0.8rem;
text-align:center;
}
#footer {
    background: #DCD9D9;
    bottom: 0px;
    color: #757575;
    font-size: 12px;
    padding: 10px 1%;
    position: fixed;
    text-align: center;
    width: 100%;
    z-index: 1002;
    left: 0;
}
.default{
	color:white;
	background:#20b672;
}
	</style>
	</head>
<body>
	
<script type="text/javascript">  
       var appId;
       var timeStamp;
       var nonceStr;
       var pg;
       var signType;
       var paySign;
       var totalfee;
      function onBridgeReady(){
    	  WeixinJSBridge.invoke(  
               'getBrandWCPayRequest', {  
                   "appId" : appId,     //公众号名称，由商户传入       
                   "timeStamp": timeStamp, //时间戳，自1970年以来的秒数       
                   "nonceStr" : nonceStr, //随机串       
                   "package" : pg,
                   "signType" : signType, //微信签名方式:       
                   "paySign" : paySign    //微信签名   
               },  
               function(res){       
                   if(res.err_msg == "get_brand_wcpay_request:ok" ) {
                	   window.location.href = "<%= notifyURL%>";
                   }
                   else{
       	    	    alert('抱歉系统故障，支付失败！请联系商家'+res.err_msg);//这里一直返回getBrandWCPayRequest提示fail_invalid appid
        	       }   
               }  
           ); 
        }  
        function pay(){   
            send_request(function(value){  
            var json = eval("(" + value + ")");  
            if(json.length > 0){  
                appId = json[0].appId;  
                timeStamp = json[0].timeStamp;  
                nonceStr = json[0].nonceStr;
                pg = json[0].pg;  
                signType = json[0].signType;  
                paySign = json[0].paySign;
                if (typeof WeixinJSBridge == "undefined"){  
                   if( document.addEventListener ){
                       document.addEventListener('WeixinJSBridgeReady', onBridgeReady, false);  
                   }else if (document.attachEvent){  
                       document.attachEvent('WeixinJSBridgeReady', onBridgeReady);  
                       document.attachEvent('onWeixinJSBridgeReady', onBridgeReady);  
                   }  
                }else{
                   onBridgeReady(); 
                }   
            }  
            },"http://leshucq.bceapp.com/pay/payparm?openId=<%= code%>&totalfee="+totalfee,true);   
        }  
function send_request(callback, urladdress,isReturnData){        
    var xmlhttp = getXMLHttpRequest();  
    xmlhttp.onreadystatechange = function(){      	
            if (xmlhttp.readyState == 4) {  
                    try{  
                    if(xmlhttp.status == 200){  
                        if(isReturnData && isReturnData==true){
/*                         	alert("responseText="+xmlhttp.responseText); */
                            callback(xmlhttp.responseText);  
                        }  
                    }else{  
                        callback("页面找不到！"+ urladdress +"");  
                    }  
                } catch(e){  
                    callback("请求发送失败，请重试！" + e);  
                }  
           }  
    } 
    xmlhttp.open("POST", urladdress, true);
    xmlhttp.send(null);  
}  
function getXMLHttpRequest() {  
    var xmlhttp;  
    if (window.XMLHttpRequest) {  
        try {  
            xmlhttp = new XMLHttpRequest();  
            xmlhttp.overrideMimeType("text/html;charset=UTF-8");  
        } catch (e) {}  
    } else if (window.ActiveXObject) {  
        try {  
            xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");  
        } catch (e) {  
            try {  
                xmlhttp = new ActiveXObject("Msxml2.XMLHttp");  
            } catch (e) {  
                try {  
                    xmlhttp = new ActiveXObject("Msxml3.XMLHttp");  
                } catch (e) {}  
            }  
        }  
    }  
    return xmlhttp;  
}
var studentID;
var elID="#zxs";
function pay(){
	var currentTime=getNowFormatDate();
	var payMoney=$(elID).find(".default").find(".priceText").text();
	var classCount=$(elID).find(".default").find(".classText").text();
	var giftClass=$("#giftClass").val();
	$.ajax({
		 url:'../ClassRecord/addClasspayrecord',
		 type:"GET",
		 data : {
			 payOption:$("#classType").find("option:selected").val(),
			 payMoney:payMoney,
			 classCount:classCount,
			 payTime:currentTime,
			 studentName:$("#name").text(),
			 studentOpenID:studentID,
			 phone:$("#phone").val(),	
			 operatorOpenID:'<%=uid%>',
			 giftClass:giftClass
		 },
		 success:function(data){
			 if(data){
				 $("#name").text(data.realName);
				 studentID=data.openid;
					swal("支付成功!", "恭喜!", "success");

					 $("#name").text("");
					 $("#phone").val("");
			 }else{

					swal("支付失败!", "请填写正确的信息.", "error");
				}
		}
	});
	
}
function getNowFormatDate() {
    var date = new Date();
    var seperator1 = "-";
    var seperator2 = ":";
    var month = date.getMonth() + 1;
    var hour=date.getHours();
    var minute=date.getMinutes();
    var second=date.getSeconds();
    var strDate = date.getDate();
    if (month >= 1 && month <= 9) {
        month = "0" + month;
    }
    if (hour >= 1 && hour <= 9) {
        hour = "0" + hour;
    }
    if (minute >= 1 && minute <= 9) {
        minute = "0" + minute;
    }
    if (second >= 1 && second <= 9) {
        second = "0" + second;
    }
    if (strDate >= 0 && strDate <= 9) {
        strDate = "0" + strDate;
    }
    var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate
            + " " + hour + seperator2 + minute
            + seperator2 + second;
    return currentdate;
}
$(function(){
	$(".price").on("click",function(){
		totalfee=$(this).children("span").text();
		$(this).addClass("default");
		$(this).siblings().removeClass("default");
		totalfee = totalfee+"00";
		totalfee = "1";
	});
	$("#phone").blur(function(){
		$.ajax({
			 url:'../userProfile/getNameByPhone',
			 type:"GET",
			 data : {
				 phone:$(this).val(),
			 },
			 success:function(data){
				 if(data){
					 $("#name").text(data.realName);
					 studentID=data.openid;
				 }
				 
			}
		});
		
	});
	$("#classType").on("change",function(){
		var type=$(this).find("option:selected").text();
		if(type=="丫丫拼音"){
			$("#yypy").show();
			$("#zxs").hide();
			$("#qwsx").hide();
			elID="#yypy";
		}
		if(type=="珠心算"){
			$("#yypy").hide();
			$("#zxs").show();
			$("#qwsx").hide();
			elID="#zxs";
		}
		if(type=="趣味数学"){
			$("#yypy").hide();
			$("#zxs").hide();
			$("#qwsx").show();
			elID="#qwsx";
		}
	});
});
    </script>
    	
	
	<a href="http://leshucq.bceapp.com/mdm/payHistory.jsp?UID=<%=uid %>" style="position: fixed;bottom: 90px;right: 10px;font-size: 14px;text-decoration: underline;color: #20b672;">查看缴费记录</a>
	<div id="data_model_div" style="height: 90px">
		<i class="icon" style="position: absolute;top: 25px;z-index: 100;right: 20px;">
			<div style="width: 30px;height: 30px;float: left;border-radius: 50%;overflow: hidden;">
				<img class="exit" src="<%=headImgUrl %>" style="width: 30px; height: 30px;" />
			</div>
			<span style="position: relative;top: 8px;left: 5px;font-style:normal"><%=name %></span>
		</i>
		<img style="position: absolute;top: 8px;left: 10px;z-index: 100;height: 60px;" class="HpLogo" src="http://leshucq.bj.bcebos.com/standard/leshuLogo.png" alt="Logo">
		<div style="width: 100%; height: 80px; background: white; position: absolute; border-bottom: 4px solid #20b672;"></div>
	</div>
	<div class="infoPanel">
      <div class="infoArea">
        <p class="infoTitle"><input id="phone" placeholder="请输入学员电话号码" style="border:none;height:30px;text-align: left;font-size:15px;" type="text" value=""></p>

      </div>
    </div> 
     <div class="infoPanel">
      <div class="infoArea">
        <p class="infoTitle">姓名</p>
        <p id="name" class="infoVal"></p>
      </div>
    </div>  
     <div class="infoPanel">
      <div class="infoArea">
        <p class="infoTitle">课程类型</p>
        <p class="infoVal">
        <select id="classType" style="border:none;font-size:15px;">
        <option value="珠心算">珠心算</option>
        <option value="丫丫拼音">丫丫拼音</option>
        <option value="趣味数学">趣味数学</option>
        </select></p>
      </div>
    </div>
    <div class="infoPanel" id="zxs">
      <div class="infoPay">
	  <div class="infoItem price default"><span class="priceText">2160</span>元<br><span class="classText">24</span>次课</div>
	  <div class="infoItem price"><span class="priceText">3880</span>元<br><span class="classText">48</span>次课</div>
	  <div class="infoItem price"><span class="priceText">6680</span>元<br><span class="classText">96</span>次课</div>
	  <div class="infoItem price"><span class="priceText">0</span>元<br><span style="display:none" class="classText">0</span>赠送课时</div>
     </div>
    </div>
      <div class="infoPanel" id="yypy" style="display:none">
      <div class="infoPay">
	  <div class="infoItem price default"><span class="priceText">1380</span>元<br><span class="classText">16</span>次课</div>
	  <div class="infoItem price"><span class="priceText">0</span>元<br><span style="display:none" class="classText">0</span>赠送课时</div>
     </div>
    </div>
        <div class="infoPanel" id="qwsx" style="display:none">
      <div class="infoPay">
	  <div class="infoItem price default"><span class="priceText">1280</span>元<br><span class="classText">16</span>次课</div>
	  <div class="infoItem price"><span class="priceText">0</span>元<br><span style="display:none" class="classText">0</span>赠送课时</div>
     </div>
    </div>
     <div class="infoPanel">
      <div class="infoArea">
        <p class="infoTitle">赠送课时</p>
        <p id="gift" class="infoVal"><input id="giftClass" style="border:none;height:30px;text-align:right;font-size:15px;" type="text" value="0" /></p>
      </div>
    </div> 
	<div class="infoPanel">
      <div class="infoArea">
        <p class="infoTitle">支付方式</p>
        <p class="infoVal"></p>
      </div>
    </div>
          <div class="infoPanel">
      <div class="infoPay">
	  <div class="infoItem" style="color:gray;border:1px solid gray;line-height:50px;">支付宝支付</div>
	  <div class="infoItem" style="color:gray;border:1px solid gray;line-height:50px;">微信支付</div>
     </div>
    </div>
      <div class="infoArea pay"><a href="javascript:pay();" style="color:white;">立即购买</a></div>
    	<div id="footer">
		<span class="clientCopyRight"><nobr>©版权所有 | 重庆乐数珠心算</nobr></span>
	</div>
	</body>
</html>
