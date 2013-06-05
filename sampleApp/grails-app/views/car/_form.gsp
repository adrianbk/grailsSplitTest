<%@ page import="com.ak.sample.Car" %>



<div class="fieldcontain ${hasErrors(bean: carInstance, field: 'currentOwner', 'error')} ">
	<label for="currentOwner">
		<g:message code="car.currentOwner.label" default="Current Owner" />
		
	</label>
	<g:textField name="currentOwner" value="${carInstance?.currentOwner}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: carInstance, field: 'make', 'error')} ">
	<label for="make">
		<g:message code="car.make.label" default="Make" />
		
	</label>
	<g:textField name="make" value="${carInstance?.make}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: carInstance, field: 'model', 'error')} ">
	<label for="model">
		<g:message code="car.model.label" default="Model" />
		
	</label>
	<g:textField name="model" value="${carInstance?.model}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: carInstance, field: 'previousOwners', 'error')} required">
	<label for="previousOwners">
		<g:message code="car.previousOwners.label" default="Previous Owners" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="previousOwners" type="number" value="${carInstance.previousOwners}" required=""/>
</div>

<div class="fieldcontain ${hasErrors(bean: carInstance, field: 'yearOfManufacture', 'error')} required">
	<label for="yearOfManufacture">
		<g:message code="car.yearOfManufacture.label" default="Year Of Manufacture" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="yearOfManufacture" type="number" value="${carInstance.yearOfManufacture}" required=""/>
</div>

