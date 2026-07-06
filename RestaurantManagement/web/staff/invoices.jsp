<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tra cá»©u hÃ³a Ä‘Æ¡n - Le Royal</title>
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
                    <div class="admin-kicker">Billing desk</div>
                    <h1 class="admin-title">Tra cá»©u hÃ³a Ä‘Æ¡n</h1>
                    <p class="admin-copy mb-0">Staff tra cá»©u hÃ³a Ä‘Æ¡n theo khÃ¡ch, thá»i gian vÃ  mÃ£ giao dá»‹ch; admin cÃ³ thá»ƒ xem toÃ n bá»™ invoice.</p>
                </div>
                <button class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#generateModal">
                    <i class="fa-solid fa-plus me-2"></i>Táº¡o tá»« mÃ£ Ä‘áº·t bÃ n
                </button>
            </section>

            <c:if test="${not empty sessionScope.successMessage}"><div class="alert alert-success">${sessionScope.successMessage}</div><c:remove var="successMessage" scope="session"/></c:if>
            <c:if test="${not empty sessionScope.errorMessage}"><div class="alert alert-danger">${sessionScope.errorMessage}</div><c:remove var="errorMessage" scope="session"/></c:if>

            <div class="card mb-4">
                <div class="card-body p-4">
                    <form method="get" class="row g-3 align-items-end">
                        <div class="col-md-4"><label class="form-label">Tá»« khÃ³a</label><input name="q" value="${param.q}" class="form-control" placeholder="TÃªn khÃ¡ch, email, mÃ£ giao dá»‹ch"></div>
                        <div class="col-md-3"><label class="form-label">Tá»« ngÃ y</label><input type="date" name="from" value="${param.from}" class="form-control"></div>
                        <div class="col-md-3"><label class="form-label">Äáº¿n ngÃ y</label><input type="date" name="to" value="${param.to}" class="form-control"></div>
                        <div class="col-md-2"><button class="btn btn-primary w-100"><i class="fa-solid fa-magnifying-glass me-2"></i>TÃ¬m</button></div>
                    </form>
                </div>
            </div>

            <section class="card">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                            <tr><th class="ps-4">Invoice</th><th>KhÃ¡ch</th><th>Tá»•ng</th><th>Giáº£m</th><th>Voucher</th><th>Thanh toÃ¡n</th><th>Staff</th><th class="text-end pe-4">Thao tÃ¡c</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${invoices}" var="i">
                                <tr>
                                    <td class="ps-4 fw-bold">#${i.id}<div class="small text-muted">${i.transactionRef}</div></td>
                                    <td>${empty i.user ? i.guestName : i.user.fullName}<div class="small text-muted"><c:if test="${not empty i.reservation}">Reservation #${i.reservation.id}</c:if></div></td>
                                    <td class="fw-bold"><fmt:formatNumber value="${i.totalAmount}" pattern="#,##0"/>Ä‘</td>
                                    <td><fmt:formatNumber value="${i.voucherDiscount + i.pointsDiscount}" pattern="#,##0"/>Ä‘</td>
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
                                                <button class="btn btn-sm btn-primary">ÄÃ£ thanh toÃ¡n</button>
                                            </form>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty invoices}"><tr><td colspan="8" class="text-center text-muted py-5">KhÃ´ng cÃ³ hÃ³a Ä‘Æ¡n phÃ¹ há»£p.</td></tr></c:if>
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
                    <h5 class="modal-title">Táº¡o hÃ³a Ä‘Æ¡n tá»« Ä‘áº·t bÃ n</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="ÄÃ³ng"></button>
                </div>
                <div class="modal-body p-4">
                    <label class="form-label">MÃ£ Ä‘áº·t bÃ n</label>
                    <input type="number" name="reservationId" class="form-control form-control-lg" required>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Há»§y</button>
                    <button class="btn btn-primary">Táº¡o hÃ³a Ä‘Æ¡n</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
