<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Le Royal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Marcellus&family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/admin-royal.css" rel="stylesheet">
</head>
<body class="admin-royal">
<div class="d-flex">
    <jsp:include page="/admin/sidebar.jsp">
        <jsp:param name="active" value="dashboard"/>
    </jsp:include>

    <main class="flex-grow-1">
        <div class="admin-shell">
            <section id="adminWorkspace" class="card mb-4 d-none">
                <div class="card-body p-0">
                    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 p-3 border-bottom">
                        <div>
                            <div class="admin-section-label">Workspace</div>
                            <h2 id="adminWorkspaceTitle" class="h4 mb-0">Restaurant admin</h2>
                        </div>
                        <div class="d-flex gap-2">
                            <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/admin/">Dashboard</a>
                            <a id="adminWorkspaceOpen" class="btn btn-sm btn-outline-secondary" href="#" target="_blank" rel="noopener">Open full page</a>
                        </div>
                    </div>
                    <iframe id="adminWorkspaceFrame" class="admin-workspace-frame" title="Restaurant admin workspace"></iframe>
                </div>
            </section>

            <div id="dashboardHome">
            <section class="admin-dashboard-hero mb-4">
                <div class="admin-dashboard-hero__content">
                    <div class="admin-kicker">Le Royal operations</div>
                    <h1 class="admin-title">Admin Dashboard</h1>
                    <p class="admin-copy mb-4">Quáº£n lÃ½ Ä‘áº·t bÃ n, hÃ³a Ä‘Æ¡n, khÃ¡ch hÃ ng vÃ  tráº£i nghiá»‡m nhÃ  hÃ ng tá»« má»™t mÃ n hÃ¬nh gá»n hÆ¡n.</p>
                    <div class="d-flex flex-wrap gap-2">
                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/quick-bill">
                            <i class="fa-solid fa-bolt me-2"></i>Quick Bill
                        </a>
                        <a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/admin/reservations">
                            <i class="fa-solid fa-clipboard-list me-2"></i>Reservations
                        </a>
                        <a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/admin/reports">
                            <i class="fa-solid fa-chart-line me-2"></i>Reports
                        </a>
                    </div>
                </div>
                <div class="admin-dashboard-hero__media" aria-hidden="true">
                    <img src="${pageContext.request.contextPath}/assets/img/le-royal/Grand Degustation Set.webp" alt="">
                </div>
            </section>

            <div class="row g-3 mb-4">
                <div class="col-md-4">
                    <div class="metric h-100">
                        <div class="admin-section-label">Paid revenue</div>
                        <div class="fs-4 fw-bold"><fmt:formatNumber value="${summary[0]}" pattern="#,##0"/>Ä‘</div>
                        <div class="text-muted small mt-2">Tá»•ng doanh thu tá»« hÃ³a Ä‘Æ¡n Ä‘Ã£ thanh toÃ¡n.</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="metric h-100">
                        <div class="admin-section-label">Today's bookings</div>
                        <div class="fs-4 fw-bold">${todayReservations}</div>
                        <div class="text-muted small mt-2">Sá»‘ reservation trong ngÃ y hÃ´m nay.</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="metric h-100">
                        <div class="admin-section-label">Need attention</div>
                        <div class="fs-4 fw-bold">${noShowCandidates}</div>
                        <div class="text-muted small mt-2">Booking cÃ³ thá»ƒ cáº§n kiá»ƒm tra no-show.</div>
                    </div>
                </div>
            </div>

            <section class="card mb-4">
                <div class="card-body p-4">
                    <div class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-3">
                        <div>
                            <div class="admin-section-label">Restaurant setup</div>
                            <h2 class="h4 mb-0">Quáº£n lÃ½ mÃ³n, menu, bÃ n vÃ  dá»‹ch vá»¥ thÃªm</h2>
                        </div>
                        <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/admin/?workspace=areas" data-workspace="areas" data-workspace-url="${pageContext.request.contextPath}/MainController?action=adminAreas&embed=1">Restaurant admin</a>
                    </div>
                    <div class="row g-3">
                        <div class="col-sm-6 col-xl-3">
                            <a class="admin-action-tile" href="${pageContext.request.contextPath}/admin/?workspace=menu-items" data-workspace="menu-items" data-workspace-url="${pageContext.request.contextPath}/MainController?action=adminMenuItems&embed=1">
                                <span class="admin-action-icon"><i class="fa-solid fa-bowl-food"></i></span>
                                <span><strong>Menu items</strong><small>ThÃªm, sá»­a, áº©n hoáº·c hiá»‡n mÃ³n Äƒn.</small></span>
                            </a>
                        </div>
                        <div class="col-sm-6 col-xl-3">
                            <a class="admin-action-tile" href="${pageContext.request.contextPath}/admin/?workspace=menu-sets" data-workspace="menu-sets" data-workspace-url="${pageContext.request.contextPath}/MainController?action=adminMenuSets&embed=1">
                                <span class="admin-action-icon"><i class="fa-solid fa-layer-group"></i></span>
                                <span><strong>Set menus</strong><small>XÃ¢y tasting menu theo course.</small></span>
                            </a>
                        </div>
                        <div class="col-sm-6 col-xl-3">
                            <a class="admin-action-tile" href="${pageContext.request.contextPath}/admin/?workspace=tables" data-workspace="tables" data-workspace-url="${pageContext.request.contextPath}/MainController?action=adminTables&embed=1">
                                <span class="admin-action-icon"><i class="fa-solid fa-chair"></i></span>
                                <span><strong>Dining tables</strong><small>Quáº£n lÃ½ bÃ n, áº£nh vÃ  tráº¡ng thÃ¡i.</small></span>
                            </a>
                        </div>
                        <div class="col-sm-6 col-xl-3">
                            <a class="admin-action-tile" href="${pageContext.request.contextPath}/admin/?workspace=addon-services" data-workspace="addon-services" data-workspace-url="${pageContext.request.contextPath}/MainController?action=adminAddonServices&embed=1">
                                <span class="admin-action-icon"><i class="fa-solid fa-music"></i></span>
                                <span><strong>Add-on services</strong><small>Hoa, Ä‘Ã n hÃ¡t vÃ  dá»‹ch vá»¥ Ä‘áº·t thÃªm.</small></span>
                            </a>
                        </div>
                    </div>
                </div>
            </section>

            <div class="row g-4">
                <div class="col-xl-8">
                    <section class="card h-100">
                        <div class="card-body p-4">
                            <div class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-3">
                                <div>
                                    <div class="admin-section-label">Work queue</div>
                                    <h2 class="h4 mb-0">Thao tÃ¡c thÆ°á»ng dÃ¹ng</h2>
                                </div>
                                <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/">Back to site</a>
                            </div>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <a class="admin-action-tile" href="${pageContext.request.contextPath}/admin/walkin">
                                        <span class="admin-action-icon"><i class="fa-solid fa-cash-register"></i></span>
                                        <span><strong>Walk-in POS</strong><small>Táº¡o bÃ n má»›i vÃ  nháº­n khÃ¡ch táº¡i quáº§y.</small></span>
                                    </a>
                                </div>
                                <div class="col-md-6">
                                    <a class="admin-action-tile" href="${pageContext.request.contextPath}/admin/timeline">
                                        <span class="admin-action-icon"><i class="fa-solid fa-timeline"></i></span>
                                        <span><strong>Timeline</strong><small>Theo dÃµi lá»‹ch phá»¥c vá»¥ theo khung giá».</small></span>
                                    </a>
                                </div>
                                <div class="col-md-6">
                                    <a class="admin-action-tile" href="${pageContext.request.contextPath}/admin/invoices">
                                        <span class="admin-action-icon"><i class="fa-solid fa-file-invoice"></i></span>
                                        <span><strong>Invoices</strong><small>Tra cá»©u hÃ³a Ä‘Æ¡n, tráº¡ng thÃ¡i thanh toÃ¡n.</small></span>
                                    </a>
                                </div>
                                <div class="col-md-6">
                                    <a class="admin-action-tile" href="${pageContext.request.contextPath}/admin/?workspace=menu-sets" data-workspace="menu-sets" data-workspace-url="${pageContext.request.contextPath}/MainController?action=adminMenuSets&embed=1">
                                        <span class="admin-action-icon"><i class="fa-solid fa-utensils"></i></span>
                                        <span><strong>Menu sets</strong><small>XÃ¢y tasting menu theo course.</small></span>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </section>
                </div>

                <div class="col-xl-4">
                    <section class="card h-100">
                        <div class="card-body p-4">
                            <div class="admin-section-label">Management</div>
                            <h2 class="h4 mb-3">Quáº£n trá»‹ nhanh</h2>
                            <div class="list-group list-group-flush admin-link-list">
                                <a class="list-group-item" href="${pageContext.request.contextPath}/admin/users"><i class="fa-solid fa-users"></i><span>Users</span></a>
                                <a class="list-group-item" href="${pageContext.request.contextPath}/admin/vouchers"><i class="fa-solid fa-ticket"></i><span>Vouchers</span></a>
                                <a class="list-group-item" href="${pageContext.request.contextPath}/admin/reviews"><i class="fa-solid fa-star-half-stroke"></i><span>Reviews</span></a>
                                <c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
                                    <a class="list-group-item" href="${pageContext.request.contextPath}/admin/?workspace=tables" data-workspace="tables" data-workspace-url="${pageContext.request.contextPath}/MainController?action=adminTables&embed=1"><i class="fa-solid fa-chair"></i><span>Tables</span></a>
                                    <a class="list-group-item" href="${pageContext.request.contextPath}/admin/surcharges"><i class="fa-solid fa-calendar-day"></i><span>Holidays</span></a>
                                    <a class="list-group-item" href="${pageContext.request.contextPath}/admin/rank-config"><i class="fa-solid fa-ranking-star"></i><span>Rank Config</span></a>
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
        var dashboardHome = document.getElementById('dashboardHome');
        if (!workspace || !frame) {
            return;
        }

        var labels = {
            'menu-items': 'Menu items',
            'menu-sets': 'Set menus',
            'categories': 'Categories',
            'tables': 'Dining tables',
            'addon-services': 'Add-on services',
            'areas': 'Areas & rooms'
        };

        function setActive(key) {
            document.querySelectorAll('[data-workspace]').forEach(function (link) {
                link.classList.toggle('active', link.getAttribute('data-workspace') === key);
            });
        }

        function openWorkspace(key, url, pushState) {
            if (!url) {
                return;
            }
            workspace.classList.remove('d-none');
            if (dashboardHome) {
                dashboardHome.classList.add('d-none');
            }
            frame.src = url;
            if (title) {
                title.textContent = labels[key] || 'Restaurant admin';
            }
            if (openLink) {
                openLink.href = url.replace(/[?&]embed=1/, '');
            }
            setActive(key);
            if (pushState && window.history) {
                window.history.replaceState(null, '', '${pageContext.request.contextPath}/admin/?workspace=' + encodeURIComponent(key));
            }
            workspace.scrollIntoView({behavior: 'smooth', block: 'start'});
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
