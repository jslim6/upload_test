<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>신규 게시글 작성</title>
</head>
<body>
	<!-- 게시글 작성 폼임을 표시 -->
	<h1>게시글 작성</h1>
	<!-- 파일 전송을 위한 multipart 선언 -->
	<form method="post" action="board_new_send.jsp" enctype="multipart/form-data">
		<table>
			<tr>
				<td><input type="text" placeholder="제목" name="title" maxlength="20" value=""></td>
			</tr>
			<tr>
				<td><textarea placeholder="내용" name="content" maxlength="2048" style="height:150px;"></textarea></td>
			</tr>
		</table>
		<input type="file" name="file">
		<hr>
		<input type="submit" value="글쓰기">
	</form>
</body>
</html>