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
    <link rel="stylesheet" href="assets/css/minimal.css">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom shadow-sm sticky-top">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center gap-3" href="MainController?action=home">
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
                <li class="nav-item"><a class="nav-link" href="MainController?action=home">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="MainController?action=menu">Menu</a></li>
                <li class="nav-item"><a class="nav-link" href="MainController?action=booking">Booking</a></li>
            </ul>
            <div class="d-flex align-items-center flex-wrap gap-2">
                <div class="btn-group lang-switch" role="group" aria-label="Language switcher">
                    <a href="MainController?action=${not empty param.action ? param.action : 'home'}&lang=vi" class="btn btn-sm ${sessionScope.lang == 'vi' ? 'btn-dark' : 'btn-outline-secondary'}">VI</a>
                    <a href="MainController?action=${not empty param.action ? param.action : 'home'}&lang=en" class="btn btn-sm ${sessionScope.lang == 'en' ? 'btn-dark' : 'btn-outline-secondary'}">EN</a>
                </div>
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser}">
                        <span class="small text-secondary me-2"><i class="fa-regular fa-user me-1"></i>${sessionScope.currentUser.fullName}</span>
                        <c:if test="${sessionScope.currentUser.role == 'ADMIN' or sessionScope.currentUser.role == 'STAFF'}">
                            <a href="${pageContext.request.contextPath}/admin/surcharges" class="btn btn-outline-primary btn-sm px-3 me-2"><i class="fa-solid fa-gauge me-1"></i> Dashboard</a>
                        </c:if>
                        <a href="MainController?action=logout" class="btn btn-outline-secondary btn-sm px-3">Logout</a>
                    </c:when>
                    <c:otherwise>
                        <a href="MainController?action=login" class="btn btn-dark btn-sm px-4">Login</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>
