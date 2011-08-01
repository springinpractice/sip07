<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/jsp/urls.jspf" %>

<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>Forums</title>
		<link rel="stylesheet" type="text/css" href="${forumsCssUrl}" />
		<script type="text/javascript">
			$(function() { $("#forumList").tablesorter({ sortList: [ [0, 0] ], textExtraction: "complex" }); });
		</script>
	</head>
	<body>
		<ul id="breadcrumbs">
			<li><a href="${homeUrl}">Home</a></li>
		</ul>
		
		<h1>Forums</h1>
		
		<c:choose>
			<c:when test="${empty forumList}">
				<p>No forums.</p>
			</c:when>
			<c:otherwise>
				<table id="forumList" class="table sortable">
					<thead>
						<tr>
							<th>Forum</th>
							<th class="numeric">#&nbsp;posts</th>
							<th class="date">Last post</th>
							<th>Moderator</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="forum" items="${forumList}">
							<c:url var="forumUrl" value="${forumsPath}/${forum.id}.html" />
							<c:url var="ownerUrl" value="${accountsPath}/${forum.owner.username}.html" />
							
							<%-- Use timeStyle="short" so jquery.tablesorter can parse column as date --%>
							<fmt:formatDate var="date" type="both" timeStyle="short" value="${forum.lastVisibleMessageDate}" />
							
							<tr>
								<td><a href="${forumUrl}"><c:out value="${forum.name}" /></a></td>
								<td class="numeric">${forum.numVisibleMessages}</td>
								<td>
									<c:if test="${not empty forum.lastVisibleMessageDate}">
										<span class="date icon" style="white-space:nowrap">${date}</span>
									</c:if>
								</td>
								<td><span class="user icon" style="white-space:nowrap"><a href="${ownerUrl}"><c:out value="${forum.owner.fullName}" /></a></span></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</c:otherwise>
		</c:choose>
	</body>
</html>
