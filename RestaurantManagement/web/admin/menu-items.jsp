<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:if test="${param.embed != '1'}">
<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menu items - Le Royal</title>
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
        <div class="admin-shell">
</c:if>
<c:if test="${param.embed == '1'}">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Marcellus&family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-royal.css">
    <script>document.body.classList.add('admin-royal');</script>
    <style>body { margin: 0; background: transparent; }</style>
    <main class="container-fluid py-4">
</c:if>
    <div class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-4">
        <div>
            <p class="text-uppercase text-secondary small mb-1">Restaurant Admin</p>
            <h1 class="h3 mb-1">Menu items</h1>
            <p class="text-secondary mb-0">Search, filter and manage dishes without leaving the admin workspace.</p>
        </div>
        <div class="d-flex flex-wrap gap-2">
            <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminMenuSets${param.embed == '1' ? '&embed=1' : ''}">
                <i class="fa-solid fa-layer-group me-2"></i>Set menus
            </a>
            <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminCategories${param.embed == '1' ? '&embed=1' : ''}">
                <i class="fa-solid fa-list-ul me-2"></i>Manage dish groups
            </a>
            <button class="btn btn-dark btn-sm" type="button" data-bs-toggle="collapse" data-bs-target="#menuItemFormPanel" aria-expanded="${not empty editMenuItem ? 'true' : 'false'}">
                <i class="fa-solid fa-plus me-2"></i>Add item
            </button>
        </div>
    </div>

    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
    <c:if test="${param.saved == '1'}"><div class="alert alert-success">Saved successfully.</div></c:if>

    <section id="menuItemFormPanel" class="collapse ${not empty editMenuItem ? 'show' : ''} mb-4">
        <form id="menuItemEditorForm" class="card" method="post" action="MainController" enctype="multipart/form-data">
            <div class="card-body p-4">
                <input type="hidden" name="action" value="saveMenuItem">
                <input type="hidden" name="id" value="${editMenuItem.id}">
                <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-3">
                    <div>
                        <div class="admin-section-label">Dish editor</div>
                        <h2 class="h5 mb-0">${empty editMenuItem ? 'Create item' : 'Edit item'}</h2>
                    </div>
                    <c:if test="${not empty editMenuItem}">
                        <a class="btn btn-outline-secondary btn-sm" href="MainController?action=adminMenuItems${param.embed == '1' ? '&embed=1' : ''}">Clear edit</a>
                    </c:if>
                </div>
                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label">Category</label>
                        <select id="draftItemCategory" class="form-select" name="categoryId" required>
                            <c:forEach items="${categories}" var="cat">
                                <option value="${cat.id}" ${not empty editMenuItem && editMenuItem.category.id == cat.id ? 'selected' : ''}>${not empty cat.categoryNameVi ? cat.categoryNameVi : cat.categoryName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Item name (VI)</label>
                        <input id="draftItemName" class="form-control" name="itemNameVi" value="${editMenuItem.itemNameVi}" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Item name (EN, optional)</label>
                        <input class="form-control" name="itemName" value="${editMenuItem.itemName}">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Description (VI)</label>
                        <textarea id="draftItemDescription" class="form-control" name="descriptionVi" rows="3">${editMenuItem.descriptionVi}</textarea>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Description (EN, optional)</label>
                        <textarea class="form-control" name="description" rows="3">${editMenuItem.description}</textarea>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Image URL</label>
                        <input id="draftItemImage" class="form-control" name="imageUrl" value="${editMenuItem.imageUrl}">
                        <div class="form-text">Paste an existing URL, or upload a new image below.</div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Upload image</label>
                        <input id="draftItemImageFile" class="form-control" name="imageFile" type="file" accept="image/*">
                        <div class="form-text">Cloudinary will store the image and save the returned link.</div>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Base price</label>
                        <input id="draftItemPrice" class="form-control" name="basePrice" type="number" min="0" step="1" value="${empty editMenuItem ? 0 : editMenuItem.basePrice}">
                    </div>
                    <div class="col-md-3 d-flex align-items-end">
                        <div class="form-check form-switch mb-2">
                            <input id="draftItemAvailable" class="form-check-input" type="checkbox" name="isAvailable" value="true" ${empty editMenuItem || editMenuItem.isAvailable ? 'checked' : ''}>
                            <label class="form-check-label">Available</label>
                        </div>
                    </div>
                    <div class="col-12 d-flex justify-content-end">
                        <button class="btn btn-dark px-4" type="submit">Save item</button>
                    </div>
                    <div class="col-12">
                        <aside class="admin-draft-preview rounded-3 p-3">
                            <div class="row g-3 align-items-center">
                                <div class="col-md-4">
                                    <div id="draftItemImageWrap" class="admin-draft-placeholder rounded-3 d-flex align-items-center justify-content-center">
                                        <i class="fa-solid fa-bowl-food fa-2x"></i>
                                    </div>
                                </div>
                                <div class="col-md-8">
                                    <p class="text-uppercase text-secondary small mb-1">Draft preview</p>
                                    <h3 id="draftItemTitle" class="h5 mb-1">New dish</h3>
                                    <p id="draftItemText" class="text-secondary mb-2">No description yet.</p>
                                    <div class="d-flex flex-wrap gap-2">
                                        <span id="draftItemCategoryLabel" class="badge text-bg-light border text-dark">Category</span>
                                        <span id="draftItemPriceLabel" class="badge text-bg-light border text-dark">0đ</span>
                                        <span id="draftItemStatusLabel" class="badge text-bg-success">Available</span>
                                    </div>
                                </div>
                            </div>
                        </aside>
                    </div>
                </div>
            </div>
        </form>
    </section>

    <div class="modal fade" id="menuItemConfirmModal" tabindex="-1" aria-labelledby="menuItemConfirmTitle" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header">
                    <div>
                        <p class="text-uppercase text-secondary small mb-1">Confirm dish</p>
                        <h5 class="modal-title" id="menuItemConfirmTitle">Review menu item</h5>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="menu-confirm-summary mb-3">
                        <div id="menuItemConfirmImage" class="menu-confirm-hero" style="width:280px; height:110px; max-width:100%; margin:0 auto;">
                            <i class="fa-solid fa-bowl-food fa-2x"></i>
                        </div>
                    </div>
                    <div class="row g-3 align-items-center">
                        <div class="col-12">
                            <h3 id="menuItemConfirmName" class="h5 mb-1">New dish</h3>
                            <p id="menuItemConfirmText" class="text-secondary mb-2">No description yet.</p>
                            <div class="d-flex flex-wrap gap-2">
                                <span id="menuItemConfirmCategory" class="badge text-bg-light border text-dark">Category</span>
                                <span id="menuItemConfirmPrice" class="badge text-bg-light border text-dark">0đ</span>
                                <span id="menuItemConfirmStatus" class="badge text-bg-success">Available</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Keep editing</button>
                    <button id="menuItemConfirmSave" type="button" class="btn btn-dark">Confirm save</button>
                </div>
            </div>
        </div>
    </div>

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
                                                <c:choose>
                                                    <c:when test="${fn:startsWith(item.imageUrl, 'http') || fn:startsWith(item.imageUrl, '/')}">
                                                        <img class="admin-menu-thumb" src="${item.imageUrl}" alt="">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img class="admin-menu-thumb" src="${pageContext.request.contextPath}/${item.imageUrl}" alt="">
                                                    </c:otherwise>
                                                </c:choose>
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
                                    <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminMenuItems&id=${item.id}${param.embed == '1' ? '&embed=1' : ''}">Edit</a>
                                    <a class="btn btn-outline-secondary btn-sm" href="MainController?action=toggleMenuItem&id=${item.id}&enabled=${!item.isAvailable}${param.embed == '1' ? '&embed=1' : ''}">${item.isAvailable ? 'Hide' : 'Restore'}</a>
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
<c:if test="${param.embed != '1'}">
        </div>
</c:if>
</main>
<script>
    (function () {
        var rows = Array.prototype.slice.call(document.querySelectorAll('[data-menu-row]'));
        var search = document.getElementById('menuItemSearch');
        var category = document.getElementById('menuCategoryFilter');
        var type = document.getElementById('menuTypeFilter');
        var status = document.getElementById('menuStatusFilter');
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
        render();
    })();

    (function () {
        var contextPath = '${pageContext.request.contextPath}';
        var name = document.getElementById('draftItemName');
        var description = document.getElementById('draftItemDescription');
        var category = document.getElementById('draftItemCategory');
        var price = document.getElementById('draftItemPrice');
        var image = document.getElementById('draftItemImage');
        var available = document.getElementById('draftItemAvailable');
        var imageWrap = document.getElementById('draftItemImageWrap');
        var title = document.getElementById('draftItemTitle');
        var text = document.getElementById('draftItemText');
        var categoryLabel = document.getElementById('draftItemCategoryLabel');
        var priceLabel = document.getElementById('draftItemPriceLabel');
        var statusLabel = document.getElementById('draftItemStatusLabel');

        function imageSrc(value) {
            value = (value || '').trim();
            if (!value) return '';
            return (/^(https?:)?\/\//i.test(value) || value.charAt(0) === '/') ? value : contextPath + '/' + value;
        }
        function money(value) {
            var number = Number(value || 0);
            return (isNaN(number) ? 0 : number).toLocaleString('vi-VN') + 'đ';
        }
        function renderDraft() {
            if (!title || !imageWrap) return;
            title.textContent = (name.value || '').trim() || 'New dish';
            text.textContent = (description.value || '').trim() || 'No description yet.';
            categoryLabel.textContent = category.options[category.selectedIndex] ? category.options[category.selectedIndex].text : 'Category';
            priceLabel.textContent = money(price.value);
            statusLabel.textContent = available.checked ? 'Available' : 'Hidden';
            statusLabel.className = available.checked ? 'badge text-bg-success' : 'badge text-bg-secondary';
            var src = imageSrc(image.value);
            imageWrap.innerHTML = src
                    ? '<img class="rounded-3" src="' + src + '" alt="">'
                    : '<i class="fa-solid fa-bowl-food fa-2x"></i>';
        }
        [name, description, category, price, image, available].forEach(function (field) {
            if (!field) return;
            field.addEventListener('input', renderDraft);
            field.addEventListener('change', renderDraft);
        });
        renderDraft();

        var form = document.getElementById('menuItemEditorForm');
        var modal = document.getElementById('menuItemConfirmModal');
        var confirmSave = document.getElementById('menuItemConfirmSave');
        var confirmed = false;
        function renderConfirm() {
            renderDraft();
            var confirmImage = document.getElementById('menuItemConfirmImage');
            var confirmName = document.getElementById('menuItemConfirmName');
            var confirmText = document.getElementById('menuItemConfirmText');
            var confirmCategory = document.getElementById('menuItemConfirmCategory');
            var confirmPrice = document.getElementById('menuItemConfirmPrice');
            var confirmStatus = document.getElementById('menuItemConfirmStatus');
            if (confirmImage) {
                var src = imageSrc(image.value);
                confirmImage.innerHTML = src
                        ? '<img style="width:100%; height:100%; object-fit:cover;" src="' + src + '" alt="">'
                        : '<i class="fa-solid fa-bowl-food fa-2x"></i>';
            }
            if (confirmName && title) confirmName.textContent = title.textContent;
            if (confirmText && text) confirmText.textContent = text.textContent;
            if (confirmCategory && categoryLabel) confirmCategory.textContent = categoryLabel.textContent;
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
                } else if (window.confirm('Review this dish and save?')) {
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
<c:if test="${param.embed == '1'}">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</c:if>
<c:if test="${param.embed != '1'}">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </div>
</div>
</body>
</html>
</c:if>
