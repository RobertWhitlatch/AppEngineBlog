<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="blog.*" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.googlecode.objectify.*" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
 
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="stylesheets/standard.css">
	</head>

	<body background="https://i.imgur.com/IrFBaqT.jpg">

		<div id="banner">
			<img id="left_banner" src="https://i.imgur.com/myXryz9.jpg"/>
			<img id="right_banner" src="https://i.imgur.com/myXryz9.jpg"/>
			<h1>Welcome to Micro-Controller Central!</h1>
			<p>Here is where you can find all kinds of project ideas and implementations. We utilize many different micro-controllers, but focus primarily on the Tiva Launchpad.</p>
		</div>

<%
    String blogRecordName = request.getParameter("blogRecordName");
    if (blogRecordName == null) {
    	blogRecordName = "default";
    }
    pageContext.setAttribute("blogRecordName", blogRecordName);
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
      pageContext.setAttribute("user", user);
%>
<a id="log_button" href="<%= userService.createLogoutURL(request.getRequestURI()) %>">Sign Out</a>
<%
    } else {
%>
<a id="log_button" href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign In</a>
<%
    }
%>
 
<%
	ObjectifyService.register(Blog.class);
	List<Blog> blogs = ObjectifyService.ofy().load().type(Blog.class).list();
	Collections.sort(blogs);
	if (blogs.isEmpty()) {
        %>
        <p id="empty_blog">There are no blog posts.</p>
        <%
    } else {
        for (Blog blog : blogs) {
            pageContext.setAttribute("blog_content",
                                     blog.getContent());
            if (blog.getUser() == null) {
                %>
                <p>An anonymous, erroneous person wrote:</p>
                <%
            } else {
                pageContext.setAttribute("blog_user",
                                         blog.getUser());
                %>
                <p class="authors"><b>${fn:escapeXml(blog_user.nickname)}</b> wrote:</p>
                <%
            }
            %>
            <blockquote class="posts">${fn:escapeXml(blog_content)}</blockquote>
            <%
        }
    }
	
	if(user != null){
%>
 
    <form action="/write" method="post">
      <div><textarea name="content" rows="3" cols="60"></textarea></div>
      <div><input type="submit" value="Post Blog" /></div>
      <input type="hidden" name="blogRecordName" value="${fn:escapeXml(blogRecordName)}"/>
    </form>
<%
	} else {
%>
		<p>Must be logged in to post.</p>
<%
	}
%>
	</body>

</html>