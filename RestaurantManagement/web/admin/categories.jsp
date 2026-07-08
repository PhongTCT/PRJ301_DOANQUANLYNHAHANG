<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:if test="${param.embed != '1'}">
<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dish groups - Le Royal</title>
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
            <p class="text-uppercase text-secondary small mb-1">Menu items</p>
            <h1 class="h3 mb-1">Dish groups</h1>
            <p class="text-secondary mb-0">These groups organize dishes for filters, courses, and the public menu.</p>
        </div>
        <div class="d-flex flex-wrap gap-2">
            <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminMenuItems${param.embed == '1' ? '&embed=1' : ''}">
                <i class="fa-solid fa-bowl-food me-2"></i>Back to menu items
            </a>
            <button class="btn btn-dark btn-sm" type="button" data-bs-toggle="collapse" data-bs-target="#categoryFormPanel" aria-expanded="${not empty editCategory ? 'true' : 'false'}">
                <i class="fa-solid fa-plus me-2"></i>Add group
            </button>
        </div>
    </div>

    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
    <c:if test="${param.saved == '1'}"><div class="alert alert-success">Saved successfully.</div></c:if>

    <section id="categoryFormPanel" class="collapse ${not empty editCategory ? 'show' : ''} mb-4">
        <form id="categoryEditorForm" class="card" method="post" action="MainController">
            <div class="card-body p-4">
                <input type="hidden" name="action" value="saveMenuCategory">
                <input type="hidden" name="id" value="${editCategory.id}">
                <c:if test="${param.embed == '1'}"><input type="hidden" name="embed" value="1"></c:if>
                <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-3">
                    <div>
                        <div class="admin-section-label">Dish group editor</div>
                        <h2 class="h5 mb-0">${empty editCategory ? 'Create group' : 'Edit group'}</h2>
                    </div>
                    <c:if test="${not empty editCategory}">
                        <a class="btn btn-outline-secondary btn-sm" href="MainController?action=adminCategories${param.embed == '1' ? '&embed=1' : ''}">Clear edit</a>
                    </c:if>
                </div>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Group name (VI)</label>
                        <input id="categoryNameViInput" class="form-control" name="categoryNameVi" value="${editCategory.categoryNameVi}" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Group name (EN, optional)</label>
                        <input id="categoryNameInput" class="form-control" name="categoryName" value="${editCategory.categoryName}">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Service period</label>
                        <select id="categoryMealTimeInput" class="form-select" name="mealTime">
                            <option value="LUNCH" ${editCategory.mealTime == 'LUNCH' ? 'selected' : ''}>Lunch Service</option>
                            <option value="DINNER" ${editCategory.mealTime == 'DINNER' ? 'selected' : ''}>Dinner Service</option>
                            <option value="ALL_DAY" ${empty editCategory || editCategory.mealTime == 'ALL_DAY' || editCategory.mealTime == 'BREAKFAST' ? 'selected' : ''}>All Services</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Course type</label>
                        <select id="categoryTypeInput" class="form-select" name="categoryType">
                            <option value="APPETIZER" ${editCategory.categoryType == 'APPETIZER' ? 'selected' : ''}>Appetizer</option>
                            <option value="SOUP" ${editCategory.categoryType == 'SOUP' ? 'selected' : ''}>Soup</option>
                            <option value="MAIN" ${editCategory.categoryType == 'MAIN' ? 'selected' : ''}>Main</option>
                            <option value="DESSERT" ${editCategory.categoryType == 'DESSERT' ? 'selected' : ''}>Dessert</option>
                            <option value="DRINK" ${editCategory.categoryType == 'DRINK' ? 'selected' : ''}>Drink</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Sort order</label>
                        <input id="categorySortOrderInput" class="form-control" name="sortOrder" type="number" min="1" value="${empty editCategory ? 1 : editCategory.sortOrder}">
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <div class="form-check form-switch mb-2">
                            <input id="categoryActiveInput" class="form-check-input" type="checkbox" name="isActive" value="true" ${empty editCategory || editCategory.isActive ? 'checked' : ''}>
                            <label class="form-check-label">Active</label>
                        </div>
                    </div>
                    <div class="col-12 d-flex justify-content-end">
                        <button class="btn btn-dark px-4" type="submit">Save group</button>
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
                        <p class="text-uppercase text-secondary small mb-1">Confirm dish group</p>
                        <h5 class="modal-title" id="categoryConfirmTitle">Review group</h5>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <h3 id="categoryConfirmName" class="h5 mb-2">New group</h3>
                    <p id="categoryConfirmEnglish" class="text-secondary mb-3">No English name.</p>
                    <div class="d-flex flex-wrap gap-2">
                        <span id="categoryConfirmService" class="badge text-bg-light border text-dark">All Services</span>
                        <span id="categoryConfirmType" class="badge text-bg-light border text-dark">Appetizer</span>
                        <span id="categoryConfirmOrder" class="badge text-bg-light border text-dark">Order 1</span>
                        <span id="categoryConfirmStatus" class="badge text-bg-success">Active</span>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Keep editing</button>
                    <button id="categoryConfirmSave" type="button" class="btn btn-dark">Confirm save</button>
                </div>
            </div>
        </div>
    </div>

    <section class="card">
        <div class="card-body p-4">
            <div class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-3">
                <div>
                    <div class="admin-section-label">Menu structure</div>
                    <h2 class="h5 mb-0">Dish groups used by menu items</h2>
                </div>
                <div class="small text-secondary">${categoryList.size()} groups</div>
            </div>
            <div class="row g-2 mb-3">
                <div class="col-lg-6">
                    <div class="input-group">
                        <span class="input-group-text"><i class="fa-solid fa-magnifying-glass"></i></span>
                        <input id="categorySearch" class="form-control" type="search" placeholder="Search group name">
                    </div>
                </div>
                <div class="col-sm-6 col-lg-3">
                    <select id="categoryTypeFilter" class="form-select">
                        <option value="">All types</option>
                        <option value="APPETIZER">Appetizer</option>
                        <option value="SOUP">Soup</option>
                        <option value="MAIN">Main</option>
                        <option value="DESSERT">Dessert</option>
                        <option value="DRINK">Drink</option>
                    </select>
                </div>
                <div class="col-sm-6 col-lg-2">
                    <select id="categoryStatusFilter" class="form-select">
                        <option value="">All status</option>
                        <option value="active">Active</option>
                        <option value="hidden">Hidden</option>
                    </select>
                </div>
            </div>
            <div class="table-responsive">
                <table class="table align-middle">
                    <thead>
                        <tr>
                            <th>Group</th>
                            <th>Service</th>
                            <th>Course type</th>
                            <th>Order</th>
                            <th>Status</th>
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
                                    <strong>${not empty cat.categoryNameVi ? cat.categoryNameVi : cat.categoryName}</strong>
                                    <c:if test="${not empty cat.categoryName}"><div class="small text-secondary">${cat.categoryName}</div></c:if>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${cat.mealTime == 'LUNCH'}">Lunch Service</c:when>
                                        <c:when test="${cat.mealTime == 'DINNER'}">Dinner Service</c:when>
                                        <c:otherwise>All Services</c:otherwise>
                                    </c:choose>
                                </td>
                                <td><span class="badge bg-light">${cat.categoryType}</span></td>
                                <td>${cat.sortOrder}</td>
                                <td><span class="badge ${cat.isActive ? 'text-bg-success' : 'text-bg-secondary'}">${cat.isActive ? 'Active' : 'Hidden'}</span></td>
                                <td class="text-end">
                                    <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminCategories&id=${cat.id}${param.embed == '1' ? '&embed=1' : ''}">Edit</a>
                                    <a class="btn btn-outline-secondary btn-sm" href="MainController?action=toggleMenuCategory&id=${cat.id}&enabled=${!cat.isActive}${param.embed == '1' ? '&embed=1' : ''}">${cat.isActive ? 'Hide' : 'Restore'}</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty categoryList}">
                            <tr><td colspan="6" class="text-center text-secondary py-5">No dish groups yet.</td></tr>
                        </c:if>
                        <tr id="categoryEmpty" class="d-none"><td colspan="6" class="text-center text-secondary py-5">No dish groups match these filters.</td></tr>
                    </tbody>
                </table>
            </div>
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mt-3">
                <div id="categoryPaginationText" class="small text-secondary"></div>
                <div id="categoryPagination" class="btn-group btn-group-sm" role="group" aria-label="Dish group pagination"></div>
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
                paginationText.textContent = visibleRows.length ? ('Showing ' + (start + 1) + '-' + end + ' of ' + visibleRows.length) : 'No dish groups';
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
            if (title) title.textContent = (nameVi.value || '').trim() || 'New group';
            if (english) english.textContent = (nameEn.value || '').trim() || 'No English name.';
            if (serviceLabel) serviceLabel.textContent = selectedText(service, 'All Services');
            if (typeLabel) typeLabel.textContent = selectedText(type, 'Appetizer');
            if (orderLabel) orderLabel.textContent = 'Order ' + (sortOrder.value || '1');
            if (statusLabel) {
                statusLabel.textContent = active.checked ? 'Active' : 'Hidden';
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
                } else if (window.confirm('Review this dish group and save?')) {
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
