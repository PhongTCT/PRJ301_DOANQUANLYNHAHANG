<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Duyá»‡t Ä‘Ã¡nh giÃ¡ - Le Royal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Marcellus&family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/admin-royal.css" rel="stylesheet">
</head>
<body class="admin-royal">
<div class="d-flex">
    <jsp:include page="/admin/sidebar.jsp">
        <jsp:param name="active" value="reviews"/>
    </jsp:include>

    <main class="flex-grow-1">
        <div class="admin-shell">
            <section class="admin-hero">
                <div>
                    <div class="admin-kicker">Guest voice</div>
                    <h1 class="admin-title">Duyá»‡t Ä‘Ã¡nh giÃ¡</h1>
                    <p class="admin-copy mb-0">Kiá»ƒm soÃ¡t nháº­n xÃ©t hiá»ƒn thá»‹ cÃ´ng khai vÃ  xá»­ lÃ½ pháº£n há»“i cá»§a khÃ¡ch sau má»—i láº§n Ä‘áº·t bÃ n.</p>
                </div>
            </section>

            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success">${sessionScope.successMessage}</div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>

            <section class="card">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead>
                                <tr>
                                    <th class="ps-4">KhÃ¡ch hÃ ng</th>
                                    <th>Äáº·t bÃ n</th>
                                    <th>Sao</th>
                                    <th>Ná»™i dung</th>
                                    <th>Tráº¡ng thÃ¡i</th>
                                    <c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
                                        <th class="text-end pe-4">Thao tÃ¡c</th>
                                    </c:if>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${reviews}" var="r">
                                    <tr>
                                        <td class="ps-4"><strong>${r.user.fullName}</strong><div class="small text-muted">${r.user.email}</div></td>
                                        <td>#${r.reservation.id}<div class="small text-muted"><fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm"/></div></td>
                                        <td class="text-warning"><c:forEach begin="1" end="${r.rating}"><i class="fa-solid fa-star"></i></c:forEach></td>
                                        <td style="max-width:420px;">${r.comment}<c:if test="${not empty r.imageUrl}"><div><a href="${r.imageUrl}" target="_blank" class="small">Xem áº£nh</a></div></c:if></td>
                                        <td><span class="badge ${r.isVisible ? 'bg-success' : 'bg-light text-dark border'}">${r.isVisible ? 'Äang hiá»ƒn thá»‹' : 'Äang áº©n'}</span></td>
                                        <c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
                                            <td class="text-end pe-4">
                                                <form method="post" action="${pageContext.request.contextPath}/admin/reviews" class="d-inline">
                                                    <input type="hidden" name="id" value="${r.id}">
                                                    <input type="hidden" name="action" value="${r.isVisible ? 'hide' : 'show'}">
                                                    <button class="btn btn-sm ${r.isVisible ? 'btn-outline-secondary' : 'btn-outline-success'}">${r.isVisible ? 'áº¨n' : 'Duyá»‡t'}</button>
                                                </form>
                                            </td>
                                        </c:if>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty reviews}">
                                    <tr><td colspan="${sessionScope.currentUser.role == 'ADMIN' ? 6 : 5}" class="text-center text-muted py-5">ChÆ°a cÃ³ Ä‘Ã¡nh giÃ¡.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>
        </div>
    </main>
</div>
</body>
</html>
