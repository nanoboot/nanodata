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

<%@page import="org.nanoboot.nanodata.persistence.api.ItemRepo"%>
<%@page import="org.nanoboot.nanodata.entity.Item"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.context.ApplicationContext"%>
<!DOCTYPE>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Nanodata - Add item</title>
        <link rel="stylesheet" type="text/css" href="styles/nanodata.css">
        <link rel="icon" type="image/x-icon" href="favicon.ico" sizes="32x32">
    </head>

    <body>

        <a href="index.jsp" id="main_title">Nanodata</a></span>

    <span class="nav"><a href="index.jsp">Home</a>
        >> <a href="items.jsp">Items</a>
        >> <a href="create_item.jsp" class="nav_a_current">Add Item</a></span>
        
    <%
        if (org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.cannotUpdate(request)) {
            out.println("Access forbidden");
            throw new jakarta.servlet.jsp.SkipPageException();
        }
    %>
    
    <%
        ApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(getServletContext());
        ItemRepo itemRepo = context.getBean("itemRepoImplSqlite", ItemRepo.class);
    %>


    <%
        String param_label = request.getParameter("label");
        boolean formToBeProcessed = param_label != null && !param_label.isEmpty();
    %>

    <% if (!formToBeProcessed) { %>
    <form action="create_item.jsp" method="post">
        <table>


    
            <tr>
                <td><label for="label">Label:<b style="color:red;font-size:130%;">*</b>:</label></td>
                <td><input type="text" name="label" value=""></td>
            </tr>
            <tr>
                <td><label for="disambiguation">Disambiguation:</label></td>
                <td><input type="text" name="disambiguation" value=""></td>
            </tr>
            <tr>
                <td><label for="description">Description:</label></td>
                <td style="text-align:left;"><input type="text" name="description" value="" ></td>
            </tr>
            <tr>
                <td><label for="attributes">Attributes:</label></td>
                <td style="text-align:left;">
                    <textarea style="width:100%;height:100px;" name="attributes"></textarea>
                </td>
            </tr>
            <tr>
                <td><label for="aliases">Aliases:</label></td>
                <td style="text-align:left;">
                    <input type="text" name="aliases" >
                </td>
            </tr>
            <tr>
                <td><label for="entryPointItem">Entry point item</label></td>
                <td style="text-align:left;">
                    <input type="checkbox" name="entryPointItem" value="1" >
                </td>
            </tr>
         
            <tr>
                <td><a href="items.jsp" style="font-size:130%;background:#dddddd;border:2px solid #bbbbbb;padding:2px;text-decoration:none;">Cancel</a></td>
                <td style="text-align:right;"><input type="submit" value="Add"></td>
            </tr>
        </table>
        <b style="color:red;font-size:200%;margin-left:20px;">*</b> ...mandatory


    </form>

    <% } else { %>

    <%
        
     String param_disambiguation = request.getParameter("disambiguation");
     String param_description = request.getParameter("description");
     String param_attributes = request.getParameter("attributes");
     String param_aliases = request.getParameter("aliases");
     String param_entryPointItem = request.getParameter("entryPointItem");


        //
        if (param_disambiguation != null && param_disambiguation.isEmpty()) {
            param_disambiguation = null;
        }
        if (param_description != null && param_description.isEmpty()) {
            param_description = null;
        }
        
        if (param_attributes != null && param_attributes.isEmpty()) {
            param_attributes = null;
        }
        if (param_aliases != null && param_aliases.isEmpty()) {
            param_aliases = null;
        }
        if (param_entryPointItem != null && param_entryPointItem.isEmpty()) {
            param_entryPointItem = null;
        }
      
        //
        Item newItem = new Item(
                null,
                param_label,
                param_disambiguation,
                param_description,
                param_attributes,
                param_aliases,
                param_entryPointItem == null ? false : param_entryPointItem.equals("1"),
                null
        );

        String idOfNewWebsite = itemRepo.create(newItem);

        newItem.setId(idOfNewWebsite);
    %>


    <p style="margin-left:20px;font-size:130%;">Created new item with id <%=newItem.getId()%>:<br><br>
        <a href="read_item.jsp?id=<%=newItem.getId()%>"><%=newItem.getId()%></a>

    </p>




    <% }%>

    <div id="footer">Content available under a <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License.">Creative Commons Attribution-ShareAlike 4.0 International License</a> <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License."><img alt="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License." style="border-width:0" src="images/creative_commons_attribution_share_alike_4.0_international_licence_88x31.png" /></a></div>
    
</body>
</html>
