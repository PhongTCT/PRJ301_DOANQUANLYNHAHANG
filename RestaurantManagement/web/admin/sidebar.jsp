<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<style>
    .admin-sidebar {
        width: 260px;
        min-width: 260px;
        max-width: 260px;
        min-height: 100vh;
        flex: 0 0 260px;
        background:
            radial-gradient(circle at top left, rgba(185,154,82,.16), transparent 22rem),
            #171a1d;
        color: #fff;
        padding: 18px 16px;
        border-right: 1px solid rgba(185,154,82,.22);
    }
    .admin-sidebar__brand {
        min-height: 58px;
        display: flex;
        align-items: center;
        margin: 8px 2px 26px;
        color: #fff;
        font-family: "Cormorant Garamond", Georgia, serif;
        font-size: 1.75rem;
        font-weight: 600;
        letter-spacing: .04em;
    }
    .admin-sidebar__link {
        min-height: 44px;
        color: rgba(255,255,255,.76);
        text-decoration: none;
        padding: 11px 14px;
        display: flex;
        align-items: center;
        gap: 10px;
        border: 1px solid transparent;
        border-radius: 0;
        margin-bottom: 6px;
        font-weight: 600;
        transition: background-color .22s, color .22s, border-color .22s, transform .22s;
        white-space: nowrap;
    }
    .admin-sidebar__link:hover,
    .admin-sidebar__link.active {
        background-color: rgba(255,255,255,.08);
        border-color: rgba(185,154,82,.32);
        color: #fff;
        transform: translateX(2px);
    }
    .admin-sidebar__link.active {
        background:
            linear-gradient(90deg, rgba(185,154,82,.24), rgba(255,255,255,.08));
        box-shadow: inset 2px 0 0 #b99a52;
    }
    .admin-sidebar__link i {
        width: 18px;
        text-align: center;
        color: #d5bc79;
    }
</style>

<aside class="admin-sidebar">
    <div class="admin-sidebar__brand">
        <i class="fa-solid fa-utensils me-2"></i>Le Royal
    </div>

    <a class="admin-sidebar__link ${param.active == 'walkin' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/walkin"><i class="fa-solid fa-cash-register"></i><span>Walk-in POS</span></a>
    <a class="admin-sidebar__link ${param.active == 'quick-bill' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/quick-bill"><i class="fa-solid fa-bolt"></i><span>Quick Bill</span></a>
    <a class="admin-sidebar__link ${param.active == 'reservations' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/reservations"><i class="fa-solid fa-clipboard-list"></i><span>Reservations</span></a>

    <a class="admin-sidebar__link ${param.active == 'invoices' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/invoices"><i class="fa-solid fa-file-invoice"></i><span>Invoices</span></a>
    <a class="admin-sidebar__link ${param.active == 'vouchers' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/vouchers"><i class="fa-solid fa-ticket"></i><span>Vouchers</span></a>
    <a class="admin-sidebar__link ${param.active == 'reviews' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/reviews"><i class="fa-solid fa-star-half-stroke"></i><span>Reviews</span></a>
    <a class="admin-sidebar__link ${param.active == 'reports' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/reports"><i class="fa-solid fa-chart-line"></i><span>Reports</span></a>

    <c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
        <a class="admin-sidebar__link ${param.active == 'rank-config' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/rank-config"><i class="fa-solid fa-ranking-star"></i><span>Rank Config</span></a>
        <a class="admin-sidebar__link ${param.active == 'surcharges' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/surcharges"><i class="fa-solid fa-calendar-day"></i><span>Holidays</span></a>
        <a class="admin-sidebar__link ${param.active == 'tables' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/tables"><i class="fa-solid fa-chair"></i><span>Tables</span></a>
    </c:if>

    <hr class="border-secondary">
    <a class="admin-sidebar__link" href="${pageContext.request.contextPath}/"><i class="fa-solid fa-arrow-left"></i><span>Back to Site</span></a>
</aside>
