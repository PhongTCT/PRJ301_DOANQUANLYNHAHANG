<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/header.jsp" />

<main class="bg-light py-5" style="min-height: 80vh;">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                    <div class="card-header bg-success text-white text-center py-5 border-0">
                        <i class="fa-solid fa-circle-check fs-1 mb-3"></i>
                        <h2 class="fw-bold mb-1">Đặt bàn thành công</h2>
                        <p class="mb-0 text-white-50">Vui lòng lưu mã đặt bàn để tra cứu khi đến nhà hàng</p>
                    </div>
                    <div class="card-body p-4 p-md-5">
                        <c:choose>
                            <c:when test="${empty sessionScope.lastReservation}">
                                <div class="text-center text-muted py-5">
                                    <i class="fa-regular fa-folder-open fs-1 mb-3 d-block"></i>
                                    Không tìm thấy thông tin đặt bàn gần nhất.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="row g-3 mb-4">
                                    <div class="col-md-6">
                                        <div class="bg-light rounded-3 p-4 h-100">
                                            <div class="small text-muted text-uppercase fw-bold">Mã đặt bàn</div>
                                            <div class="display-6 fw-bold text-primary">#${sessionScope.lastReservation.id}</div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="bg-light rounded-3 p-4 h-100">
                                            <div class="small text-muted text-uppercase fw-bold">Mã hóa đơn</div>
                                            <div class="display-6 fw-bold text-success">#${sessionScope.lastInvoice.id}</div>
                                        </div>
                                    </div>
                                </div>

                                <div class="border rounded-3 p-4 mb-4">
                                    <div class="d-flex justify-content-between py-2 border-bottom">
                                        <span>Ngày giờ</span>
                                        <strong><fmt:formatDate value="${sessionScope.lastReservation.reservationDate}" pattern="dd/MM/yyyy" /> - <fmt:formatDate value="${sessionScope.lastReservation.reservationTime}" pattern="HH:mm" /></strong>
                                    </div>
                                    <div class="d-flex justify-content-between py-2 border-bottom">
                                        <span>Khách hàng</span>
                                        <strong>${sessionScope.lastReservation.guestName}</strong>
                                    </div>
                                    <div class="d-flex justify-content-between py-2 border-bottom">
                                        <span>Tổng thanh toán dự kiến</span>
                                        <strong class="text-primary"><fmt:formatNumber value="${sessionScope.lastInvoice.totalAmount}" pattern="#,##0" />đ</strong>
                                    </div>
                                    <div class="d-flex justify-content-between py-2">
                                        <span>Trạng thái hóa đơn</span>
                                        <strong>${sessionScope.lastInvoice.paymentStatus}</strong>
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap gap-2 justify-content-center">
                                    <a href="${pageContext.request.contextPath}/customer/reservations" class="btn btn-primary px-4"><i class="fa-solid fa-clock-rotate-left me-2"></i>Đơn đặt bàn của tôi</a>
                                    <a href="${pageContext.request.contextPath}/customer/invoices" class="btn btn-outline-dark px-4"><i class="fa-solid fa-file-invoice me-2"></i>Hóa đơn của tôi</a>
                                    <a href="${pageContext.request.contextPath}/MainController?action=home" class="btn btn-light border px-4">Về trang chủ</a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/footer.jsp" />
