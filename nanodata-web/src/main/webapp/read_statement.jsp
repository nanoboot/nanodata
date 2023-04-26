<%@page import="org.nanoboot.nanodata.web.misc.utils.Utils"%>
<%@page import="org.nanoboot.nanodata.persistence.api.StatementRepo"%>
<%@page import="org.nanoboot.nanodata.persistence.api.ItemRepo"%>
<%@page import="org.nanoboot.nanodata.entity.Statement"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.context.ApplicationContext"%>
<%@page import="java.util.Scanner"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Comparator"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<!DOCTYPE>
<%@ page session="false" %>

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


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Read item - Nanodata</title>
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
        >> 
        <a href="read_statement.jsp?id=<%=id%>" class="nav_a_current">Read</a>
        
        
                    <% boolean canUpdate = org.nanoboot.nanodata.web.misc.utils.Utils.canUpdate(request); %>
<% if(canUpdate) { %>
        <a href="update_statement.jsp?id=<%=id%>">Update</a>
<% } %>


        
        
    </span>




    <%
        ApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(getServletContext());
        StatementRepo statementRepo = context.getBean("statementRepoImplSqlite", StatementRepo.class);
        ItemRepo itemRepo = context.getBean("itemRepoImplSqlite", ItemRepo.class);
        Statement statement = statementRepo.read(id);

        if (statement == null) {
    %><span style="font-weight:bold;color:red;" class="margin_left_and_big_font">Error: Statement with id <%=id%> was not found.</span>

    <%
            throw new jakarta.servlet.jsp.SkipPageException();
        }
    %>
    <style>
        th{
            text-align:left;
            background:#cccccc;
        }
    </style>
    <p class="margin_left_and_big_font">
        <a href="read_item.jsp?id=<%=statement.getId()%>&previous_next=previous" class="button">Previous</a>
        <a href="read_item.jsp?id=<%=statement.getId()%>&previous_next=next" class="button">Next</a>
        <br><br>
    </p>
    
<script>  
function redirectToUpdate() {
    
    <% if(canUpdate) { %>
window.location.href = 'update_statement.jsp?id=<%=id%>'
<% } %>

}


</script>  
    <table ondblclick = "redirectToUpdate()">
        <tr>
            <th>ID</th><td><%=statement.getId()%></td></tr>
        <tr><th>Source</th><td><a href="read_item?id=<%=statement.getSource()%>"><%=itemRepo.getLabel(statement.getSource())%></a></td></tr>
        <tr><th>Value</th><td><%=Utils.formatToHtml(statement.getValue())%></td></tr>
        <tr><th>Target</th><td><a href="read_item?id=<%=statement.getTarget()%>"><%=itemRepo.getLabel(statement.getTarget())%></a></td></tr>
        
        

    </table>
        
     
        <div id="footer">Content available under a <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License.">Creative Commons Attribution-ShareAlike 4.0 International License</a> <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License."><img alt="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License." style="border-width:0" src="images/creative_commons_attribution_share_alike_4.0_international_licence_88x31.png" /></a></div>
</body>
</html>
