<%@page import="java.sql.*"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%
try
{
	// JDBC ����̹� ����
    Class.forName("com.mysql.jdbc.Driver");
    String db_address = "jdbc:mysql://127.0.0.1:3306/file_board";
    String db_username = "root";
    String db_pwd = "root";
    Connection connection = DriverManager.getConnection(db_address, db_username, db_pwd);
    
    // ���ڵ� UTF-8 ����
    request.setCharacterEncoding("UTF-8");
    
 	// �Խñ� ��ȣ�� �����ϱ� ���� �ӽ� ������ ���� ����
 	int num = 0;
    
 	// �����θ� �ľ��ϱ� ���� ���ڿ� ���� ����
 	String uploadRoute = "";
 	
 	// MySQL�� �����ϱ� ���� �������� insertQuery ���ڿ� ���� (���� ��ϵ� �Խñ��� ������ �ľ�)
 	String insertQuery = "SELECT MAX(num) from file_board.post";
 
 	// SQL �������� ���� (MySQL�� ����)�ϱ� ���� ��ü ����
 	PreparedStatement psmt = connection.prepareStatement(insertQuery);
 	
 	// ��ȸ�� ��������� �����ϱ� ���� ResultSet ��ü ����
 	ResultSet result = psmt.executeQuery();
 	
 	// �޾ƿ� ������ ������
 	while(result.next())
 	{
 		// �ռ� �ӽ� ������ num ������, ������ MAX(num) Į���� + 1�� �Ͽ� ����
 		num = result.getInt("MAX(num)") + 1;
 	}
 			
 	// ��¥
	Timestamp today_date = new Timestamp(System.currentTimeMillis());
 	
	String uploadDir = this.getClass().getResource("").getPath();
	
	// ������ ���ε�� ���
	uploadRoute = "file_board/WebContent/upload/";
	
	uploadDir = uploadDir.substring(1, uploadDir.indexOf(".metadata")) + uploadRoute;
	
	// ���� ũ�� ���� byte ũ��
	int maxSize = 100 * 1024 * 1024;
	
	// ���ڵ� ����
	String encoding = "UTF-8";
	
	// Multipartrequest ��ü ����
	MultipartRequest multipartRequest = new MultipartRequest(request, uploadDir, maxSize, encoding, new DefaultFileRenamePolicy());
	String fileName = multipartRequest.getOriginalFileName("file");
	String fileRealName = multipartRequest.getFilesystemName("file");
	String title = multipartRequest.getParameter("title");
	String content = multipartRequest.getParameter("content");
	
	// MySQL�� �����ϱ� ���� �������� insertQuery ���ڿ� ���� (����ڰ� �ű� �Խñ� �ۼ��� ������ ����)
	insertQuery = "INSERT INTO file_board.post(num, title, content, date, file_name, file_realName, file_route) VALUES (?, ?, ?, ?, ?, ?, ?)";
			
	// SQL ��������, ���ο� ������ ���� �����
	psmt = connection.prepareStatement(insertQuery);
		
	// VALUES ? ���� �ϳ��� �����Ͽ� ����
	psmt.setInt(1, num);
	psmt.setString(2, title);
	psmt.setString(3, content);
	psmt.setTimestamp(4, today_date);
	psmt.setString(5, fileName);
	psmt.setString(6, fileRealName);
	psmt.setString(7, "/file_board/upload/" + fileRealName);
		
	// INSERT �Ͽ� �ݿ��� ���ڵ��� �Ǽ������ ��ȯ
	psmt.executeUpdate();
	
	response.sendRedirect("board_list.jsp");
}
catch (Exception ex)
{
    out.println("������ �߻��߽��ϴ�. ���� �޽��� : " + ex.getMessage());
}
%>