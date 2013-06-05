
<%@ page import="com.ak.sample.Car" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'car.label', default: 'Car')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-car" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-car" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
				<thead>
					<tr>
					
						<g:sortableColumn property="currentOwner" title="${message(code: 'car.currentOwner.label', default: 'Current Owner')}" />
					
						<g:sortableColumn property="make" title="${message(code: 'car.make.label', default: 'Make')}" />
					
						<g:sortableColumn property="model" title="${message(code: 'car.model.label', default: 'Model')}" />
					
						<g:sortableColumn property="previousOwners" title="${message(code: 'car.previousOwners.label', default: 'Previous Owners')}" />
					
						<g:sortableColumn property="yearOfManufacture" title="${message(code: 'car.yearOfManufacture.label', default: 'Year Of Manufacture')}" />
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${carInstanceList}" status="i" var="carInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" id="${carInstance.id}">${fieldValue(bean: carInstance, field: "currentOwner")}</g:link></td>
					
						<td>${fieldValue(bean: carInstance, field: "make")}</td>
					
						<td>${fieldValue(bean: carInstance, field: "model")}</td>
					
						<td>${fieldValue(bean: carInstance, field: "previousOwners")}</td>
					
						<td>${fieldValue(bean: carInstance, field: "yearOfManufacture")}</td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${carInstanceTotal}" />
			</div>
		</div>
	</body>
</html>
