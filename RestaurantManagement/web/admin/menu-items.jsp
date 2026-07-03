<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/header.jsp" />
<main class="container py-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div><p class="text-uppercase text-secondary small mb-1">Restaurant Admin</p><h1 class="h3 mb-0">Menu items</h1></div>
        <div class="btn-group"><a class="btn btn-outline-dark btn-sm" href="MainController?action=adminCategories">Categories</a><a class="btn btn-outline-dark btn-sm" href="MainController?action=adminMenuItemSizes">Sizes</a></div>
    </div>
    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
    <c:if test="${param.saved == '1'}"><div class="alert alert-success">Saved successfully.</div></c:if>
    <div class="row g-4">
        <div class="col-lg-4">
            <form class="border rounded-3 p-4 bg-light" method="post" action="MainController">
                <input type="hidden" name="action" value="saveMenuItem"><input type="hidden" name="id" value="${editMenuItem.id}">
                <h2 class="h5 mb-3">${empty editMenuItem ? 'Create item' : 'Edit item'}</h2>
                <label class="form-label">Category</label>
                <select class="form-select mb-3" name="categoryId" required>
                    <c:forEach items="${categories}" var="cat"><option value="${cat.id}" ${not empty editMenuItem && editMenuItem.category.id == cat.id ? 'selected' : ''}>${cat.categoryName}</option></c:forEach>
                </select>
                <label class="form-label">Item name</label><input class="form-control mb-3" name="itemName" value="${editMenuItem.itemName}" required>
                <label class="form-label">Description</label><textarea class="form-control mb-3" name="description" rows="3">${editMenuItem.description}</textarea>
                <label class="form-label">Image URL</label><input class="form-control mb-3" name="imageUrl" value="${editMenuItem.imageUrl}">
                <label class="form-label">Base price</label><input class="form-control mb-3" name="basePrice" type="number" min="0" step="1" value="${empty editMenuItem ? 0 : editMenuItem.basePrice}">
                <div class="form-check form-switch mb-3"><input class="form-check-input" type="checkbox" name="isAvailable" value="true" ${empty editMenuItem || editMenuItem.isAvailable ? 'checked' : ''}><label class="form-check-label">Available</label></div>
                <button class="btn btn-dark w-100" type="submit">Save</button>
            </form>
        </div>
        <div class="col-lg-8">
            <div class="table-responsive">
                <table class="table align-middle">
                    <thead><tr><th>ID</th><th>Item</th><th>Category</th><th>Price</th><th>Status</th><th></th></tr></thead>
                    <tbody>
                        <c:forEach items="${menuItemList}" var="item">
                            <tr>
                                <td>${item.id}</td>
                                <td><strong>${item.itemName}</strong><div class="small text-secondary">${item.description}</div></td>
                                <td>${item.category.categoryName}</td>
                                <td><fmt:formatNumber value="${item.basePrice}" pattern="#,##0"/></td>
                                <td><span class="badge ${item.isAvailable ? 'text-bg-success' : 'text-bg-secondary'}">${item.isAvailable ? 'Available' : 'Hidden'}</span></td>
                                <td class="text-end"><a class="btn btn-outline-dark btn-sm" href="MainController?action=adminMenuItems&id=${item.id}">Edit</a> <a class="btn btn-outline-secondary btn-sm" href="MainController?action=toggleMenuItem&id=${item.id}&enabled=${!item.isAvailable}">${item.isAvailable ? 'Hide' : 'Show'}</a></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>
<jsp:include page="/footer.jsp" />
