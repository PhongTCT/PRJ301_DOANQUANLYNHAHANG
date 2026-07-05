<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/header.jsp" />
<main class="container py-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4"><div><p class="text-uppercase text-secondary small mb-1">Restaurant Admin</p><h1 class="h3 mb-0">Menu categories</h1></div><a class="btn btn-outline-dark btn-sm" href="MainController?action=adminMenuItems">Menu items</a></div>
    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
    <c:if test="${param.saved == '1'}"><div class="alert alert-success">Saved successfully.</div></c:if>
    <div class="row g-4">
        <div class="col-lg-4">
            <form class="border rounded-3 p-4 bg-light" method="post" action="MainController">
                <input type="hidden" name="action" value="saveMenuCategory"><input type="hidden" name="id" value="${editCategory.id}">
                <h2 class="h5 mb-3">${empty editCategory ? 'Create category' : 'Edit category'}</h2>
                <label class="form-label">Name (VI)</label><input class="form-control mb-3" name="categoryNameVi" value="${editCategory.categoryNameVi}" required>
                <label class="form-label">Name (EN, optional)</label><input class="form-control mb-3" name="categoryName" value="${editCategory.categoryName}">
                <label class="form-label">Service period</label><select class="form-select mb-3" name="mealTime"><option value="LUNCH" ${editCategory.mealTime == 'LUNCH' ? 'selected' : ''}>Lunch Service</option><option value="DINNER" ${editCategory.mealTime == 'DINNER' ? 'selected' : ''}>Dinner Service</option><option value="ALL_DAY" ${empty editCategory || editCategory.mealTime == 'ALL_DAY' || editCategory.mealTime == 'BREAKFAST' ? 'selected' : ''}>All Services</option></select>
                <label class="form-label">Type</label><select class="form-select mb-3" name="categoryType"><option value="APPETIZER" ${editCategory.categoryType == 'APPETIZER' ? 'selected' : ''}>APPETIZER</option><option value="MAIN" ${editCategory.categoryType == 'MAIN' ? 'selected' : ''}>MAIN</option><option value="DESSERT" ${editCategory.categoryType == 'DESSERT' ? 'selected' : ''}>DESSERT</option><option value="DRINK" ${editCategory.categoryType == 'DRINK' ? 'selected' : ''}>DRINK</option><option value="SOUP" ${editCategory.categoryType == 'SOUP' ? 'selected' : ''}>SOUP</option></select>
                <label class="form-label">Sort order</label><input class="form-control mb-3" name="sortOrder" type="number" min="1" value="${empty editCategory ? 1 : editCategory.sortOrder}">
                <div class="form-check form-switch mb-3"><input class="form-check-input" type="checkbox" name="isActive" value="true" ${empty editCategory || editCategory.isActive ? 'checked' : ''}><label class="form-check-label">Active</label></div>
                <button class="btn btn-dark w-100" type="submit">Save</button>
            </form>
        </div>
        <div class="col-lg-8"><div class="table-responsive"><table class="table align-middle"><thead><tr><th>ID</th><th>Name</th><th>Service</th><th>Type</th><th>Order</th><th>Status</th><th></th></tr></thead><tbody><c:forEach items="${categoryList}" var="cat"><tr><td>${cat.id}</td><td><strong>${not empty cat.categoryNameVi ? cat.categoryNameVi : cat.categoryName}</strong><c:if test="${not empty cat.categoryName}"><div class="small text-secondary">${cat.categoryName}</div></c:if></td><td><c:choose><c:when test="${cat.mealTime == 'LUNCH'}">Lunch Service</c:when><c:when test="${cat.mealTime == 'DINNER'}">Dinner Service</c:when><c:otherwise>All Services</c:otherwise></c:choose></td><td>${cat.categoryType}</td><td>${cat.sortOrder}</td><td><span class="badge ${cat.isActive ? 'text-bg-success' : 'text-bg-secondary'}">${cat.isActive ? 'Active' : 'Inactive'}</span></td><td class="text-end"><a class="btn btn-outline-dark btn-sm" href="MainController?action=adminCategories&id=${cat.id}">Edit</a> <a class="btn btn-outline-secondary btn-sm" href="MainController?action=toggleMenuCategory&id=${cat.id}&enabled=${!cat.isActive}">${cat.isActive ? 'Disable' : 'Enable'}</a></td></tr></c:forEach></tbody></table></div></div>
    </div>
</main>
<jsp:include page="/footer.jsp" />
