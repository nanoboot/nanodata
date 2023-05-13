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

<%@page import="org.nanoboot.nanodata.persistence.api.UrlRepo"%>
<%@page import="org.nanoboot.nanodata.entity.Url"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.context.ApplicationContext"%>
<!DOCTYPE>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Nanodata - Add url</title>
        <link rel="stylesheet" type="text/css" href="styles/nanodata.css">
        <link rel="icon" type="image/x-icon" href="favicon.ico" sizes="32x32">
    </head>

    <body>

        <a href="index.jsp" id="main_title">Nanodata</a></span>

    <span class="nav"><a href="index.jsp">Home</a>
        >> <a href="urls.jsp">Urls</a>
        >> <a href="create_url.jsp" class="nav_a_current">Add Url</a></span>

    <%
        if (org.nanoboot.nanodata.web.misc.utils.Utils.cannotUpdate(request)) {
            out.println("Access forbidden");
            throw new jakarta.servlet.jsp.SkipPageException();
        }
    %>

    <%
        ApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(getServletContext());
        UrlRepo urlRepo = context.getBean("urlRepoImplSqlite", UrlRepo.class);
    %>


    <%
        String param_url = request.getParameter("url");
        String param_item_id_for_form = request.getParameter("item_id");
        boolean formToBeProcessed = param_url != null && !param_url.isEmpty();
    %>

    <% if (!formToBeProcessed) { %>
    <form action="create_url.jsp" method="post">
        <table>



            <tr>
                <td><label for="url">Url<b style="color:red;font-size:130%;">*</b>:</label></td>
                <td><input type="text" name="url" value="<%=(param_url==null?"":param_url)%>"></td>
            </tr>
            <tr>
                <td><label for="name">Name</label></td>
                <td><input type="text" name="name" value=""></td>
            </tr>
            <tr>
                <td><label for="item_id">Item id<b style="color:red;font-size:130%;">*</b></label></td>
                <td style="text-align:left;"><input type="text" name="item_id" value="<%=(param_item_id_for_form==null?"":param_item_id_for_form)%>" ></td>
            </tr>

            <tr>
                <td><label for="official">Official</label></td>
                <td style="text-align:left;">
                    <input type="checkbox" name="official" value="1" >
                </td>
            </tr>


            <tr>
                <td><a href="urls.jsp" style="font-size:130%;background:#dddddd;border:2px solid #bbbbbb;padding:2px;text-decoration:none;">Cancel</a></td>
                <td style="text-align:right;"><input type="submit" value="Add"></td>
            </tr>
        </table>
        <b style="color:red;font-size:200%;margin-left:20px;">*</b> ...mandatory


    </form>

    <iframe src="items.jsp" width="800" height="800">
    </iframe>

    <% } else { %>

    <%
        
     String param_name = request.getParameter("name");
     String param_official = request.getParameter("official");
     String param_item_id = request.getParameter("item_id");
     if(param_official == null) {
     param_official = "0";
        }
        //
        Url newUrl = new Url(
                null,
                param_url,
                param_name,
                param_item_id,
                Boolean.valueOf(param_official.equals("1")),
                null
        );

        String idOfUrl = urlRepo.create(newUrl);

        newUrl.setId(idOfUrl);
    %>


    <p style="margin-left:20px;font-size:130%;">Created new url with id <%=newUrl.getId()%>:<br><br>
        <a href="read_url.jsp?id=<%=newUrl.getId()%>"><%=newUrl.getId()%></a>

    </p>




    <% }%>

    <div id="footer">Content available under a <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License.">Creative Commons Attribution-ShareAlike 4.0 International License</a> <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License."><img alt="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License." style="border-width:0" src="images/creative_commons_attribution_share_alike_4.0_international_licence_88x31.png" /></a></div>

</body>
</html>
