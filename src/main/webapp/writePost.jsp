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
    String subList = request.getParameter("subList");
    if (subList == null) {
    	subList = "default";
    }
    pageContext.setAttribute("subList", subList);
    ObjectifyService.register(Subscriber.class);
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
%>
	<ul id="toolbar">
		<li><a href="/">Home</a></li>
		<li><a href="/all">View all Posts</a></li>
		<li><a href="/writepost"  class="active">Make a Post</a></li>
<%
    if (user != null) {
        pageContext.setAttribute("user", user);
%>
		<li style="float:right"><a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">Sign Out</a></li>
<%
		Subscriber sub = ObjectifyService.ofy().load().type(Subscriber.class).filter("user", user).first().now();
		if(sub == null){
%>
			<li style="float:right"><a href="/subscribe">Subscribe!</a></li>
<%
		} else if (sub.isSubscribed()){
%>
			<li style="float:right"><a href="/subscribe">Unsubscribe</a></li>
<%
		} else {
%>
			<li style="float:right"><a href="/subscribe">Subscribe!</a></li>
<%
		}
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
	
	if(user != null){
%>
 
    <form action="/write" method="post">
    	<p id="writing_headers">Title</p>
    	<div><textarea name="title" rows="1" cols="60"></textarea></div>
    	<p id="writing_headers">Body</p>
    	<div><textarea name="content" rows="6" cols="120"></textarea></div>
    	<br>
    	<div><input type="submit" value="Post Blog" /></div>
    	<input type="hidden" name="blogRecordName" value="${fn:escapeXml(blogRecordName)}"/>
    </form>
<%
	} else {
%>
		<p id="empty_blog">Must be logged in to post.</p>
<%
	}
%>
	</body>

</html>