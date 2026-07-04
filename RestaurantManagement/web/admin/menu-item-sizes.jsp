<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/header.jsp" />
<main class="container py-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4"><div><p class="text-uppercase text-secondary small mb-1">Restaurant Admin</p><h1 class="h3 mb-0">Menu item sizes</h1></div><a class="btn btn-outline-dark btn-sm" href="MainController?action=adminMenuItems">Menu items</a></div>
    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
    <c:if test="${param.saved == '1'}"><div class="alert alert-success">Saved successfully.</div></c:if>
    <div class="row g-4">
        <div class="col-lg-4">
            <form class="border rounded-3 p-4 bg-light" method="post" action="MainController">
                <input type="hidden" name="action" value="saveMenuItemSize"><input type="hidden" name="id" value="${editSize.id}">
                <h2 class="h5 mb-3">${empty editSize ? 'Create size' : 'Edit size'}</h2>
                <label class="form-label">Menu item</label>
                <select class="form-select mb-3" name="menuItemId" required>
                    <c:forEach items="${menuItems}" var="item"><option value="${item.id}" ${not empty editSize && editSize.menuItem.id == item.id ? 'selected' : ''}>${item.itemName}</option></c:forEach>
                </select>
                <label class="form-label">Size name</label><input class="form-control mb-3" name="sizeName" value="${editSize.sizeName}" required>
                <label class="form-label">Price modifier</label><input class="form-control mb-3" name="priceModifier" type="number" min="0" step="1" value="${empty editSize ? 0 : editSize.priceModifier}">
                <button class="btn btn-dark w-100" type="submit">Save</button>
            </form>
        </div>
        <div class="col-lg-8"><div class="table-responsive"><table class="table align-middle"><thead><tr><th>ID</th><th>Item</th><th>Size</th><th>Modifier</th><th></th></tr></thead><tbody><c:forEach items="${sizeList}" var="size"><tr><td>${size.id}</td><td>${size.menuItem.itemName}</td><td><strong>${size.sizeName}</strong></td><td><fmt:formatNumber value="${size.priceModifier}" pattern="#,##0"/></td><td class="text-end"><a class="btn btn-outline-dark btn-sm" href="MainController?action=adminMenuItemSizes&id=${size.id}">Edit</a></td></tr></c:forEach></tbody></table></div></div>
    </div>
</main>
<jsp:include page="/footer.jsp" />
