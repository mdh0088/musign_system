<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>    
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script src="/inc/js/dosign.js"></script>
<jsp:include page="/WEB-INF/pages/family/common/header.jsp"/>
<jsp:include page="/WEB-INF/pages/family/common/lnb.jsp"/>

<script>
$(document).ready(function(){
	
	if ("${title}"!="") 
	{
		$('#rr_title').text( repWord("${title}"));
	}
	
	if ("${purpose}"!="") 
	{
		$('#rr_purpose').text( repWord("${purpose}"));
	}
	
	if ("${company}"!="") 
	{
		$('#rr_company').text( repWord("${company}"));
	}
	
	if ("${cont}"!="") 
	{
		$('#rr_cont').val( repWord("${cont}"));
	} 
	getInfo();
	
	var ref_team_nm="${ref_team_nm}";
	var ref_nm ="${ref_nm}";
	
	if (ref_nm!="") 
	{
		ref_nm=ref_nm.split('|');
		ref_team_nm=ref_team_nm.split('|');
		var inner ='';
			inner +='<tr>';
			inner +='	<td rowspan="2" >ํ์กฐ๋ถ์</td>';
		for (var i = 0; i < ref_team_nm.length-1; i++) {
			inner +='	<td class="ref_td">'+ref_team_nm[i]+'</td>';
		}
			inner +='</tr>';
			inner +='<tr>';
		
		for (var i = 0; i < ref_nm.length-1; i++) {
			inner +='	<td>'+ref_nm[i]+'</td>';
		}
			inner +='</tr>';
		$("#ref_area").show();
		$("#ref_target").html(inner);
	}
	
})

function getInfo(){
	var detail_cont = "${detail_cont}".split('|');
	var detail_amt = "${detail_amt}".split('|');
	var detail_receipt = "${detail_receipt}".split('|');
	var detail_receipt_ori = "${detail_receipt_ori}".split('|');
	
	var inner="";
	var sum=0;
	for (var i = 0; i < detail_cont.length-1; i++) 
	{
		sum +=detail_amt[i]*1; 
		inner +='<tr>';
		inner +='<th>'+(i+1)+'</th>';
		inner +='<th colspan="3">'+detail_cont[i]+'</th>';
		inner +='<th>'+comma(detail_amt[i])+'</th>';
		
		
		if (nullChk(detail_receipt[i])!='') 
		{
			inner +='<th colspan="2">';
			inner +="	<img src='/img/doc_icon.png' style='width:50px; height:50px;' onclick=\"window.open('${image_dir}rr_receipt/"+detail_receipt[i]+"', 'imgView', 'width=500', 'height=500')\">";
			inner +='</th>';
		}
		else
		{
			inner +='<th colspan="2">๋ฑ๋ก๋ ์์์ฆ์ด<br> ์์ต๋๋ค.</th>';
		}
		inner +='</tr>';
	}
	
	inner +="<tr>";
	inner +='<th colspan="6">ํฉ๊ณ : '+comma(sum)+'</th>';
	inner +="</tr>";

	$('#list_area').after(inner);
	
	
}

</script>
<div id="container">
	<div class="musign-grid musign-grid02">
		<jsp:include page="/WEB-INF/pages/family/dosign/comment_area.jsp"/>
		<div id="mySelector" class="container">
			<h2>ํ์์</h2>
					<jsp:include page="/WEB-INF/pages/family/dosign/line_area.jsp"/>
			   <div class="sec sec2">

					<div id="ref_area">
		    			<span style="display: table;margin: 0 auto;">์ต&nbsp;์ข&nbsp;๊ฒฐ&nbsp;์ฌ&nbsp;๊ถ&nbsp;์&nbsp;์ &nbsp;&nbsp;์&nbsp;๊ฒฌ &nbsp;&nbsp;๋ฐ &nbsp;&nbsp;์ง&nbsp;์&nbsp;์ฌ&nbsp;ํญ</span>
		    			<table class="box-r" border='1'>
		    				<colgroup>
		    					<col width="46px">
		    					<col width="84px">
		    					<col width="84px">
		    					<col width="84px">
		    				</colgroup>
		    				<tbody id="ref_target">

		    				</tbody>
		    			</table>
		    		</div>
	    			
	    			<table>
	    				<tr>
	    					<td >์?๋ชฉ</td> 
	    					<td colspan="6" id="rr_title"></td>
	    				</tr>

	    				<tr>
	    					<td colspan="6" class="text-left">
	    						1. ๋ชฉ์? : <span id="rr_purpose"></span><br>
	    						2. ์์ฒด : <span id="rr_company"></span><br>
	    						3. ์ฉ์ญ๊ธฐ๊ฐ : ${start_ymd} ~ ${end_ymd}<br>
	    						4. ๋ด์ฉ : <textarea id="rr_cont" readonly="readonly"></textarea><br>
	    					</td>
	    				</tr>
           		        <tr id="list_area">
           		        	<th class="color-g">No.</th>
           		        	<th class="color-g" colspan="3">๋ด์ฉ</th>
           		        	<th class="color-g">๊ธ์ก</th>
           		        	<th class="color-g" colspan="2">์์์ฆ๋ณด๊ธฐ</th>
           		        </tr>
	    			</table>

			   </div>
			<div class="sec sec3">
				<p>์์ ๊ฐ์ ์ฌ์?๋ก ํ์ํ๊ณ?์ ํ์ค๋ ๊ฒฐ์ฌํ์ฌ ์ฃผ์๊ธฐ ๋ฐ๋๋๋ค.</p>
			</div>
		</div>
		<c:if test="${isManager eq 'Y'}">
			<input type="button" value="๊ฒฐ์ฌ" onclick="final_approve('${idx}')">
			<input type="button" value="๋ฐ๋?ค" onclick="show_comment('return')">
		</c:if>
	</div>
</div>



<jsp:include page="/WEB-INF/pages/family/common/footer.jsp"/>