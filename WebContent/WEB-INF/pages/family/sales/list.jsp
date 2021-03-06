<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>    
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/pages/family/common/header.jsp"/>
<jsp:include page="/WEB-INF/pages/family/common/lnb.jsp"/>
<jsp:include page="/WEB-INF/pages/family/common/excelDown.jsp"/>
<jsp:include page="/inc/date_picker/date_picker.html"/>

<script>
$(document).ready(function(){
	$("body").addClass("body-board-list body-sales-list");
	getList();
	
	$("#chk_all").change(function() 
	{
		if($("#chk_all").is(":checked"))
		{
			$('.chk_sale').prop("checked", true);
		}
		else
		{
			$('.chk_sale').prop("checked", false);
		}
	});
})


function getList(page_val)
{
	if (nullChk(page_val)!="") 
	{
		page = page_val;
	}
	
	setCookie("page",page,1);
	setCookie("order_by", order_by,1);
	setCookie("sort_type", sort_type,1);
	setCookie('listSize', $('#list_size').val(),1);
	setCookie('start_ymd',$('#start_ymd').val(),1);
	setCookie('end_ymd',$('#end_ymd').val(),1);
	setCookie('step',$('#step').val(),1);
	

	
	
	setCookie('important',$('#important_project').val(),1);
	
	
	setCookie('sale_manager',$('#sale_manager').val(),1);
	setCookie('sale_service',$('#sale_service').val(),1);
	setCookie('search_cont',$('#search_cont').val(),1);
	setCookie('upt_start_ymd',$('#upt_start_ymd').val(),1);
	setCookie('upt_end_ymd',$('#upt_end_ymd').val(),1);
	
	
	var important_yn = 'N';

	if ($('#important_chk').prop('checked')) 
	{
		important_yn='Y';
	}
	
	$.ajax({
		type : "POST", 
		url : "./getSaleList",
		dataType : "text",
		async : false,
		data : 
		{
			page : page,
			order_by : order_by,
			sort_type : sort_type,
			listSize : $('#list_size').val(),
			start_ymd : $('#start_ymd').val(),
			end_ymd : $('#end_ymd').val(),
			step : $('#step').val(),
			
			important_yn : important_yn,
			choice : $('#choice').val(),
			known_path : $('#known_path').val(),
			budget : $('#Budget').val(),

			sale_manager : $('#sale_manager').val(),
			sale_service : $('#sale_service').val(),
			search_cont : $('#search_cont').val(),
			upt_start_ymd : $('#upt_start_ymd').val(),
			upt_end_ymd : $('#upt_end_ymd').val(),
		},
		error : function() 
		{
			console.log("AJAX ERROR");
		},
		success : function(data) 
		{
			
			console.log(data);
			var result = JSON.parse(data);
			var inner = "";
			console.log(result);
			$('#sale_cnt').text('?????? '+result.list.length+'??? / ??? '+result.TotalCnt+'???');
			if(result.list.length > 0)
			{
					
				for(var i = 0; i < result.list.length; i++)
				{
					inner +='<tr>';
					inner +='	<td><input type="checkbox" class="chk_sale" value="'+result.list[i].idx+'"></td>';
					inner +='	<td onclick="javascript:location.href=\'write?idx='+result.list[i].idx+'\' ">'+nullChk(result.list[i].step)+'</td>';
					inner +='	<td onclick="javascript:location.href=\'write?idx='+result.list[i].idx+'\' ">'+nullChk(result.list[i].important_yn)+'</td>';
					inner +='	<td onclick="javascript:location.href=\'write?idx='+result.list[i].idx+'\' ">'+nullChk(result.list[i].NAME)+'</td>';
					inner +='	<td onclick="javascript:location.href=\'write?idx='+result.list[i].idx+'\' ">'+nullChk(result.list[i].user_company)+'</td>';
					inner +='	<td onclick="javascript:location.href=\'write?idx='+result.list[i].idx+'\' ">'+nullChk(result.list[i].select_way)+'</td>';
					inner +='	<td onclick="javascript:location.href=\'write?idx='+result.list[i].idx+'\' ">'+nullChk(result.list[i].project_budget)+'</td>';
					inner +='	<td onclick="javascript:location.href=\'write?idx='+result.list[i].idx+'\' ">'+nullChk(result.list[i].known_path.slice(0,-1))+'</td>';
					inner +='	<td onclick="javascript:location.href=\'write?idx='+result.list[i].idx+'\' ">'+nullChk(result.list[i].submit_date)+'</td>';
					inner +='	<td onclick="javascript:location.href=\'write?idx='+result.list[i].idx+'\' ">'+nullChk(result.list[i].update_date)+'</td>';
					inner +='	<td class="sale_comment_text" style="display:none">'+repWord(nullChk(result.list[i].comment))+'</td>';
					inner +='	<td class="sale_comment_btn" onclick="getSaleComment('+result.list[i].idx+')" ><span>??????</span></td>';
// 					inner +='	<td onclick="javascript:location.href=\'write?idx='+result.list[i].idx+'\' ">'+nullChk(result.list[i].user_type)+'</td>';
// 					inner +='	<td onclick="javascript:location.href=\'write?idx='+result.list[i].idx+'\' ">'+nullChk(result.list[i].known_path.slice(0,-1))+'</td>';
//					inner +='	<td onclick="javascript:location.href=\'write?idx='+result.list[i].idx+'\' ">'+nullChk(result.list[i].user_phone)+'</td>';
//					inner +='	<td onclick="javascript:location.href=\'write?idx='+result.list[i].idx+'\' ">'+nullChk(result.list[i].user_email)+'</td>';
// 					inner +='	<td onclick="javascript:location.href=\'write?idx='+result.list[i].idx+'\' ">'+nullChk(result.list[i].user_manager)+'</td>';
// 					inner +='	<td onclick="javascript:location.href=\'write?idx='+result.list[i].idx+'\' ">'+nullChk(result.list[i].service_type.slice(0,-1))+'</td>';
// 					inner +='	<td onclick="javascript:location.href=\'write?idx='+result.list[i].idx+'\' ">'+nullChk(result.list[i].project_type.slice(0,-1))+'</td>';
// 					inner +='	<td onclick="javascript:location.href=\'write?idx='+result.list[i].idx+'\' ">'+nullChk(result.list[i].start_ymd)+'</td>';
// 					inner +='	<td onclick="javascript:location.href=\'write?idx='+result.list[i].idx+'\' ">'+nullChk(result.list[i].end_ymd)+'</td>';
//					inner +='	<td onclick="javascript:location.href=\'write?idx='+result.list[i].idx+'\' ">'+nullChk(result.list[i].site_url)+'</td>';
					
					inner +='</tr>';
				}
			}
			else
			{
				inner += '<tr>';
				inner += '	<td colspan="18"><div class="no-data">??????????????? ????????????.</div></td>';
				inner += '</tr>';
			}
			
			order_by = result.order_by;
			sort_type = result.sort_type;
			listSize = result.listSize;
			$("#list_target").html(inner);
			$(".pro-pagenation").html(makePaging(result.page, result.s_page, result.e_page, result.pageNum, 1));
		}
	});
}

function excelDown()
{
	var filename = "????????????";
	var table = "excelTable";
	$('.sale_comment_text').show();
	$('.sale_comment_btn').hide();
	$('.sale_comment_btn').text('');
    exportExcel(filename, table);
    
    $('.sale_comment_text').hide();
    $('.sale_comment_btn').text('??????');
    $('.sale_comment_btn').show();
	
    
}

function doDelete(){
	
	
	var idx ="";
	$('.chk_sale').each(function(){ 
		if ($(this).prop('checked')==true) 
		{
			idx +=$(this).val()+"|";
		}
	})
	
	if (idx=="") 
	{
		alert('????????? ???????????? ??????????????????.');
		return;
	}
	
	if(!confirm("?????? ?????????????????????????"))
	{
		return;
	}
	
	if (idx=="") 
	{
		alert("????????? ???????????? ??????????????????.");
		return;
	}
	
	$.ajax({
		type : "POST", 
		url : "./doDelete",
		dataType : "text",
		async : false,
		data : 
		{
			idx : idx
		},
		error : function() 
		{
			console.log("AJAX ERROR");
		},
		success : function(data) 
		{
			console.log(data);
			var result = JSON.parse(data);
			alert(result.msg);
			if (result.isSuc=="success")
			{
				location.reload();				
			}
		}
	});    
}

function getSaleComment(sale_idx){
	$.ajax({
		type : "POST", 
		url : "./getSaleComment",
		dataType : "text",
		async : false,
		data : 
		{
			sale_idx : sale_idx
		},
		error : function() 
		{
			console.log("AJAX ERROR");
		},
		success : function(data) 
		{
			console.log(data);
			var result = JSON.parse(data);
			if (nullChk(result.data.comment)!='') 
			{
				alert(repWord(result.data.comment));
			}
			else
			{
				alert('????????? ???????????? ????????????.');
			}
		}
	}); 
}
</script>

<div id="container" class="sales_list">
	<h1 class="name">????????????</h1>
	<div class="searchBox">
		<div class="state">
			<p class="search_tit">?????????</p>
			<input type="text" id="search_cont" name="search_cont" placeholder="????????? /???????????? /????????? ????????? ???????????????." onkeypress="javascript:excuteEnter(getList);" style="width:125%">
		</div>
		<div class="list_top_wrap">
			<div class="calendar_box">
				<div class="calendar chart-calendar">
<!-- 					<div class="list_search_box"> -->
<!-- 						<h6 class="search_tit">???????????? ???????????? </h6> -->
<!-- 						<div class="calendar1"><input type="date" id="upt_start_ymd" class="cal_date"></div> -->
<!-- 						<div class="calendar2">-</div> -->
<!-- 						<div class="calendar3"><input type="date" id="upt_end_ymd" class="cal_date"></div> -->
<!-- 					</div> -->
					<div class="list_search_box">
						<h6 class="search_tit">???????????? </h6>
						<select name="date_srot_list" id="date_srot_list" class="date_srot_list">
							<option value="submit_date">?????????</option>
							<option value="update_date">?????????</option>
							<option value="start_date">?????????</option>
							<option value="end_date">?????????</option>
						</select>
						<div class="calendar1"><input type="date" id="start_ymd" class="cal_date"></div>
						<div class="calendar2">-</div>
						<div class="calendar3"><input type="date" id="end_ymd" class="cal_date"></div>
						<div id="important_project" class="important_project" onclick="getList(1)">
							<h6 class="search_tit">??????</h6>
							<input type="checkbox" id="important_chk" class="important_chk" />
						</div>
					</div>
				</div>	
			</div>
			<div class="state_box">
				
				<div class="state">
					<p class="search_tit">????????? </p> 
					<select id="sale_manager" name="sale_manager" onchange="getList(1);">
						<option value="" selected="selected">??????</option>
						<c:forEach var="i" items="${saleUserList}" varStatus="loop">
							<option value="${i.idx}">${i.name}</option>
						</c:forEach>
					</select>
				</div>
				
				<div class="state">
					<p class="search_tit">???????????? </p>
					<select id="step" onchange="getList(1);">
						<option value="">??????</option>
						<option value="1" class="red"><div></div>??????/??????</option>
						<option value="2" class="orange"><p></p>???????????????</option>
						<option value="3" class="orange"><p></p>????????????</option>
						<option value="4" class="orange"><p></p>???????????????</option>
						<option value="5" class="orange"><p></p>????????????</option>
						<option value="6" class="green"><p></p>??????</option>
						<option value="7" class="green"><p></p>??????</option>
					</select>
				</div>
				
				<div class="state">
					<p class="search_tit">???????????? </p>
					<select id="choice" onchange="getList(1);">
						<option value="">??????</option>
						<option value="01">????????????</option>
						<option value="02">????????????</option>
						<option value="03">????????????</option>
						<option value="04">??????</option>
						<option value="05">??????</option>
					</select>
				</div>
				
				<div class="state">
					<p class="search_tit">???????????? </p>
					<select id="known_path" onchange="getList(1);">
						<option value="">??????</option>
						<option value="01">???????????????</option>
						<option value="02">????????????</option>
						<option value="03">?????????</option>
						<option value="04">?????????</option>
						<option value="05">?????? ??????</option>
						<option value="06">????????? ??????</option>
						<option value="07">??????????????? ?????????</option>
						<option value="08">??????????????????</option>
						<option value="09">??????</option>
					</select>
				</div>
				
				<div class="state">
					<p class="search_tit">?????? </p>
					<select id="Budget" onchange="getList(1);">
						<option value="">??????</option>
						<option value="01">3????????? ??????</option>
						<option value="02">3~5????????? ??????</option>
						<option value="03">5~1?????? ??????</option>
						<option value="04">1~2????????????</option>
						<option value="05">2??????~3?????? ??????</option>
						<option value="06">3????????????</option>
					</select>
				</div>
				
			</div>	
		</div>
	</div>
	
	<div class="alignment_wrap">
		<div id="sale_cnt"></div>
				
		<div class="list_option">
			<select id="list_size" name="list_size" onchange="getList();">
				<option value="10" selected="selected">10??? ??????</option>
				<option value="20" >20??? ??????</option>
				<option value="50" >50??? ??????</option>
				<option value="100" >100??? ??????</option>
				<option value="1000" >1000??? ??????</option>					
			</select>
			<div class="calendar4 del_btn" onclick="doDelete();">??????</div>
		</div>	
	</div>
	
	<div class="board_wrap">
		<table id="excelTable" class="board">
			<thead>
			
				<!--<tr style="display:none;">
					<th colspan="3">??????</th>
					<th colspan="5">????????????</th>
					<th colspan="8">????????????</th>
				</tr>-->
				<tr>
					<th><input type="checkbox" id="chk_all"></th> 
					<th onclick="reSortAjax('sort_step_no');">????????????</th>
					<th onclick="reSortAjax('sort_important');">??????</th>
					<th onclick="reSortAjax('sort_name');">?????????</th>
					<th onclick="reSortAjax('sort_user_company');">?????????</th>
					<th onclick="reSortAjax('sort_select_way');">????????????</th>
					<th onclick="reSortAjax('sort_project_budget');">??????</th>
					<th onclick="reSortAjax('sort_known_path');">????????????</th>
					<th onclick="reSortAjax('sort_submit_date');">?????? ??????</th>
					<th onclick="reSortAjax('sort_update_date');">?????? ??????</th>
					<th>?????????</th>
<!-- 					<th onclick="reSortAjax('sort_user_type');">????????????</th> -->
<!-- 					<th onclick="reSortAjax('sort_user_manager');">????????????</th> -->
					<!--<th>?????????</th>
					<th>?????????</th>-->
<!-- 					<th onclick="reSortAjax('sort_service_type');">?????????</th> -->
<!-- 					<th onclick="reSortAjax('sort_project_type');">???????????? ??????</th> -->
<!--  			        <th onclick="reSortAjax('sort_start_ymd');">?????? ??????</th> -->
<!-- 					<th onclick="reSortAjax('sort_end_ymd');">?????? ?????????</th> -->
					<!--<th>?????? ????????? ??????</th>
					<th>????????????</th>-->
				</tr>
			</thead>
			<tbody id="list_target">
			
			</tbody>
		</table>
	</div>
	<div class="list_btn_wrap">
		<div class="down_bt list_down_bt" onclick="excelDown();">?????? ????????????</div>	
	</div>
	<jsp:include page="/WEB-INF/pages/family/common/paging_new.jsp"/>
</div>

<script>
$( document ).ready(function() {
	
	
	getCookie('listSize')      != '' ? $('#list_size').val(getCookie('listSize'))          : $('#list_size').val();
	getCookie('start_ymd')     != '' ? $('#start_ymd').val(getCookie('start_ymd'))         : $('#start_ymd').val();
	getCookie('end_ymd')       != '' ? $('#end_ymd').val(getCookie('end_ymd'))             : $('#end_ymd').val(); 
	getCookie('step')          != '' ? $('#step').val(getCookie('step'))                   : $('#step').val(); 
	getCookie('important')     != '' ? $('#important_project').val(getCookie('important')) : $('#important_project').val();
	getCookie('sale_manager')  != '' ? $('#sale_manager').val(getCookie('sale_manager'))   : $('#sale_manager').val();
	getCookie('sale_service')  != '' ? $('#sale_service').val(getCookie('sale_service'))   : $('#sale_service').val();
	getCookie('search_cont')   != '' ? $('#search_cont').val(getCookie('search_cont'))     : $('#search_cont').val();
	getCookie('upt_start_ymd') != '' ? $('#upt_start_ymd').val(getCookie('upt_start_ymd')) : $('#upt_start_ymd').val();
	getCookie('upt_end_ymd')   != '' ? $('#upt_end_ymd').val(getCookie('upt_end_ymd'))     : $('#upt_end_ymd').val();
	if(nullChk(getCookie("page")) != "") { page = nullChk(getCookie("page")); }
	if(nullChk(getCookie("order_by")) != "") { order_by = nullChk(getCookie("order_by")); }
	if(nullChk(getCookie("sort_type")) != "") { sort_type = nullChk(getCookie("sort_type")); }
});
</script>
<jsp:include page="/WEB-INF/pages/family/common/footer.jsp"/>