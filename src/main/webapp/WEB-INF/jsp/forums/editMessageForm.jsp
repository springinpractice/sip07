<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%@ include file="../portal/definitions.jspf" %>

<c:set var="forum" value="${originalMessage.forum}"/>
<c:set var="messageId" value="${originalMessage.id}" />
<c:set var="subject" value="${originalMessage.subject}" />
<c:set var="author" value="${originalMessage.author}" />
<c:set var="dateCreated" value="${originalMessage.dateCreated}" />

<c:set var="forumPath" value="${forumsPath}/${forum.id}" />
<c:set var="messagesPath" value="${forumPath}/messages" />

<c:url var="messageJsUrl" value="/scripts/message.js" />
<c:url var="forumUrl" value="${forumPath}.html" />
<c:url var="messageUrl" value="${messagesPath}/${messageId}.html" />
<c:url var="authorUrl" value="${accountsPath}/${author.username}.html" />

<spring:message var="saveLabel" code="editMessage.label.save" />

<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title><spring:message code="editMessage.pageTitle" /></title>
		<link rel="stylesheet" type="text/css" href="${forumsCssUrl}" />
		<script type="text/javascript">
			var messageUrl = '${messageUrl}';
			var blockedAlert = $('${blockedAlert}');
			var blockLink = $('${blockLink}');
			var unblockLink = $('${unblockLink}');
		</script>
		<script type="text/javascript" src="${messageJsUrl}"></script>
		<script type="text/javascript">
			$(document).ready(function() {
				kickIt(${message.id}, ${message.visible});
			});
		</script>
	</head>
	<body>
		<%@ include file="../portal/topNav.jspf" %>
		
		<div id="breadcrumbs">
			<a href="${homeUrl}"><spring:message code="home.pageTitle" /></a> &gt;
			<a href="${forumsUrl}"><spring:message code="forums.pageTitle" /></a> &gt;
			<a href="${forumUrl}">${forum.name}</a> &gt;
			<c:out value="${subject}" />
		</div>
		
		<c:if test="${param.saved == true}">
			<div class="info">Message saved. <a href="${messageUrl}">View it</a></div>
		</c:if>
		
		<div id="blockedAlertContainer">
			<c:if test="${!message.visible}">
				<c:out value="${blockedAlert}" />
			</c:if>
		</div>
		
		<form:form cssClass="main" modelAttribute="message" action="${messageUrl}">
			<input type="hidden" name="_method" value="PUT" />
			<form:errors path="*">
				<div class="warning"><spring:message code="error.global" /></div>
			</form:errors>
			<h1 class="commentEdit"><spring:message code="editMessage.pageTitle" /></h1>
			<table>
				<tr>
					<td class="formLabel">
						<spring:message code="editMessage.label.subject" />
					</td>
					<td>
						<div><form:input id="subjectField" path="subject" cssClass="long" cssErrorClass="long error" /></div>
						<form:errors path="subject">
							<div class="formFieldError"><form:errors path="subject" htmlEscape="false" /></div>
						</form:errors>
					</td>
				</tr>
				<tr>
					<td class="formLabel">
						<spring:message code="editMessage.label.author" />
					</td>
					<td><span class="user icon"><a href="${authorUrl}"><c:out value="${author.fullName}" /></a></span></td>
				</tr>
				<tr>
					<td class="formLabel">
						<spring:message code="editMessage.label.date" />
					</td>
					<td><span class="date icon"><fmt:formatDate type="both" value="${dateCreated}" /></span></td>
				</tr>
				<tr>
					<td class="formLabel textarea">
						<spring:message code="editMessage.label.text" />
					</td>
					<td>
						<form:textarea id="textArea" path="text" cssClass="resizable" cssErrorClass="resizable error" />
						<form:errors path="text">
							<div class="formFieldError"><form:errors path="text" htmlEscape="false" /></div>
						</form:errors>
					</td>
				</tr>
				<tr>
					<td></td>
					<td><input type="submit" value="${saveLabel}" /></td>
				</tr>
			</table>
		</form:form>
	</body>
</html>
