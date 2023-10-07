<%@page import="org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils"%>
<%@page import="org.nanoboot.nanodata.persistence.api.ItemRepo"%>
<%@page import="org.nanoboot.nanodata.persistence.api.StatementRepo"%>
<%@page import="org.nanoboot.nanodata.persistence.api.UrlRepo"%>
<%@page import="org.nanoboot.nanodata.entity.Item"%>
<%@page import="org.nanoboot.nanodata.entity.Statement"%>
<%@page import="org.nanoboot.nanodata.entity.Url"%>
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
        >> <a href="items.jsp">Items</a>
        >> 
        <a href="read_item.jsp?id=<%=id%>" class="nav_a_current">Read</a>


        <% boolean canUpdate = org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.canUpdate(request); %>
        <% if(canUpdate) { %>
        <a href="update_item.jsp?id=<%=id%>">Update</a>
        <a href="edit_content.jsp?id=<%=id%>">Edit</a>
        <a href="upload_file.jsp?id=<%=id%>">Upload</a>
        <% } %>




    </span>




    <%
        ApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(getServletContext());
        StatementRepo statementRepo = context.getBean("statementRepoImplSqlite", StatementRepo.class);
        UrlRepo urlRepo = context.getBean("urlRepoImplSqlite", UrlRepo.class);
        ItemRepo itemRepo = context.getBean("itemRepoImplSqlite", ItemRepo.class);
        Item item = itemRepo.read(id);

        if (item == null) {
    %><span style="font-weight:bold;color:red;" class="margin_left_and_big_font">Error: Item with id <%=id%> was not found.</span>

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
        <!--
        <a href="read_item.jsp?id=<%=item.getId()%>&previous_next=previous" class="button">Previous</a>
        <a href="read_item.jsp?id=<%=item.getId()%>&previous_next=next" class="button">Next</a>
        <br><br>
        -->
        
    </p>

    <script>
        function redirectToUpdate() {

        <% if(canUpdate) { %>
            window.location.href = 'update_item.jsp?id=<%=id%>'
        <% } %>

        }
        function redirectToEdit() {
        <% if(canUpdate) { %>
            window.location.href = 'edit_content.jsp?id=<%=id%>'
        <% } %>
        }


    </script>

    
    
    



<script>
  const copyId = async () => {
    try {
      await navigator.clipboard.writeText('<%=item.getId()%>');
      console.log('Content copied to clipboard');
    } catch (err) {
      console.error('Failed to copy: ', err);
    }
  }
</script>

<style>
    .section_header {
        color:green;font-weight:700;border:2px solid blue;background:yellow;font-size:140%;margin:20px;padding:5px;display:block;max-width:350px;
    }
</style>



    <span class="section_header">Data</span>
    <table ondblclick = "redirectToUpdate()">
        <tr>
        <th>ID</th><td><%=item.getId()%> <button onclick="copyId()">Copy</button></td></tr>
        <tr><th>Label</th><td><%=item.getLabel()%></a></td></tr>
        <tr><th>Disambiguation</th><td><%=OctagonJakartaUtils.formatToHtml(item.getDisambiguation())%></td></tr>
        <tr><th>Description</th><td><%=OctagonJakartaUtils.formatToHtml(item.getDescription())%></td></tr>
        <tr><th>Attributes</th><td><pre><%=OctagonJakartaUtils.formatToHtml(item.getAttributes())%></pre></td></tr>
        <tr><th>Aliases</th><td><%=OctagonJakartaUtils.formatToHtml(item.getAliases())%></td></tr>
        <tr><th>Entry Point Item</th><td><%=OctagonJakartaUtils.formatToHtml(item.getEntryPointItem())%></td></tr>
        <tr><th>Created at</th><td><%=item.getCreatedAt()%></a></td></tr>


    </table>

    <span class="section_header">Statements</span>
    
    <% if(canUpdate) { %>
    <a href="create_statement.jsp?source=<%=item.getId()%>" style="margin-left:20px;font-size:110%;background:#dddddd;border:2px solid #bbbbbb;padding:1px;text-decoration:none;margin-bottom:20px !important;">Add</a>
    <br><br>
    <%}%>
    
    <%
        List<Statement> statements = statementRepo.list(
                1,
                100,
                null,
                null, 
                null,
                item.getId(),
                null
        );

        if (statements.isEmpty()) {

    %><span style="font-weight:bold;color:orange;" class="margin_left_and_big_font">Nothing found.</span>

    <%
        } else {
    %>

    <table>
        <thead>
            <tr>
                <!--<th title="ID">ID</th>-->

                <th style="width:170px;"></th>
                <th>Source</th>
                <th>Value</th>
                <th>Target</th>
                <th>Flags</th>
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
                padding:2px;
            }
            tr td {
                padding-right:2px;
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
            <td><%=OctagonJakartaUtils.formatToHtml(i.getFlags())%></td>


        </tr>
        <%
            }
        %>
    </tbody>
</table>
<% } %>







<span class="section_header">Reverse statements</span>
<!--<a href="create_statement.jsp?source=<%=item.getId()%>" style="margin-left:20px;font-size:110%;background:#dddddd;border:2px solid #bbbbbb;padding:1px;text-decoration:none;margin-bottom:20px !important;">Add</a>-->

<%
    List<Statement> reverseStatements = statementRepo.list(
            1,
            100,
            null,
            null, 
            null,
            null,
            item.getId()
    );

    if (reverseStatements.isEmpty()) {

%><span style="font-weight:bold;color:orange;" class="margin_left_and_big_font">Nothing found.</span>

<%
    } else {
%>

<table>
    <thead>
        <tr>
            <!--<th title="ID">ID</th>-->

            <th style="width:170px;"></th>
            <th>Source</th>
            <th>Value</th>
            <th>Target</th>
            <th>Flags</th>
        </tr>
    </thead>

    <tbody>


    <%
        for (Statement i: reverseStatements) {
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
        <td><%=OctagonJakartaUtils.formatToHtml(i.getFlags())%></td>


    </tr>
    <%
        }
    %>
</tbody>
</table>
<% } %>







<span class="section_header">Urls</span>

    <% if(canUpdate) { %>
    <a href="create_url.jsp?item_id=<%=item.getId()%>" style="margin-left:20px;font-size:110%;background:#dddddd;border:2px solid #bbbbbb;padding:1px;text-decoration:none;margin-bottom:20px !important;">Add</a>
    <br><br>
    <%}%>
    
<%
    List<Url> urls = urlRepo.list(
            1,
            100,
            null,
            null,
            item.getId()
    );

    if (urls.isEmpty()) {

%><span style="font-weight:bold;color:orange;" class="margin_left_and_big_font">Nothing found.</span>

<%
    } else {
%>

<table>
    <thead>
        <tr>
            <!--<th title="ID">ID</th>-->

            <th style="width:170px;"></th>
            <th>Url</th>
            <th>Name</th>
            <th>Item</th>
            <th>Official</th>
        </tr>
    </thead>

    <tbody>



    <%
        for (Url u: urls) {
    %>
    <tr>
        <!--<td><%=u.getId()%></td>-->



        <td>
            <a href="read_url.jsp?id=<%=u.getId()%>">Read</a>

<!--<% if(canUpdate) { %><a href="update_item.jsp?id=<%=u.getId()%>"><img src="images/update.png" title="Update" width="48" height="48" /></a><%}%>-->
            <% if(canUpdate) { %>
            <a href="update_url.jsp?id=<%=u.getId()%>">Update</a>
            <a href="delete_url.jsp?id=<%=u.getId()%>" target="_blank">Delete</a>
            <%}%>
        </td>
        <td><a href="<%=u.getUrl()%>"><%=u.getUrl()%></a></td>
        <td><%=u.getName()%></td>
        <td><a href="read_item.jsp?id=<%=u.getItemId()%>"><%=itemRepo.getLabel(u.getItemId())%></a></td>
        <td><%=OctagonJakartaUtils.formatToHtml(u.getOfficial())%></td>


    </tr>
    <%
        }
    %>
</tbody>
</table>
<% } %>










<span class="section_header">Content</span>
<%
    String filePath = System.getProperty("nanodata.confpath") + "/" + "content/" + id.charAt(0) + id.charAt(1) + "/" + id.charAt(2) + id.charAt(3) + "/"+ id ;
    File dir = new File(filePath);
//            if (!dir.exists()) {
//                boolean b = dir.mkdirs();
//                System.err.println("b=" + b);
//            }
System.err.println("filePath=" + filePath);
    File content = new File(dir, id + ".html");
    if (content.exists()) {

        Scanner sc = new Scanner(content);

        // we just need to use \\Z as delimiter
        sc.useDelimiter("\\Z");

        String contentString = sc.next();
        contentString = contentString.replace("[[FILE]]", "FileServlet/" + id + "/");

        out.println("<div id=\"content\" ondblclick = \"redirectToEdit()\" style=\"padding:20px;margin:20px; border-top:3px solid rgb(220,220,220);border-bottom:3px solid rgb(220,220,220);\">" + contentString + "</div>");
    } else {
        out.println("<p  ondblclick = \"redirectToEdit()\" style=\"padding:20px;\">No content found</p>");
    }
%>

<span class="section_header">Files</span>

<ul style="font-size:120%;line-height:160%;">
    <%
        File[] files = dir.listFiles();
        if(files == null) {files = new File[]{};}
        List<File> filesList = Arrays.asList(files);
        class FileComparator implements Comparator<File> {

            @Override
            public int compare(File file1, File file2) {
                String file1Name = removeExtension(file1);
                String file2Name = removeExtension(file2);
                boolean file1IsNumber = isNumber(file1Name);
                boolean file2IsNumber = isNumber(file2Name);
                Integer file1AsNumber = file1IsNumber ? Integer.valueOf(file1Name) : 0;
                Integer file2AsNumber = file2IsNumber ? Integer.valueOf(file2Name) : 0;
                if (file1IsNumber && file2IsNumber) {
                    return file1AsNumber.compareTo(file2AsNumber);
                }
                if (file1IsNumber && !file2IsNumber) {
                    return -1;
                }
                if (!file1IsNumber && file2IsNumber) {
                    return 1;
                }
                return file1Name.compareTo(file2Name);
            }

            private boolean isNumber(String string) {
                try {
                    Integer.valueOf(string);
                    System.err.println("isNumber("+string+")=true");
                    return true;
                } catch (Exception e) {
                System.err.println("isNumber("+string+")=false");
                    return false;
                }

            }

            private String removeExtension(File file) {
                String fileName = file.getName();
                if (!fileName.contains(".")) {
                    return fileName;
                }
                String[] array = fileName.split("\\.");
                if (array.length != 2) {
                    return fileName;
                } else {
                    return array[0];
                }
            }
        }

        Collections.sort(filesList,
                new FileComparator());
boolean noFilesFound = true;
        for (File f : filesList) {
            if (f.getName().endsWith(".sha512")) {
                continue;
            }
            if (f.getName().equals(id + ".html")) {
            continue;
        }
                
            if (f.isDirectory()) {
                continue;
            }
            noFilesFound = false;
    %>
    <li><a href="FileServlet/<%=id%>/<%=f.getName()%>" class="button"><%=f.getName()%></a> <%=(f.isDirectory() ? "(directory)" : ("(file " + f.length() / 1024 ))%> kB )</li>

    <%
        }
        if (noFilesFound) {
            out.println("<p>No files found.</p>");
        }
    %>


</ul>



<div id="footer">Content available under a <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License.">Creative Commons Attribution-ShareAlike 4.0 International License</a> <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License."><img alt="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License." style="border-width:0" src="images/creative_commons_attribution_share_alike_4.0_international_licence_88x31.png" /></a></div>
</body>
</html>
