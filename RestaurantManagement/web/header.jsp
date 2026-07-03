<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:if test="${not empty param.lang}">
    <c:set var="lang" value="${param.lang}" scope="session" />
</c:if>
<c:if test="${empty sessionScope.lang}">
    <c:set var="lang" value="vi" scope="session" />
</c:if>
<fmt:setLocale value="${sessionScope.lang}" scope="session" />
<fmt:setBundle basename="i18n.messages" scope="session" />
<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Le Royal - Contemporary Fine Dining</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@400;500;600&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/minimal.css">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom shadow-sm sticky-top">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center gap-3" href="${pageContext.request.contextPath}/MainController?action=home">
            <span class="brand-emblem" aria-hidden="true">
                <svg class="brand-symbol" viewBox="0 0 64 64" focusable="false">
                    <path class="brand-symbol-l" d="M25 10V54H43" />
                    <path class="brand-symbol-r" d="M33 14C46 10 54 17 53 28C52 38 41 41 33 34" />
                    <path class="brand-symbol-r" d="M35 37C44 41 50 48 53 56" />
                </svg>
            </span>
            <span class="brand-text">Le Royal</span>
        </a>
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mx-auto gap-lg-2 py-3 py-lg-0 main-nav">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/MainController?action=home">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/MainController?action=menu">Menu</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/MainController?action=booking">Booking</a></li>
            </ul>
            <div class="d-flex align-items-center flex-wrap gap-2">
                <div class="btn-group lang-switch" role="group" aria-label="Language switcher">
                    <a href="${pageContext.request.contextPath}/MainController?action=${not empty param.action ? param.action : 'home'}&lang=vi" class="btn btn-sm ${sessionScope.lang == 'vi' ? 'btn-dark' : 'btn-outline-secondary'}">VI</a>
                    <a href="${pageContext.request.contextPath}/MainController?action=${not empty param.action ? param.action : 'home'}&lang=en" class="btn btn-sm ${sessionScope.lang == 'en' ? 'btn-dark' : 'btn-outline-secondary'}">EN</a>
                </div>
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser}">
                        <div class="dropdown d-inline-block me-2">
                            <button class="btn btn-light border btn-sm dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fa-regular fa-user me-1"></i>${sessionScope.currentUser.fullName}
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2 account-menu">
                                <c:choose>
                                    <c:when test="${sessionScope.currentUser.role == 'ADMIN' or sessionScope.currentUser.role == 'STAFF'}">
                                        <li>
                                            <a class="dropdown-item py-3 account-menu__primary" href="${pageContext.request.contextPath}/admin/quick-bill">
                                                <i class="fa-solid fa-briefcase me-2"></i>Quản lý
                                            </a>
                                        </li>
                                    </c:when>
                                    <c:otherwise>
                                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/customer/reservations"><i class="fa-solid fa-clock-rotate-left me-2 text-primary"></i>My Reservations</a></li>
                                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/customer/vouchers"><i class="fa-solid fa-ticket me-2 text-primary"></i>Voucher của tôi</a></li>
                                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/customer/reviews"><i class="fa-solid fa-star me-2 text-primary"></i>Đánh giá của tôi</a></li>
                                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/customer/invoices"><i class="fa-solid fa-file-invoice me-2 text-primary"></i>Hóa đơn của tôi</a></li>
                                    </c:otherwise>
                                </c:choose>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item py-2 text-danger" href="${pageContext.request.contextPath}/MainController?action=logout"><i class="fa-solid fa-arrow-right-from-bracket me-2"></i>Logout</a></li>
                            </ul>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/MainController?action=login" class="btn btn-dark btn-sm px-4">Login</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>
