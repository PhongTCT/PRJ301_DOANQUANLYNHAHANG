<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="row g-3">
    <div class="col-12">
        <div class="admin-fieldset-title">Thông tin mã</div>
    </div>
    <div class="col-md-4">
        <label class="form-label">Mã voucher</label>
        <input name="voucherCode" class="form-control" required>
    </div>
    <div class="col-md-4">
        <label class="form-label">Loại</label>
        <select name="voucherType" class="form-select">
            <c:forEach items="${voucherTypes}" var="t"><option value="${t}">${t}</option></c:forEach>
        </select>
    </div>
    <div class="col-md-4">
        <label class="form-label">Trạng thái</label>
        <select name="isActive" class="form-select">
            <option value="true">Đang bật</option>
            <option value="false">Đã tắt</option>
        </select>
    </div>

    <div class="col-12 pt-2">
        <div class="admin-fieldset-title">Mức giảm và điều kiện</div>
    </div>
    <div class="col-md-3">
        <label class="form-label">Giảm %</label>
        <input type="number" step="0.01" name="discountPercent" class="form-control">
    </div>
    <div class="col-md-3">
        <label class="form-label">Giảm tiền</label>
        <input type="number" step="1000" name="discountAmount" class="form-control">
    </div>
    <div class="col-md-3">
        <label class="form-label">Đơn tối thiểu</label>
        <input type="number" step="1000" name="minOrderValue" class="form-control">
    </div>
    <div class="col-md-3">
        <label class="form-label">Giảm tối đa</label>
        <input type="number" step="1000" name="maxDiscount" class="form-control">
    </div>

    <div class="col-12 pt-2">
        <div class="admin-fieldset-title">Thời hạn và số lượng</div>
    </div>
    <div class="col-md-4">
        <label class="form-label">Số lượng</label>
        <input type="number" name="usageLimit" class="form-control" min="1" required>
    </div>
    <div class="col-md-4">
        <label class="form-label">Từ ngày</label>
        <input type="datetime-local" name="validFrom" class="form-control" required>
    </div>
    <div class="col-md-4">
        <label class="form-label">Đến ngày</label>
        <input type="datetime-local" name="validTo" class="form-control" required>
    </div>
</div>
