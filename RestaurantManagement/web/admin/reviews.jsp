<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setLocale value="${sessionScope.lang == 'vi' ? 'vi_VN' : 'en_US'}" />
<fmt:setBundle basename="i18n.messages" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="admin.reviews.title" /> - Le Royal</title>
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
                    <div class="admin-kicker"><fmt:message key="admin.reviews.kicker" /></div>
                    <h1 class="admin-title"><fmt:message key="admin.reviews.title" /></h1>
                    <p class="admin-copy mb-0"><fmt:message key="admin.reviews.desc" /></p>
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
                                    <th class="ps-4"><fmt:message key="admin.reviews.col.customer" /></th>
                                    <th><fmt:message key="admin.reviews.col.booking" /></th>
                                    <th><fmt:message key="admin.reviews.col.stars" /></th>
                                    <th><fmt:message key="admin.reviews.col.content" /></th>
                                    <th><fmt:message key="admin.reviews.col.status" /></th>
                                    <c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
                                        <th class="text-end pe-4"><fmt:message key="admin.reviews.col.actions" /></th>
                                    </c:if>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${reviews}" var="r">
                                    <tr>
                                        <td class="ps-4"><strong>${r.user.fullName}</strong><div class="small text-muted">${r.user.email}</div></td>
                                        <td>#${r.reservation.id}<div class="small text-muted"><fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm"/></div></td>
                                        <td class="text-warning"><c:forEach begin="1" end="${r.rating}"><i class="fa-solid fa-star"></i></c:forEach></td>
                                        <td style="max-width:420px;">${r.comment}<c:if test="${not empty r.imageUrl}"><div><a href="${r.imageUrl}" target="_blank" class="small"><fmt:message key="admin.reviews.btn.viewimage" /></a></div></c:if></td>
                                        <td>
                                            <c:set var="reviewStatus">
                                                <c:choose>
                                                    <c:when test="${r.isVisible}"><fmt:message key="admin.reviews.status.visible" /></c:when>
                                                    <c:otherwise><fmt:message key="admin.reviews.status.hidden" /></c:otherwise>
                                                </c:choose>
                                            </c:set>
                                            <span class="badge ${r.isVisible ? 'bg-success' : 'bg-light text-dark border'}">${reviewStatus}</span>
                                        </td>
                                        <c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
                                            <td class="text-end pe-4">
                                                <form method="post" action="${pageContext.request.contextPath}/admin/reviews" class="d-inline">
                                                    <input type="hidden" name="id" value="${r.id}">
                                                    <input type="hidden" name="action" value="${r.isVisible ? 'hide' : 'show'}">
                                                    <c:set var="reviewBtnText">
                                                        <c:choose>
                                                            <c:when test="${r.isVisible}"><fmt:message key="admin.reviews.btn.hide" /></c:when>
                                                            <c:otherwise><fmt:message key="admin.reviews.btn.approve" /></c:otherwise>
                                                        </c:choose>
                                                    </c:set>
                                                    <button class="btn btn-sm ${r.isVisible ? 'btn-outline-secondary' : 'btn-outline-success'}">${reviewBtnText}</button>
                                                </form>
                                            </td>
                                        </c:if>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty reviews}">
                                    <tr><td colspan="${sessionScope.currentUser.role == 'ADMIN' ? 6 : 5}" class="text-center text-muted py-5"><fmt:message key="admin.reviews.empty" /></td></tr>
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
