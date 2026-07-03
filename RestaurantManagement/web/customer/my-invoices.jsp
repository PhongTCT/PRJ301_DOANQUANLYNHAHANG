<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/header.jsp" />
<main class="bg-light py-5" style="min-height:80vh;">
    <div class="container">
        <h2 class="fw-bold mb-4"><i class="fa-solid fa-file-invoice me-2 text-primary"></i>Hóa đơn của tôi</h2>
        <div class="card border-0 shadow-sm">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light"><tr><th class="ps-4">Mã</th><th>Đặt bàn</th><th>Tổng</th><th>Ưu đãi</th><th>Voucher</th><th>Thanh toán</th><th>Ngày tạo</th><th class="text-end pe-4">Thao tác</th></tr></thead>
                    <tbody>
                    <c:forEach items="${invoices}" var="i">
                        <tr>
                            <td class="ps-4 fw-bold">#${i.id}</td>
                            <td><c:if test="${not empty i.reservation}">#${i.reservation.id}</c:if></td>
                            <td class="fw-bold text-primary"><fmt:formatNumber value="${i.totalAmount}" pattern="#,##0"/>đ</td>
                            <td><fmt:formatNumber value="${i.voucherDiscount + i.pointsDiscount}" pattern="#,##0"/>đ</td>
                            <td>
                                <c:forEach items="${i.voucherRedemptions}" var="vr"><span class="badge bg-light text-dark border">${vr.voucher.voucherCode}</span></c:forEach>
                                <c:if test="${empty i.voucherRedemptions}">-</c:if>
                            </td>
                            <td><span class="badge ${i.paymentStatus == 'PAID' ? 'bg-success' : 'bg-warning text-dark'}">${i.paymentStatus}</span> <span class="small text-muted">${i.paymentMethod}</span></td>
                            <td><fmt:formatDate value="${i.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                            <td class="text-end pe-4">
                                <c:if test="${i.paymentStatus == 'PENDING' and i.paymentMethod == 'VNPAY'}">
                                    <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/payment/vnpay-pay?invoiceId=${i.id}">
                                        <i class="fa-solid fa-credit-card me-1"></i>Thanh toán VNPay
                                    </a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty invoices}"><tr><td colspan="8" class="text-center text-muted py-5">Bạn chưa có hóa đơn.</td></tr></c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>
<jsp:include page="/footer.jsp" />
