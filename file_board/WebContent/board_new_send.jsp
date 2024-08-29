<%@page import="java.sql.*"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%
try
{
	// JDBC 드라이버 연결
    Class.forName("com.mysql.jdbc.Driver");
    String db_address = "jdbc:mysql://127.0.0.1:3306/file_board";
    String db_username = "root";
    String db_pwd = "root";
    Connection connection = DriverManager.getConnection(db_address, db_username, db_pwd);
    
    // 인코딩 UTF-8 설정
    request.setCharacterEncoding("UTF-8");
    
 	// 게시글 번호를 결정하기 위한 임시 정수형 변수 선언
 	int num = 0;
    
 	// 절대경로를 파악하기 위한 문자열 변수 선언
 	String uploadRoute = "";
 	
 	// MySQL로 전송하기 위한 쿼리문인 insertQuery 문자열 선언 (현재 등록된 게시글의 갯수를 파악)
 	String insertQuery = "SELECT MAX(num) from file_board.post";
 
 	// SQL 쿼리문을 실행 (MySQL로 전송)하기 위한 객체 선언
 	PreparedStatement psmt = connection.prepareStatement(insertQuery);
 	
 	// 조회된 결과물들을 저장하기 위한 ResultSet 객체 선언
 	ResultSet result = psmt.executeQuery();
 	
 	// 받아온 정보가 있을때
 	while(result.next())
 	{
 		// 앞서 임시 선언한 num 변수에, 가져온 MAX(num) 칼럼값 + 1을 하여 저장
 		num = result.getInt("MAX(num)") + 1;
 	}
 			
 	// 날짜
	Timestamp today_date = new Timestamp(System.currentTimeMillis());
 	
	String uploadDir = this.getClass().getResource("").getPath();
	
	// 파일이 업로드될 경로
	uploadRoute = "file_board/WebContent/upload/";
	
	uploadDir = uploadDir.substring(1, uploadDir.indexOf(".metadata")) + uploadRoute;
	
	// 파일 크기 제한 byte 크기
	int maxSize = 100 * 1024 * 1024;
	
	// 인코딩 설정
	String encoding = "UTF-8";
	
	// Multipartrequest 객체 선언
	MultipartRequest multipartRequest = new MultipartRequest(request, uploadDir, maxSize, encoding, new DefaultFileRenamePolicy());
	String fileName = multipartRequest.getOriginalFileName("file");
	String fileRealName = multipartRequest.getFilesystemName("file");
	String title = multipartRequest.getParameter("title");
	String content = multipartRequest.getParameter("content");
	
	// MySQL로 전송하기 위한 쿼리문인 insertQuery 문자열 선언 (사용자가 신규 게시글 작성한 정보를 전송)
	insertQuery = "INSERT INTO file_board.post(num, title, content, date, file_name, file_realName, file_route) VALUES (?, ?, ?, ?, ?, ?, ?)";
			
	// SQL 쿼리문을, 새로운 내용을 토대로 재실행
	psmt = connection.prepareStatement(insertQuery);
		
	// VALUES ? 값에 하나씩 삽입하여 전송
	psmt.setInt(1, num);
	psmt.setString(2, title);
	psmt.setString(3, content);
	psmt.setTimestamp(4, today_date);
	psmt.setString(5, fileName);
	psmt.setString(6, fileRealName);
	psmt.setString(7, "/file_board/upload/" + fileRealName);
		
	// INSERT 하여 반영된 레코드의 건수결과를 반환
	psmt.executeUpdate();
	
	response.sendRedirect("board_list.jsp");
}
catch (Exception ex)
{
    out.println("오류가 발생했습니다. 오류 메시지 : " + ex.getMessage());
}
%>