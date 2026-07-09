<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="row g-3">
    <div class="col-12">
        <div class="admin-fieldset-title"><fmt:message key="admin.voucherfield.section.info"/></div>
    </div>
    <div class="col-md-4">
        <label class="form-label"><fmt:message key="admin.voucherfield.label.code"/></label>
        <input name="voucherCode" class="form-control" required>
    </div>
    <div class="col-md-4">
        <label class="form-label"><fmt:message key="admin.voucherfield.label.type"/></label>
        <select name="voucherType" class="form-select">
            <c:forEach items="${voucherTypes}" var="t"><option value="${t}">${t}</option></c:forEach>
        </select>
    </div>
    <div class="col-md-4">
        <label class="form-label"><fmt:message key="admin.voucherfield.label.status"/></label>
        <select name="isActive" class="form-select">
            <option value="true"><fmt:message key="admin.voucherfield.label.active"/></option>
            <option value="false"><fmt:message key="admin.voucherfield.label.inactive"/></option>
        </select>
    </div>

    <div class="col-12 pt-2">
        <div class="admin-fieldset-title"><fmt:message key="admin.voucherfield.section.discount"/></div>
    </div>
    <div class="col-md-3">
        <label class="form-label"><fmt:message key="admin.voucherfield.label.discount.percent"/></label>
        <input type="number" step="0.01" name="discountPercent" class="form-control">
    </div>
    <div class="col-md-3">
        <label class="form-label"><fmt:message key="admin.voucherfield.label.discount.amount"/></label>
        <input type="number" step="1000" name="discountAmount" class="form-control">
    </div>
    <div class="col-md-3">
        <label class="form-label"><fmt:message key="admin.voucherfield.label.minorder"/></label>
        <input type="number" step="1000" name="minOrderValue" class="form-control">
    </div>
    <div class="col-md-3">
        <label class="form-label"><fmt:message key="admin.voucherfield.label.maxdiscount"/></label>
        <input type="number" step="1000" name="maxDiscount" class="form-control">
    </div>

    <div class="col-12 pt-2">
        <div class="admin-fieldset-title"><fmt:message key="admin.voucherfield.section.validity"/></div>
    </div>
    <div class="col-md-4">
        <label class="form-label"><fmt:message key="admin.voucherfield.label.quantity"/></label>
        <input type="number" name="usageLimit" class="form-control" min="1" required>
    </div>
    <div class="col-md-4">
        <label class="form-label"><fmt:message key="admin.voucherfield.label.from"/></label>
        <input type="datetime-local" name="validFrom" class="form-control" required>
    </div>
    <div class="col-md-4">
        <label class="form-label"><fmt:message key="admin.voucherfield.label.to"/></label>
        <input type="datetime-local" name="validTo" class="form-control" required>
    </div>
</div>
