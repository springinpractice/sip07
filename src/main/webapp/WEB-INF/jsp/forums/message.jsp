<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ include file="/WEB-INF/jsp/urls.jspf" %>

<c:set var="forum" value="${message.forum}"/>
<c:set var="forumPath" value="${forumsPath}/${forum.id}" />
<c:set var="messagePath" value="${forumPath}/messages/${message.id}" />

<c:url var="messageJsUrl" value="/scripts/message.js" />
<c:url var="forumUrl" value="${forumPath}.html" />
<c:url var="messageUrl" value="${messagePath}" />
<c:url var="editMessageUrl" value="${messagePath}/edit.html" />
<c:url var="moderatorUrl" value="${accountsPath}/${forum.owner.username}.html" />
<c:url var="authorUrl" value="${accountsPath}/${message.author.username}.html" />

<c:set var="blockedAlert">
	<div id="blockedAlert" class="warning">This message has been blocked. Only administrators and forum moderators can see it.</div>
</c:set>

<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title><c:out value="${message.subject}" /></title>
		<link rel="stylesheet" type="text/css" href="${forumsCssUrl}" />
		<script type="text/javascript">
			var messageUrl = '${messageUrl}';
			var blockedAlert = $('${blockedAlert}');
			var blockLink = $('${blockLink}');
			var unblockLink = $('${unblockLink}');
		</script>
		<script type="text/javascript" src="${messageJsUrl}"></script>
		<script type="text/javascript">
			$(function() {
				kickIt(<c:out value="${message.id}" />, <c:out value="${message.visible}" />);
			});
		</script>
	</head>
	<body>
		<ul id="breadcrumbs">
			<li><a href="${homeUrl}"><spring:message code="home.pageTitle" /></a></li>
			<li><a href="${forumsUrl}"><spring:message code="forums.pageTitle" /></a></li>
			<li><a href="${forumUrl}">${forum.name}</a></li>
		</ul>
		
		<div style="margin-bottom:20px">
			<div style="float:right;margin: 7px 0 0 20px">
				Forum moderated by
				<span class="user icon"><a href="${moderatorUrl}"><c:out value="${forum.owner.fullName}" /></a></span>
			</div>
			<div><h1 style="margin-bottom:0"><c:out value="${message.subject}" /></h1></div>
			<div style="clear:both"></div>
		</div>
		
		<c:if test="${!message.visible}">
			<div class="warning alert">
				This message has been blocked. Only administrators and forum moderators can see it.
			</div>
		</c:if>
		
		<div class="byLine">
			Posted by <span class="user icon"><a href="${authorUrl}"><c:out value="${message.author.fullName}" /></a></span>
			on <span class="date icon"><fmt:formatDate type="both" value="${message.dateCreated}" /></span>
		</div>
		
		<%-- WARNING: This doesn't escape XML! Be sure to scrub inputs before rendering them. --%>
		<div class="pane">
			<c:out value="${message.text}" escapeXml="false" />
		</div>

		<ul class="actionBar">
			<li class="commentEdit icon"><a href="${editMessageUrl}" title="Edit message subject, text or visibility">Edit message</a></li>
			<c:choose>
				<c:when test="${message.visible}">
					<li id="blockLink" class="cancel icon"><a href="#" title="Hide messages from users without deleting it">Block message</a></li>
				</c:when>
				<c:otherwise>
					<li id="unblockLink" class="accept icon"><a href="#" title="Allow users to see this message again">Unblock message</a></li>
				</c:otherwise>
			</c:choose>
			<li id="deleteLink" class="commentDelete icon"><a href="#" title="Permanently delete this message">Delete message</a></li>
		</ul>
		
		<form id="deleteForm" action="${messageUrl}" method="post">
			<div><input type="hidden" name="_method" value="DELETE" /></div>
		</form>
	</body>
</html>
