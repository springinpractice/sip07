<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ include file="/WEB-INF/jsp/urls.jspf" %>

<c:set var="forum" value="${originalMessage.forum}"/>
<c:set var="forumPath" value="${forumsPath}/${forum.id}" />
<c:url var="forumUrl" value="${forumPath}.html" />

<c:url var="messageUrl" value="${forumPath}/messages/${originalMessage.id}.html" />

<c:set var="author" value="${originalMessage.author}" />
<c:url var="authorUrl" value="${accountsPath}/${author.username}.html" />

<spring:message var="saveLabel" code="editMessage.label.save" />

<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title><spring:message code="editMessage.pageTitle" /></title>
		<link rel="stylesheet" type="text/css" href="${forumsCssUrl}" />
	</head>
	<body>
		<ul id="breadcrumbs">
			<li><a href="${homeUrl}"><spring:message code="home.pageTitle" /></a></li>
			<li><a href="${forumsUrl}"><spring:message code="forums.pageTitle" /></a></li>
			<li><a href="${forumUrl}">${forum.name}</a></li>
			<li><a href="${forumUrl}">${originalMessage.subject}</a></li>
		</ul>
		
		<h1 class="commentEdit"><spring:message code="editMessage.pageTitle" /></h1>
		
		<c:if test="${param.saved == true}">
			<div class="info alert">Message saved. <a href="${messageUrl}">View it</a></div>
		</c:if>
		
		<c:if test="${!originalMessage.visible}">
			<jsp:include page="blockedMessageWarningAlert.jsp" />
		</c:if>
		
		<form:form cssClass="main" modelAttribute="message" action="${messageUrl}">
			<input type="hidden" name="_method" value="PUT" />
			<form:errors path="*">
				<div class="warning alert"><spring:message code="error.global" /></div>
			</form:errors>
			<div class="panel grid">
				<div class="gridRow yui-gf">
					<div class="fieldLabel yui-u first">
						<spring:message code="editMessage.label.subject" />
					</div>
					<div class="yui-u">
						<form:input id="subjectField" path="subject" cssClass="long" cssErrorClass="long error" />
						<form:errors path="subject">
							<div class="errorMessage"><form:errors path="subject" htmlEscape="false" /></div>
						</form:errors>
					</div>
				</div>
				<div class="gridRow yui-gf">
					<div class="fieldLabel yui-u first">
						<spring:message code="editMessage.label.author" />
					</div>
					<div class="yui-u">
						<span class="user icon"><a href="${authorUrl}"><c:out value="${author.fullName}" /></a></span>
					</div>
				</div>
				<div class="gridRow yui-gf">
					<div class="fieldLabel yui-u first">
						<spring:message code="editMessage.label.date" />
					</div>
					<div class="yui-u">
						<span class="date icon"><fmt:formatDate type="both" value="${originalMessage.dateCreated}" /></span>
					</div>
				</div>
				<div class="gridRow yui-gf">
					<div class="fieldLabel yui-u first">
						<spring:message code="editMessage.label.text" />
					</div>
					<div class="yui-u">
						<form:textarea id="textArea" path="text" cssClass="resizable" cssErrorClass="resizable error" />
						<form:errors path="text">
							<div class="errorMessage"><form:errors path="text" htmlEscape="false" /></div>
						</form:errors>
					</div>
				</div>
				<div class="gridRow yui-gf">
					<div class="yui-u first"></div>
					<div class="yui-u">
						<input type="submit" value="${saveLabel}" />
					</div>
				</div>
			</div>
		</form:form>
	</body>
</html>
