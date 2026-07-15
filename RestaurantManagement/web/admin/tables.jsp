<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<fmt:setLocale value="${sessionScope.lang == 'vi' ? 'vi_VN' : 'en_US'}" />
<fmt:setBundle basename="i18n.messages" />
<c:if test="${param.embed != '1'}">
<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="admin.tables.title" /> - <fmt:message key="admin.dashboard.workspace.title" /></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Marcellus&family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/admin-royal.css" rel="stylesheet">
</head>
<body class="admin-royal">
    <div class="d-flex">
        <jsp:include page="/admin/sidebar.jsp">
            <jsp:param name="active" value="tables"/>
        </jsp:include>
        <div class="flex-grow-1 p-5">
</c:if>

<c:if test="${param.embed == '1'}">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Marcellus&family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/admin-royal.css" rel="stylesheet">
    <style>
        body { margin: 0; padding: 0; background: transparent !important; }
        .table-wrap { padding: 1.25rem; }
    </style>
</c:if>

<c:set var="displayTables" value="${not empty tables ? tables : tableList}" />
<div class="${param.embed == '1' ? 'table-wrap' : ''}">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold m-0 admin-title" style="font-size: clamp(1.5rem, 2.5vw, 2.2rem);"><fmt:message key="admin.tables.list" /></h2>
        <button class="btn btn-primary px-4" type="button" data-bs-toggle="collapse" data-bs-target="#addTablePanel" aria-expanded="false">
            <i class="fa-solid fa-plus me-1"></i> <fmt:message key="admin.tables.add" />
        </button>
    </div>

    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fa-solid fa-circle-check me-2"></i> ${sessionScope.lang == 'en' ? sessionScope.successMessage : sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="<fmt:message key="admin.common.close" />"></button>
        </div>
        <c:remove var="successMessage" scope="session" />
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fa-solid fa-circle-exclamation me-2"></i> ${sessionScope.lang == 'en' ? sessionScope.errorMessage : sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="<fmt:message key="admin.common.close" />"></button>
        </div>
        <c:remove var="errorMessage" scope="session" />
    </c:if>

    <section id="addTablePanel" class="collapse mb-4">
        <div class="card border-0 shadow-sm">
            <div class="card-body p-4">
                <form action="${pageContext.request.contextPath}/MainController" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="saveDiningTable">
                    <input type="hidden" name="isActive" value="true">
                    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-3">
                        <div>
                            <div class="admin-section-label"><fmt:message key="admin.tables.editor" /></div>
                            <h5 class="fw-bold mb-0"><fmt:message key="admin.tables.add" /></h5>
                        </div>
                        <button type="button" class="btn btn-outline-secondary btn-sm" data-bs-toggle="collapse" data-bs-target="#addTablePanel"><fmt:message key="admin.common.cancel" /></button>
                    </div>
                    <div class="py-2">
                        <div class="row g-4">
                            <div class="col-lg-7">
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label text-muted small fw-bold"><fmt:message key="admin.tables.label.code" /></label>
                                        <input id="draftTableCode" type="text" name="tableCode" class="form-control form-control-lg" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label text-muted small fw-bold"><fmt:message key="admin.tables.label.capacity" /></label>
                                        <input id="draftTableCapacity" type="number" name="capacity" class="form-control form-control-lg" value="2" min="1" required>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label text-muted small fw-bold"><fmt:message key="admin.tables.label.room" /></label>
                                    <select id="draftTableRoom" name="roomId" class="form-select form-select-lg">
                                        <c:forEach items="${rooms}" var="r">
                                            <option value="${r.id}">${sessionScope.lang == 'en' ? r.roomNameEn : r.roomName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label text-muted small fw-bold"><fmt:message key="admin.tables.label.bookingfee" /></label>
                                        <input id="draftTablePrice" type="number" name="basePrice" class="form-control form-control-lg" value="0" min="0" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label text-muted small fw-bold"><fmt:message key="admin.tables.label.status" /></label>
                                        <select id="draftTableStatus" name="status" class="form-select form-select-lg">
                                            <option value="AVAILABLE" selected><fmt:message key="admin.tables.status.available" /></option>
                                            <option value="RESERVED"><fmt:message key="admin.tables.status.reserved" /></option>
                                            <option value="OCCUPIED"><fmt:message key="admin.tables.status.occupied" /></option>
                                        </select>
                                    </div>
                                </div>
                                <div class="mb-0">
                                    <label class="form-label text-muted small fw-bold"><fmt:message key="admin.tables.label.image" /></label>
                                    <input id="draftTableImage" type="text" name="imageUrl" class="form-control form-control-lg" placeholder="assets/img/le-royal/seating/dining-room.jpg">
                                    <div class="form-text">Paste an existing URL, or upload a new image below.</div>
                                </div>
                                <div class="mt-3">
                                    <label class="form-label text-muted small fw-bold">UPLOAD IMAGE</label>
                                    <input id="draftTableImageFile" type="file" name="imageFile" class="form-control form-control-lg" accept="image/*">
                                </div>
                            </div>
                            <div class="col-lg-5">
                                <aside class="admin-draft-preview rounded-3 p-3">
                                    <div id="draftTableImageWrap" class="menu-confirm-hero mb-3" style="width:280px; height:110px; max-width:100%; margin:0 auto;">
                                        <i class="fa-solid fa-chair fa-2x"></i>
                                    </div>
                                    <p class="text-uppercase text-secondary small mb-1">Draft preview</p>
                                    <h3 id="draftTableTitle" class="h5 mb-1"><fmt:message key="admin.tables.preview.new" /></h3>
                                    <p id="draftTableMeta" class="text-secondary mb-2">2 guests · Room</p>
                                    <div class="d-flex flex-wrap gap-2">
                                        <span id="draftTableStatusBadge" class="badge text-bg-success"><fmt:message key="admin.tables.status.available" /></span>
                                        <span id="draftTablePriceLabel" class="badge text-bg-light border text-dark">0d</span>
                                    </div>
                                </aside>
                            </div>
                        </div>
                    </div>
                    <div class="d-flex justify-content-end gap-2 pt-3">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-toggle="collapse" data-bs-target="#addTablePanel"><fmt:message key="admin.common.cancel" /></button>
                        <button type="submit" class="btn btn-primary rounded-pill px-4"><fmt:message key="admin.tables.btn.add" /></button>
                    </div>
                </form>
            </div>
        </div>
    </section>

    <div class="card mb-3">
        <div class="card-body p-3">
            <div class="row g-2 align-items-center">
                <div class="col-lg-6">
                    <div class="input-group">
                        <span class="input-group-text"><i class="fa-solid fa-magnifying-glass"></i></span>
                        <input id="tableSearch" class="form-control" type="search" placeholder="<fmt:message key="admin.tables.search" />">
                    </div>
                </div>
                <div class="col-sm-6 col-lg-3">
                    <select id="tableStatusFilter" class="form-select">
                        <option value=""><fmt:message key="admin.common.filter.all.status" /></option>
                        <option value="AVAILABLE"><fmt:message key="admin.tables.status.available" /></option>
                        <option value="RESERVED"><fmt:message key="admin.tables.status.reserved" /></option>
                        <option value="OCCUPIED"><fmt:message key="admin.tables.status.occupied" /></option>
                        <option value="HOLD"><fmt:message key="admin.tables.status.hold" /></option>
                    </select>
                </div>
            </div>
        </div>
    </div>

    <div class="card border-0">
        <div class="card-body p-0">
            <table class="table table-hover align-middle m-0">
                <thead class="table-light">
                    <tr>
                        <th class="ps-4 py-3"><fmt:message key="admin.tables.col.table" /></th>
                        <th><fmt:message key="admin.tables.col.room" /></th>
                        <th><fmt:message key="admin.tables.col.capacity" /></th>
                        <th><fmt:message key="admin.tables.col.bookingfee" /></th>
                        <th><fmt:message key="admin.tables.col.status" /></th>
                        <th class="text-end pe-4"><fmt:message key="admin.tables.col.action" /></th>
                    </tr>
                </thead>
                <tbody id="tableRows">
                    <c:forEach items="${displayTables}" var="t">
                        <tr data-table-row
                            data-search="${t.tableCode} ${sessionScope.lang == 'en' ? t.room.roomNameEn : t.room.roomName} ${not empty t.room.area ? t.room.area.name : ''}"
                            data-status="${t.status}">
                            <td class="ps-4">
                                <div class="d-flex align-items-center gap-3">
                                    <c:set var="tableImage" value="${empty t.imageUrl ? 'assets/img/le-royal/seating/dining-room.jpg' : t.imageUrl}" />
                                    <c:choose>
                                        <c:when test="${fn:startsWith(tableImage, 'http') || fn:startsWith(tableImage, '/')}">
                                            <img class="admin-menu-thumb rounded-2" src="${tableImage}" alt="${t.tableCode}">
                                        </c:when>
                                        <c:otherwise>
                                            <img class="admin-menu-thumb rounded-2" src="${pageContext.request.contextPath}/${tableImage}" alt="${t.tableCode}">
                                        </c:otherwise>
                                    </c:choose>
                                    <strong class="text-primary">${t.tableCode}</strong>
                                </div>
                            </td>
                            <td>${sessionScope.lang == 'en' ? t.room.roomNameEn : t.room.roomName}</td>
                            <td><i class="fa-solid fa-user-group me-1 text-muted"></i> ${t.capacity}</td>
                            <td><fmt:formatNumber value="${t.basePrice}" pattern="#,##0"/>d</td>
                            <td>
                                <c:choose>
                                    <c:when test="${t.status == 'AVAILABLE'}"><span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill px-3 py-1"><fmt:message key="admin.tables.status.available" /></span></c:when>
                                    <c:when test="${t.status == 'RESERVED'}"><span class="badge bg-warning-subtle text-warning border border-warning-subtle rounded-pill px-3 py-1"><fmt:message key="admin.tables.status.reserved" /></span></c:when>
                                    <c:when test="${t.status == 'OCCUPIED'}"><span class="badge bg-danger-subtle text-danger border border-danger-subtle rounded-pill px-3 py-1"><fmt:message key="admin.tables.status.occupied" /></span></c:when>
                                </c:choose>
                            </td>
                            <td class="text-end pe-4">
                                <button class="btn btn-sm btn-light border shadow-sm rounded-circle me-1" style="width:32px; height:32px;" data-bs-toggle="modal" data-bs-target="#editModal${t.id}" title="<fmt:message key="admin.common.edit" />"><i class="fa-solid fa-pen text-primary"></i></button>
                                <button class="btn btn-sm btn-light border shadow-sm rounded-circle" style="width:32px; height:32px;" data-bs-toggle="modal" data-bs-target="#deleteModal${t.id}" title="<fmt:message key="admin.common.delete" />"><i class="fa-solid fa-trash text-danger"></i></button>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty displayTables}">
                        <tr><td colspan="6" class="text-center text-muted py-5"><fmt:message key="admin.tables.empty" /></td></tr>
                    </c:if>
                    <tr id="tableEmpty" class="d-none"><td colspan="6" class="text-center text-muted py-5"><fmt:message key="admin.tables.empty.filter" /></td></tr>
                </tbody>
            </table>
        </div>
    </div>
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mt-3">
        <div id="tablePaginationText" class="small text-secondary"></div>
        <div id="tablePagination" class="btn-group btn-group-sm" role="group" aria-label="Table pagination"></div>
    </div>
</div>

<c:if test="${param.embed != '1'}">
        </div>
    </div>
</c:if>

<!-- Edit Modals -->
<c:forEach items="${displayTables}" var="t">
    <div class="modal fade" id="editModal${t.id}" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <form action="${pageContext.request.contextPath}/MainController" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="saveDiningTable">
                    <input type="hidden" name="id" value="${t.id}">
                    <input type="hidden" name="isActive" value="${t.isActive}">
                    <div class="modal-header border-0 pb-0">
                        <h5 class="modal-title fw-bold"><fmt:message key="admin.tables.modal.update" /> ${t.tableCode}</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body py-4">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted small fw-bold"><fmt:message key="admin.tables.label.code" /></label>
                                <input type="text" name="tableCode" class="form-control form-control-lg" value="${t.tableCode}" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted small fw-bold"><fmt:message key="admin.tables.label.capacity" /></label>
                                <input type="number" name="capacity" class="form-control form-control-lg" value="${t.capacity}" min="1" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold"><fmt:message key="admin.tables.label.room" /></label>
                            <select name="roomId" class="form-select form-select-lg">
                                <c:forEach items="${rooms}" var="r">
                                    <option value="${r.id}" ${t.room.id == r.id ? 'selected' : ''}>${sessionScope.lang == 'en' ? r.roomNameEn : r.roomName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted small fw-bold"><fmt:message key="admin.tables.label.bookingfee" /></label>
                                <input type="number" name="basePrice" class="form-control form-control-lg" value="${t.basePrice}" min="0" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted small fw-bold"><fmt:message key="admin.tables.label.status" /></label>
                                <select name="status" class="form-select form-select-lg">
                                    <option value="AVAILABLE" ${t.status == 'AVAILABLE' ? 'selected' : ''}><fmt:message key="admin.tables.status.available" /></option>
                                    <option value="RESERVED" ${t.status == 'RESERVED' ? 'selected' : ''}><fmt:message key="admin.tables.status.reserved" /></option>
                                    <option value="OCCUPIED" ${t.status == 'OCCUPIED' ? 'selected' : ''}><fmt:message key="admin.tables.status.occupied" /></option>
                                </select>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold"><fmt:message key="admin.tables.label.image" /></label>
                            <input type="text" name="imageUrl" class="form-control form-control-lg" value="${t.imageUrl}" placeholder="assets/img/le-royal/seating/dining-room.jpg">
                            <div class="form-text">Paste an existing URL, or upload a new image below.</div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">UPLOAD IMAGE</label>
                            <input type="file" name="imageFile" class="form-control form-control-lg" accept="image/*">
                        </div>
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal"><fmt:message key="admin.common.cancel" /></button>
                        <button type="submit" class="btn btn-primary rounded-pill px-4"><fmt:message key="admin.common.save.changes" /></button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="deleteModal${t.id}" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <form action="${pageContext.request.contextPath}/MainController" method="post">
                    <input type="hidden" name="action" value="toggleDiningTable">
                    <input type="hidden" name="id" value="${t.id}">
                    <input type="hidden" name="enabled" value="false">
                    <div class="modal-header border-0 pb-0">
                        <h5 class="modal-title fw-bold text-danger"><fmt:message key="admin.tables.modal.hide" /></h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body py-4">
                        <fmt:message key="admin.tables.modal.hide.confirm" /> <strong class="text-danger">${t.tableCode}</strong>?
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal"><fmt:message key="admin.common.cancel" /></button>
                        <button type="submit" class="btn btn-danger rounded-pill px-4"><fmt:message key="admin.tables.modal.hide.btn" /></button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</c:forEach>

<script>
    (function () {
        var rows = Array.prototype.slice.call(document.querySelectorAll('[data-table-row]'));
        var search = document.getElementById('tableSearch');
        var status = document.getElementById('tableStatusFilter');
        var empty = document.getElementById('tableEmpty');
        var pagination = document.getElementById('tablePagination');
        var paginationText = document.getElementById('tablePaginationText');
        var pageSize = 8;
        var currentPage = 1;

        function normalized(value) {
            return (value || '').toLowerCase();
        }

        function filteredRows() {
            var q = normalized(search && search.value);
            var statusValue = status ? status.value : '';
            return rows.filter(function (row) {
                return (!q || normalized(row.getAttribute('data-search')).indexOf(q) !== -1)
                        && (!statusValue || row.getAttribute('data-status') === statusValue);
            });
        }

        function renderPagination(totalPages) {
            if (!pagination) return;
            pagination.innerHTML = '';
            for (var i = 1; i <= totalPages; i++) {
                var button = document.createElement('button');
                button.type = 'button';
                button.className = 'btn ' + (i === currentPage ? 'btn-dark' : 'btn-outline-secondary');
                button.textContent = i;
                button.setAttribute('data-page', i);
                button.addEventListener('click', function () {
                    currentPage = Number(this.getAttribute('data-page'));
                    render();
                });
                pagination.appendChild(button);
            }
        }

        function render() {
            var visibleRows = filteredRows();
            var totalPages = Math.max(1, Math.ceil(visibleRows.length / pageSize));
            if (currentPage > totalPages) currentPage = totalPages;
            rows.forEach(function (row) { row.classList.add('d-none'); });
            var start = (currentPage - 1) * pageSize;
            visibleRows.slice(start, start + pageSize).forEach(function (row) { row.classList.remove('d-none'); });
            if (empty) empty.classList.toggle('d-none', visibleRows.length > 0);
            if (paginationText) {
                var end = Math.min(start + pageSize, visibleRows.length);
                paginationText.textContent = visibleRows.length ? ('Showing ' + (start + 1) + '-' + end + ' of ' + visibleRows.length) : '<fmt:message key="admin.common.pagination.no.items" />';
            }
            renderPagination(totalPages);
        }

        [search, status].forEach(function (field) {
            if (!field) return;
            field.addEventListener('input', function () { currentPage = 1; render(); });
            field.addEventListener('change', function () { currentPage = 1; render(); });
        });
        render();
    })();

    (function () {
        var contextPath = '${pageContext.request.contextPath}';
        var code = document.getElementById('draftTableCode');
        var capacity = document.getElementById('draftTableCapacity');
        var room = document.getElementById('draftTableRoom');
        var price = document.getElementById('draftTablePrice');
        var status = document.getElementById('draftTableStatus');
        var image = document.getElementById('draftTableImage');
        var imageFile = document.getElementById('draftTableImageFile');
        var title = document.getElementById('draftTableTitle');
        var meta = document.getElementById('draftTableMeta');
        var imageWrap = document.getElementById('draftTableImageWrap');
        var statusBadge = document.getElementById('draftTableStatusBadge');
        var priceLabel = document.getElementById('draftTablePriceLabel');
        var tableUploadPreviewUrl = '';

        function imageSrc(value) {
            value = (value || '').trim();
            if (!value) return '';
            return (/^(https?:)?\/\//i.test(value) || value.charAt(0) === '/') ? value : contextPath + '/' + value;
        }
        function money(value) {
            var number = Number(value || 0);
            return (isNaN(number) ? 0 : number).toLocaleString('vi-VN') + 'd';
        }
        function renderDraft() {
            if (!title || !imageWrap) return;
            title.textContent = (code.value || '').trim() || '<fmt:message key="admin.tables.preview.new" />';
            meta.textContent = (capacity.value || '2') + ' guests · ' + (room.options[room.selectedIndex] ? room.options[room.selectedIndex].text : 'Room');
            priceLabel.textContent = money(price.value);
            statusBadge.textContent = status.options[status.selectedIndex] ? status.options[status.selectedIndex].text : '<fmt:message key="admin.tables.status.available" />';
            statusBadge.className = status.value === 'AVAILABLE' ? 'badge text-bg-success' : (status.value === 'RESERVED' ? 'badge text-bg-warning' : 'badge text-bg-secondary');
            imageWrap.innerHTML = '<img style="width:100%; height:100%; object-fit:cover;" src="' + (tableUploadPreviewUrl || imageSrc(image.value) || contextPath + '/assets/img/le-royal/seating/dining-room.jpg') + '" alt="">';
        }
        [code, capacity, room, price, status, image].forEach(function (field) {
            if (!field) return;
            field.addEventListener('input', renderDraft);
            field.addEventListener('change', renderDraft);
        });
        if (imageFile) {
            imageFile.addEventListener('change', function () {
                if (tableUploadPreviewUrl) {
                    URL.revokeObjectURL(tableUploadPreviewUrl);
                }
                tableUploadPreviewUrl = this.files && this.files[0] ? URL.createObjectURL(this.files[0]) : '';
                renderDraft();
            });
        }
        renderDraft();
    })();
</script>

<c:if test="${param.embed != '1'}">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
</c:if>
