<!-- SQL ������ ���� import -->
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>�Խñ� ���</title>
</head>
<body>
    <!-- �Խñ� ��� ������ ǥ�� -->
    <h1>�Խñ� ��ϵ�</h1>
      <%
      try
      {
        // JDBC  ����̹� ����
        Class.forName("com.mysql.jdbc.Driver");
        String db_address = "jdbc:mysql://localhost:3306/file_board";
        String db_username = "root";
        String db_pwd = "root";
        Connection connection = DriverManager.getConnection(db_address, db_username, db_pwd);
        
        // MySQL�� �����ϱ� ���� �������� insertQuery ���ڿ� ����
        String insertQuery = "SELECT * FROM file_board.post order by num desc";
        
        // MySQL ������ ����
        PreparedStatement psmt = connection.prepareStatement(insertQuery);
        
        // �������� ������ �޾ƿ� ������ result ��ü�� ����
        ResultSet result = psmt.executeQuery();%>
        
        <!-- �Խñ� ����� ǥ���� �⺻ ���̺� ���� -->
        <table border="1">
        <tr>
          <td colspan="5">
            <h3>�Խñ� ���� Ŭ���� �� ���� ����</h3>
          </td>
        </tr>
        <tr>
		  <td colspan="5">
            <button type="button" value="�ű� �� �ۼ�" onClick="location.href='board_new.jsp'">�ű� �� �ۼ�</button>
          </td>
        </tr>
        <tr>
          <td>��ȣ</td>
          <td>����</td>
          <td>�ۼ���</td>
        </tr>
        <%
        // �޾ƿ� ������ �Է��ϰ�, �ϳ��� Ŀ���� �������� �ѱ�
        while (result.next())
          {%>
            <tr>
              <!-- ��ȣ <td> �Ʒ��� DB���� �޾ƿ� num Į���� ���� -->
              <td><%=result.getInt("num") %></td>
              
              <!-- ���� <td> �Ʒ��� DB���� �޾ƿ� title Į���� ����, ���� Ŭ���� post_read.jsp�� ����Ǹ� num Į������ parameter�� �ѱ� -->
              <td><a href="board_read.jsp?num=<%=result.getInt("num") %>"><%=result.getString("title") %></a></td>
              
              <!-- �ۼ��� <td> �Ʒ��� DB���� �޾ƿ� date Į���� ���� -->
              <td><%=result.getTimestamp("date") %></td>
            </tr>
            <%
            }%>
          </table>
        <%
        }
      catch (Exception ex)
      {
        out.println("������ �߻��߽��ϴ�. ���� �޽��� : " + ex.getMessage());
      }%>
</body>
</html>