<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
.fileDrop {
	width: 600px;
	height: 200px;
	border: 1px dotted blue;
}

small {
	margin-left: 3px;
	font-weight: bold;
	color: gray;
}
</style>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script>
	// $(document).ready(function(){
    //     var formData = new FormData();
    //     console.log(formData);
        
	// });
    $(document).ready(function(){
        $(".fileDrop").on("dragenter dragover", function(event){
            event.preventDefault(); // 기본효과를 막음
        });
        // event : jQuery의 이벤트
        // originalEvent : javascript의 이벤트
        $(".fileDrop").on("drop", function(event){
            event.preventDefault(); // 기본효과를 막음
            // 드래그된 파일의 정보
            var files = event.originalEvent.dataTransfer.files;
            // 첫번째 파일
            var file = [];
            for(var i = 0; i<files.length; i++) {
                file.push(files[i]);    
            }
            // 콘솔에서 파일정보 확인
            console.log("files 정보 : ", files);
            console.log("file[0] 정보 : ", file[0]);
            console.log("file[1] 정보 : ", file[1]);
                        
            // ajax로 전달할 폼 객체
            var formData = new FormData();
            // 폼 객체에 파일추가, append("변수명", 값)
            for(var i = 0; i < files.length; i++) {
                formData.append("file", file[i]);
            }
            console.log("Formdata : ", formData);

            $.ajax({
                type: "post",
                url: "${path}/upload/uploadAjax",
                data: formData,
                // processData: true=> get방식, false => post방식
                dataType: "text",
                // contentType: true => application/x-www-form-urlencoded, 
                //                false => multipart/form-data
                processData: false,
                contentType: false,
                success: function(data){
                    var jdata = JSON.parse(data);
                    console.log("upload data : ", jdata);
                    console.log("upload data lenghth : ", jdata.length);
                     
                    var str = "";
                    // 이미지 파일이면 썸네일 이미지 출력
                    for(var i = 0; i < jdata.length; i++) {
                        
                        if(checkImageType(jdata[i])){ 
                        str = "<div><a href='${path}/upload/displayFile?fileName="+getImageLink(jdata[i])+"'>";
                        str += "<img src='${path}/upload/displayFile?fileName="+jdata[i]+"'></a>";
                        // 일반파일이면 다운로드링크
                        } else { 
                            str = "<div><a href='${path}/upload/displayFile?fileName="+jdata[i]+"'>"+getOriginalName(jdata[i])+"</a>";
                        }
                        // 삭제 버튼
                        str += "<span data-src="+jdata[i]+">[삭제]</span></div>";
                        $(".uploadedList").append(str);
                    }
                },
                error : function(error) {
                    console.log("error : ", error);
                }
            });
        });

        $(".uploadedList").on("click", "span", function(event){
            alert("이미지 삭제")
            var that = $(this); // 여기서 this는 클릭한 span태그
            $.ajax({
                url: "${path}/upload/deleteFile",
                type: "post",
                // data: "fileName="+$(this).attr("date-src") = {fileName:$(this).attr("data-src")}
                // 태그.attr("속성")
                data: {fileName:$(this).attr("data-src")}, // json방식
                dataType: "text",
                success: function(result){
                    if( result == "deleted" ){
                        // 클릭한 span태그가 속한 div를 제거
                        that.parent("div").remove();
                    }
                }
            });
        });
    });
    function checkImageType(fileName) {
        // i : ignore case(대소문자 무관)
        var pattern = /jpg|gif|png|jpeg/i; // 정규표현식
        return fileName.match(pattern); // 규칙이 맞으면 true
    }

    function getImageLink(fileName) {
        // 이미지파일이 아니면
        if(!checkImageType(fileName)) { 
            return; // 함수 종료 
        }
        // 이미지 파일이면(썸네일이 아닌 원본이미지를 가져오기 위해)
        // 썸네일 이미지 파일명 - 파일경로+파일명 /2017/03/09/s_43fc37cc-021b-4eec-8322-bc5c8162863d_spring001.png
        var front = fileName.substr(0, 12); // 년원일 경로 추출
        var end = fileName.substr(14); // 년원일 경로와 s_를 제거한 원본 파일명을 추출
        console.log(front); // /2017/03/09/
        console.log(end); // 43fc37cc-021b-4eec-8322-bc5c8162863d_spring001.png
        // 원본 파일명 - /2017/03/09/43fc37cc-021b-4eec-8322-bc5c8162863d_spring001.png
        return front+end; // 디렉토리를 포함한 원본파일명을 리턴
    }

        // 원본파일이름을 목록에 출력하기 위해
    function getOriginalName(fileName) {
        // 이미지 파일이면
        if(checkImageType(fileName)) {
            return; // 함수종료
        }
        // uuid를 제외한 원래 파일 이름을 리턴
        var idx = fileName.indexOf("_")+1;
        return fileName.substr(idx);
    }
</script>
</head>
<body>
	<h2>AJAX File Upload</h2>
	<!-- 파일을 업로드할 영역 -->
	<div class="fileDrop"></div>
	<!-- 업로드된 파일 목록 -->
	<div class="uploadedList"></div>
</body>
</html>