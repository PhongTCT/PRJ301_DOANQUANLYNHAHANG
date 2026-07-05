<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/header.jsp" />
<main class="container py-4 py-lg-5">
    <div class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-4">
        <div>
            <p class="text-uppercase text-secondary small mb-1">Restaurant Admin</p>
            <h1 class="h3 mb-1">Menu items</h1>
            <p class="text-secondary mb-0">Search, filter and manage dishes without leaving the admin workspace.</p>
        </div>
        <div class="d-flex flex-wrap gap-2">
            <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminMenuSets">
                <i class="fa-solid fa-layer-group me-2"></i>Set menus
            </a>
            <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminCategories">
                <i class="fa-solid fa-list-ul me-2"></i>Categories
            </a>
            <button class="btn btn-dark btn-sm" type="button" data-bs-toggle="collapse" data-bs-target="#menuItemFormPanel" aria-expanded="${not empty editMenuItem ? 'true' : 'false'}">
                <i class="fa-solid fa-plus me-2"></i>Add item
            </button>
        </div>
    </div>

    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
    <c:if test="${param.saved == '1'}"><div class="alert alert-success">Saved successfully.</div></c:if>

    <section id="menuItemFormPanel" class="collapse ${not empty editMenuItem ? 'show' : ''} mb-4">
        <form class="card" method="post" action="MainController">
            <div class="card-body p-4">
                <input type="hidden" name="action" value="saveMenuItem">
                <input type="hidden" name="id" value="${editMenuItem.id}">
                <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-3">
                    <div>
                        <div class="admin-section-label">Dish editor</div>
                        <h2 class="h5 mb-0">${empty editMenuItem ? 'Create item' : 'Edit item'}</h2>
                    </div>
                    <c:if test="${not empty editMenuItem}">
                        <a class="btn btn-outline-secondary btn-sm" href="MainController?action=adminMenuItems">Clear edit</a>
                    </c:if>
                </div>
                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label">Category</label>
                        <select class="form-select" name="categoryId" required>
                            <c:forEach items="${categories}" var="cat">
                                <option value="${cat.id}" ${not empty editMenuItem && editMenuItem.category.id == cat.id ? 'selected' : ''}>${not empty cat.categoryNameVi ? cat.categoryNameVi : cat.categoryName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Item name (VI)</label>
                        <input class="form-control" name="itemNameVi" value="${editMenuItem.itemNameVi}" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Item name (EN, optional)</label>
                        <input class="form-control" name="itemName" value="${editMenuItem.itemName}">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Description (VI)</label>
                        <textarea class="form-control" name="descriptionVi" rows="3">${editMenuItem.descriptionVi}</textarea>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Description (EN, optional)</label>
                        <textarea class="form-control" name="description" rows="3">${editMenuItem.description}</textarea>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Image URL</label>
                        <input class="form-control" name="imageUrl" value="${editMenuItem.imageUrl}">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Base price</label>
                        <input class="form-control" name="basePrice" type="number" min="0" step="1" value="${empty editMenuItem ? 0 : editMenuItem.basePrice}">
                    </div>
                    <div class="col-md-3 d-flex align-items-end">
                        <div class="form-check form-switch mb-2">
                            <input class="form-check-input" type="checkbox" name="isAvailable" value="true" ${empty editMenuItem || editMenuItem.isAvailable ? 'checked' : ''}>
                            <label class="form-check-label">Available</label>
                        </div>
                    </div>
                    <div class="col-12 d-flex justify-content-end">
                        <button class="btn btn-dark px-4" type="submit">Save item</button>
                    </div>
                </div>
            </div>
        </form>
    </section>

    <section class="card">
        <div class="card-body p-4">
            <div class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-3">
                <div>
                    <div class="admin-section-label">Dish library</div>
                    <h2 class="h5 mb-0">All dishes</h2>
                </div>
                <div class="small text-secondary"><span id="menuItemResultCount">${menuItemList.size()}</span> items</div>
            </div>

            <div class="row g-2 mb-3">
                <div class="col-lg-4">
                    <div class="input-group">
                        <span class="input-group-text"><i class="fa-solid fa-magnifying-glass"></i></span>
                        <input id="menuItemSearch" class="form-control" type="search" placeholder="Search dish name or description">
                    </div>
                </div>
                <div class="col-sm-6 col-lg-3">
                    <select id="menuCategoryFilter" class="form-select">
                        <option value="">All categories</option>
                        <c:forEach items="${categories}" var="cat">
                            <option value="${cat.id}">${not empty cat.categoryNameVi ? cat.categoryNameVi : cat.categoryName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-sm-6 col-lg-2">
                    <select id="menuTypeFilter" class="form-select">
                        <option value="">All types</option>
                        <option value="APPETIZER">Appetizer</option>
                        <option value="SOUP">Soup</option>
                        <option value="MAIN">Main</option>
                        <option value="DESSERT">Dessert</option>
                        <option value="DRINK">Drink</option>
                    </select>
                </div>
                <div class="col-sm-6 col-lg-2">
                    <select id="menuStatusFilter" class="form-select">
                        <option value="">All status</option>
                        <option value="available">Available</option>
                        <option value="hidden">Hidden</option>
                    </select>
                </div>
                <div class="col-sm-6 col-lg-1">
                    <button id="menuFilterReset" class="btn btn-outline-secondary w-100" type="button" title="Reset filters">
                        <i class="fa-solid fa-rotate-left"></i>
                    </button>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table align-middle">
                    <thead>
                        <tr>
                            <th>Dish</th>
                            <th>Category</th>
                            <th>Type</th>
                            <th>Price</th>
                            <th>Status</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody id="menuItemRows">
                        <c:forEach items="${menuItemList}" var="item">
                            <tr data-menu-row
                                data-search="${not empty item.itemNameVi ? item.itemNameVi : ''} ${not empty item.itemName ? item.itemName : ''} ${not empty item.descriptionVi ? item.descriptionVi : ''} ${not empty item.description ? item.description : ''}"
                                data-category="${item.category.id}"
                                data-type="${item.category.categoryType}"
                                data-status="${item.isAvailable ? 'available' : 'hidden'}">
                                <td>
                                    <div class="d-flex align-items-center gap-3">
                                        <c:choose>
                                            <c:when test="${not empty item.imageUrl}">
                                                <img class="admin-menu-thumb" src="${pageContext.request.contextPath}/${item.imageUrl}" alt="">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="admin-menu-thumb admin-menu-thumb--empty"><i class="fa-solid fa-bowl-food"></i></div>
                                            </c:otherwise>
                                        </c:choose>
                                        <div>
                                            <strong>${not empty item.itemNameVi ? item.itemNameVi : item.itemName}</strong>
                                            <c:if test="${not empty item.itemName}"><div class="small text-secondary">${item.itemName}</div></c:if>
                                            <div class="small text-secondary">${not empty item.descriptionVi ? item.descriptionVi : item.description}</div>
                                        </div>
                                    </div>
                                </td>
                                <td>${not empty item.category.categoryNameVi ? item.category.categoryNameVi : item.category.categoryName}</td>
                                <td><span class="badge bg-light">${item.category.categoryType}</span></td>
                                <td><fmt:formatNumber value="${item.basePrice}" pattern="#,##0"/></td>
                                <td><span class="badge ${item.isAvailable ? 'text-bg-success' : 'text-bg-secondary'}">${item.isAvailable ? 'Available' : 'Hidden'}</span></td>
                                <td class="text-end">
                                    <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminMenuItems&id=${item.id}">Edit</a>
                                    <a class="btn btn-outline-secondary btn-sm" href="MainController?action=toggleMenuItem&id=${item.id}&enabled=${!item.isAvailable}">${item.isAvailable ? 'Hide' : 'Show'}</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <tr id="menuItemEmpty" class="d-none">
                            <td colspan="6" class="text-center text-secondary py-5">No dishes match these filters.</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mt-3">
                <div id="menuPaginationText" class="small text-secondary"></div>
                <div id="menuPagination" class="btn-group btn-group-sm" role="group" aria-label="Menu item pagination"></div>
            </div>
        </div>
    </section>
</main>
<script>
    (function () {
        var rows = Array.prototype.slice.call(document.querySelectorAll('[data-menu-row]'));
        var search = document.getElementById('menuItemSearch');
        var category = document.getElementById('menuCategoryFilter');
        var type = document.getElementById('menuTypeFilter');
        var status = document.getElementById('menuStatusFilter');
        var reset = document.getElementById('menuFilterReset');
        var empty = document.getElementById('menuItemEmpty');
        var count = document.getElementById('menuItemResultCount');
        var pagination = document.getElementById('menuPagination');
        var paginationText = document.getElementById('menuPaginationText');
        var pageSize = 8;
        var currentPage = 1;

        function normalized(value) {
            return (value || '').toLowerCase();
        }

        function filteredRows() {
            var q = normalized(search && search.value);
            var categoryValue = category ? category.value : '';
            var typeValue = type ? type.value : '';
            var statusValue = status ? status.value : '';
            return rows.filter(function (row) {
                var matchesSearch = !q || normalized(row.getAttribute('data-search')).indexOf(q) !== -1;
                var matchesCategory = !categoryValue || row.getAttribute('data-category') === categoryValue;
                var matchesType = !typeValue || row.getAttribute('data-type') === typeValue;
                var matchesStatus = !statusValue || row.getAttribute('data-status') === statusValue;
                return matchesSearch && matchesCategory && matchesType && matchesStatus;
            });
        }

        function render() {
            var visibleRows = filteredRows();
            var totalPages = Math.max(1, Math.ceil(visibleRows.length / pageSize));
            if (currentPage > totalPages) {
                currentPage = totalPages;
            }
            rows.forEach(function (row) {
                row.classList.add('d-none');
            });
            var start = (currentPage - 1) * pageSize;
            visibleRows.slice(start, start + pageSize).forEach(function (row) {
                row.classList.remove('d-none');
            });
            if (empty) {
                empty.classList.toggle('d-none', visibleRows.length > 0);
            }
            if (count) {
                count.textContent = visibleRows.length;
            }
            if (paginationText) {
                var end = Math.min(start + pageSize, visibleRows.length);
                paginationText.textContent = visibleRows.length ? ('Showing ' + (start + 1) + '-' + end + ' of ' + visibleRows.length) : 'No items';
            }
            renderPagination(totalPages);
        }

        function renderPagination(totalPages) {
            if (!pagination) {
                return;
            }
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

        [search, category, type, status].forEach(function (field) {
            if (field) {
                field.addEventListener('input', function () {
                    currentPage = 1;
                    render();
                });
                field.addEventListener('change', function () {
                    currentPage = 1;
                    render();
                });
            }
        });
        if (reset) {
            reset.addEventListener('click', function () {
                if (search) search.value = '';
                if (category) category.value = '';
                if (type) type.value = '';
                if (status) status.value = '';
                currentPage = 1;
                render();
            });
        }
        render();
    })();
</script>
<jsp:include page="/footer.jsp" />
