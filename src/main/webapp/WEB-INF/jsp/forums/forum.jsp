<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/jsp/urls.jspf" %>

<c:set var="messagesPath" value="${forumsPath}/${forum.id}/messages" />
<c:url var="moderatorUrl" value="${accountsPath}/${forum.owner.username}.html" />
<c:url var="postMessageUrl" value="${messagesPath}/post.html" />

<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title><c:out value="${forum.name}" /></title>
		<link rel="stylesheet" type="text/css" href="${forumsCssUrl}" />
		<script type="text/javascript">
			$(function() {
				$('#messageList').tablesorter({ sortList: [ [2, 1] ], textExtraction: "complex" });
			});
		</script>
	</head>
	<body>
		<ul id="breadcrumbs">
			<li><a href="${homeUrl}">Home</a></li>
			<li><a href="${forumsUrl}">Forums</a></li>
		</ul>
		
		<div style="margin-bottom:20px">
			<div style="float:right;margin: 7px 0 0 20px">
				Forum moderated by <span class="user icon"><a href="${moderatorUrl}"><c:out value="${forum.owner.fullName}" /></a></span>
			</div>
			<div><h1 style="margin-bottom:0"><c:out value="${forum.name}" /></h1></div>
			<div style="clear:both"></div>
		</div>
		
		<c:if test="${param.deleted == true}">
			<div class="info alert">Message deleted.</div>
		</c:if>
		
		<c:choose>
			<c:when test="${empty forum.messages}">
				<p>Be the first to <a href="${postMessageUrl}">post a message</a>.</p>
			</c:when>
			<c:otherwise>
				<div class="tableActionBar">
					${forum.numVisibleMessages} messages
					| <span class="commentAdd icon"><a href="${postMessageUrl}">Post message</a></span>
				</div>
				<table id="messageList" class="table tablesorter">
					<thead>
						<tr>
							<th>Message</th>
							<th>Author</th>
							<th>Date</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="message" items="${forum.messages}">
							<c:url var="messageUrl" value="${messagesPath}/${message.id}.html" />
							<c:url var="authorUrl" value="${accountsPath}/${message.author.username}.html" />
							
							<%-- Use timeStyle="short" so jquery.tablesorter can parse column as date --%>
							<fmt:formatDate var="date" type="both" timeStyle="short" value="${message.dateCreated}" />
							
							<tr>
								<td>
									<a href="${messageUrl}"><c:out value="${message.subject}" /></a>
									<c:if test="${not message.visible}"><b>[BLOCKED]</b></c:if>
								</td>
								<td><span class="user icon" style="white-space:nowrap"><a href="${authorUrl}"><c:out value="${message.author.fullName}" /></a></span></td>
								<td><span class="date icon" style="white-space:nowrap">${date}</span></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</c:otherwise>
		</c:choose>
	</body>
</html>
