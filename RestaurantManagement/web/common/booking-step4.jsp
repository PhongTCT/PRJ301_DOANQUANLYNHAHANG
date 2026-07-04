<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="${sessionScope.lang == 'en' ? 'en_US' : 'vi_VN'}" />
<fmt:setBundle basename="i18n.messages" />

<jsp:include page="/header.jsp" />

<link href="${pageContext.request.contextPath}/assets/css/admin-royal.css" rel="stylesheet">
<main class="bg-light py-5 admin-royal">
    <div class="container">
        <!-- Progress Steps -->
        <div class="row justify-content-center mb-5">
            <div class="col-lg-8">
                <div class="position-relative m-4">
                    <div class="progress" style="height: 2px;">
                        <div class="progress-bar bg-primary" role="progressbar" style="width: 100%;" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100"></div>
                    </div>
                    <div class="d-flex justify-content-between position-absolute top-0 w-100" style="margin-top: -12px;">
                        <!-- Step 1 -->
                        <div class="text-center" style="width: 24px;">
                            <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center mx-auto shadow-sm" style="width: 32px; height: 32px;">
                                <i class="fa-solid fa-check small"></i>
                            </div>
                            <span class="d-block mt-2 small fw-bold text-primary"><fmt:message key="booking.step1.title"/></span>
                        </div>
                        <!-- Step 2 -->
                        <div class="text-center" style="width: 24px;">
                            <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center mx-auto shadow-sm" style="width: 32px; height: 32px;">
                                <i class="fa-solid fa-check small"></i>
                            </div>
                            <span class="d-block mt-2 small fw-bold text-primary"><fmt:message key="booking.step2.title"/></span>
                        </div>
                        <!-- Step 3 -->
                        <div class="text-center" style="width: 24px;">
                            <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center mx-auto shadow-sm" style="width: 32px; height: 32px;">
                                <i class="fa-solid fa-check small"></i>
                            </div>
                            <span class="d-block mt-2 small fw-bold text-primary"><fmt:message key="booking.step3.title"/></span>
                        </div>
                        <!-- Step 4 -->
                        <div class="text-center" style="width: 24px;">
                            <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center mx-auto shadow-sm" style="width: 32px; height: 32px;">
                                <span class="small fw-bold">4</span>
                            </div>
                            <span class="d-block mt-2 small fw-bold text-primary">Xác nhận</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger shadow-sm border-0 rounded-3 mb-4">
                <i class="fa-solid fa-circle-exclamation me-2"></i> ${error}
            </div>
        </c:if>

        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                    <div class="card-header bg-primary text-white text-center py-4 border-0">
                        <i class="fa-solid fa-file-invoice fs-1 mb-2"></i>
                        <h4 class="fw-bold mb-0">Xác nhận thông tin Đặt bàn</h4>
                        <p class="mb-0 text-white-50">Vui lòng kiểm tra lại thông tin trước khi hoàn tất</p>
                    </div>
                    <div class="card-body p-4 p-md-5">
                        
                        <form action="${pageContext.request.contextPath}/MainController" method="POST" class="needs-validation">
                            <input type="hidden" name="action" value="booking">
                            <input type="hidden" name="submitFinal" value="true">

                        <h6 class="fw-bold text-uppercase text-primary mb-3"><i class="fa-regular fa-calendar-check me-2"></i>Thông tin đặt bàn</h6>
                        <div class="row mb-4 bg-light p-3 rounded-3 mx-0">
                            <div class="col-sm-6 mb-2 mb-sm-0">
                                <span class="text-muted small d-block">Ngày nhận bàn</span>
                                <strong class="fs-6"><fmt:formatDate value="${sessionScope.bookingDraft.reservationDate}" pattern="dd/MM/yyyy" /></strong>
                            </div>
                            <div class="col-sm-6">
                                <span class="text-muted small d-block">Giờ đến</span>
                                <strong class="fs-6">${sessionScope.bookingDraft.reservationTime}</strong>
                            </div>
                            <div class="col-sm-6 mt-3">
                                <span class="text-muted small d-block">Khách hàng</span>
                                <strong>${sessionScope.currentUser.fullName} (${sessionScope.currentUser.phone})</strong>
                            </div>
                            <div class="col-sm-6 mt-3">
                                <span class="text-muted small d-block">Số lượng</span>
                                <strong>${sessionScope.bookingDraft.adultsCount} người lớn <c:if test="${sessionScope.bookingDraft.childrenCount > 0}">, ${sessionScope.bookingDraft.childrenCount} trẻ em</c:if></strong>
                            </div>
                        </div>

                        <h6 class="fw-bold text-uppercase text-primary mb-3"><i class="fa-solid fa-receipt me-2"></i>Tóm tắt thanh toán</h6>
                        <div class="bg-white border rounded-3 p-3 mb-4">
                            <div class="d-flex justify-content-between py-2 border-bottom">
                                <span class="text-muted">Tạm tính bàn, món ăn và dịch vụ</span>
                                <strong><fmt:formatNumber value="${subtotal}" pattern="#,##0" />đ</strong>
                            </div>
                            <div class="d-flex justify-content-between py-2 border-bottom">
                                <span class="text-muted">Phụ thu ngày lễ</span>
                                <strong><fmt:formatNumber value="${surcharge}" pattern="#,##0" />đ</strong>
                            </div>
                            <div class="d-flex justify-content-between pt-3">
                                <span class="fw-bold">Tổng trước ưu đãi</span>
                                <strong class="text-primary fs-5"><fmt:formatNumber value="${grossTotal}" pattern="#,##0" />đ</strong>
                            </div>
                        </div>

                        <div class="row g-3 mb-4">
                            <div class="col-md-7">
                                <label class="form-label fw-bold"><i class="fa-solid fa-ticket me-2 text-primary"></i>Voucher giảm tổng bill</label>
                                <select class="form-select form-select-lg" name="voucherCode">
                                    <option value="">Không dùng voucher</option>
                                    <c:forEach items="${availableVouchers}" var="v">
                                        <option value="${v.voucherCode}">
                                            ${v.voucherCode} -
                                            <c:choose>
                                                <c:when test="${not empty v.discountPercent}">giảm ${v.discountPercent}%</c:when>
                                                <c:otherwise>giảm <fmt:formatNumber value="${v.discountAmount}" pattern="#,##0" />đ</c:otherwise>
                                            </c:choose>
                                            còn ${v.remainingUses} lượt
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="form-text">Mỗi voucher chỉ dùng một lần cho mỗi tài khoản. Lượt dùng sẽ được lưu cùng invoice.</div>
                            </div>
                            <div class="col-md-5">
                                <label class="form-label fw-bold"><i class="fa-solid fa-coins me-2 text-warning"></i>Điểm tích lũy</label>
                                <div class="input-group input-group-lg">
                                    <input type="number" class="form-control" name="pointsToUse" min="0" max="${loyaltyPoints}" value="0">
                                    <span class="input-group-text">/${loyaltyPoints}</span>
                                </div>
                                <div class="form-text">1 điểm = 1.000đ giảm trực tiếp vào hóa đơn.</div>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold"><i class="fa-solid fa-wallet me-2 text-success"></i>Phương thức thanh toán</label>
                            <div class="row g-2">
                                <div class="col-md-4">
                                    <label class="border rounded-3 p-3 w-100 h-100">
                                        <input type="radio" name="paymentMethod" value="CASH" checked class="me-2"> Tiền mặt tại quầy
                                    </label>
                                </div>
                                <div class="col-md-4">
                                    <label class="border rounded-3 p-3 w-100 h-100">
                                        <input type="radio" name="paymentMethod" value="VNPAY" class="me-2"> VNPay
                                        <span class="d-block small text-muted mt-1">Chuyển sang cổng VNPay để thanh toán ngay.</span>
                                    </label>
                                </div>
                                <div class="col-md-4">
                                    <label class="border rounded-3 p-3 w-100 h-100 text-muted">
                                        <input type="radio" name="paymentMethod" value="MOMO" class="me-2" disabled> MoMo
                                        <span class="d-block small mt-1">Đang phát triển.</span>
                                    </label>
                                </div>
                            </div>
                            <div class="form-text">VNPay sẽ tự cập nhật hóa đơn khi thanh toán thành công. Tiền mặt được staff/admin xác nhận tại quầy.</div>
                        </div>

                        <div class="alert alert-info border-0 rounded-3 d-flex align-items-start">
                            <i class="fa-solid fa-circle-info fs-4 text-info me-3 mt-1"></i>
                            <div class="small">
                                Voucher và điểm được kiểm tra lại tại thời điểm xác nhận để đảm bảo số lượng còn đúng. Nếu voucher đã hết lượt hoặc tài khoản đã dùng voucher đó, hệ thống sẽ báo lỗi và giữ bạn ở bước này.
                            </div>
                        </div>

                        <div class="mt-5 text-center">
                            <a href="${pageContext.request.contextPath}/MainController?action=booking&step=3" class="btn btn-light btn-lg px-4 me-2 border"><i class="fa-solid fa-arrow-left me-2"></i>Quay lại</a>
                            <button type="submit" class="btn btn-success btn-lg px-5 shadow-sm fw-bold"><i class="fa-solid fa-check-circle me-2"></i>Xác nhận Đặt Bàn</button>
                        </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/footer.jsp" />
