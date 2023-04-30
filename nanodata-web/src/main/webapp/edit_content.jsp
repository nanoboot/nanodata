<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page session="false" %>
<%@page import="java.io.FileWriter"%>
<%@page import="java.io.BufferedWriter"%>
<!DOCTYPE html>

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

    <%@page import="java.util.Scanner"%>
    <%@page import="java.io.File"%>
    <%@page import="org.nanoboot.nanodata.web.misc.utils.Utils"%>
    <%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
    <%@page import="org.springframework.context.ApplicationContext"%>

    <head>
        <title>Edit content - Nanodata</title>
        <link rel="stylesheet" type="text/css" href="styles/nanodata.css">
        <link rel="stylesheet" type="text/css" href="styles/website.css">
        <link rel="icon" type="image/x-icon" href="favicon.ico" sizes="32x32">
        <style>
            form {
                margin:10px;
                margin-right:20px;
            }
        </style>
    </head>

    <body>

        <a href="index.jsp" id="main_title">Nanodata</a>
        <%
            String id = request.getParameter("id");

            if (id == null || id.isEmpty()) {
        %><span style="font-weight:bold;color:red;" class="margin_left_and_big_font">Error: Parameter "id" is required </span>

        <%
                throw new jakarta.servlet.jsp.SkipPageException();
            }
        %>

        <span class="nav"><a href="index.jsp">Home</a>
            >> <a href="items.jsp">Items</a>
            >> 
        <a href="read_item.jsp?id=<%=id%>">Read</a>
        <a href="update_item.jsp?id=<%=id%>">Update</a>
        <a href="edit_content.jsp?id=<%=id%>" class="nav_a_current">Edit</a>
        <a href="upload_file.jsp?id=<%=id%>">Upload</a>
        </span>

        <%
            if (org.nanoboot.nanodata.web.misc.utils.Utils.cannotUpdate(request)) {
                out.println("Access forbidden");
                throw new jakarta.servlet.jsp.SkipPageException();
            }
        %>

        <%
            String submit_button_save_changes = request.getParameter("submit_button_save_changes");
            String submit_button_preview = request.getParameter("submit_button_preview");
            String submit_button_cancel = request.getParameter("submit_button_cancel");

            if (submit_button_cancel != null) {%><script>function redirectToShow() {
                    window.location.href = 'show_content.jsp?id=<%=id%>'
                }
                redirectToShow();</script><% }
            %>

        <%
            String contentString = null;

            if (submit_button_save_changes == null && submit_button_preview == null) {

                String filePath = System.getProperty("nanodata.confpath") + "/" + "content/" + id.charAt(0) + id.charAt(1) + "/" + id.charAt(2) + id.charAt(3) + "/"+ id ;
                File dir = new File(filePath);
                if (!dir.exists()) {
                    dir.mkdirs();
                }

                File content = new File(dir, id + ".html");
                if (content.exists()) {

                    Scanner sc = new Scanner(content);

                    // we just need to use \\Z as delimiter
                    sc.useDelimiter("\\Z");

                    contentString = sc.next();
                } else {
                    contentString = "";
                }
            } else {
                String contentParameter = request.getParameter("content");
                contentString = contentParameter;
            }
        %>

        <% //if(submit_button_save_changes == null) { %>
        <form action="edit_content.jsp" method="post">
            <input type="submit" name="submit_button_save_changes" value="Save Changes">&nbsp;&nbsp;
            <input type="submit" name="submit_button_preview" value="Preview">&nbsp;&nbsp;
            <input type="submit" name="submit_button_cancel" value="Cancel">&nbsp;&nbsp;
            <input type="hidden" name="id" value="<%=id%>">
            <br>
            <textarea id="content" name="content" lang="en" dir="ltr" rows="20"
                      onChange="flgChange = true;" onKeyPress="flgChange = true;" style="width:100%;font-family:monospace;font-size:150%;margin-top:10px;"><%=contentString%></textarea>
        </form>
        <% //} %>

        <% if (submit_button_preview != null) {
                out.println("<div>" + (contentString.replace("[[FILE]]", "FileServlet/" + id + "/")) + "</div>");
            }
        %>
        <% if (submit_button_save_changes

            
                != null) {

                String filePath = System.getProperty("nanodata.confpath") + "/" + "content/" + id.charAt(0) + id.charAt(1) + "/" + id.charAt(2) + id.charAt(3) + "/"+ id ;
                File dir = new File(filePath);
                if (!dir.exists()) {
                    dir.mkdir();
                }

                File content = new File(dir, id + ".html");

                if (content.exists()) {

                    Scanner sc = new Scanner(content);

                    // we just need to use \\Z as delimiter
                    sc.useDelimiter("\\Z");

                    String contentString2 = sc.next();
                    SimpleDateFormat dt = new SimpleDateFormat("yyyyMMdd.hhmmss");
                    Date currentDate = new Date();
                    File contentBackupDir = new File(content.getParentFile().getAbsolutePath() + "/content_backup/");
                    if (!contentBackupDir.exists()) {
                        contentBackupDir.mkdir();
                    }
                    String backupFileName = content.getName() + "." + dt.format(currentDate) + ".html";
                    File backupFile = new File(contentBackupDir, backupFileName);
                    BufferedWriter writer = new BufferedWriter(new FileWriter(backupFile));
                    writer.write(contentString2);

                    writer.close();

                }

                String str = contentString;
                BufferedWriter writer = new BufferedWriter(new FileWriter(content));
                writer.write(str);

                writer.close();

        %>
        <script>
            function redirectToRead() {
                window.location.href = 'read_item.jsp?id=<%=id%>'
            }
            redirectToRead();
        </script>


        <%
            }

        %>


    </body>
</html>
