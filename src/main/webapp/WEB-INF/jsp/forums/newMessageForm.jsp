<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<c:set var="forum" value="${message.forum}"/>
<c:set var="forumPath" value="${forumsPath}/${forum.id}" />
<c:set var="messagesPath" value="${forumPath}/messages" />

<c:url var="forumUrl" value="${forumPath}.html" />
<c:url var="messagesUrl" value="${messagesPath}.html" />
<c:url var="moderatorUrl" value="${accountsPath}/${forum.owner.username}.html" />

<spring:message var="postLabel" code="postNewMessage.label.post" />

<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title><spring:message code="postNewMessage.pageTitle" /></title>
		<link rel="stylesheet" type="text/css" href="${forumsCssUrl}" />
	</head>
	<body>
		<ul id="breadcrumbs">
			<li><a href="${homeUrl}"><spring:message code="home.pageTitle" /></a></li>
			<li><a href="${forumsUrl}"><spring:message code="forums.pageTitle" /></a></li>
			<li><a href="${forumUrl}"><c:out value="${forum.name}" /></a></li>
		</ul>
		
		<h1 class="commentAdd"><spring:message code="postNewMessage.pageTitle" /></h1>
		
		<form:form cssClass="main" modelAttribute="message" action="${messagesUrl}">
			<form:errors path="*">
				<div class="warning alert"><spring:message code="error.global" /></div>
			</form:errors>
			<div class="panel grid">
				<div class="gridRow yui-gf">
					<div class="yui-u first">
						<spring:message code="postNewMessage.label.subject" />
					</div>
					<div class="yui-u">
						<form:input id="subjectField" path="subject" cssClass="long" cssErrorClass="long error" />
						<form:errors path="subject">
							<div class="formFieldError"><form:errors path="subject" htmlEscape="false" /></div>
						</form:errors>
					</div>
				</div>
				<div class="gridRow yui-gf">
					<div class="yui-u first">
						<spring:message code="postNewMessage.label.text" />
					</div>
					<div class="yui-u">
						<form:textarea id="textArea" path="text" cssClass="resizable" cssErrorClass="resizable error" />
						<form:errors path="text">
							<div class="formFieldError"><form:errors path="text" htmlEscape="false" /></div>
						</form:errors>
					</div>
				</div>
				<div class="gridRow yui-gf">
					<div class="yui-u first"></div>
					<div class="yui-u">
						<input type="submit" value="${postLabel}" />
					</div>
				</div>
			</div>
		</form:form>
	</body>
</html>
