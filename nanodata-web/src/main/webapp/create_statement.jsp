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

<%@page import="org.nanoboot.nanodata.persistence.api.StatementRepo"%>
<%@page import="org.nanoboot.nanodata.entity.Statement"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.context.ApplicationContext"%>
<!DOCTYPE>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Nanodata - Add statement</title>
        <link rel="stylesheet" type="text/css" href="styles/nanodata.css">
        <link rel="icon" type="image/x-icon" href="favicon.ico" sizes="32x32">
    </head>

    <body>

        <a href="index.jsp" id="main_title">Nanodata</a></span>

    <span class="nav"><a href="index.jsp">Home</a>
        >> <a href="statements.jsp">Statements</a>
        >> <a href="create_statement.jsp" class="nav_a_current">Add Statement</a></span>
        
    <%
        if (org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.cannotUpdate(request)) {
            out.println("Access forbidden");
            throw new jakarta.servlet.jsp.SkipPageException();
        }
    %>
    
    <%
        ApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(getServletContext());
        StatementRepo statementRepo = context.getBean("statementRepoImplSqlite", StatementRepo.class);
    %>


    <%
        String param_value = request.getParameter("value");
        String param_source_for_form = request.getParameter("source");
        boolean formToBeProcessed = param_value != null && !param_value.isEmpty();
    %>

    <% if (!formToBeProcessed) { %>
    <form action="create_statement.jsp" method="post">
        <table>


    
            <tr>
                <td><label for="source">Source<b style="color:red;font-size:130%;">*</b>:</label></td>
                <td><input type="text" name="source" value="<%=(param_source_for_form==null?"":param_source_for_form)%>"></td>
            </tr>
            <tr>
                <td><label for="value">Value<b style="color:red;font-size:130%;">*</b></label></td>
                <td><input type="text" name="value" value=""></td>
            </tr>
            <tr>
                <td><label for="target">Target<b style="color:red;font-size:130%;">*</b></label></td>
                <td style="text-align:left;"><input type="text" name="target" value="" ></td>
            </tr>
           
            <tr>
                <td><label for="target">Flags<b style="color:red;font-size:130%;">*</b></label></td>
                <td style="text-align:left;"><input type="text" name="flags" value="" ></td>
            </tr>
           
         
         
            <tr>
                <td><a href="statements.jsp" style="font-size:130%;background:#dddddd;border:2px solid #bbbbbb;padding:2px;text-decoration:none;">Cancel</a></td>
                <td style="text-align:right;"><input type="submit" value="Add"></td>
            </tr>
        </table>
        <b style="color:red;font-size:200%;margin-left:20px;">*</b> ...mandatory


    </form>
            
            <iframe src="items.jsp" width="800" height="800">
            </iframe>
            
    <% } else { %>

    <%
        
     String param_source = request.getParameter("source");
     String param_target = request.getParameter("target");
     String param_flags = request.getParameter("flags");

        //
        Statement newStatement = new Statement(
                null,
                param_value,
                param_source,
                param_target,
                null,
                param_flags
        );

        String idOfStatement = statementRepo.create(newStatement);

        newStatement.setId(idOfStatement);
    %>


    <p style="margin-left:20px;font-size:130%;">Created new item with id <%=newStatement.getId()%>:<br><br>
        <a href="read_statement.jsp?id=<%=newStatement.getId()%>"><%=newStatement.getId()%></a>

    </p>




    <% }%>

    <div id="footer">Content available under a <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License.">Creative Commons Attribution-ShareAlike 4.0 International License</a> <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License."><img alt="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License." style="border-width:0" src="images/creative_commons_attribution_share_alike_4.0_international_licence_88x31.png" /></a></div>
    
</body>
</html>
