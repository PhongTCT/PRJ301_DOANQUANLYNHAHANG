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
    <title><fmt:message key="admin.reports.title.sub"/> - Le Royal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Marcellus&family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/admin-royal.css" rel="stylesheet">
</head>
<body class="admin-royal">
<div class="d-flex">
    <jsp:include page="/admin/sidebar.jsp">
        <jsp:param name="active" value="reports"/>
    </jsp:include>

    <main class="flex-grow-1">
        <div class="admin-shell">
            <section class="admin-hero">
                <div>
                    <div class="admin-kicker"><fmt:message key="admin.reports.title"/></div>
                    <h1 class="admin-title"><fmt:message key="admin.reports.title.sub"/></h1>
                    <p class="admin-copy mb-0"><fmt:message key="admin.reports.desc"/></p>
                </div>
                <form method="get" class="d-flex gap-2 flex-wrap">
                    <input type="date" name="from" value="${fromValue}" class="form-control">
                    <input type="date" name="to" value="${toValue}" class="form-control">
                    <button class="btn btn-primary"><i class="fa-solid fa-filter me-2"></i><fmt:message key="admin.reports.filter"/></button>
                </form>
            </section>

            <div class="row g-3 mb-4">
                <div class="col-md-3"><div class="metric"><div class="admin-section-label"><fmt:message key="admin.reports.revenue"/></div><div class="fs-4 fw-bold"><fmt:formatNumber value="${summary[0]}" pattern="#,##0"/>d</div></div></div>
                <div class="col-md-3"><div class="metric"><div class="admin-section-label"><fmt:message key="admin.reports.invoicecount"/></div><div class="fs-4 fw-bold">${summary[1]}</div></div></div>
                <div class="col-md-3"><div class="metric"><div class="admin-section-label"><fmt:message key="admin.reports.voucherdiscount"/></div><div class="fs-4 fw-bold"><fmt:formatNumber value="${summary[2]}" pattern="#,##0"/>d</div></div></div>
                <div class="col-md-3"><div class="metric"><div class="admin-section-label"><fmt:message key="admin.reports.pointsdiscount"/></div><div class="fs-4 fw-bold"><fmt:formatNumber value="${summary[3]}" pattern="#,##0"/>d</div></div></div>
            </div>

            <div class="card mb-4">
                <div class="card-body p-4">
                    <canvas id="revenueChart" height="110"></canvas>
                </div>
            </div>

            <section class="card">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table align-middle">
                            <thead>
                                <tr><th class="ps-4"><fmt:message key="admin.reports.col.date"/></th><th><fmt:message key="admin.reports.col.revenue"/></th><th><fmt:message key="admin.reports.invoicecount"/></th></tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${revenueRows}" var="r">
                                    <tr>
                                        <td class="ps-4 fw-semibold">${r[0]}</td>
                                        <td class="fw-bold"><fmt:formatNumber value="${r[1]}" pattern="#,##0"/>d</td>
                                        <td>${r[2]}</td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty revenueRows}">
                                    <tr><td colspan="3" class="text-center text-muted py-5"><fmt:message key="admin.reports.empty"/></td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
const labels = [<c:forEach items="${revenueRows}" var="r" varStatus="s">'${r[0]}'${s.last ? '' : ','}</c:forEach>];
const values = [<c:forEach items="${revenueRows}" var="r" varStatus="s">${r[1]}${s.last ? '' : ','}</c:forEach>];
new Chart(document.getElementById('revenueChart'), {
    type: 'bar',
    data: { labels: labels, datasets: [{ label: '<fmt:message key="admin.reports.chart"/>', data: values, backgroundColor: '#b99a52' }] },
    options: { responsive: true, plugins: { legend: { display: false } }, scales: { y: { ticks: { callback: v => new Intl.NumberFormat('vi-VN').format(v) + 'd' } } } }
});
</script>
</body>
</html>
