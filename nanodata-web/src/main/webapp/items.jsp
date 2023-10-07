<%@page import="org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils"%>
<%@page import="java.util.List"%>
<%@page import="org.nanoboot.nanodata.persistence.api.ItemRepo"%>
<%@page import="org.nanoboot.nanodata.entity.Item"%>
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
        <title>List items - Nanodata</title>
        <link rel="stylesheet" type="text/css" href="styles/nanodata.css">
        <link rel="icon" type="image/x-icon" href="favicon.ico" sizes="32x32">
    </head>

    <body>

        <a href="index.jsp" id="main_title">Nanodata</a></span>

    <span class="nav"><a href="index.jsp">Home</a>
        >> <a href="items.jsp" class="nav_a_current">Items</a>


        <% boolean canUpdate = org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.canUpdate(request); %>
        <% if(canUpdate) { %>
        >> <a href="create_item.jsp">Add Item</a>
        <% } %>



    </span>

    <%
        ApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(getServletContext());
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
        String label = request.getParameter("label");
        String disambiguation = request.getParameter("disambiguation");
        String description = request.getParameter("description");
        String aliases = request.getParameter("aliases");
        String entryPointItem = request.getParameter("entryPointItem");

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


    <form action="items.jsp" method="get">

        <label for="pageNumber">Page </label><input type="text" name="pageNumber" value="<%=pageNumberInt%>" size="4" style="margin-right:10px;">
        <label for="id">ID</label><input type="text" name="id" value="<%=id != null ? id : ""%>" size="5" style="margin-right:10px;">
        <label for="label">Label</label><input type="text" name="label" value="<%=label != null ? label : ""%>" style="margin-right:10px;max-width:100px;">
        <label for="disambiguation">Disambiguation</label><input type="text" name="disambiguation" <%=disambiguation != null ? disambiguation : ""%> style="max-width:100px;">
        <label for="description">Description</label><input type="text" name="description" <%=description != null ? description : ""%>  style="max-width:100px;">
       <label for="aliases">Aliases</label><input type="text" name="aliases"  <%=aliases != null ? aliases : ""%> style="max-width:100px;">
        <label for="entryPointItem">Entry Point Item</label><input type="checkbox" name="entryPointItem"  <%=entryPointItem != null && entryPointItem.equals("1") ? "checked " : ""%>value="1">

        <input type="submit" value="Filter" style="margin-left:20px;height:40px;">
        <br>
        <br>

        <input type="submit" name="PreviousNextPage" value="Previous page" style="margin-left:20px;height:40px;">
        <input type="submit" name="PreviousNextPage" value="Next page" style="margin-left:20px;height:40px;">
    </form>

    <%
        List<Item> items = itemRepo.list(
                pageNumberInt,
                10,
                /*id,*/
                label == null || label.isEmpty() ? null : label, 
                org.nanoboot.nanodata.persistence.api.TextPosition.DOES_NOT_MATTER
        );

        if (items.isEmpty()) {

    %><span style="font-weight:bold;color:orange;" class="margin_left_and_big_font">Warning: Nothing found.</span>

    <%            throw new jakarta.servlet.jsp.SkipPageException();
        }
    %>

    <table>
        <thead>
            <tr>
                <!--<th title="ID">ID</th>-->
                
                
                <th style="width:130px;"></th>
                <th>Label</th>
                <th>Disambiguation</th>
                <th>Description</th>
                <th>Aliases</th>
                <th>Entry Point Item</th>
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
            for (Item i: items) {
        %>
        <tr>
            <!--<td><%=i.getId()%></td>-->


            
            
                        <td>
                            <a href="read_item.jsp?id=<%=i.getId()%>">Read</a>
                <!--<a href="read_item.jsp?id=<%=i.getId()%>"><img src="images/read.png" title="View" width="48" height="48" /></a>-->
                <!--<% if(canUpdate) { %><a href="update_item.jsp?id=<%=i.getId()%>"><img src="images/update.png" title="Update" width="48" height="48" /></a><%}%>-->
                <% if(canUpdate) { %><a href="update_item.jsp?id=<%=i.getId()%>">Update</a><%}%>
            </td>
            
            <td><%=i.getLabel()%></td>
            
            <td><%=i.getDisambiguation() == null ? EMPTY : i.getDisambiguation()%></td>
            <td><%=i.getDescription() == null ? EMPTY : i.getDescription()%></td>
            <td><%=i.getAliases() == null ? EMPTY : i.getAliases()%></td>
            <td><%=org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.formatToHtml(i.getEntryPointItem())%></td>


        </tr>
        <%
            }
        %>
    </tbody>
</table>

<div id="footer">Content available under a <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License.">Creative Commons Attribution-ShareAlike 4.0 International License</a> <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License."><img alt="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License." style="border-width:0" src="images/creative_commons_attribution_share_alike_4.0_international_licence_88x31.png" /></a></div>

</body>
</html>
