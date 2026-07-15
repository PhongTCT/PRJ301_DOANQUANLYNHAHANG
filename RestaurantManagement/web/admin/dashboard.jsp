<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setLocale value="${sessionScope.lang == 'vi' ? 'vi_VN' : 'en_US'}" />
<fmt:setBundle basename="i18n.messages" />
<!DOCTYPE html>
<html lang="${sessionScope.lang == 'en' ? 'en' : 'vi'}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="admin.dashboard.title" /> - Le Royal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant Garamond&family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/admin-royal.css" rel="stylesheet">
</head>
<body class="admin-royal">
<div class="d-flex">
    <jsp:include page="/admin/sidebar.jsp">
        <jsp:param name="active" value="dashboard"/>
    </jsp:include>

    <main class="flex-grow-1">
        <div class="admin-shell">

            <section id="adminWorkspace" class="admin-workspace-panel d-none mb-4">
                <div class="admin-workspace-panel__header">
                    <div>
                        <div class="admin-section-label"><fmt:message key="admin.dashboard.workspace" /></div>
                        <h2 id="adminWorkspaceTitle" class="h4 mb-0"><fmt:message key="admin.dashboard.workspace.title" /></h2>
                    </div>
                    <div class="d-flex gap-2">
                        <button class="btn btn-sm btn-outline-secondary" id="adminWorkspaceClose" type="button">
                            <i class="fa-solid fa-xmark me-1"></i><fmt:message key="admin.dashboard.close" />
                        </button>
                        <a id="adminWorkspaceOpen" class="btn btn-sm btn-outline-secondary" href="#" target="_blank" rel="noopener">
                            <i class="fa-solid fa-arrow-up-right-from-square me-1"></i><fmt:message key="admin.dashboard.open" />
                        </a>
                    </div>
                </div>
                <iframe id="adminWorkspaceFrame" class="admin-workspace-frame" title="<fmt:message key="admin.dashboard.workspace.aria" />"></iframe>
            </section>

            <div id="dashboardHome">
                <div class="row g-3 mb-4">
                    <div class="col-md-3">
                        <div class="metric h-100">
                            <div class="admin-section-label"><fmt:message key="admin.dashboard.paid.revenue" /></div>
                            <div class="fs-4 fw-bold"><fmt:formatNumber value="${summary[0]}" pattern="#,##0"/>d</div>
                            <div class="text-muted small mt-2"><fmt:message key="admin.dashboard.paid.revenue.desc" /></div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="metric h-100">
                            <div class="admin-section-label"><fmt:message key="admin.dashboard.topup.revenue" /></div>
                            <div class="fs-4 fw-bold"><fmt:formatNumber value="${topUpSummary[0]}" pattern="#,##0"/>d</div>
                            <div class="text-muted small mt-2">${topUpSummary[1]} <fmt:message key="admin.dashboard.topup.revenue.desc" /></div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="metric h-100">
                            <div class="admin-section-label"><fmt:message key="admin.dashboard.today.bookings" /></div>
                            <div class="fs-4 fw-bold">${todayReservations}</div>
                            <div class="text-muted small mt-2"><fmt:message key="admin.dashboard.today.bookings.desc" /></div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="metric h-100">
                            <div class="admin-section-label"><fmt:message key="admin.dashboard.attention" /></div>
                            <div class="fs-4 fw-bold">${noShowCandidates}</div>
                            <div class="text-muted small mt-2"><fmt:message key="admin.dashboard.attention.desc" /></div>
                        </div>
                    </div>
                </div>

                <c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
                    <section class="card mb-4">
                        <div class="card-body p-4">
                            <div class="admin-section-header">
                                <div>
                                    <div class="admin-section-label"><fmt:message key="admin.dashboard.setup" /></div>
                                    <h2 class="h4 mb-0"><fmt:message key="admin.dashboard.setup.desc" /></h2>
                                </div>
                            </div>
                            <div class="row g-3">
                                <div class="col-sm-6 col-xl-3">
                                    <a class="admin-action-tile" href="${pageContext.request.contextPath}/MainController?action=adminMenuItems">
                                        <span class="admin-action-icon"><i class="fa-solid fa-bowl-food"></i></span>
                                        <span><strong><fmt:message key="admin.dashboard.menuitems.title" /></strong><small><fmt:message key="admin.dashboard.menuitems.desc" /></small></span>
                                    </a>
                                </div>
                                <div class="col-sm-6 col-xl-3">
                                    <a class="admin-action-tile" href="${pageContext.request.contextPath}/MainController?action=adminMenuSets">
                                        <span class="admin-action-icon"><i class="fa-solid fa-layer-group"></i></span>
                                        <span><strong><fmt:message key="admin.dashboard.menusets.title" /></strong><small><fmt:message key="admin.dashboard.menusets.desc" /></small></span>
                                    </a>
                                </div>
                                <div class="col-sm-6 col-xl-3">
                                    <a class="admin-action-tile" href="${pageContext.request.contextPath}/MainController?action=adminTables">
                                        <span class="admin-action-icon"><i class="fa-solid fa-chair"></i></span>
                                        <span><strong><fmt:message key="admin.dashboard.tables.title" /></strong><small><fmt:message key="admin.dashboard.tables.desc" /></small></span>
                                    </a>
                                </div>
                                <div class="col-sm-6 col-xl-3">
                                    <a class="admin-action-tile" href="${pageContext.request.contextPath}/MainController?action=adminAddonServices">
                                        <span class="admin-action-icon"><i class="fa-solid fa-music"></i></span>
                                        <span><strong><fmt:message key="admin.dashboard.addons.title" /></strong><small><fmt:message key="admin.dashboard.addons.desc" /></small></span>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </section>
                </c:if>

                <div class="row g-4">
                    <div class="col-xl-8">
                        <section class="card h-100">
                            <div class="card-body p-4">
                                <div class="admin-section-header">
                                    <div>
                                        <div class="admin-section-label"><fmt:message key="admin.dashboard.workqueue" /></div>
                                        <h2 class="h4 mb-0"><fmt:message key="admin.dashboard.workqueue.desc" /></h2>
                                    </div>
                                    <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/"><i class="fa-solid fa-arrow-left me-1"></i><fmt:message key="admin.dashboard.backtosite" /></a>
                                </div>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <a class="admin-action-tile" href="${pageContext.request.contextPath}/admin/walkin">
                                            <span class="admin-action-icon"><i class="fa-solid fa-cash-register"></i></span>
                                            <span><strong><fmt:message key="admin.dashboard.walkin.title" /></strong><small><fmt:message key="admin.dashboard.walkin.desc" /></small></span>
                                        </a>
                                    </div>
                                    <div class="col-md-6">
                                        <a class="admin-action-tile" href="${pageContext.request.contextPath}/admin/timeline">
                                            <span class="admin-action-icon"><i class="fa-solid fa-timeline"></i></span>
                                            <span><strong><fmt:message key="admin.dashboard.timeline.title" /></strong><small><fmt:message key="admin.dashboard.timeline.desc" /></small></span>
                                        </a>
                                    </div>
                                    <div class="col-md-6">
                                        <a class="admin-action-tile" href="${pageContext.request.contextPath}/admin/invoices">
                                            <span class="admin-action-icon"><i class="fa-solid fa-file-invoice"></i></span>
                                            <span><strong><fmt:message key="admin.dashboard.invoices.title" /></strong><small><fmt:message key="admin.dashboard.invoices.desc" /></small></span>
                                        </a>
                                    </div>
                                    <c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
                                        <div class="col-md-6">
                                            <a class="admin-action-tile" href="${pageContext.request.contextPath}/MainController?action=adminMenuSets">
                                                <span class="admin-action-icon"><i class="fa-solid fa-utensils"></i></span>
                                                <span><strong><fmt:message key="admin.dashboard.label.menusets" /></strong><small><fmt:message key="admin.dashboard.menusets.desc" /></small></span>
                                            </a>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </section>
                    </div>

                    <div class="col-xl-4">
                        <section class="card h-100">
                            <div class="card-body p-4">
                                <div class="admin-section-label"><fmt:message key="admin.dashboard.management" /></div>
                                <h2 class="h4 mb-3"><fmt:message key="admin.dashboard.management.desc" /></h2>
                                <div class="list-group list-group-flush admin-link-list">
                                    <a class="list-group-item" href="${pageContext.request.contextPath}/admin/users"><i class="fa-solid fa-users"></i><span><fmt:message key="admin.dashboard.users" /></span></a>
                                    <a class="list-group-item" href="${pageContext.request.contextPath}/admin/vouchers"><i class="fa-solid fa-ticket"></i><span><fmt:message key="admin.dashboard.vouchers" /></span></a>
                                    <a class="list-group-item" href="${pageContext.request.contextPath}/admin/reviews"><i class="fa-solid fa-star-half-stroke"></i><span><fmt:message key="admin.dashboard.reviews" /></span></a>
                                    <c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
                                        <a class="list-group-item" href="${pageContext.request.contextPath}/MainController?action=adminTables"><i class="fa-solid fa-chair"></i><span><fmt:message key="admin.dashboard.label.tables" /></span></a>
                                        <a class="list-group-item" href="${pageContext.request.contextPath}/admin/surcharges"><i class="fa-solid fa-calendar-day"></i><span><fmt:message key="admin.dashboard.holidays" /></span></a>
                                        <a class="list-group-item" href="${pageContext.request.contextPath}/admin/rank-config"><i class="fa-solid fa-ranking-star"></i><span><fmt:message key="admin.dashboard.rankconfig" /></span></a>
                                    </c:if>
                                </div>
                            </div>
                        </section>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
(function () {
    var workspace = document.getElementById('adminWorkspace');
    var frame = document.getElementById('adminWorkspaceFrame');
    var title = document.getElementById('adminWorkspaceTitle');
    var openLink = document.getElementById('adminWorkspaceOpen');
    var closeBtn = document.getElementById('adminWorkspaceClose');
    var dashboardHome = document.getElementById('dashboardHome');
    if (!workspace || !frame) return;

    var labels = {
        'menu-items': '<fmt:message key="admin.dashboard.label.menuitems"/>',
        'menu-sets': '<fmt:message key="admin.dashboard.label.menusets"/>',
        'categories': '<fmt:message key="admin.dashboard.label.categories"/>',
        'tables': '<fmt:message key="admin.dashboard.label.tables"/>',
        'addon-services': '<fmt:message key="admin.dashboard.label.addons"/>',
        'areas': '<fmt:message key="admin.dashboard.label.areas"/>'
    };

    function setActive(key) {
        document.querySelectorAll('[data-workspace]').forEach(function (link) {
            link.classList.toggle('active', link.getAttribute('data-workspace') === key);
        });
    }

    function openWorkspace(key, url, pushState) {
        if (!url) return;
        workspace.classList.remove('d-none');
        if (dashboardHome) dashboardHome.classList.add('d-none');
        frame.src = url;
        if (title) title.textContent = labels[key] || '<fmt:message key="admin.dashboard.workspace.title"/>';
        if (openLink) openLink.href = url.replace(/[?&]embed=1/, '');
        setActive(key);
        if (pushState && window.history) {
            window.history.replaceState(null, '', '${pageContext.request.contextPath}/admin/?workspace=' + encodeURIComponent(key));
        }
        workspace.scrollIntoView({behavior: 'smooth', block: 'start'});
    }

    function closeWorkspace() {
        workspace.classList.add('d-none');
        if (dashboardHome) dashboardHome.classList.remove('d-none');
        frame.src = '';
        if (window.history) {
            window.history.replaceState(null, '', '${pageContext.request.contextPath}/admin/');
        }
        document.querySelectorAll('[data-workspace]').forEach(function (link) {
            link.classList.remove('active');
        });
    }

    if (closeBtn) {
        closeBtn.addEventListener('click', closeWorkspace);
    }

    document.querySelectorAll('[data-workspace-url]').forEach(function (link) {
        link.addEventListener('click', function (event) {
            event.preventDefault();
            openWorkspace(link.getAttribute('data-workspace'), link.getAttribute('data-workspace-url'), true);
        });
    });

    var current = new URLSearchParams(window.location.search).get('workspace');
    if (current) {
        var initial = document.querySelector('[data-workspace="' + current + '"][data-workspace-url]');
        if (initial) {
            openWorkspace(current, initial.getAttribute('data-workspace-url'), false);
        }
    }
})();
</script>
</body>
</html>
