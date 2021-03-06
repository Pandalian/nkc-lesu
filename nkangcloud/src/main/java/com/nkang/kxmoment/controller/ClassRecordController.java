package com.nkang.kxmoment.controller;

import java.text.ParseException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mongodb.BasicDBObject;
import com.mongodb.DBObject;
import com.nkang.kxmoment.baseobject.WeChatUser;
import com.nkang.kxmoment.baseobject.classhourrecord.Classexpenserecord;
import com.nkang.kxmoment.baseobject.classhourrecord.Classpayrecord;
import com.nkang.kxmoment.baseobject.classhourrecord.StudentBasicInformation;
import com.nkang.kxmoment.baseobject.classhourrecord.TeamerCredit;
import com.nkang.kxmoment.util.Constants;
import com.nkang.kxmoment.util.DateUtil;
import com.nkang.kxmoment.util.MongoDBBasic;
import com.nkang.kxmoment.util.RestUtils;
import com.nkang.kxmoment.util.StringUtils;
import com.nkang.kxmoment.util.SmsUtils.RestTest;
//  http://leshucq.bceapp.com/ClassRecord/updateStudentBasicInfo?openID=oO8exvzE95JUvwpNxNTxraOqzUFI&enrolledTime=2018-1-5&enrolledWay=lao&district=chongqing&totalClass=55&expenseClass=33&leftPayClass=22&leftSendClass=0&classType=珠心算
@Controller
@RequestMapping("/ClassRecord")
public class ClassRecordController {
	@RequestMapping("/updateStudentBasicInfo")
	public @ResponseBody boolean AddClassRecord(
			@RequestParam(value = "openID") String openid,
			@RequestParam(value = "enrolledTime") String enrolledTime,
			@RequestParam(value = "name") String name,
			@RequestParam(value = "enrolledWay") String enrolledWay,
			@RequestParam(value = "district") String district,
			@RequestParam(value = "teacher") String teacher,
			@RequestParam(value = "totalClass") String totalClass,
			@RequestParam(value = "expenseClass") String expenseClass,
			@RequestParam(value = "leftPayClass") String leftPayClass,
			@RequestParam(value = "leftSendClass") String leftSendClass,
			@RequestParam(value = "classType") String classType
			)
	{
		StudentBasicInformation stInfor = new StudentBasicInformation();
		stInfor.setTeacher(teacher);
		stInfor.setDistrict(district);
		stInfor.setEnrolledTime(enrolledTime);
		stInfor.setEnrolledWay(enrolledWay);
		stInfor.setClassType(classType);
		if(totalClass!=null && !"".equals(totalClass)){
			stInfor.setTotalClass(Integer.parseInt(totalClass));
		}else{
			stInfor.setTotalClass(-1);
		}
		if(expenseClass!=null && !"".equals(expenseClass)){
			stInfor.setExpenseClass(Integer.parseInt(expenseClass));
				}else{
					stInfor.setExpenseClass(-1);
				}
		if(leftPayClass!=null && !"".equals(leftPayClass)){
			stInfor.setLeftPayClass(Integer.parseInt(leftPayClass));
		}else{
			stInfor.setLeftPayClass(-1);
		}
		if(leftSendClass!=null && !"".equals(leftSendClass)){
			stInfor.setLeftSendClass(Integer.parseInt(leftSendClass));
		}else{
			stInfor.setLeftSendClass(-1);
		}
		stInfor.setOpenID(openid);
		stInfor.setRealName(name);
		if(MongoDBBasic.updateStudentBasicInformation(stInfor)){
			return true;
		}
		return false;
		
	}
	
	//updateStudentSendClass(String OpenID, int send)
	//http://leshucq.bceapp.com/ClassRecord/updateStudentSendClass?openID=oO8exvzE95JUvwpNxNTxraOqzUFI&send=2
	/*@RequestMapping("/updateStudentSendClass")
	public @ResponseBody String UpdateStudentSendClass(@RequestParam(value = "openID") String openid,@RequestParam(value = "send") int send){
		if(MongoDBBasic.updateStudentSendClass(openid,send)){
			return "success";
		}
		
		return "failed";
		
		
	}
	*/
	

	// getStudentInformation by openid
	//http://leshucq.bceapp.com/ClassRecord/getClassTypeRecords?openID=oO8exvzE95JUvwpNxNTxraOqzUFI
	@RequestMapping("/getClassTypeRecords")
	public @ResponseBody Map<String,StudentBasicInformation> getClassTypeRecords(@RequestParam(value = "openID") String openid){
		return MongoDBBasic.getClassTypeRecords(openid);
		
		}
	@RequestMapping("/getClassTypeRecordsByTeacherAndStudent")
	public @ResponseBody Map<String,StudentBasicInformation> getClassTypeRecordsByTeacherAndStudent(@RequestParam(value = "openID") String openid,@RequestParam(value = "teacherID") String teacherID){
		return MongoDBBasic.getClassTypeRecordsByTeacherAndStudent(openid,teacherID);
	}
	@RequestMapping("/getStudentsByTeacher")
	public @ResponseBody List<StudentBasicInformation> getStudentsByTeacher(@RequestParam(value = "teacher") String teacherID){
		return MongoDBBasic.getStudentsByTeacher(teacherID);
		
		}
	@RequestMapping("/getAllOpenIDHasClass")
	public @ResponseBody Map<String,String>  getAllOpenIDHasClass(){
		List<WeChatUser> wcus=MongoDBBasic.getAllOpenIDHasClass();
		Map<String,String> map=new HashMap<String,String>();
		for(int i=0;i<wcus.size();i++){
			if(!map.containsKey(wcus.get(i).getOpenid())){
				map.put(wcus.get(i).getOpenid(), wcus.get(i).getNickname());
			}
		}
		return map;
		
		}
	
	
//	http://leshucq.bceapp.com/ClassRecord/addClasspayrecord?payOption=YY语音&payMoney=2230&classCount=20&payTime=2018-01-05&studentName=march&studentOpenID=oO8exvzE95JUvwpNxNTxraOqzUFI
	@RequestMapping("/addClasspayrecord")
	public @ResponseBody String AddClasspayrecord(
			@RequestParam(value = "payOption") String payOption,
			@RequestParam(value = "payMoney") String payMoney,
			@RequestParam(value = "classCount") String classCount,
			@RequestParam(value = "payTime") String payTime,
			@RequestParam(value = "studentName") String studentName,
			@RequestParam(value = "studentOpenID") String studentOpenID,
			@RequestParam(value = "phone") String phone,
			@RequestParam(value = "giftClass") String giftClass,
			@RequestParam(value = "operatorOpenID") String operatorOpenID){
		Classpayrecord cpd = new Classpayrecord();
		int money=0;
		int count=0;
		int gift=0;
		if(null!=payMoney && !"".equals(payMoney)){
			money=Integer.parseInt(payMoney);
		}
		if(null!=classCount && !"".equals(classCount)){
			count = Integer.parseInt(classCount);
		}
		if(null!=giftClass && !"".equals(giftClass)){
			gift = Integer.parseInt(giftClass);
		}
		cpd.setStudentName(studentName);
		cpd.setPayMoney(money);
		cpd.setPayOption(payOption);
		cpd.setPayTime(payTime);
		cpd.setStudentOpenID(studentOpenID);
		cpd.setClassCount(count);
		cpd.setPhone(phone);
		cpd.setOperatorOpenID(operatorOpenID);
		cpd.setGiftClass(gift);
		if(MongoDBBasic.addClasspayrecord(cpd)){
			return "succss addClasspayrecord";
		}
		
				return "failed";
		
		
	}
	
	//get Classpayrecords   getClasspayrecords?openid=oO8exvzE95JUvwpNxNTxraOqzUFI
	//	http://leshucq.bceapp.com/ClassRecord/getClasspayrecords?openID=oO8exvzE95JUvwpNxNTxraOqzUFI
	@RequestMapping("/getClasspayrecords")
	public @ResponseBody List<Classpayrecord> getClasspayrecords(@RequestParam(value = "openID") String openid){
		return MongoDBBasic.getClasspayrecords("studentOpenID",openid);
	}

//	ClassRecord/addClassExpenseRecord?expenseOption=YY语音&expenseTime=2018-1-5&
//	expenseClassCount=1&teacherName=ZHANG&teacherOpenID=oO8exv5qxR-KcrpaSezZJsAfrQF4&
//  studentName=MARCH&studentOpenID=oO8exvzE95JUvwpNxNTxraOqzUFI&expenseDistrict=CHONGQING&
//  teacherComment=GOOD&teacherConfirmExpense=true&teacherConfirmTime=1-5&parentConfirmExpense=true&parentConfirmTime=1-5
	
	@RequestMapping("/addClassExpenseRecord")
	public @ResponseBody boolean AddClassExpenseRecord(HttpServletRequest request, HttpServletResponse response,
			@RequestParam(value = "expenseOption") String expenseOption,
			@RequestParam(value = "expenseTime") String expenseTime,
			@RequestParam(value = "expenseClassCount") String expenseClassCount,
			@RequestParam(value = "teacherName") String teacherName,
			@RequestParam(value = "teacherOpenID") String teacherOpenID,
			@RequestParam(value = "studentName",required=false) String studentName,
			@RequestParam(value = "studentOpenID") String studentOpenID,
			@RequestParam(value = "expenseDistrict") String expenseDistrict,
			@RequestParam(value = "teacherComment") String teacherComment){
			//@RequestParam(value = "teacherConfirmExpense") boolean teacherConfirmExpense,
			//@RequestParam(value = "teacherConfirmTime") String teacherConfirmTime
			//@RequestParam(value = "parentConfirmExpense") boolean parentConfirmExpense,
			//@RequestParam(value = "parentConfirmTime") String parentConfirmTime
		
		Classexpenserecord cer = new Classexpenserecord();
		cer.setExpenseClassCount(expenseClassCount);
		cer.setExpenseDistrict(expenseDistrict);
		cer.setExpenseOption(expenseOption);
		cer.setExpenseTime(expenseTime);

		Date a = new Date();
		cer.setExpenseID(a.getTime()+"");
		//cer.setParentConfirmExpense(parentConfirmExpense);
		//cer.setParentConfirmTime(parentConfirmTime);
		cer.setStudentName(studentName);
		cer.setStudentOpenID(studentOpenID);
		cer.setTeacherComment(teacherComment);
		//cer.setTeacherConfirmExpense(teacherConfirmExpense);
		//cer.setTeacherConfirmTime(teacherConfirmTime);
		cer.setTeacherName(teacherName);
		cer.setTeacherOpenID(teacherOpenID);
		
		
		if(MongoDBBasic.addClassExpenseRecord(cer)){
			RestUtils.sendQuotationToUser(studentOpenID, studentName+","+teacherName+"老师在"+expenseTime+"发起了"+expenseOption+"课销记录，您可以点击详情查看课销并确认课销，感谢支持~", "http://leshucq.bj.bcebos.com/standard/standard_leshuapp.jpg", studentName+",您有一次来自乐数新的课销请求","http://leshucq.bceapp.com/mdm/expenseClassDetail.jsp?expenseID="+cer.getExpenseID()+"&UID="+studentOpenID);
			//send message to leshu admin to get client engaged

			String tel = MongoDBBasic.queryAttrByOpenID("phone", studentOpenID, true);
			String templateId="276211";
			if(StringUtils.isEmpty(tel)){
				tel = "15123944895";
			}
			String para=studentName+","+expenseTime+","+expenseOption;
			RestTest.testTemplateSMS(true, Constants.ucpass_accountSid,Constants.ucpass_token,Constants.ucpass_appId, templateId,tel,para);

			return true;
		}
		
		return false;
		
		
	}
	
	//getClassExpenseRecords by studentid
	// http://leshucq.bceapp.com/ClassRecord/getExpenseRecords?openID=oO8exvzE95JUvwpNxNTxraOqzUFI
	@RequestMapping("/getExpenseRecords")
	public @ResponseBody List<Classexpenserecord> getClassExpenseRecords(@RequestParam(value = "openID") String openid,@RequestParam(value = "classType",required=false) String classType){
		
		if(classType==null){
			classType="";
		}
		return MongoDBBasic.getClassExpenseRecords("studentOpenID",openid,classType);
	}
	
	
	// http://leshucq.bceapp.com/ClassRecord/parentConfirmTime?expenseID=1515660345557&comment=nice---GOOD
	@RequestMapping("/parentConfirmTime")
	public @ResponseBody boolean parentConfirmTime(
			@RequestParam(value = "expenseID") String expenseID,
			@RequestParam(value = "comment") String parentComment){
		
		return MongoDBBasic.parentConfirmTime(expenseID,parentComment);
			
		
	}
	
	
	@RequestMapping("/getexpenseRecord")
	public @ResponseBody Classexpenserecord getexpenseRecord(
			@RequestParam(value = "expenseID") String expenseID
			){
		return MongoDBBasic.getexpenseRecord(expenseID);
		
	}
	
	@RequestMapping("/addTeamerCredit")
	public @ResponseBody boolean AddTeamerCredit(HttpServletRequest request, HttpServletResponse response,
			@RequestParam(value = "StudentOpenID") String StudentOpenID,
			@RequestParam(value = "Operation") String Operation,
			@RequestParam(value = "Operator") String Operator,
			@RequestParam(value = "OperatorName") String OperatorName,
			@RequestParam(value = "Amount") String Amount,
			@RequestParam(value = "ChangeJustification") String ChangeJustification){
		TeamerCredit tc = new TeamerCredit();
		tc.setAmount(Amount);
		tc.setChangeJustification(ChangeJustification);
		tc.setOperation(Operation);
		tc.setOperator(Operator);
		tc.setOperatorName(OperatorName);
		tc.setStudentOpenID(StudentOpenID);
		if(MongoDBBasic.addHistryTeamerCredit(tc)){
			return true;
		}
		return false;
		
	}
			
	//getHistryTeamerCredit
	@RequestMapping("/getHistryTeamerCredit")
	public @ResponseBody List<TeamerCredit> getHistryTeamerCredit(@RequestParam(value = "StudentOpenID") String StudentOpenID) {
		
		return MongoDBBasic.getHistryTeamerCredit(StudentOpenID);
		
	}
	
	//queryWeChatUserByTelephone
	
	@RequestMapping("/getTeamerCredit")
	public @ResponseBody TeamerCredit queryWeChatUserByTelephone(@RequestParam(value = "phone") String phone) {
		
		return MongoDBBasic.queryWeChatUserByTelephone(phone);
		
	}
	
	@RequestMapping("/clearAll")
	public @ResponseBody boolean clearAll(@RequestParam(value = "phone",required=false ) String phone) {
		
		return MongoDBBasic.clearAll(phone);
		
	}
	
	@RequestMapping("/autoExpenseClass")
	public List<Classexpenserecord> autoExpenseClass(@RequestParam(value = "openID") String openID,@RequestParam(value = "classType") String classType) throws ParseException {
		
		return MongoDBBasic.autoExpenseClass(openID,classType);
		
	}
	// http://leshucq.bceapp.com/ClassRecord/getExpenseCounts?expenseOption=趣味数学&teacherOpenID=oO8exv4NSFp5WnsKAyxAAJq7f3y8&start=2018-01-26&end=2018-01-27
	@RequestMapping("/getExpenseCounts")
	public @ResponseBody int getExpenseClassCountByTime(@RequestParam(value = "expenseOption") String expenseOption,
			@RequestParam(value = "teacherOpenID") String teacherOpenID,
			@RequestParam(value = "expenseDistrict") String expenseDistrict,
			@RequestParam(value = "start") String start,
			@RequestParam(value = "end") String end) {
				
			return MongoDBBasic.getExpenseClassCountByTime(expenseOption,teacherOpenID,expenseDistrict,start,end);
				
	}
	
	// http://leshucq.bceapp.com/ClassRecord/headmasterGetExpenseCounts?expenseOption=趣味数学&start=2018-01-11&end=2018-01-27
	@RequestMapping("/headmasterGetExpenseCounts")
	public @ResponseBody Map<String,String> getExpenseClassCounts(@RequestParam(value = "expenseOption",required=false ) String expenseOption,
			@RequestParam(value = "expenseDistrict",required=false) String expenseDistrict,
			@RequestParam(value = "start") String start,
			@RequestParam(value = "end") String end) {
				
			return MongoDBBasic.getExpenseClassCounts(expenseOption,expenseDistrict,start,end);
				
	}
	
	// http://leshucq.bceapp.com/ClassRecord/governorGetExpenseCounts?expenseOption=趣味数学&expenseDistrict=江北校区&start=2018-01-2&end=2018-01-27
		@RequestMapping("/governorGetExpenseCounts")
		public @ResponseBody Map<String,String> governorGetExpenseClassCounts(@RequestParam(value = "expenseOption",required=false ) String expenseOption,
				@RequestParam(value = "expenseDistrict") String expenseDistrict,
				@RequestParam(value = "start") String start,
				@RequestParam(value = "end") String end) {
					
				return MongoDBBasic.getExpenseClassCounts(expenseOption,expenseDistrict,start,end);
					
		}
}
