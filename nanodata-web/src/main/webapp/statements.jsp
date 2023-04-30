<%@page import="java.util.List"%>
<%@page import="org.nanoboot.nanodata.persistence.api.StatementRepo"%>
<%@page import="org.nanoboot.nanodata.persistence.api.ItemRepo"%>
<%@page import="org.nanoboot.nanodata.entity.Statement"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.context.ApplicationContext"%>
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
        <title>List statements - Nanodata</title>
        <link rel="stylesheet" type="text/css" href="styles/nanodata.css">
        <link rel="icon" type="image/x-icon" href="favicon.ico" sizes="32x32">
    </head>

    <body>

        <a href="index.jsp" id="main_title">Nanodata</a></span>

    <span class="nav"><a href="index.jsp">Home</a>
        >> <a href="statements.jsp" class="nav_a_current">Statements</a>


        <% boolean canUpdate = org.nanoboot.nanodata.web.misc.utils.Utils.canUpdate(request); %>
        <% if(canUpdate) { %>
        >> <a href="create_statement.jsp">Add Statement</a>
        <% } %>



    </span>

    <%
        ApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(getServletContext());
        StatementRepo statementRepo = context.getBean("statementRepoImplSqlite", StatementRepo.class);
        ItemRepo itemRepo = context.getBean("itemRepoImplSqlite", ItemRepo.class);
    %>


    <style>
        input[type="submit"] {
            padding-top: 15px !important;
            padding-left:10px;
            padding-right:10px;
            border:2px solid #888 !important;
            font-weight:bold;
        }
        input[type="checkbox"] {
            margin-right:20px;
        }
    </style>
    <%
        final String EMPTY = "<span style=\"color:grey;font-size:75%;\">[empty]</span>";
        String id = request.getParameter("id");
        String value = request.getParameter("value");
        String source = request.getParameter("source");
        String target = request.getParameter("target");

        String pageNumber = request.getParameter("pageNumber");
        String previousNextPage = request.getParameter("PreviousNextPage");
        if (previousNextPage != null && !previousNextPage.isEmpty()) {
            if (previousNextPage.equals("Previous page")) {
                pageNumber = String.valueOf(Integer.valueOf(pageNumber) - 1);
            }
            if (previousNextPage.equals("Next page")) {
                pageNumber = String.valueOf(Integer.valueOf(pageNumber) + 1);
            }
        }
        int pageNumberInt = pageNumber == null || pageNumber.isEmpty() ? 1 : Integer.valueOf(pageNumber);

    %>


    <form action="statements.jsp" method="get">

        <label for="pageNumber">Page </label><input type="text" name="pageNumber" value="<%=pageNumberInt%>" size="4" style="margin-right:10px;">
        <label for="id">ID</label><input type="text" name="id" value="<%=id != null ? id : ""%>" size="5" style="margin-right:10px;">
        <label for="value">Value</label><input type="text" name="value" value="<%=value != null ? value : ""%>" style="margin-right:10px;max-width:100px;">
        <label for="source">Source</label><input type="text" name="source" value="<%=source != null ? source : ""%>" style="max-width:100px;">
        <label for="target">Target</label><input type="text" name="target" value="<%=target!= null ? target : ""%>" style="max-width:100px;">


        <input type="submit" value="Filter" style="margin-left:20px;height:40px;">
        <br>
        <br>

        <input type="submit" name="PreviousNextPage" value="Previous page" style="margin-left:20px;height:40px;">
        <input type="submit" name="PreviousNextPage" value="Next page" style="margin-left:20px;height:40px;">
    </form>

    <%
        List<Statement> statements = statementRepo.list(
                pageNumberInt,
                10,
                source, 
                target, 
                value,
                null,
                null
        );

        if (statements.isEmpty()) {

    %><span style="font-weight:bold;color:orange;" class="margin_left_and_big_font">Warning: Nothing found.</span>

    <%            throw new jakarta.servlet.jsp.SkipPageException();
        }
    %>

    <table>
        <thead>
            <tr>
                <!--<th title="ID">ID</th>-->

                <th style="width:170px;"></th>
                <th>Source</th>
                <th>Value</th>
                <th>Target</th>
            </tr>
        </thead>

        <tbody>

        <style>

            tr td a img {
                border:2px solid grey;
                background:#dddddd;
                padding:4px;
                width:30%;
                height:30%;
            }
            tr td a img:hover {
                border:3px solid #888888;
                padding:3px;
            }
            tr td {
                padding-right:0;
            }
        </style>


        <%
            for (Statement i: statements) {
        %>
        <tr>
            <!--<td><%=i.getId()%></td>-->



            <td>
                <a href="read_statement.jsp?id=<%=i.getId()%>">Read</a>
                
    <!--<a href="read_item.jsp?id=<%=i.getId()%>"><img src="images/read.png" title="View" width="48" height="48" /></a>-->
    <!--<% if(canUpdate) { %><a href="update_item.jsp?id=<%=i.getId()%>"><img src="images/update.png" title="Update" width="48" height="48" /></a><%}%>-->
                <% if(canUpdate) { %>
                <a href="update_statement.jsp?id=<%=i.getId()%>">Update</a> 
                <a href="delete_statement.jsp?id=<%=i.getId()%>" target="_blank">Delete</a>
                
                <%}%>
            </td>
            <td><a href="read_item.jsp?id=<%=i.getSource()%>"><%=itemRepo.getLabel(i.getSource())%></a></td>
            <td><%=i.getValue()%></td>
                <td><a href="read_item.jsp?id=<%=i.getTarget()%>"><%=itemRepo.getLabel(i.getTarget())%></a></td>


        </tr>
        <%
            }
        %>
    </tbody>
</table>

<div id="footer">Content available under a <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License.">Creative Commons Attribution-ShareAlike 4.0 International License</a> <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License."><img alt="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License." style="border-width:0" src="images/creative_commons_attribution_share_alike_4.0_international_licence_88x31.png" /></a></div>

</body>
</html>
