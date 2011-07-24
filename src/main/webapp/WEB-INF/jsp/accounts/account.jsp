<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/jsp/urls.jspf" %>

<c:set var="email" value="${account.email}" />

<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title><c:out value="${account.fullName}" /></title>
		<link rel="stylesheet" type="text/css" href="${forumsCssUrl}" />
	</head>
	<body>
		<ul id="breadcrumbs">
			<li><a href="${homeUrl}">Home</a></li>
		</ul>
		
		<h1><c:out value="${account.fullName}" /></h1>
		
		<div class="warning alert">
			We wouldn't normally show security-related fields in a user profile, but we're doing it here to make it
			easier to see which users can perform which actions.
		</div>
		
		<div>
			<div class="pane grid">
				<div class="gridRow yui-gf">
					<div class="yui-u first">Username:</div>
					<div class="yui-u"><c:out value="${account.username}" /></div>
				</div>
				<div class="gridRow yui-gf">
					<div class="yui-u first">E-mail:</div>
					<div class="yui-u">
						<span class="email icon"><a href="mailto:${email}">${email}</a></span>
					</div>
				</div>
			</div>
			<div class="pane grid">
				<div class="gridRow yui-gf">
					<div class="yui-u first">Account enabled:</div>
					<div class="yui-u"><c:out value="${account.enabled}" /></div>
				</div>
				<div class="gridRow yui-gf">
					<div class="yui-u first">Roles:</div>
					<div class="yui-u">
						<c:forEach var="role" items="${account.roles}">
							<c:out value="${role.name}" /><br />
						</c:forEach>
					</div>
				</div>
				<div class="gridRow yui-gf">
					<div class="yui-u first">Permissions:</div>
					<div class="yui-u">
						<c:forEach var="permission" items="${account.permissions}">
							<c:out value="${permission.name}" /><br />
						</c:forEach>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>
