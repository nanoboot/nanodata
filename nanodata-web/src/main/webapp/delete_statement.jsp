<%@page import="org.nanoboot.powerframework.time.moment.LocalDate"%>
<%@page import="org.nanoboot.nanodata.web.misc.utils.Utils"%>
<%@page import="org.nanoboot.nanodata.persistence.api.StatementRepo"%>
<%@page import="org.nanoboot.nanodata.entity.Statement"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.context.ApplicationContext"%>

<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="org.apache.commons.fileupload.FileUploadException"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.io.output.*"%>

<!DOCTYPE>
<!--
 Nanodata.
 Copyright (C) 2023-2023 the original author or authors.

 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; version 2
 of the License only.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
-->

<%@ page session="false" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Update statement - Nanodata</title>
        <link rel="stylesheet" type="text/css" href="styles/nanodata.css">
        <link rel="icon" type="image/x-icon" href="favicon.ico" sizes="32x32">
    </head>

    <body>

        <a href="index.jsp" id="main_title">Nanodata</a></span>


    <%
        String id = request.getParameter("id");
        if (id == null || id.isEmpty()) {
    %><span style="font-weight:bold;color:red;" class="margin_left_and_big_font">Error: Parameter "id" is required</span>

    <%
            throw new jakarta.servlet.jsp.SkipPageException();
        }
    %>

    <span class="nav"><a href="index.jsp">Home</a>
        >> <a href="statements.jsp">Statements</a>
        >> <a href="read_statement.jsp?id=<%=id%>">Read</a>
        <a href="update_statement.jsp?id=<%=id%>">Update</a>
        <a href="delete_statement.jsp?id=<%=id%>" class="nav_a_current">Delete</a>


    </span>

    <%
        if (org.nanoboot.nanodata.web.misc.utils.Utils.cannotUpdate(request)) {
            out.println("Access forbidden");
            throw new jakarta.servlet.jsp.SkipPageException();
        }
    %>
    <%
        ApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(getServletContext());
        StatementRepo statementRepo = context.getBean("statementRepoImplSqlite", StatementRepo.class);
        Statement statement = statementRepo.read(id);

        if (statement == null) {
    %><span style="font-weight:bold;color:red;" class="margin_left_and_big_font">Error: statement with id <%=id%> was not found.</span>

    <%
            throw new jakarta.servlet.jsp.SkipPageException();
        }
        String param_user_agree_to_delete_this_statement = request.getParameter("user_agree_to_delete_this_statement");
        boolean formToBeProcessed = param_user_agree_to_delete_this_statement != null && !param_user_agree_to_delete_this_statement.isEmpty();
    %>


    <% if (!formToBeProcessed) {%>
    <form action="delete_statement.jsp" method="get">
        <input type="hidden" name="id" value="<%=id%>" readonly></td>

        <input type="hidden" name="user_agree_to_delete_this_statement" value="yes">

        <a href="statements.jsp" style="font-size:130%;background:#dddddd;border:2px solid #bbbbbb;padding:2px;text-decoration:none;">Cancel</a></td>
    <input type="submit" value="Delete forever">






</form>

<% } else { %>



<%
  
    statementRepo.delete(id);

%>


<script>
    function redirectToList() {
        window.location.href = 'statements.jsp?id=<%=id%>'
    }
    redirectToList();
</script>



<% }%>

<div id="footer">Content available under a <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License.">Creative Commons Attribution-ShareAlike 4.0 International License</a> <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License."><img alt="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License." style="border-width:0" src="images/creative_commons_attribution_share_alike_4.0_international_licence_88x31.png" /></a></div>
</body>
</html>
