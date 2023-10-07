<%@page import="org.nanoboot.powerframework.time.moment.LocalDate"%>
<%@page import="org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils"%>
<%@page import="org.nanoboot.nanodata.persistence.api.UrlRepo"%>
<%@page import="org.nanoboot.nanodata.entity.Url"%>
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
        <title>Update url - Nanodata</title>
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
        >> <a href="urls.jsp">Urls</a>
        >> <a href="read_url.jsp?id=<%=id%>">Read</a>
        <a href="update_url.jsp?id=<%=id%>" class="nav_a_current">Update</a>
        <a href="delete_url.jsp?id=<%=id%>">Delete</a>


    </span>

    <%
        if (org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.cannotUpdate(request)) {
            out.println("Access forbidden");
            throw new jakarta.servlet.jsp.SkipPageException();
        }
    %>
    <%
        ApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(getServletContext());
        UrlRepo urlRepo = context.getBean("urlRepoImplSqlite", UrlRepo.class);
        Url url = urlRepo.read(id);

        if (url == null) {
    %><span style="font-weight:bold;color:red;" class="margin_left_and_big_font">Error: url with id <%=id%> was not found.</span>

    <%
            throw new jakarta.servlet.jsp.SkipPageException();
        }
        String param_url = request.getParameter("url");
        boolean formToBeProcessed = param_url != null && !param_url.isEmpty();
    %>


    <% if (!formToBeProcessed) {%>
    <form action="update_url.jsp" method="get">
        <table>
            <tr>
                <td><label for="id">ID <b style="color:red;font-size:130%;">*</b>:</label></td>
                <td><input type="text" name="id" value="<%=id%>" readonly style="background:#dddddd;"></td>
            </tr>
            <tr>
                <td><label for="url">Url <b style="color:red;font-size:130%;">*</b>:</label></td>
                <td><input type="text" name="url" value="<%=url.getUrl()%>"></td>
            </tr>
            <tr>
                <td><label for="name">Name</label></td>
                <td><input type="text" name="name" value="<%=url.getName() == null ? "" : url.getName()%>"></td>
            </tr>
            <tr>
                <td><label for="item_id">Item id</label></td>
                <td><input type="text" name="item_id" value="<%=url.getItemId()%>"></td>
            </tr>
            <tr>
                <td><label for="official">Official</label></td>
                <td style="text-align:left;">
                    <input type="checkbox" name="official" value="1" <%=url.getOfficial().booleanValue() ? "checked" : ""%> >
                </td>
            </tr>




            <tr>
                <td><a href="urls.jsp" style="font-size:130%;background:#dddddd;border:2px solid #bbbbbb;padding:2px;text-decoration:none;">Cancel</a></td>
                <td style="text-align:right;"><input type="submit" value="Update"></td>
            </tr>
        </table>
        <b style="color:red;font-size:200%;margin-left:20px;">*</b> ...mandatory





    </form>

    <% } else { %>



    <%
        
     String param_name = request.getParameter("name");
     String param_official = request.getParameter("official");
     if(param_official == null) {
     param_official = "0";
        }
     String param_item_id = request.getParameter("item_id");
     
        //
        Url updatedUrl = new Url(
                id,
                param_url,
                param_name,
                param_item_id,
                Boolean.valueOf(param_official.equals("1")),
                null
        );
        urlRepo.update(updatedUrl);


    %>


    <script>
        function redirectToRead() {
            window.location.href = 'read_url.jsp?id=<%=id%>'
        }
        redirectToRead();
    </script>



    <% }%>

    <div id="footer">Content available under a <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License.">Creative Commons Attribution-ShareAlike 4.0 International License</a> <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License."><img alt="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License." style="border-width:0" src="images/creative_commons_attribution_share_alike_4.0_international_licence_88x31.png" /></a></div>
</body>
</html>
