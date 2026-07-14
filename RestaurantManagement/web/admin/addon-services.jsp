<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setLocale value="${sessionScope.lang == 'en' ? 'en_US' : 'vi_VN'}" />
<fmt:setBundle basename="i18n.messages" />
<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="admin.addons.title" /> - Le Royal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Marcellus&family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-royal.css">
</head>
<body class="admin-royal">
<div class="d-flex">
    <jsp:include page="/admin/sidebar.jsp">
        <jsp:param name="active" value="addon-services"/>
    </jsp:include>
    <main class="flex-grow-1">
        <div class="admin-shell py-4">
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
            <p class="text-uppercase text-secondary small mb-1"><fmt:message key="admin.dashboard.workspace.title" /></p>
            <h1 class="h3 mb-0"><fmt:message key="admin.addons.title" /></h1>
        </div>
        <button class="btn btn-dark btn-sm" type="button" data-bs-toggle="collapse" data-bs-target="#addonFormPanel" aria-expanded="${not empty editAddon ? 'true' : 'false'}">
            <i class="fa-solid fa-plus me-2"></i><fmt:message key="admin.addons.btn.add" />
        </button>
    </div>
    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
    <c:if test="${param.saved == '1'}"><div class="alert alert-success"><fmt:message key="admin.common.saved.success" /></div></c:if>
    <div class="row g-4">
        <div id="addonFormPanel" class="col-lg-4 collapse ${not empty editAddon ? 'show' : ''}">
            <form id="addonEditorForm" class="border rounded-3 p-4 bg-light" method="post" action="MainController" enctype="multipart/form-data">
                <input type="hidden" name="action" value="saveAddonService">
                <input type="hidden" name="id" value="${editAddon.id}">
                <h2 class="h5 mb-3">${empty editAddon ? '<fmt:message key="admin.addons.editor.create" />' : '<fmt:message key="admin.addons.editor.edit" />'}</h2>
                <label class="form-label"><fmt:message key="admin.addons.label.name" /></label>
                <input id="draftAddonName" class="form-control mb-3" name="serviceName" value="${editAddon.serviceName}" required>
                <label class="form-label"><fmt:message key="admin.addons.label.desc" /></label>
                <textarea id="draftAddonDescription" class="form-control mb-3" name="description" rows="3">${editAddon.description}</textarea>
                <label class="form-label"><fmt:message key="admin.addons.label.price" /></label>
                <input id="draftAddonPrice" class="form-control mb-3" name="price" type="number" min="0" step="1" value="${empty editAddon ? 0 : editAddon.price}">
                <label class="form-label"><fmt:message key="admin.addons.label.image" /></label>
                <input id="draftAddonImage" class="form-control mb-3" name="imageUrl" value="${editAddon.imageUrl}" placeholder="assets/img/le-royal/Private Live Pianist.jpg">
                <label class="form-label">Upload image</label>
                <input id="draftAddonImageFile" class="form-control mb-3" name="imageFile" type="file" accept="image/*">
                <div class="form-check form-switch mb-3">
                    <input id="draftAddonAvailable" class="form-check-input" type="checkbox" name="isAvailable" value="true" ${empty editAddon || editAddon.isAvailable ? 'checked' : ''}>
                    <label class="form-check-label"><fmt:message key="admin.common.active.switch" /></label>
                </div>
                <aside class="admin-draft-preview rounded-3 p-3 mb-3">
                    <div id="draftAddonImageWrap" class="admin-draft-placeholder rounded-3 d-flex align-items-center justify-content-center mb-3">
                        <i class="fa-solid fa-music fa-2x"></i>
                    </div>
                    <p class="text-uppercase text-secondary small mb-1">Draft preview</p>
                    <h3 id="draftAddonTitle" class="h5 mb-1"><fmt:message key="admin.addons.preview.new" /></h3>
                    <p id="draftAddonText" class="text-secondary mb-2"><fmt:message key="admin.addons.preview.nodesc" /></p>
                    <div class="d-flex flex-wrap gap-2">
                        <span id="draftAddonPriceLabel" class="badge text-bg-light border text-dark">0</span>
                        <span id="draftAddonStatusLabel" class="badge text-bg-success"><fmt:message key="admin.common.available" /></span>
                    </div>
                </aside>
                <button class="btn btn-dark w-100" type="submit"><fmt:message key="admin.common.save" /></button>
            </form>
        </div>
        <div class="col-lg-8">
            <div class="card mb-3">
                <div class="card-body p-3">
                    <div class="row g-2 align-items-center">
                        <div class="col-lg-8">
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-solid fa-magnifying-glass"></i></span>
                                <input id="addonSearch" class="form-control" type="search" placeholder="<fmt:message key="admin.addons.search" />">
                            </div>
                        </div>
                        <div class="col-sm-6 col-lg-2">
                            <select id="addonStatusFilter" class="form-select">
                                <option value=""><fmt:message key="admin.common.filter.all.status" /></option>
                                <option value="available"><fmt:message key="admin.common.available" /></option>
                                <option value="hidden"><fmt:message key="admin.common.hidden" /></option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
            <div class="table-responsive">
                <table class="table align-middle">
                    <thead>
                        <tr>
                            <th><fmt:message key="admin.addons.col.image" /></th>
                            <th><fmt:message key="admin.addons.col.id" /></th>
                            <th><fmt:message key="admin.addons.col.service" /></th>
                            <th><fmt:message key="admin.addons.col.price" /></th>
                            <th><fmt:message key="admin.addons.col.status" /></th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${addonList}" var="addon">
                            <c:set var="addonImage" value="${empty addon.imageUrl ? 'assets/img/le-royal/Champagne Welcome Service.jpg' : addon.imageUrl}" />
                            <tr data-addon-row data-search="${addon.serviceName} ${addon.description}" data-status="${addon.isAvailable ? 'available' : 'hidden'}">
                                <td><img src="${addonImage}" style="width: 76px; height: 52px; object-fit: cover;" class="rounded-2" alt="${addon.serviceName}"></td>
                                <td>${addon.id}</td>
                                <td><strong>${addon.serviceName}</strong><div class="small text-secondary">${addon.description}</div></td>
                                <td><fmt:formatNumber value="${addon.price}" pattern="#,##0"/></td>
                                <td><span class="badge ${addon.isAvailable ? 'text-bg-success' : 'text-bg-secondary'}">${addon.isAvailable ? '<fmt:message key="admin.common.available" />' : '<fmt:message key="admin.common.hidden" />'}</span></td>
                                <td class="text-end">
                                    <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminAddonServices&id=${addon.id}"><fmt:message key="admin.addons.btn.edit" /></a>
                                    <a class="btn btn-outline-secondary btn-sm" href="MainController?action=toggleAddonService&id=${addon.id}&enabled=${!addon.isAvailable}">${addon.isAvailable ? '<fmt:message key="admin.addons.btn.hide" />' : '<fmt:message key="admin.addons.btn.restore" />'}</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <tr id="addonEmpty" class="d-none"><td colspan="6" class="text-center text-secondary py-5"><fmt:message key="admin.addons.empty" /></td></tr>
                    </tbody>
                </table>
            </div>
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mt-3">
                <div id="addonPaginationText" class="small text-secondary"></div>
                <div id="addonPagination" class="btn-group btn-group-sm" role="group" aria-label="<fmt:message key="admin.addons.title" />"></div>
            </div>
        </div>
    </div>
</div>
</main>
</div>
<div class="modal fade" id="addonConfirmModal" tabindex="-1" aria-labelledby="addonConfirmTitle" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <div class="modal-header">
                <div>
                    <p class="text-uppercase text-secondary small mb-1"><fmt:message key="admin.addons.modal.confirm" /></p>
                    <h5 class="modal-title" id="addonConfirmTitle"><fmt:message key="admin.addons.modal.review" /></h5>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="<fmt:message key="admin.common.close" />"></button>
            </div>
            <div class="modal-body">
                <div class="menu-confirm-summary mb-3">
                    <div id="addonConfirmImage" class="menu-confirm-hero" style="width:280px; height:110px; max-width:100%; margin:0 auto;">
                        <i class="fa-solid fa-music fa-2x"></i>
                    </div>
                </div>
                <div class="row g-3 align-items-center">
                    <div class="col-12">
                        <h3 id="addonConfirmName" class="h5 mb-1"><fmt:message key="admin.addons.preview.new" /></h3>
                        <p id="addonConfirmText" class="text-secondary mb-2"><fmt:message key="admin.addons.preview.nodesc" /></p>
                        <div class="d-flex flex-wrap gap-2">
                            <span id="addonConfirmPrice" class="badge text-bg-light border text-dark">0</span>
                            <span id="addonConfirmStatus" class="badge text-bg-success"><fmt:message key="admin.common.available" /></span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal"><fmt:message key="admin.addons.modal.keep" /></button>
                <button id="addonConfirmSave" type="button" class="btn btn-dark"><fmt:message key="admin.addons.modal.save" /></button>
            </div>
        </div>
    </div>
</div>
<script>
    (function () {
        var rows = Array.prototype.slice.call(document.querySelectorAll('[data-addon-row]'));
        var search = document.getElementById('addonSearch');
        var status = document.getElementById('addonStatusFilter');
        var empty = document.getElementById('addonEmpty');
        var pagination = document.getElementById('addonPagination');
        var paginationText = document.getElementById('addonPaginationText');
        var pageSize = 6;
        var currentPage = 1;

        function normalized(value) { return (value || '').toLowerCase(); }
        function matches(item) {
            var q = normalized(search && search.value);
            var statusValue = status ? status.value : '';
            return (!q || normalized(item.getAttribute('data-search')).indexOf(q) !== -1)
                    && (!statusValue || item.getAttribute('data-status') === statusValue);
        }
        function filteredRows() { return rows.filter(matches); }
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
        var name = document.getElementById('draftAddonName');
        var description = document.getElementById('draftAddonDescription');
        var price = document.getElementById('draftAddonPrice');
        var image = document.getElementById('draftAddonImage');
        var imageFile = document.getElementById('draftAddonImageFile');
        var available = document.getElementById('draftAddonAvailable');
        var imageWrap = document.getElementById('draftAddonImageWrap');
        var title = document.getElementById('draftAddonTitle');
        var text = document.getElementById('draftAddonText');
        var priceLabel = document.getElementById('draftAddonPriceLabel');
        var statusLabel = document.getElementById('draftAddonStatusLabel');
        var addonUploadPreviewUrl = '';

        function imageSrc(value) {
            value = (value || '').trim();
            if (!value) return '';
            return (/^(https?:)?\/\//i.test(value) || value.charAt(0) === '/') ? value : contextPath + '/' + value;
        }
        function money(value) {
            var number = Number(value || 0);
            return (isNaN(number) ? 0 : number).toLocaleString('vi-VN');
        }
        function renderDraft() {
            if (!title || !imageWrap) return;
            title.textContent = (name.value || '').trim() || '<fmt:message key="admin.addons.preview.new" />';
            text.textContent = (description.value || '').trim() || '<fmt:message key="admin.addons.preview.nodesc" />';
            priceLabel.textContent = money(price.value);
            statusLabel.textContent = available.checked ? '<fmt:message key="admin.common.available" />' : '<fmt:message key="admin.common.hidden" />';
            statusLabel.className = available.checked ? 'badge text-bg-success' : 'badge text-bg-secondary';
            var src = addonUploadPreviewUrl || imageSrc(image.value) || contextPath + '/assets/img/le-royal/Champagne Welcome Service.jpg';
            imageWrap.innerHTML = '<img class="rounded-3" src="' + src + '" alt="">';
        }
        [name, description, price, image, available].forEach(function (field) {
            if (!field) return;
            field.addEventListener('input', renderDraft);
            field.addEventListener('change', renderDraft);
        });
        if (imageFile) {
            imageFile.addEventListener('change', function () {
                if (addonUploadPreviewUrl) {
                    URL.revokeObjectURL(addonUploadPreviewUrl);
                }
                addonUploadPreviewUrl = this.files && this.files[0] ? URL.createObjectURL(this.files[0]) : '';
                renderDraft();
            });
        }
        renderDraft();

        var form = document.getElementById('addonEditorForm');
        var modal = document.getElementById('addonConfirmModal');
        var confirmSave = document.getElementById('addonConfirmSave');
        var confirmed = false;
        function renderConfirm() {
            renderDraft();
            var confirmImage = document.getElementById('addonConfirmImage');
            var confirmName = document.getElementById('addonConfirmName');
            var confirmText = document.getElementById('addonConfirmText');
            var confirmPrice = document.getElementById('addonConfirmPrice');
            var confirmStatus = document.getElementById('addonConfirmStatus');
            if (confirmImage) {
                var src = addonUploadPreviewUrl || imageSrc(image.value) || contextPath + '/assets/img/le-royal/Champagne Welcome Service.jpg';
                confirmImage.innerHTML = '<img style="width:100%; height:100%; object-fit:cover;" src="' + src + '" alt="">';
            }
            if (confirmName && title) confirmName.textContent = title.textContent;
            if (confirmText && text) confirmText.textContent = text.textContent;
            if (confirmPrice && priceLabel) confirmPrice.textContent = priceLabel.textContent;
            if (confirmStatus && statusLabel) {
                confirmStatus.textContent = statusLabel.textContent;
                confirmStatus.className = statusLabel.className;
            }
        }
        if (form) {
            form.addEventListener('submit', function (event) {
                if (confirmed) return;
                event.preventDefault();
                renderConfirm();
                if (window.bootstrap && modal) {
                    window.bootstrap.Modal.getOrCreateInstance(modal).show();
                } else if (window.confirm('<fmt:message key="admin.addons.modal.keep" />?')) {
                    confirmed = true;
                    form.submit();
                }
            });
        }
        if (confirmSave && form) {
            confirmSave.addEventListener('click', function () {
                confirmed = true;
                form.submit();
            });
        }
    })();
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
