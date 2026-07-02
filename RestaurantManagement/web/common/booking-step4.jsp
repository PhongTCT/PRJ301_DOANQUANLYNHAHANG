<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="${sessionScope.lang == 'en' ? 'en_US' : 'vi_VN'}" />
<fmt:setBundle basename="i18n.messages" />

<jsp:include page="/header.jsp" />

<main class="bg-light py-5">
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
                        
                        <!-- General Info -->
                        <h6 class="fw-bold text-uppercase text-primary mb-3"><i class="fa-regular fa-calendar-check me-2"></i>Thông tin chung</h6>
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
                                <strong>${sessionScope.user.fullName} (${sessionScope.user.phone})</strong>
                            </div>
                            <div class="col-sm-6 mt-3">
                                <span class="text-muted small d-block">Số lượng</span>
                                <strong>${sessionScope.bookingDraft.adultsCount} người lớn <c:if test="${sessionScope.bookingDraft.childrenCount > 0}">, ${sessionScope.bookingDraft.childrenCount} trẻ em</c:if></strong>
                            </div>
                        </div>

                        <!-- Payment Mock Info -->
                        <div class="alert alert-warning border-0 rounded-3 d-flex align-items-center">
                            <i class="fa-solid fa-money-bill-wave fs-3 text-warning me-3"></i>
                            <div>
                                <h6 class="fw-bold mb-1">Thanh toán tại quầy</h6>
                                <p class="mb-0 small text-muted">Do hệ thống thanh toán trực tuyến đang được phát triển, đơn của bạn sẽ được lưu trước. Vui lòng thanh toán trực tiếp tại nhà hàng bằng Tiền mặt hoặc Thẻ.</p>
                            </div>
                        </div>

                        <form action="${pageContext.request.contextPath}/MainController" method="POST" class="mt-5 text-center">
                            <input type="hidden" name="action" value="booking">
                            <input type="hidden" name="submitFinal" value="true">
                            <a href="${pageContext.request.contextPath}/MainController?action=booking&step=3" class="btn btn-light btn-lg px-4 me-2 border"><i class="fa-solid fa-arrow-left me-2"></i>Quay lại</a>
                            <button type="submit" class="btn btn-success btn-lg px-5 shadow-sm fw-bold"><i class="fa-solid fa-check-circle me-2"></i>Xác nhận Đặt Bàn</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/footer.jsp" />
