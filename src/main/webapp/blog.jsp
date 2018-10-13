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
%>
	<ul id="toolbar">
		<li><a href="/" class="active">Home</a></li>
		<li><a href="/all">View all Posts</a></li>
		<li><a href="/writepost">Make a Post</a></li>
<%
    if (user != null) {
      pageContext.setAttribute("user", user);
%>
		<li style="float:right"><a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">Sign Out</a></li>
<%
    } else {
%>
		<li style="float:right"><a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign In</a></li>
<%
    }
%>
	</ul>
<%
	ObjectifyService.register(Blog.class);
	List<Blog> blogs = ObjectifyService.ofy().load().type(Blog.class).list();
	Collections.sort(blogs);
	if (blogs.isEmpty()) {
        %>
        <p id="empty_blog">There are no blog posts. You should write one!</p>
        <%
    } else {
    	int i = 0;
        for (Blog blog : blogs) {
        	i++;
        	pageContext.setAttribute("blog_date", blog.getDate());
            pageContext.setAttribute("blog_title", blog.getTitle());  	
            pageContext.setAttribute("blog_content", blog.getContent());
            pageContext.setAttribute("blog_user", blog.getUser());
            %>
            <hr>
            <p id="title"><b>${fn:escapeXml(blog_title)}</b></p>
            <blockquote id="posts">${fn:escapeXml(blog_content)}</blockquote>
            <p id="authors">Posted by ${fn:escapeXml(blog_user.nickname)} at ${fn:escapeXml(blog_date)}.</p>
            <%
            if(i == 5){
            	break;
            }
        }
    }

%>

	</body>

</html>