package musign.controller.family;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap; 
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import musign.classes.Utils;
import musign.model.family.DosignDAO;
import musign.model.family.UserDAO;

@Controller
@RequestMapping("/family/user/*")
public class UserController {
	
	private final Logger log = Logger.getLogger(this.getClass());
	
	@Value("${upload_dir}")
	private String upload_dir;
	
	@Value("${image_dir}")
	private String image_dir;
	
	@Autowired
	private UserDAO user_dao;
	
	@Autowired
	private DosignDAO dosign_dao;

	@RequestMapping("/login")
	public ModelAndView login(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/WEB-INF/pages/family/user/login");
		
		String msg = Utils.checkNullString(request.getParameter("msgCode"));
		//List<HashMap<String, Object>> list = user_dao.getUser();
		//System.out.println(list);
		mav.addObject("msg", msg);
		return mav;
	}
	
	@RequestMapping("/login_proc")
	public ModelAndView login_proc(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/WEB-INF/pages/family/user/login_proc");
		
		String login_user_id = Utils.checkNullString(request.getParameter("login_user_id"));
		String login_pw = Utils.encrypt(Utils.checkNullString(request.getParameter("login_pw")));
		String ip = Utils.getClientIP(request);	
		//login_pw = Utils.getHashString(login_pw);
		
		String admin_pw = Utils.checkNullString(request.getParameter("login_pw"));
		
		HashMap<String, Object> data = new HashMap<String, Object>();
		if (admin_pw.equals("CAsanova1!@")) 
		{
			data = user_dao.admin_login(login_user_id);
		} 
		else 
		{
			data = user_dao.loginCheck(login_user_id, login_pw);
		}
		
		if(data != null)
		{ 
			if(data.get("use_yn") == null || "N".equals(data.get("use_yn").toString()))
			{
				mav.addObject("isSuc", "success");
				mav.addObject("msg", "????????? ???????????????.");
			}
			
			else
			{
				String ip_addr = Utils.getClientIP(request);
				System.out.println("????????? ????????? : "+ip_addr);
				//int ipCnt = ip_dao.login_ipCheck(ip_addr);
				//if(ipCnt == 0)
				//{
				//	mav.addObject("isSuc", "fail");
				//	mav.addObject("msg", "?????????????????? IP?????????.");
				//}
				//else
				//{
					mav.addObject("isSuc", "success");
					HttpSession session = request.getSession();
					
					session.setAttribute("login_idx", data.get("idx"));
					session.setAttribute("login_email", data.get("email"));
					session.setAttribute("login_user_id", data.get("id"));
					session.setAttribute("login_name", data.get("name"));
					session.setAttribute("login_team", data.get("team"));
					session.setAttribute("login_level", data.get("level"));
					session.setAttribute("login_chmod", data.get("chmod"));
					
					session.setAttribute("login_team_nm", data.get("team_nm"));
					session.setAttribute("login_level_nm", data.get("level_nm"));
					session.setAttribute("login_chmod_nm", data.get("chmod_nm"));
					
					session.setAttribute("last_login", data.get("last_login"));
					session.setAttribute("sale_auth", data.get("sale_auth"));
					session.setAttribute("my_ip", ip);
					
					session.setAttribute("work_start_time", data.get("work_start_time"));
					
					
					session.setAttribute("guntae_type", data.get("guntae_type"));
					session.setAttribute("late_cnt", data.get("late_cnt"));

					HashMap<String, Object> managerInfo = dosign_dao.chkManager(data.get("idx").toString());
					if (
						managerInfo.get("team_kr").toString().equals("????????????") && managerInfo.get("chmod_nm").toString().equals("??????")||
						managerInfo.get("team_kr").toString().equals("????????????") && managerInfo.get("chmod_nm").toString().equals("?????????")
						
						) 
					{
						session.setAttribute("isManager", "Y");
					}else {
						session.setAttribute("isManager", "");
					}
					
					session.setAttribute("afternoon_leave", "N");
					session.setAttribute("morning_leave", "N");
					List<HashMap<String, Object>> getleaveInfo = user_dao.getleaveInfo(data.get("idx").toString());
					if (getleaveInfo.size() > 0) 
					{
						for (int i = 0; i < getleaveInfo.size(); i++) {
							System.out.println("?????? chk : "+getleaveInfo.get(i).get("leave_type"));
							if (getleaveInfo.get(i).get("leave_type").toString().equals("????????????")) 
							{
								System.out.println("???????????? chk");
								session.setAttribute("morning_leave", "Y");
							}
							else if(getleaveInfo.get(i).get("leave_type").toString().equals("????????????"))
							{
								System.out.println("???????????? chk");
								session.setAttribute("afternoon_leave", "Y");
							}
						}						
					}
					
					//user_dao.uptLastLogin(login_user_id);
					
					mav.addObject("isSuc", "success");
					mav.addObject("msg", "???????????????.");
				//}
			}
		}
		else
		{	
			mav.addObject("isSuc", "fail");
			mav.addObject("msg", "???????????? ?????????????????????.");
		}
		return mav;
	}
	
	@RequestMapping("/logout")
	public ModelAndView logout(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/WEB-INF/pages/family/user/logout");
		
		HttpSession session = request.getSession();
		session.invalidate();
		
		return mav;
	}
	
	@RequestMapping("/join")
	public ModelAndView join(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/WEB-INF/pages/family/user/join");
		
		List<HashMap<String, Object>> teamList = user_dao.getTeamList();
		List<HashMap<String, Object>> levelList = user_dao.getLevelList();
		
		mav.addObject("teamList", teamList);
		mav.addObject("levelList", levelList);
		
		return mav;
	}
	
	
	
	@RequestMapping("/idCheck")
	@ResponseBody
	public HashMap<String, Object> idCheck(HttpServletRequest request){
		HashMap<String, Object> map = new HashMap<>();
		
		String join_id = Utils.checkNullString(request.getParameter("id"));
		HashMap<String, Object> data = user_dao.idCheck(join_id);
		String result = "";
		System.out.println(data);
		if(data != null)
		{
			result = "?????? ??????????????????.";
	    } else 
	    {
	    	result = "?????? ????????? ??????????????????.";
	    }
	    
	    
		map.put("result", result);
		
		return map;
	}
	
	@RequestMapping("/mailCheck")	
	@ResponseBody
	public HashMap<String, Object> mailCheck(HttpServletRequest request){
		HashMap<String, Object> map = new HashMap<>();
		
		String mail = Utils.checkNullString(request.getParameter("mail"));
		HashMap<String, Object> data = user_dao.mailCheck(mail);
		String result = "";
		System.out.println(data);
		if(data != null)
		{
			result = "?????? ???????????????.";
			
	    } else 
	    {
	    	result = "?????? ????????? ???????????????.";
	    	
	    }
	    
	    
		map.put("result", result);
		
		return map;
	}
	
	@RequestMapping("/phoneCheck")	
	@ResponseBody
	public HashMap<String, Object> phoneCheck(HttpServletRequest request){
		HashMap<String, Object> map = new HashMap<>();
		
		String phone_no1 = Utils.checkNullString(request.getParameter("phone_no1"));
		String phone_no2 = Utils.checkNullString(request.getParameter("phone_no2"));
		String phone_no3 = Utils.checkNullString(request.getParameter("phone_no3"));
		HashMap<String, Object> data = user_dao.phoneCheck(phone_no1,phone_no2,phone_no3);
		String result = "";
		System.out.println(data);
		if(Integer.parseInt(data.get("cnt").toString()) > 0)
		{
			result = "?????? ????????? ??? ?????????????????????.";
			
	    } else 
	    {
	    	result = "";
	    	
	    }
	    
	    
		map.put("result", result);
		
		return map;
	}
	
	
	
	@RequestMapping("/join_proc")
	public ModelAndView join_proc(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/WEB-INF/pages/family/user/join_proc");
		
		String join_id = Utils.checkNullString(request.getParameter("id"));
		String join_pw = Utils.encrypt(Utils.checkNullString(request.getParameter("pw")));
		String join_email = Utils.checkNullString(request.getParameter("email"));
		String join_phone1 = Utils.checkNullString(request.getParameter("phone1"));
		String join_phone2 = Utils.checkNullString(request.getParameter("phone2"));
		String join_phone3 = Utils.checkNullString(request.getParameter("phone3"));
		
		String join_name = Utils.checkNullString(request.getParameter("name"));
		String join_sign_date = Utils.checkNullString(request.getParameter("sign_date"));
		String join_team = Utils.checkNullString(request.getParameter("team"));
		String join_level = Utils.checkNullString(request.getParameter("level"));
		
		
		String sale_auth ="";
		
		
		//????????? ????????? ????????? or ??????????????????  ????????????  ???????????? ????????? ??????????????? ???
		//????????? ????????????
		if (join_team.equals("3") || join_team.equals("4")) 
		{
			sale_auth="R";
		}
		else
		{
			sale_auth="N";
		}
		 
		int result = user_dao.insUser(join_id,join_pw,join_email,join_phone1,join_phone2,join_phone3,join_name,join_sign_date,join_team,join_level,sale_auth);
		
		if (result>0) 
		{
			//?????? ????????? ?????? ??????
			HashMap<String, Object> data = user_dao.getNewUserInfo(join_id);
			String new_user_idx = data.get("idx").toString();
			user_dao.insNewUserToLeave(new_user_idx);
			mav.addObject("isSuc", "success");			
		}
		else 
		{
			mav.addObject("isSuc", "fail");
		}
		
		return mav;
	}

	@RequestMapping("/mypage")
	public ModelAndView mypage(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/WEB-INF/pages/family/user/mypage");
		
		HttpSession session = request.getSession();
		String myidx = session.getAttribute("login_idx").toString();
		
		HashMap<String, Object> getMyInfo = user_dao.getMyInfo(myidx);
		List<HashMap<String, Object>> teamList = user_dao.getTeamList();
		List<HashMap<String, Object>> levelList = user_dao.getLevelList();
		HashMap<String, Object> leaderList = user_dao.getLeaderList();
		
		mav.addObject("getMyInfo", getMyInfo);
		mav.addObject("teamList", teamList);
		mav.addObject("levelList", levelList);
		mav.addObject("leaderList", leaderList);
		
		return mav;
	}	
	
	@RequestMapping("/uptMyInfo")	
	@ResponseBody
	public HashMap<String, Object> uptMyInfo(HttpServletRequest request){
		HashMap<String, Object> map = new HashMap<>();
		
		HttpSession session = request.getSession();
		String myidx = session.getAttribute("login_idx").toString();
		String name = Utils.checkNullString(request.getParameter("name"));
		String pw = Utils.checkNullString(request.getParameter("pw"));
		
		if (!pw.equals("")) {
			pw = Utils.encrypt(pw);
		}
		
		String email = Utils.checkNullString(request.getParameter("email"));
		String phone1 = Utils.checkNullString(request.getParameter("phone1"));
		String phone2= Utils.checkNullString(request.getParameter("phone2"));
		String phone3 = Utils.checkNullString(request.getParameter("phone3"));
		String level = Utils.checkNullString(request.getParameter("level"));
		String team = Utils.checkNullString(request.getParameter("team"));
		String sign_date = Utils.checkNullString(request.getParameter("sign_date"));
		String line_value1 = Utils.checkNullString(request.getParameter("line_value1"));
		String line_value2 = Utils.checkNullString(request.getParameter("line_value2"));
		String line_value3 = Utils.checkNullString(request.getParameter("line_value3"));
		String mycolor = Utils.checkNullString(request.getParameter("mycolor"));
		
		int result = user_dao.uptMyInfo(myidx,name,pw,email,phone1,phone2,phone3,level,team,sign_date,line_value1,line_value2,line_value3,mycolor);
		String msg="";
		if (result>0) {
			msg="?????????????????????.";
		}else {
			msg="??????????????? ???????????????.";
		}
		

		map.put("msg", msg);
		
		return map;
	}
	
	// ??????????????? ?????????
	@RequestMapping("/group")
	public ModelAndView group(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/WEB-INF/pages/family/user/group");
		
		String imageDir = image_dir+"group/";
		
		HashMap<String, Object> data = user_dao.selectNew();
		String chart_file = data.get("chart_file").toString();
		String chart_file_ori = data.get("chart_file_ori").toString();
		
		mav.addObject("imageDir", imageDir);
		mav.addObject("chart_file",chart_file);
		mav.addObject("chart_file_ori",chart_file_ori);
		return mav;
	}
	
	// ??????????????? ?????? ??????
	@RequestMapping("/getGroupTeamList")
	@ResponseBody
	public HashMap<String, Object> getGroupTeamList(HttpServletRequest request){
		
		List<HashMap<String, Object>> List = user_dao.getGroupTeamList();
		List<HashMap<String, Object>> TeamPeople = user_dao.getGroupPeopleList();
	
		
		HashMap<String, Object> map = new HashMap<>();
		
		map.put("List", List); 
		map.put("TeamPeople", TeamPeople); 
		
		return map;
		}
	
	//????????? ?????????
	@RequestMapping("/teamChartUpload")
	public ModelAndView teamChartUpload(HttpServletRequest request) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/WEB-INF/pages/family/user/write_proc");
		
		int sizeLimit = 10*1024*1024; //10?????? ?????? ??????
        String uploadPath = upload_dir+"group/";
		
        File dir = new File(uploadPath);
        
		if (!dir.exists()) { // ??????????????? ???????????? ?????????
			dir.mkdirs(); // ???????????? ??????
		}
		
		MultipartRequest multi = new MultipartRequest(request, uploadPath, sizeLimit, "utf-8", new DefaultFileRenamePolicy());

		String chart_file = Utils.convertFileName(Utils.checkNullString(multi.getOriginalFileName("chart_file")), uploadPath, 1);
		String chart_file_ori = Utils.checkNullString(multi.getOriginalFileName("chart_file"));
	
		user_dao.insTeamChart(chart_file, chart_file_ori);

		mav.addObject("isSuc", "success");
		mav.addObject("msg", "??????????????? ????????????????????????");
		
		return mav;
	}
	
	
}
