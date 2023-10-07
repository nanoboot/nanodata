<%@page import="java.io.FileWriter"%>
<%@page import="java.io.FileWriter"%>
<%@page import="java.io.BufferedWriter"%>
<%@page import="java.security.MessageDigest"%>
<%@page import="java.nio.file.Paths"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="java.io.File"%>
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
        <title>Upload File - Nanodata</title>
        <link rel="stylesheet" type="text/css" href="styles/nanodata.css">
        <link rel="icon" type="image/x-icon" href="favicon.ico" sizes="32x32">
    </head>

    <body>

        <a href="index.jsp" id="main_title">Nanodata</a></span>

    <%
        String id = request.getParameter("id");
        boolean formToBeProcessed = request.getContentType() != null && request.getContentType().indexOf("multipart/form-data") >= 0;
        if (!formToBeProcessed && (id == null || id.isEmpty())) {
    %><span style="font-weight:bold;color:red;" class="margin_left_and_big_font">Error: Parameter "id" is required</span>

    <%
            throw new jakarta.servlet.jsp.SkipPageException();
        }
    %>

    <% if (id != null) {%>
    <span class="nav"><a href="index.jsp">Home</a>
        >> <a href="items.jsp">Items</a>
        >> <a href="read_item.jsp?id=<%=id%>">Read</a>
        <a href="update_item.jsp?id=<%=id%>">Update</a>
        <a href="edit_content.jsp?id=<%=id%>">Edit</a>
        <a href="upload_file.jsp?id=<%=id%>" class="nav_a_current">Upload</a>


    </span>

    <%
        if (org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.cannotUpdate(request)) {
            out.println("Access forbidden");
            throw new jakarta.servlet.jsp.SkipPageException();
        }
    %>

    <% } %>

    <%
        String param_file = request.getParameter("file");

        //param_variant_screenshot != null && !param_variant_screenshot.isEmpty();
    %>

    <% if (!formToBeProcessed) {%>
    <form action="upload_file.jsp"  method = "post" enctype = "multipart/form-data">
        Select a file to upload: <br />

        <input type = "file" name = "file" size = "50" />
        <br /><br />
        <input type = "submit" value = "Upload file" />
        <input type="hidden" name="id" value="<%=id%>" />
    </form>

    <% } else { %>

    <%

        File file;
        int maxFileSize = 40 * 1024 * 1024;
        int maxRequestSize = 50 * 1024 * 1024;
        int maxMemSize = 5000 * 1024;
        ServletContext context = pageContext.getServletContext();
        

        // Verify the content type
        String contentType = request.getContentType();

        if ((contentType.indexOf("multipart/form-data") >= 0)) {
            DiskFileItemFactory factory = new DiskFileItemFactory();
            // maximum size that will be stored in memory
            factory.setSizeThreshold(maxMemSize);

            factory.setRepository(new File("c:\\temp"));
            
            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setSizeMax(maxRequestSize);
            upload.setFileSizeMax(maxRequestSize);
            

            try {
                // Parse the request to get file items.
                List<FileItem> fileItems = upload.parseRequest(request);

                // Process the uploaded file items
                Iterator i = fileItems.iterator();

                String tmpFileName = System.getProperty("nanodata.confpath") + "/" + "content/" + "tmp_file_" + String.valueOf(((int) (Math.random() * 1000000))) + String.valueOf(((int) (Math.random() * 1000000)));

                String origFileName = null;
                while (i.hasNext()) {
                    FileItem fi = (FileItem) i.next();
                    if (!fi.isFormField()) {
                        // Get the uploaded file parameters
                        String fieldName = fi.getFieldName();
                        String fileName = fi.getName();

                        boolean isInMemory = fi.isInMemory();
                        long sizeInBytes = fi.getSize();
                        origFileName = fileName;
                        fileName = tmpFileName;
                        // Write the file
                        if (fileName.lastIndexOf("\\") >= 0) {
                            file = new File(fileName.substring(fileName.lastIndexOf("\\")));
                        } else {
                            file = new File(fileName.substring(fileName.lastIndexOf("\\") + 1));
                        }
                        fi.write(file);
                        out.println("<span class=\"margin_left_and_big_font\">Uploaded file.</span><br>");
                    }
                    if (fi.isFormField()) {
                        if (fi.getFieldName().equals("id")) {

                            id = fi.getString();
                            if (origFileName == null) {
                                System.err.println("Uploading file failed.");
                            } else {
                            String filePath = System.getProperty("nanodata.confpath") + "/" + "content/" + id.charAt(0) + id.charAt(1) + "/" + id.charAt(2) + id.charAt(3) + "/"+ id ;
                                File newFile = new File(filePath + "/" + origFileName);
                                File parentDir = new File(filePath);
                                if(!parentDir.exists()) {
                                    parentDir.mkdirs();
                                }
                                new File(tmpFileName).renameTo(newFile);
                                ////
//                                byte[] sha512sumByteArray = MessageDigest.getInstance("SHA-512").digest(Files.readAllBytes(Paths.get(newFile.getAbsolutePath())));
//                                StringBuilder sb = new StringBuilder(sha512sumByteArray.length * 2);
//                                for (byte b : sha512sumByteArray) {
//                                    sb.append(String.format("%02x", b));
//                                }
//                                String hexString = sb.toString();
//                                File hexFile = new File(newFile.getParentFile(), newFile.getName() + ".sha512");
//
//                                BufferedWriter writer = new BufferedWriter(new FileWriter(hexFile));
//                                writer.write(hexString);
//
//                                writer.close();
                                ////
                            }

                        }
                    }
                }

            } catch (Exception ex) {
                System.out.println(ex);
            }
        } else {
            out.println("<p>No file uploaded</p>");
        }
    %>




    <script>
        function redirectToRead() {  
window.location.href = 'read_item.jsp?id=<%=id%>'
}  
redirectToRead();
</script>

    <% }

        
    %>


</body>
</html>
