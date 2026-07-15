<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setLocale value="${sessionScope.lang == 'vi' ? 'vi_VN' : 'en_US'}" />
<fmt:setBundle basename="i18n.messages" />
<c:if test="${param.embed != '1'}">
<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="admin.categories.title" /> - Le Royal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Marcellus&family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-royal.css">
</head>
<body class="admin-royal">
<div class="d-flex">
    <jsp:include page="/admin/sidebar.jsp">
        <jsp:param name="active" value="menu-items"/>
    </jsp:include>
    <main class="flex-grow-1">
        <div class="admin-shell py-4">
</c:if>
<c:if test="${param.embed == '1'}">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Marcellus&family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-royal.css">
    <script>document.body.classList.add('admin-royal');</script>
    <style>body { margin: 0; background: transparent; }</style>
</c:if>

<c:if test="${param.embed == '1'}"><main class="container-fluid py-4"></c:if>
    <div class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-4">
        <div>
            <p class="text-uppercase text-secondary small mb-1"><fmt:message key="admin.menuitems.title" /></p>
            <h1 class="h3 mb-1"><fmt:message key="admin.categories.title" /></h1>
            <p class="text-secondary mb-0"><fmt:message key="admin.categories.desc" /></p>
        </div>
        <div class="d-flex flex-wrap gap-2">
            <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminMenuItems${param.embed == '1' ? '&embed=1' : ''}">
                <i class="fa-solid fa-bowl-food me-2"></i><fmt:message key="admin.categories.back.menuitems" />
            </a>
            <button class="btn btn-dark btn-sm" type="button" data-bs-toggle="collapse" data-bs-target="#categoryFormPanel" aria-expanded="${not empty editCategory ? 'true' : 'false'}">
                <i class="fa-solid fa-plus me-2"></i><fmt:message key="admin.categories.btn.add" />
            </button>
        </div>
    </div>

    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
    <c:if test="${param.saved == '1'}"><div class="alert alert-success"><fmt:message key="admin.common.saved.success" /></div></c:if>

    <section id="categoryFormPanel" class="collapse ${not empty editCategory ? 'show' : ''} mb-4">
        <form id="categoryEditorForm" class="card" method="post" action="MainController">
            <div class="card-body p-4">
                <input type="hidden" name="action" value="saveMenuCategory">
                <input type="hidden" name="id" value="${editCategory.id}">
                <c:if test="${param.embed == '1'}"><input type="hidden" name="embed" value="1"></c:if>
                <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-3">
                    <div>
                        <div class="admin-section-label"><fmt:message key="admin.categories.editor.title" /></div>
                        <h2 class="h5 mb-0">
                            <c:choose>
                                <c:when test="${empty editCategory}"><fmt:message key="admin.categories.editor.create" /></c:when>
                                <c:otherwise><fmt:message key="admin.categories.editor.edit" /></c:otherwise>
                            </c:choose>
                        </h2>
                    </div>
                    <c:if test="${not empty editCategory}">
                        <a class="btn btn-outline-secondary btn-sm" href="MainController?action=adminCategories${param.embed == '1' ? '&embed=1' : ''}"><fmt:message key="admin.categories.editor.clear" /></a>
                    </c:if>
                </div>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label"><fmt:message key="admin.categories.label.name.vi" /></label>
                        <input id="categoryNameViInput" class="form-control" name="categoryNameVi" value="${editCategory.categoryNameVi}" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label"><fmt:message key="admin.categories.label.name.en" /></label>
                        <input id="categoryNameInput" class="form-control" name="categoryName" value="${editCategory.categoryName}">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label"><fmt:message key="admin.categories.label.service" /></label>
                        <input id="categoryMealTimeInput" class="form-control" value="<fmt:message key="admin.menusets.label.service.dinner" />" readonly>
                        <input type="hidden" name="mealTime" value="DINNER">
                        <div class="form-text"><fmt:message key="admin.menusets.label.service.dinner.note" /></div>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label"><fmt:message key="admin.categories.label.coursetype" /></label>
                        <select id="categoryTypeInput" class="form-select" name="categoryType">
                            <option value="APPETIZER" ${editCategory.categoryType == 'APPETIZER' ? 'selected' : ''}><fmt:message key="admin.menuitems.type.appetizer" /></option>
                            <option value="SOUP" ${editCategory.categoryType == 'SOUP' ? 'selected' : ''}><fmt:message key="admin.menuitems.type.soup" /></option>
                            <option value="MAIN" ${editCategory.categoryType == 'MAIN' ? 'selected' : ''}><fmt:message key="admin.menuitems.type.main" /></option>
                            <option value="DESSERT" ${editCategory.categoryType == 'DESSERT' ? 'selected' : ''}><fmt:message key="admin.menuitems.type.dessert" /></option>
                            <option value="DRINK" ${editCategory.categoryType == 'DRINK' ? 'selected' : ''}><fmt:message key="admin.menuitems.type.drink" /></option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label"><fmt:message key="admin.categories.label.sort" /></label>
                        <input id="categorySortOrderInput" class="form-control" name="sortOrder" type="number" min="1" value="${empty editCategory ? 1 : editCategory.sortOrder}">
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <div class="form-check form-switch mb-2">
                            <input id="categoryActiveInput" class="form-check-input" type="checkbox" name="isActive" value="true" ${empty editCategory || editCategory.isActive ? 'checked' : ''}>
                            <label class="form-check-label"><fmt:message key="admin.common.active" /></label>
                        </div>
                    </div>
                    <div class="col-12 d-flex justify-content-end">
                        <button class="btn btn-dark px-4" type="submit"><fmt:message key="admin.common.save" /></button>
                    </div>
                </div>
            </div>
        </form>
    </section>

    <div class="modal fade" id="categoryConfirmModal" tabindex="-1" aria-labelledby="categoryConfirmTitle" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header">
                    <div>
                        <p class="text-uppercase text-secondary small mb-1"><fmt:message key="admin.categories.modal.confirm" /></p>
                        <h5 class="modal-title" id="categoryConfirmTitle"><fmt:message key="admin.categories.modal.review" /></h5>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="<fmt:message key="admin.common.close" />"></button>
                </div>
                <div class="modal-body">
                    <h3 id="categoryConfirmName" class="h5 mb-2"><fmt:message key="admin.categories.preview.new" /></h3>
                    <p id="categoryConfirmEnglish" class="text-secondary mb-3"><fmt:message key="admin.categories.preview.noen" /></p>
                    <div class="d-flex flex-wrap gap-2">
                        <span id="categoryConfirmService" class="badge text-bg-light border text-dark"><fmt:message key="admin.menusets.label.service.dinner" /></span>
                        <span id="categoryConfirmType" class="badge text-bg-light border text-dark"><fmt:message key="admin.menuitems.type.appetizer" /></span>
                        <span id="categoryConfirmOrder" class="badge text-bg-light border text-dark"><fmt:message key="admin.categories.label.sort" /> 1</span>
                        <span id="categoryConfirmStatus" class="badge text-bg-success"><fmt:message key="admin.common.active" /></span>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal"><fmt:message key="admin.menuitems.modal.keep" /></button>
                    <button id="categoryConfirmSave" type="button" class="btn btn-dark"><fmt:message key="admin.menuitems.modal.save" /></button>
                </div>
            </div>
        </div>
    </div>

    <section class="card">
        <div class="card-body p-4">
            <div class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-3">
                <div>
                    <div class="admin-section-label"><fmt:message key="admin.categories.library.title" /></div>
                    <h2 class="h5 mb-0"><fmt:message key="admin.categories.library.sub" /></h2>
                </div>
                <div class="small text-secondary">${categoryList.size()} <fmt:message key="admin.categories.library.count" /></div>
            </div>
            <div class="row g-2 mb-3">
                <div class="col-lg-6">
                    <div class="input-group">
                        <span class="input-group-text"><i class="fa-solid fa-magnifying-glass"></i></span>
                        <input id="categorySearch" class="form-control" type="search" placeholder="<fmt:message key="admin.categories.search" />">
                    </div>
                </div>
                <div class="col-sm-6 col-lg-3">
                    <select id="categoryTypeFilter" class="form-select">
                        <option value=""><fmt:message key="admin.common.filter.all.types" /></option>
                        <option value="APPETIZER"><fmt:message key="admin.menuitems.type.appetizer" /></option>
                        <option value="SOUP"><fmt:message key="admin.menuitems.type.soup" /></option>
                        <option value="MAIN"><fmt:message key="admin.menuitems.type.main" /></option>
                        <option value="DESSERT"><fmt:message key="admin.menuitems.type.dessert" /></option>
                        <option value="DRINK"><fmt:message key="admin.menuitems.type.drink" /></option>
                    </select>
                </div>
                <div class="col-sm-6 col-lg-2">
                    <select id="categoryStatusFilter" class="form-select">
                        <option value=""><fmt:message key="admin.common.filter.all.status" /></option>
                        <option value="active"><fmt:message key="admin.common.active" /></option>
                        <option value="hidden"><fmt:message key="admin.common.hidden" /></option>
                    </select>
                </div>
            </div>
            <div class="table-responsive">
                <table class="table align-middle">
                    <thead>
                        <tr>
                            <th><fmt:message key="admin.categories.col.group" /></th>
                            <th><fmt:message key="admin.categories.col.service" /></th>
                            <th><fmt:message key="admin.categories.col.coursetype" /></th>
                            <th><fmt:message key="admin.categories.col.order" /></th>
                            <th><fmt:message key="admin.categories.col.status" /></th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody id="categoryRows">
                        <c:forEach items="${categoryList}" var="cat">
                            <tr data-category-row
                                data-search="${cat.categoryNameVi} ${cat.categoryName}"
                                data-type="${cat.categoryType}"
                                data-status="${cat.isActive ? 'active' : 'hidden'}">
                                <td>
                                    <c:set var="mainCatName" value="${sessionScope.lang == 'vi' ? (not empty cat.categoryNameVi ? cat.categoryNameVi : cat.categoryName) : (not empty cat.categoryName ? cat.categoryName : cat.categoryNameVi)}" />
                                    <c:set var="subCatName" value="${sessionScope.lang == 'vi' ? cat.categoryName : cat.categoryNameVi}" />
                                    <strong>${mainCatName}</strong>
                                    <c:if test="${not empty subCatName}"><div class="small text-secondary">${subCatName}</div></c:if>
                                </td>
                                <td>
                                    <fmt:message key="admin.menusets.label.service.dinner" />
                                </td>
                                <td>
                                    <span class="badge bg-light">
                                        <c:choose>
                                            <c:when test="${cat.categoryType == 'APPETIZER'}"><fmt:message key="admin.menuitems.type.appetizer" /></c:when>
                                            <c:when test="${cat.categoryType == 'SOUP'}"><fmt:message key="admin.menuitems.type.soup" /></c:when>
                                            <c:when test="${cat.categoryType == 'MAIN'}"><fmt:message key="admin.menuitems.type.main" /></c:when>
                                            <c:when test="${cat.categoryType == 'DESSERT'}"><fmt:message key="admin.menuitems.type.dessert" /></c:when>
                                            <c:when test="${cat.categoryType == 'DRINK'}"><fmt:message key="admin.menuitems.type.drink" /></c:when>
                                            <c:otherwise>${cat.categoryType}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                                <td>${cat.sortOrder}</td>
                                <td><span class="badge ${cat.isActive ? 'text-bg-success' : 'text-bg-secondary'}">
                                    <c:choose>
                                        <c:when test="${cat.isActive}"><fmt:message key="admin.common.active"/></c:when>
                                        <c:otherwise><fmt:message key="admin.common.hidden"/></c:otherwise>
                                    </c:choose>
                                </span></td>
                                <td class="text-end">
                                    <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminCategories&id=${cat.id}${param.embed == '1' ? '&embed=1' : ''}"><fmt:message key="admin.common.edit" /></a>
                                    <a class="btn btn-outline-secondary btn-sm" href="MainController?action=toggleMenuCategory&id=${cat.id}&enabled=${!cat.isActive}${param.embed == '1' ? '&embed=1' : ''}">
                                        <c:choose>
                                            <c:when test="${cat.isActive}"><fmt:message key="admin.common.hide"/></c:when>
                                            <c:otherwise><fmt:message key="admin.common.restore"/></c:otherwise>
                                        </c:choose>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty categoryList}">
                            <tr><td colspan="6" class="text-center text-secondary py-5"><fmt:message key="admin.categories.empty" /></td></tr>
                        </c:if>
                        <tr id="categoryEmpty" class="d-none"><td colspan="6" class="text-center text-secondary py-5"><fmt:message key="admin.categories.empty.filter" /></td></tr>
                    </tbody>
                </table>
            </div>
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mt-3">
                <div id="categoryPaginationText" class="small text-secondary"></div>
                <div id="categoryPagination" class="btn-group btn-group-sm" role="group" aria-label="<fmt:message key="admin.categories.library.sub" />"></div>
            </div>
        </div>
    </section>
<c:if test="${param.embed == '1'}"></main></c:if>

<script>
    (function () {
        var rows = Array.prototype.slice.call(document.querySelectorAll('[data-category-row]'));
        var search = document.getElementById('categorySearch');
        var type = document.getElementById('categoryTypeFilter');
        var status = document.getElementById('categoryStatusFilter');
        var empty = document.getElementById('categoryEmpty');
        var pagination = document.getElementById('categoryPagination');
        var paginationText = document.getElementById('categoryPaginationText');
        var pageSize = 8;
        var currentPage = 1;

        function normalized(value) { return (value || '').toLowerCase(); }
        function filteredRows() {
            var q = normalized(search && search.value);
            var typeValue = type ? type.value : '';
            var statusValue = status ? status.value : '';
            return rows.filter(function (row) {
                return (!q || normalized(row.getAttribute('data-search')).indexOf(q) !== -1)
                        && (!typeValue || row.getAttribute('data-type') === typeValue)
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
                paginationText.textContent = visibleRows.length ? ((start + 1) + '-' + end + ' / ' + visibleRows.length) : '<fmt:message key="admin.categories.empty.filter"/>';
            }
            renderPagination(totalPages);
        }
        [search, type, status].forEach(function (field) {
            if (!field) return;
            field.addEventListener('input', function () { currentPage = 1; render(); });
            field.addEventListener('change', function () { currentPage = 1; render(); });
        });
        render();
    })();

    (function () {
        var form = document.getElementById('categoryEditorForm');
        var modal = document.getElementById('categoryConfirmModal');
        var confirmSave = document.getElementById('categoryConfirmSave');
        var nameVi = document.getElementById('categoryNameViInput');
        var nameEn = document.getElementById('categoryNameInput');
        var service = document.getElementById('categoryMealTimeInput');
        var type = document.getElementById('categoryTypeInput');
        var sortOrder = document.getElementById('categorySortOrderInput');
        var active = document.getElementById('categoryActiveInput');
        var confirmed = false;

        function selectedText(select, fallback) {
            return select && select.options[select.selectedIndex] ? select.options[select.selectedIndex].text : fallback;
        }
        function renderConfirm() {
            var title = document.getElementById('categoryConfirmName');
            var english = document.getElementById('categoryConfirmEnglish');
            var serviceLabel = document.getElementById('categoryConfirmService');
            var typeLabel = document.getElementById('categoryConfirmType');
            var orderLabel = document.getElementById('categoryConfirmOrder');
            var statusLabel = document.getElementById('categoryConfirmStatus');
            if (title) title.textContent = (nameVi.value || '').trim() || '<fmt:message key="admin.categories.preview.new"/>';
            if (english) english.textContent = (nameEn.value || '').trim() || '<fmt:message key="admin.categories.preview.noen"/>';
            if (serviceLabel) serviceLabel.textContent = selectedText(service, '<fmt:message key="admin.menusets.label.service.dinner"/>');
            if (typeLabel) typeLabel.textContent = selectedText(type, '<fmt:message key="admin.menuitems.type.appetizer"/>');
            if (orderLabel) orderLabel.textContent = '' + '<fmt:message key="admin.categories.label.sort"/> ' + (sortOrder.value || '1');
            if (statusLabel) {
                statusLabel.textContent = active.checked ? '<fmt:message key="admin.common.active"/>' : '<fmt:message key="admin.common.hidden"/>';
                statusLabel.className = active.checked ? 'badge text-bg-success' : 'badge text-bg-secondary';
            }
        }
        if (form) {
            form.addEventListener('submit', function (event) {
                if (confirmed) return;
                event.preventDefault();
                renderConfirm();
                if (window.bootstrap && modal) {
                    window.bootstrap.Modal.getOrCreateInstance(modal).show();
                } else if (window.confirm('<fmt:message key="admin.categories.modal.review"/>')) {
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

<c:if test="${param.embed != '1'}">
        </div>
    </main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
</c:if>
<c:if test="${param.embed == '1'}">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</c:if>
