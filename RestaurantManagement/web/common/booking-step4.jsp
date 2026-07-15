<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="${sessionScope.lang == 'vi' ? 'vi_VN' : 'en_US'}" />
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
                            <span class="d-block mt-2 small fw-bold text-primary"><fmt:message key="booking.step4.title"/></span>
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
                        <h4 class="fw-bold mb-0"><fmt:message key="booking.step4.header.title"/></h4>
                        <p class="mb-0 text-white-50"><fmt:message key="booking.step4.header.desc"/></p>
                    </div>
                    <div class="card-body p-4 p-md-5">
                        
                        <form action="${pageContext.request.contextPath}/MainController" method="POST" class="needs-validation">
                            <input type="hidden" name="action" value="booking">
                            <input type="hidden" name="submitFinal" value="true">

                        <h6 class="fw-bold text-uppercase text-primary mb-3"><i class="fa-regular fa-calendar-check me-2"></i><fmt:message key="booking.step4.info.title"/></h6>
                        <div class="row mb-4 bg-light p-3 rounded-3 mx-0">
                            <div class="col-sm-6 mb-2 mb-sm-0">
                                <span class="text-muted small d-block"><fmt:message key="booking.step4.info.date"/></span>
                                <strong class="fs-6"><fmt:formatDate value="${sessionScope.bookingDraft.reservationDate}" pattern="dd/MM/yyyy" /></strong>
                            </div>
                            <div class="col-sm-6">
                                <span class="text-muted small d-block"><fmt:message key="booking.step4.info.time"/></span>
                                <strong class="fs-6">${sessionScope.bookingDraft.reservationTime}</strong>
                            </div>
                            <div class="col-sm-6 mt-3">
                                <span class="text-muted small d-block"><fmt:message key="booking.step4.info.customer"/></span>
                                <strong>${sessionScope.currentUser.fullName} (${sessionScope.currentUser.phone})</strong>
                            </div>
                            <div class="col-sm-6 mt-3">
                                <span class="text-muted small d-block"><fmt:message key="booking.step4.info.guests"/></span>
                                <strong>${sessionScope.bookingDraft.adultsCount} <fmt:message key="booking.step4.info.adults"/> <c:if test="${sessionScope.bookingDraft.childrenCount > 0}">, ${sessionScope.bookingDraft.childrenCount} <fmt:message key="booking.step4.info.children"/></c:if></strong>
                            </div>
                        </div>

                        <h6 class="fw-bold text-uppercase text-primary mb-3"><i class="fa-solid fa-receipt me-2"></i><fmt:message key="booking.step4.summary.title"/></h6>
                        <div class="bg-white border rounded-3 p-3 mb-4">
                            <div class="d-flex justify-content-between py-2 border-bottom">
                                <span class="text-muted"><fmt:message key="booking.step4.summary.subtotal"/></span>
                                <strong><fmt:formatNumber value="${subtotal}" pattern="#,##0" />đ</strong>
                            </div>
                            <div class="d-flex justify-content-between py-2 border-bottom">
                                <span class="text-muted"><fmt:message key="booking.step4.summary.surcharge"/></span>
                                <strong><fmt:formatNumber value="${surcharge}" pattern="#,##0" />đ</strong>
                            </div>
                            <div class="d-flex justify-content-between pt-3">
                                <span class="fw-bold"><fmt:message key="booking.step4.summary.total"/></span>
                                <strong class="text-primary fs-5"><fmt:formatNumber value="${grossTotal}" pattern="#,##0" />đ</strong>
                            </div>
                        </div>

                        <div class="row g-3 mb-4">
                            <div class="col-md-7">
                                <label class="form-label fw-bold"><i class="fa-solid fa-ticket me-2 text-primary"></i><fmt:message key="booking.step4.voucher.title"/></label>
                                <select class="form-select form-select-lg" name="voucherCode">
                                    <option value=""><fmt:message key="booking.step4.voucher.none"/></option>
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
                                <div class="form-text"><fmt:message key="booking.step4.voucher.note"/></div>
                            </div>
                            <div class="col-md-5">
                                <label class="form-label fw-bold"><i class="fa-solid fa-coins me-2 text-warning"></i><fmt:message key="booking.step4.points.title"/></label>
                                <div class="input-group input-group-lg">
                                    <input type="number" class="form-control" name="pointsToUse" min="0" max="${loyaltyPoints}" value="0">
                                    <span class="input-group-text">/${loyaltyPoints}</span>
                                </div>
                                <div class="form-text"><fmt:message key="booking.step4.points.note"/></div>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold"><i class="fa-solid fa-wallet me-2 text-success"></i><fmt:message key="booking.step4.payment.title"/></label>
                            <div class="row g-2">
                                <div class="col-md-4">
                                    <label class="border rounded-3 p-3 w-100 h-100">
                                        <input type="radio" name="paymentMethod" value="CASH" checked class="me-2"> <fmt:message key="booking.step4.payment.cash"/>
                                    </label>
                                </div>
                                <div class="col-md-4">
                                    <label class="border rounded-3 p-3 w-100 h-100">
                                        <input type="radio" name="paymentMethod" value="VNPAY" class="me-2"> VNPay
                                        <span class="d-block small text-muted mt-1"><fmt:message key="booking.step4.payment.vnpay.desc"/></span>
                                    </label>
                                </div>
                                <div class="col-md-4">
                                    <label class="border rounded-3 p-3 w-100 h-100">
                                        <input type="radio" name="paymentMethod" value="XU" class="me-2"> <fmt:message key="booking.step4.payment.xu"/>
                                        <span class="d-block small text-muted mt-1"><fmt:message key="booking.step4.payment.xu.desc"/> <fmt:formatNumber value="${coinBalance}" pattern="#,##0"/> Xu</span>
                                    </label>
                                </div>
                                <div class="col-md-4">
                                    <label class="border rounded-3 p-3 w-100 h-100 text-muted">
                                        <input type="radio" name="paymentMethod" value="MOMO" class="me-2" disabled> MoMo
                                        <span class="d-block small mt-1"><fmt:message key="booking.step4.payment.momo.desc"/></span>
                                    </label>
                                </div>
                            </div>
                            <div class="form-text"><fmt:message key="booking.step4.payment.note"/></div>
                        </div>

                        <div class="alert alert-info border-0 rounded-3 d-flex align-items-start">
                            <i class="fa-solid fa-circle-info fs-4 text-info me-3 mt-1"></i>
                            <div class="small">
                                <fmt:message key="booking.step4.notice"/>
                            </div>
                        </div>

                        <div class="mt-5 text-center">
                            <a href="${pageContext.request.contextPath}/MainController?action=booking&step=3" class="btn btn-light btn-lg px-4 me-2 border"><i class="fa-solid fa-arrow-left me-2"></i><fmt:message key="booking.step4.btn.back"/></a>
                            <button type="submit" class="btn btn-success btn-lg px-5 shadow-sm fw-bold"><i class="fa-solid fa-check-circle me-2"></i><fmt:message key="booking.step4.btn.confirm"/></button>
                        </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/footer.jsp" />
