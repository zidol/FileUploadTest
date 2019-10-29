<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
    /* iframe 스타일 설정 */
    iframe {
        width: 600px;
        height: 100px;
        border: 1px;
        border-style: solid;
    }
</style>
</head>
<body>
<%-- <%@ include file="../include/menu.jsp" %> --%>
    <!-- enctype="multipart/form-data" 파일업로드 필수 옵션 -->
    <!-- application/x-www-form-urlencoded 기본옵션 -->
    <form id="form1" action="/upload/uploadForm" target="iframePhoto" method="post" enctype="multipart/form-data" accept-charset="UTF-8">
        <input multiple="multiple" type="file" name="file">
        <input type="submit" value="업로드">    
    </form>
    <!-- form data가 이곳으로 이동 -->
    <iframe name="iframePhoto"></iframe>
	<script>
	
	function addFilePath(msg){
	    console.log(msg); // 파일명 콘솔 출력
	    document.getElementById("form1").reset(); // ifream에 업로드결과를 출력 후 form에 저장된 데이터 초기화
	}
	</script>
</body>
</html>