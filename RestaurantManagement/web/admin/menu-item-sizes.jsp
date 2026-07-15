<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setLocale value="${sessionScope.lang == 'vi' ? 'vi_VN' : 'en_US'}" />
<fmt:setBundle basename="i18n.messages" />
<jsp:include page="/header.jsp" />
<main class="container py-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4"><div><p class="text-uppercase text-secondary small mb-1"><fmt:message key="admin.dashboard.workspace.title" /></p><h1 class="h3 mb-0"><fmt:message key="admin.itemsizes.title" /></h1></div><a class="btn btn-outline-dark btn-sm" href="MainController?action=adminMenuItems"><fmt:message key="admin.menuitems.title" /></a></div>
    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
    <c:if test="${param.saved == '1'}"><div class="alert alert-success"><fmt:message key="admin.common.saved.success" /></div></c:if>
    <div class="row g-4">
        <div class="col-lg-4">
            <form class="border rounded-3 p-4 bg-light" method="post" action="MainController">
                <input type="hidden" name="action" value="saveMenuItemSize"><input type="hidden" name="id" value="${editSize.id}">
                <h2 class="h5 mb-3">${empty editSize ? '<fmt:message key="admin.itemsizes.create" />' : '<fmt:message key="admin.itemsizes.edit" />'}</h2>
                <label class="form-label"><fmt:message key="admin.itemsizes.label.item" /></label>
                <select class="form-select mb-3" name="menuItemId" required>
                    <c:forEach items="${menuItems}" var="item"><option value="${item.id}" ${not empty editSize && editSize.menuItem.id == item.id ? 'selected' : ''}>${item.itemName}</option></c:forEach>
                </select>
                <label class="form-label"><fmt:message key="admin.itemsizes.label.name" /></label><input class="form-control mb-3" name="sizeName" value="${editSize.sizeName}" required>
                <label class="form-label"><fmt:message key="admin.itemsizes.label.modifier" /></label><input class="form-control mb-3" name="priceModifier" type="number" min="0" step="1" value="${empty editSize ? 0 : editSize.priceModifier}">
                <button class="btn btn-dark w-100" type="submit"><fmt:message key="admin.common.save" /></button>
            </form>
        </div>
        <div class="col-lg-8"><div class="table-responsive"><table class="table align-middle"><thead><tr><th><fmt:message key="admin.itemsizes.col.id" /></th><th><fmt:message key="admin.itemsizes.col.item" /></th><th><fmt:message key="admin.itemsizes.col.size" /></th><th><fmt:message key="admin.itemsizes.col.modifier" /></th><th></th></tr></thead><tbody><c:forEach items="${sizeList}" var="size"><tr><td>${size.id}</td><td>${size.menuItem.itemName}</td><td><strong>${size.sizeName}</strong></td><td><fmt:formatNumber value="${size.priceModifier}" pattern="#,##0"/></td><td class="text-end"><a class="btn btn-outline-dark btn-sm" href="MainController?action=adminMenuItemSizes&id=${size.id}"><fmt:message key="admin.itemsizes.btn.edit" /></a></td></tr></c:forEach></tbody></table></div></div>
    </div>
</main>
<jsp:include page="/footer.jsp" />
