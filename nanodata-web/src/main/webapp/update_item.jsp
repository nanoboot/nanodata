<%@page import="org.nanoboot.powerframework.time.moment.LocalDate"%>
<%@page import="org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils"%>
<%@page import="org.nanoboot.nanodata.persistence.api.ItemRepo"%>
<%@page import="org.nanoboot.nanodata.entity.Item"%>
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
        <title>Update item - Nanodata</title>
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
        >> <a href="items.jsp">Items</a>
        >> <a href="read_item.jsp?id=<%=id%>">Read</a>
        <a href="update_item.jsp?id=<%=id%>" class="nav_a_current">Update</a>
        <a href="edit_content.jsp?id=<%=id%>">Edit</a>
        <a href="upload_file.jsp?id=<%=id%>">Upload</a>


    </span>

    <%
        if (org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.cannotUpdate(request)) {
            out.println("Access forbidden");
            throw new jakarta.servlet.jsp.SkipPageException();
        }
    %>
    <%
        ApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(getServletContext());
        ItemRepo itemRepo = context.getBean("itemRepoImplSqlite", ItemRepo.class);
        Item item = itemRepo.read(id);

        if (item == null) {
    %><span style="font-weight:bold;color:red;" class="margin_left_and_big_font">Error: item with id <%=id%> was not found.</span>

    <%
            throw new jakarta.servlet.jsp.SkipPageException();
        }
        String param_label = request.getParameter("label");
        boolean formToBeProcessed = param_label != null && !param_label.isEmpty();
    %>

    
    <% if (!formToBeProcessed) {%>
    <form action="update_item.jsp" method="get">
        <table>
            <tr>
                <td><label for="id">ID <b style="color:red;font-size:130%;">*</b>:</label></td>
                <td><input type="text" name="id" value="<%=id%>" readonly style="background:#dddddd;"></td>
            </tr>
            <tr>
                <td><label for="label">Label <b style="color:red;font-size:130%;">*</b>:</label></td>
                <td><input type="text" name="label" value="<%=item.getLabel()%>"></td>
            </tr>
            <tr>
                <td><label for="disambiguation">Disambiguation:</label></td>
                <td><input type="text" name="disambiguation" value="<%=item.getDisambiguation() == null ? "" : item.getDisambiguation()%>"></td>
            </tr>
            <tr>
                <td><label for="description">Description:</label></td>
                <td><input type="text" name="description" value="<%=item.getDescription() == null ? "" : item.getDescription()%>"></td>
            </tr>
            <tr>
                <td><label for="attributes">Attributes:</label></td>
                <td><textarea style="width:100%;height:100px;" name="attributes"><%=item.getAttributes() == null ? "" : item.getAttributes()%></textarea></td>
            </tr>
            <tr>
                <td><label for="aliases">Aliases:</label></td>
                <td><input type="text" name="aliases" value="<%=item.getAliases() == null ? "" : item.getAliases()%>"></td>
            </tr>

            <tr>
                <td><label for="entryPointItem">Entry point item</label></td>
                <td style="text-align:left;">
                    <input type="checkbox" name="entryPointItem" value="1" <%=item.getEntryPointItem().booleanValue() ? "checked" : ""%> >
                </td>
            </tr>

           


            <tr>
                <td><a href="variants.jsp" style="font-size:130%;background:#dddddd;border:2px solid #bbbbbb;padding:2px;text-decoration:none;">Cancel</a></td>
                <td style="text-align:right;"><input type="submit" value="Update"></td>
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
        //
        Item updatedItem = new Item(
                id,
                param_label,
                param_disambiguation,
                param_description,
                param_attributes,
                param_aliases,
                param_entryPointItem == null ? null : Boolean.valueOf(param_entryPointItem.equals("1")), 
                null
        );

        itemRepo.update(updatedItem);


    %>


    <script>
        function redirectToRead() {
            window.location.href = 'read_item.jsp?id=<%=id%>'
        }
        redirectToRead();
    </script>



    <% }%>

    <div id="footer">Content available under a <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License.">Creative Commons Attribution-ShareAlike 4.0 International License</a> <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License."><img alt="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License." style="border-width:0" src="images/creative_commons_attribution_share_alike_4.0_international_licence_88x31.png" /></a></div>
</body>
</html>
