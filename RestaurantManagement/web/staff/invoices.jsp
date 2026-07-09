<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setBundle basename="i18n.messages" />
<!DOCTYPE html>
<html lang="${sessionScope.lang != null ? sessionScope.lang : 'vi'}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="staff.invoice.title"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Marcellus&family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/admin-royal.css" rel="stylesheet">
</head>
<body class="admin-royal">
<div class="d-flex">
    <jsp:include page="/admin/sidebar.jsp">
        <jsp:param name="active" value="invoices"/>
    </jsp:include>

    <main class="flex-grow-1">
        <div class="admin-shell">
            <section class="admin-hero">
                <div>
                    <div class="admin-kicker"><fmt:message key="staff.invoice.kicker"/></div>
                    <h1 class="admin-title"><fmt:message key="staff.invoice.heading"/></h1>
                    <p class="admin-copy mb-0"><fmt:message key="staff.invoice.desc"/></p>
                </div>
                <button class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#generateModal">
                    <i class="fa-solid fa-plus me-2"></i><fmt:message key="staff.invoice.btn.generate"/>
                </button>
            </section>

            <c:if test="${not empty sessionScope.successMessage}"><div class="alert alert-success">${sessionScope.successMessage}</div><c:remove var="successMessage" scope="session"/></c:if>
            <c:if test="${not empty sessionScope.errorMessage}"><div class="alert alert-danger">${sessionScope.errorMessage}</div><c:remove var="errorMessage" scope="session"/></c:if>

            <div class="card mb-4">
                <div class="card-body p-4">
                    <form method="get" class="row g-3 align-items-end">
                        <div class="col-md-4"><label class="form-label"><fmt:message key="staff.invoice.filter.keyword"/></label><input name="q" value="${param.q}" class="form-control" placeholder="<fmt:message key="staff.invoice.filter.placeholder"/>"></div>
                        <div class="col-md-3"><label class="form-label"><fmt:message key="staff.invoice.filter.from"/></label><input type="date" name="from" value="${param.from}" class="form-control"></div>
                        <div class="col-md-3"><label class="form-label"><fmt:message key="staff.invoice.filter.to"/></label><input type="date" name="to" value="${param.to}" class="form-control"></div>
                        <div class="col-md-2"><button class="btn btn-primary w-100"><i class="fa-solid fa-magnifying-glass me-2"></i><fmt:message key="staff.invoice.filter.search"/></button></div>
                    </form>
                </div>
            </div>

            <section class="card">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                            <tr><th class="ps-4"><fmt:message key="staff.invoice.table.invoice"/></th><th><fmt:message key="staff.invoice.table.guest"/></th><th><fmt:message key="staff.invoice.table.total"/></th><th><fmt:message key="staff.invoice.table.discount"/></th><th><fmt:message key="staff.invoice.table.voucher"/></th><th><fmt:message key="staff.invoice.table.payment"/></th><th><fmt:message key="staff.invoice.table.staff"/></th><th class="text-end pe-4"><fmt:message key="staff.invoice.table.actions"/></th></tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${invoices}" var="i">
                                <tr>
                                    <td class="ps-4 fw-bold">#${i.id}<div class="small text-muted">${i.transactionRef}</div></td>
                                    <td>${empty i.user ? i.guestName : i.user.fullName}<div class="small text-muted"><c:if test="${not empty i.reservation}">Reservation #${i.reservation.id}</c:if></div></td>
                                    <td class="fw-bold"><fmt:formatNumber value="${i.totalAmount}" pattern="#,##0"/>đ</td>
                                    <td><fmt:formatNumber value="${i.voucherDiscount + i.pointsDiscount}" pattern="#,##0"/>đ</td>
                                    <td>
                                        <c:forEach items="${i.voucherRedemptions}" var="vr"><span class="badge bg-light text-dark border">${vr.voucher.voucherCode}</span></c:forEach>
                                        <c:if test="${empty i.voucherRedemptions}">-</c:if>
                                    </td>
                                    <td><span class="badge ${i.paymentStatus == 'PAID' ? 'bg-success' : 'bg-warning text-dark'}">${i.paymentStatus}</span><div class="small text-muted">${i.paymentMethod}</div></td>
                                    <td>${empty i.issuedByStaff ? '-' : i.issuedByStaff.fullName}</td>
                                    <td class="text-end pe-4">
                                        <c:if test="${i.paymentStatus != 'PAID'}">
                                            <form method="post" class="d-inline">
                                                <input type="hidden" name="action" value="markPaid"><input type="hidden" name="id" value="${i.id}">
                                                <button class="btn btn-sm btn-primary"><fmt:message key="staff.invoice.btn.markPaid"/></button>
                                            </form>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty invoices}"><tr><td colspan="8" class="text-center text-muted py-5"><fmt:message key="staff.invoice.empty"/></td></tr></c:if>
                        </tbody>
                    </table>
                </div>
            </section>
        </div>
    </main>
</div>

<div class="modal fade" id="generateModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form method="post">
                <input type="hidden" name="action" value="generate">
                <div class="modal-header">
                    <h5 class="modal-title"><fmt:message key="staff.invoice.modal.title"/></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="<fmt:message key="staff.invoice.modal.close"/>"></button>
                </div>
                <div class="modal-body p-4">
                    <label class="form-label"><fmt:message key="staff.invoice.modal.label"/></label>
                    <input type="number" name="reservationId" class="form-control form-control-lg" required>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light border" data-bs-dismiss="modal"><fmt:message key="staff.invoice.modal.cancel"/></button>
                    <button class="btn btn-primary"><fmt:message key="staff.invoice.modal.generate"/></button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
