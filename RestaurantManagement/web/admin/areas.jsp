<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setLocale value="${sessionScope.lang == 'en' ? 'en_US' : 'vi_VN'}" />
<fmt:setBundle basename="i18n.messages" />
<c:set var="isEn" value="${sessionScope.lang == 'en'}" />
<fmt:message key="admin.areas.preview.default.name" var="defaultAreaName" />
<fmt:message key="admin.areas.preview.default.desc" var="defaultAreaDesc" />
<fmt:message key="admin.common.available" var="availableText" />
<fmt:message key="admin.common.hidden" var="hiddenText" />
<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="admin.areas.title" /> - Le Royal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Marcellus&family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-royal.css">
</head>
<body class="admin-royal">
<div class="d-flex">
    <jsp:include page="/admin/sidebar.jsp">
        <jsp:param name="active" value="areas"/>
    </jsp:include>
    <main class="flex-grow-1">
        <div class="admin-shell">
            <div class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-4">
                <div>
                    <p class="text-uppercase text-secondary small mb-1"><fmt:message key="admin.dashboard.workspace.title" /></p>
                    <h1 class="h3 mb-1"><fmt:message key="admin.areas.title" /></h1>
                    <p class="text-secondary mb-0"><fmt:message key="admin.areas.subtitle" /></p>
                </div>
                <div class="d-flex flex-wrap gap-2">
                    <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminRooms">
                        <i class="fa-solid fa-door-open me-2"></i><fmt:message key="admin.rooms.title" />
                    </a>
                    <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminTables">
                        <i class="fa-solid fa-chair me-2"></i><fmt:message key="admin.sidebar.tables" />
                    </a>
                    <button class="btn btn-dark btn-sm" type="button" data-bs-toggle="collapse" data-bs-target="#areaFormPanel" aria-expanded="${not empty editArea ? 'true' : 'false'}">
                        <i class="fa-solid fa-plus me-2"></i><fmt:message key="admin.areas.create" />
                    </button>
                </div>
            </div>

            <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
            <c:if test="${param.saved == '1'}"><div class="alert alert-success"><fmt:message key="admin.common.saved.success" /></div></c:if>

            <section id="areaFormPanel" class="collapse ${not empty editArea ? 'show' : ''} mb-4">
                <form class="card" method="post" action="MainController">
                    <div class="card-body p-4">
                        <input type="hidden" name="action" value="saveArea">
                        <input type="hidden" name="id" value="${editArea.id}">
                        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-3">
                            <div>
                                <div class="admin-section-label"><fmt:message key="admin.areas.editor.kicker" /></div>
                                <h2 class="h5 mb-0">
                                    <c:choose>
                                        <c:when test="${empty editArea}"><fmt:message key="admin.areas.create" /></c:when>
                                        <c:otherwise><fmt:message key="admin.areas.edit" /></c:otherwise>
                                    </c:choose>
                                </h2>
                            </div>
                            <c:if test="${not empty editArea}">
                                <a class="btn btn-outline-secondary btn-sm" href="MainController?action=adminAreas"><fmt:message key="admin.common.clear" /></a>
                            </c:if>
                        </div>

                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label"><fmt:message key="admin.areas.label.name.vi" /></label>
                                <input id="draftAreaName" class="form-control" name="nameVi" value="${not empty editArea.nameVi ? editArea.nameVi : editArea.name}" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label"><fmt:message key="admin.areas.label.name.en" /></label>
                                <input class="form-control" name="name" value="${editArea.name}">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label"><fmt:message key="admin.areas.label.modifier" /></label>
                                <input id="draftAreaModifier" class="form-control" name="priceModifier" type="number" min="0" step="1" value="${empty editArea ? 0 : editArea.priceModifier}">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label"><fmt:message key="admin.areas.label.desc.vi" /></label>
                                <textarea id="draftAreaDesc" class="form-control" name="descriptionVi" rows="3">${not empty editArea.descriptionVi ? editArea.descriptionVi : editArea.description}</textarea>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label"><fmt:message key="admin.areas.label.desc.en" /></label>
                                <textarea class="form-control" name="description" rows="3">${editArea.description}</textarea>
                            </div>
                            <div class="col-12">
                                <div class="form-check form-switch">
                                    <input id="draftAreaActive" class="form-check-input" type="checkbox" name="isActive" value="true" ${empty editArea || editArea.isActive ? 'checked' : ''}>
                                    <label class="form-check-label" for="draftAreaActive"><fmt:message key="admin.common.available" /></label>
                                </div>
                            </div>
                            <div class="col-12">
                                <aside class="admin-draft-preview rounded-3 p-3">
                                    <p class="text-uppercase text-secondary small mb-1"><fmt:message key="admin.areas.preview" /></p>
                                    <h3 id="areaPreviewName" class="h5 mb-1">${empty editArea ? defaultAreaName : (isEn ? (not empty editArea.name ? editArea.name : editArea.nameVi) : (not empty editArea.nameVi ? editArea.nameVi : editArea.name))}</h3>
                                    <p id="areaPreviewDesc" class="text-secondary small mb-2">${empty editArea ? defaultAreaDesc : (isEn ? (not empty editArea.description ? editArea.description : editArea.descriptionVi) : (not empty editArea.descriptionVi ? editArea.descriptionVi : editArea.description))}</p>
                                    <div class="d-flex flex-wrap gap-2">
                                        <span class="badge text-bg-light border text-dark">
                                            <fmt:message key="admin.areas.label.modifier" />:
                                            <strong id="areaPreviewModifier"><fmt:formatNumber value="${empty editArea ? 0 : editArea.priceModifier}" pattern="#,##0"/></strong>
                                        </span>
                                        <span id="areaPreviewStatus" class="badge ${empty editArea || editArea.isActive ? 'text-bg-success' : 'text-bg-secondary'}">
                                            ${empty editArea || editArea.isActive ? availableText : hiddenText}
                                        </span>
                                    </div>
                                </aside>
                            </div>
                            <div class="col-12 d-flex justify-content-end">
                                <button class="btn btn-dark px-4" type="submit"><fmt:message key="admin.common.save" /></button>
                            </div>
                        </div>
                    </div>
                </form>
            </section>

            <section class="card">
                <div class="card-body p-4">
                    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-3">
                        <div>
                            <div class="admin-section-label"><fmt:message key="admin.areas.list" /></div>
                            <h2 class="h5 mb-0"><fmt:message key="admin.areas.list.title" /></h2>
                        </div>
                    </div>

                    <div class="row g-2 mb-3">
                        <div class="col-md-8">
                            <input id="areaSearch" class="form-control" type="search" placeholder="<fmt:message key='admin.areas.search' />">
                        </div>
                        <div class="col-md-4">
                            <select id="areaStatusFilter" class="form-select">
                                <option value=""><fmt:message key="admin.common.filter.all.status" /></option>
                                <option value="active"><fmt:message key="admin.common.available" /></option>
                                <option value="inactive"><fmt:message key="admin.common.hidden" /></option>
                            </select>
                        </div>
                    </div>

                    <div class="table-responsive">
                        <table class="table align-middle mb-0">
                            <thead>
                                <tr>
                                    <th><fmt:message key="admin.areas.col.name" /></th>
                                    <th><fmt:message key="admin.areas.col.modifier" /></th>
                                    <th><fmt:message key="admin.areas.col.status" /></th>
                                    <th class="text-end"></th>
                                </tr>
                            </thead>
                            <tbody id="areaRows">
                                <c:forEach items="${areaList}" var="area">
                                    <c:set var="areaName" value="${isEn ? (not empty area.name ? area.name : area.nameVi) : (not empty area.nameVi ? area.nameVi : area.name)}" />
                                    <c:set var="areaDesc" value="${isEn ? (not empty area.description ? area.description : area.descriptionVi) : (not empty area.descriptionVi ? area.descriptionVi : area.description)}" />
                                    <tr data-area-row data-search="${area.name} ${area.nameVi} ${area.description} ${area.descriptionVi}" data-status="${area.isActive ? 'active' : 'inactive'}">
                                        <td>
                                            <strong>${areaName}</strong>
                                            <div class="small text-secondary">${areaDesc}</div>
                                        </td>
                                        <td><fmt:formatNumber value="${area.priceModifier}" pattern="#,##0"/></td>
                                        <td>
                                            <span class="badge ${area.isActive ? 'text-bg-success' : 'text-bg-secondary'}">
                                                ${area.isActive ? availableText : hiddenText}
                                            </span>
                                        </td>
                                        <td class="text-end">
                                            <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminAreas&id=${area.id}"><fmt:message key="admin.areas.btn.edit" /></a>
                                            <a class="btn btn-outline-secondary btn-sm" href="MainController?action=toggleArea&id=${area.id}&enabled=${!area.isActive}">
                                                <c:choose>
                                                    <c:when test="${area.isActive}"><fmt:message key="admin.areas.btn.disable" /></c:when>
                                                    <c:otherwise><fmt:message key="admin.areas.btn.enable" /></c:otherwise>
                                                </c:choose>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <tr id="areaEmptyRow" class="d-none">
                                    <td colspan="4" class="text-center text-secondary py-5"><fmt:message key="admin.areas.empty" /></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="d-flex justify-content-between align-items-center mt-3">
                        <div id="areaPageInfo" class="small text-secondary"></div>
                        <div class="btn-group">
                            <button id="areaPrev" type="button" class="btn btn-outline-secondary btn-sm"><fmt:message key="admin.common.prev" /></button>
                            <button id="areaNext" type="button" class="btn btn-outline-secondary btn-sm"><fmt:message key="admin.common.next" /></button>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </main>
</div>

<script>
    (function () {
        var defaultAreaName = '<fmt:message key="admin.areas.preview.default.name" />';
        var defaultAreaDesc = '<fmt:message key="admin.areas.preview.default.desc" />';
        var availableText = '<fmt:message key="admin.common.available" />';
        var hiddenText = '<fmt:message key="admin.common.hidden" />';
        var nameInput = document.getElementById('draftAreaName');
        var descInput = document.getElementById('draftAreaDesc');
        var modifierInput = document.getElementById('draftAreaModifier');
        var activeInput = document.getElementById('draftAreaActive');
        var previewName = document.getElementById('areaPreviewName');
        var previewDesc = document.getElementById('areaPreviewDesc');
        var previewModifier = document.getElementById('areaPreviewModifier');
        var previewStatus = document.getElementById('areaPreviewStatus');

        function updatePreview() {
            if (previewName) previewName.textContent = (nameInput.value || '').trim() || defaultAreaName;
            if (previewDesc) previewDesc.textContent = (descInput.value || '').trim() || defaultAreaDesc;
            if (previewModifier) previewModifier.textContent = new Intl.NumberFormat('vi-VN', {maximumFractionDigits: 0}).format(Number(modifierInput.value || 0));
            if (previewStatus) {
                previewStatus.textContent = activeInput.checked ? availableText : hiddenText;
                previewStatus.className = activeInput.checked ? 'badge text-bg-success' : 'badge text-bg-secondary';
            }
        }
        [nameInput, descInput, modifierInput, activeInput].forEach(function (field) {
            if (field) field.addEventListener('input', updatePreview);
            if (field) field.addEventListener('change', updatePreview);
        });
        updatePreview();

        var search = document.getElementById('areaSearch');
        var status = document.getElementById('areaStatusFilter');
        var rows = Array.prototype.slice.call(document.querySelectorAll('[data-area-row]'));
        var empty = document.getElementById('areaEmptyRow');
        var pageInfo = document.getElementById('areaPageInfo');
        var prev = document.getElementById('areaPrev');
        var next = document.getElementById('areaNext');
        var page = 1;
        var perPage = 8;
        var visibleRows = [];

        function applyFilters() {
            var query = (search.value || '').toLowerCase().trim();
            var selectedStatus = status.value;
            visibleRows = rows.filter(function (row) {
                var matchesSearch = !query || (row.getAttribute('data-search') || '').toLowerCase().indexOf(query) >= 0;
                var matchesStatus = !selectedStatus || row.getAttribute('data-status') === selectedStatus;
                return matchesSearch && matchesStatus;
            });
            var maxPage = Math.max(1, Math.ceil(visibleRows.length / perPage));
            if (page > maxPage) page = maxPage;
            renderPage();
        }

        function renderPage() {
            var maxPage = Math.max(1, Math.ceil(visibleRows.length / perPage));
            rows.forEach(function (row) { row.classList.add('d-none'); });
            visibleRows.slice((page - 1) * perPage, page * perPage).forEach(function (row) { row.classList.remove('d-none'); });
            if (empty) empty.classList.toggle('d-none', visibleRows.length !== 0);
            pageInfo.textContent = visibleRows.length ? (page + ' / ' + maxPage + ' - ' + visibleRows.length) : '0';
            prev.disabled = page <= 1;
            next.disabled = page >= maxPage;
        }

        if (search) search.addEventListener('input', function () { page = 1; applyFilters(); });
        if (status) status.addEventListener('change', function () { page = 1; applyFilters(); });
        if (prev) prev.addEventListener('click', function () { if (page > 1) { page--; renderPage(); } });
        if (next) next.addEventListener('click', function () {
            var maxPage = Math.max(1, Math.ceil(visibleRows.length / perPage));
            if (page < maxPage) { page++; renderPage(); }
        });
        applyFilters();
    })();
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
