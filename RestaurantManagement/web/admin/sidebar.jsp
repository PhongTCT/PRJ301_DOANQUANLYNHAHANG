<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<style>
    :root {
        --admin-scroll-thumb: rgba(145, 115, 55, 0.42);
        --admin-scroll-thumb-hover: rgba(145, 115, 55, 0.68);
    }
    html {
        scrollbar-gutter: stable;
    }
    body,
    body * {
        scrollbar-width: thin;
        scrollbar-color: var(--admin-scroll-thumb) transparent;
    }
    body::-webkit-scrollbar,
    body *::-webkit-scrollbar {
        width: 8px;
        height: 8px;
    }
    body::-webkit-scrollbar-track,
    body *::-webkit-scrollbar-track {
        background: transparent;
    }
    body::-webkit-scrollbar-thumb,
    body *::-webkit-scrollbar-thumb {
        min-height: 42px;
        border: 2px solid transparent;
        border-radius: 999px;
        background: var(--admin-scroll-thumb);
        background-clip: padding-box;
    }
    body::-webkit-scrollbar-thumb:hover,
    body *::-webkit-scrollbar-thumb:hover {
        background: var(--admin-scroll-thumb-hover);
        background-clip: padding-box;
    }
    body::-webkit-scrollbar-corner,
    body *::-webkit-scrollbar-corner {
        background: transparent;
    }
    .admin-sidebar {
        position: sticky;
        top: 0;
        align-self: start;
        width: 272px;
        min-width: 272px;
        max-width: 272px;
        height: 100vh;
        min-height: 100vh;
        flex: 0 0 272px;
        overflow-y: auto;
        overscroll-behavior: contain;
        background:
            linear-gradient(180deg, rgba(255, 255, 255, 0.035), transparent 16rem),
            #151512;
        color: #fff;
        padding: 24px 18px;
        border-right: 1px solid rgba(185,154,82,.18);
        scrollbar-color: rgba(213,188,121,.32) transparent;
    }
    .admin-sidebar::-webkit-scrollbar {
        width: 5px;
    }
    .admin-sidebar::-webkit-scrollbar-thumb {
        border-width: 1px;
        background: rgba(213,188,121,.28);
    }
    .admin-sidebar::-webkit-scrollbar-thumb:hover {
        background: rgba(213,188,121,.52);
    }
    .admin-sidebar__brand {
        min-height: 72px;
        display: flex;
        align-items: center;
        gap: 13px;
        margin: 2px 4px 28px;
        color: #f8f3ea;
        font-family: "Marcellus", Georgia, serif;
        font-size: 1.18rem;
        font-weight: 500;
        letter-spacing: 0.18em !important;
        text-transform: uppercase;
        text-decoration: none;
    }
    .admin-sidebar__mark {
        width: 48px;
        height: 48px;
        flex: 0 0 48px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border: 1px solid rgba(185, 154, 82, 0.32);
        background: #fbfaf7;
    }
    .admin-sidebar__mark svg {
        width: 42px;
        height: 42px;
        overflow: visible;
    }
    .admin-sidebar__mark path {
        fill: none;
        stroke-width: 1.6;
        stroke-linecap: round;
        stroke-linejoin: round;
        vector-effect: non-scaling-stroke;
    }
    .admin-sidebar__mark .brand-symbol-l {
        stroke: #111111;
    }
    .admin-sidebar__mark .brand-symbol-r {
        stroke: #b99a52;
        stroke-width: 1.9;
    }
    .admin-sidebar__brand-text {
        display: block;
        line-height: 1;
    }
    .admin-sidebar__brand-text small {
        display: block;
        margin-top: 8px;
        font-family: "Manrope", Arial, sans-serif;
        font-size: 0.62rem;
        font-weight: 700;
        letter-spacing: 0.18em !important;
        text-transform: uppercase;
        color: rgba(213, 188, 121, 0.72);
    }
    .admin-sidebar__link {
        position: relative;
        min-height: 46px;
        color: rgba(248, 243, 234, 0.72);
        text-decoration: none;
        padding: 11px 14px 11px 12px;
        display: flex;
        align-items: center;
        gap: 12px;
        border: 0;
        border-radius: 0;
        margin-bottom: 3px;
        font-weight: 500;
        transition: background-color .22s, color .22s, transform .22s;
        white-space: nowrap;
    }
    .admin-sidebar__link:hover,
    .admin-sidebar__link.active {
        background-color: rgba(255, 255, 255, 0.055);
        color: #f8f3ea;
    }
    .admin-sidebar__link.active {
        background: linear-gradient(90deg, rgba(185,154,82,.16), rgba(255,255,255,.045));
        color: #fff;
    }
    .admin-sidebar__link.active::before {
        content: "";
        position: absolute;
        left: 0;
        top: 11px;
        bottom: 11px;
        width: 2px;
        background: #b99a52;
    }
    .admin-sidebar__link i {
        width: 22px;
        text-align: center;
        color: rgba(213, 188, 121, 0.78);
        font-size: 0.92rem;
    }
    .admin-sidebar__link span {
        font-size: 0.88rem;
        letter-spacing: 0.02em;
    }
    .admin-sidebar__section {
        margin: 18px 12px 9px;
        color: rgba(213, 188, 121, 0.58);
        font-size: 0.64rem;
        font-weight: 800;
        letter-spacing: 0.16em;
        text-transform: uppercase;
    }
    .admin-sidebar__divider {
        margin: 18px 10px;
        border-color: rgba(255,255,255,.09);
    }
</style>

<aside class="admin-sidebar">
    <a class="admin-sidebar__brand" href="${pageContext.request.contextPath}/admin/">
        <span class="admin-sidebar__mark" aria-hidden="true">
            <svg viewBox="0 0 64 64" focusable="false">
                <path class="brand-symbol-l" d="M25 10V54H43" />
                <path class="brand-symbol-r" d="M33 14C46 10 54 17 53 28C52 38 41 41 33 34" />
                <path class="brand-symbol-r" d="M35 37C44 41 50 48 53 56" />
            </svg>
        </span>
        <span class="admin-sidebar__brand-text">Le Royal<small>Admin</small></span>
    </a>

    <div class="admin-sidebar__section"><fmt:message key="admin.sidebar.service"/></div>
    <a class="admin-sidebar__link ${param.active == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/"><i class="fa-solid fa-gauge-high"></i><span><fmt:message key="admin.sidebar.dashboard"/></span></a>
    <a class="admin-sidebar__link ${param.active == 'walkin' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/walkin"><i class="fa-solid fa-cash-register"></i><span><fmt:message key="admin.sidebar.walkin"/></span></a>
    <a class="admin-sidebar__link ${param.active == 'quick-bill' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/quick-bill"><i class="fa-solid fa-bolt"></i><span><fmt:message key="admin.sidebar.quickbill"/></span></a>
    <a class="admin-sidebar__link ${param.active == 'reservations' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/reservations"><i class="fa-solid fa-clipboard-list"></i><span><fmt:message key="admin.sidebar.reservations"/></span></a>
    <a class="admin-sidebar__link ${param.active == 'timeline' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/timeline"><i class="fa-solid fa-timeline"></i><span><fmt:message key="admin.sidebar.timeline"/></span></a>

    <c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
        <div class="admin-sidebar__section"><fmt:message key="admin.sidebar.restaurant"/></div>
        <a class="admin-sidebar__link ${param.active == 'menu-items' ? 'active' : ''}" href="${pageContext.request.contextPath}/MainController?action=adminMenuItems"><i class="fa-solid fa-bowl-food"></i><span><fmt:message key="admin.sidebar.menuitems"/></span></a>
        <a class="admin-sidebar__link ${param.active == 'menu-sets' ? 'active' : ''}" href="${pageContext.request.contextPath}/MainController?action=adminMenuSets"><i class="fa-solid fa-layer-group"></i><span><fmt:message key="admin.sidebar.menusets"/></span></a>
        <a class="admin-sidebar__link ${param.active == 'tables' ? 'active' : ''}" href="${pageContext.request.contextPath}/MainController?action=adminTables"><i class="fa-solid fa-chair"></i><span><fmt:message key="admin.sidebar.tables"/></span></a>
        <a class="admin-sidebar__link ${param.active == 'addon-services' ? 'active' : ''}" href="${pageContext.request.contextPath}/MainController?action=adminAddonServices"><i class="fa-solid fa-music"></i><span><fmt:message key="admin.sidebar.addons"/></span></a>
    </c:if>

    <div class="admin-sidebar__section"><fmt:message key="admin.sidebar.office"/></div>
    <a class="admin-sidebar__link ${param.active == 'invoices' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/invoices"><i class="fa-solid fa-file-invoice"></i><span><fmt:message key="admin.sidebar.invoices"/></span></a>
    <a class="admin-sidebar__link ${param.active == 'vouchers' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/vouchers"><i class="fa-solid fa-ticket"></i><span><fmt:message key="admin.sidebar.vouchers"/></span></a>
    <a class="admin-sidebar__link ${param.active == 'reviews' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/reviews"><i class="fa-solid fa-star-half-stroke"></i><span><fmt:message key="admin.sidebar.reviews"/></span></a>
    <a class="admin-sidebar__link ${param.active == 'reports' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/reports"><i class="fa-solid fa-chart-line"></i><span><fmt:message key="admin.sidebar.reports"/></span></a>
    <a class="admin-sidebar__link ${param.active == 'users' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/users"><i class="fa-solid fa-users"></i><span><fmt:message key="admin.sidebar.users"/></span></a>

    <c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
        <div class="admin-sidebar__section"><fmt:message key="admin.sidebar.admin"/></div>
        <a class="admin-sidebar__link ${param.active == 'rank-config' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/rank-config"><i class="fa-solid fa-ranking-star"></i><span><fmt:message key="admin.sidebar.rankconfig"/></span></a>
        <a class="admin-sidebar__link ${param.active == 'surcharges' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/surcharges"><i class="fa-solid fa-calendar-day"></i><span><fmt:message key="admin.sidebar.holidays"/></span></a>
            </c:if>

    <hr class="admin-sidebar__divider">
    <a class="admin-sidebar__link" href="${pageContext.request.contextPath}/"><i class="fa-solid fa-arrow-left"></i><span><fmt:message key="admin.sidebar.back"/></span></a>
</aside>
