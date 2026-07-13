<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setLocale value="${sessionScope.lang == 'en' ? 'en_US' : 'vi_VN'}" />
<fmt:setBundle basename="i18n.messages" />
<jsp:include page="/header.jsp" />
<main class="container py-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
            <p class="text-uppercase text-secondary small mb-1"><fmt:message key="admin.dashboard.workspace.title" /></p>
            <h1 class="h3 mb-0"><fmt:message key="admin.areas.title" /></h1>
        </div>
        <div class="btn-group flex-wrap">
            <a class="btn btn-dark btn-sm" href="MainController?action=adminAreas"><fmt:message key="admin.areas.title" /></a>
            <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminRooms"><fmt:message key="admin.rooms.title" /></a>
            <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminTables"><fmt:message key="admin.tables.title" /></a>
            <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminCategories"><fmt:message key="admin.categories.title" /></a>
            <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminMenuItems"><fmt:message key="admin.menuitems.title" /></a>
            <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminMenuItemSizes"><fmt:message key="admin.itemsizes.title" /></a>
            <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminMenuSets"><fmt:message key="admin.menusets.title" /></a>
            <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminAddonServices"><fmt:message key="admin.addons.title" /></a>
        </div>
    </div>
    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
    <c:if test="${param.saved == '1'}"><div class="alert alert-success"><fmt:message key="admin.common.saved.success" /></div></c:if>
    <div class="row g-4">
        <div class="col-lg-4">
            <form class="border rounded-3 p-4 bg-light" method="post" action="MainController">
                <input type="hidden" name="action" value="saveArea">
                <input type="hidden" name="id" value="${editArea.id}">
                <h2 class="h5 mb-3">${empty editArea ? '<fmt:message key="admin.areas.create" />' : '<fmt:message key="admin.areas.edit" />'}</h2>
                <label class="form-label"><fmt:message key="admin.areas.label.name" /></label>
                <input class="form-control mb-3" name="name" value="${editArea.name}" required>
                <label class="form-label"><fmt:message key="admin.areas.label.desc" /></label>
                <textarea class="form-control mb-3" name="description" rows="3">${editArea.description}</textarea>
                <label class="form-label"><fmt:message key="admin.areas.label.modifier" /></label>
                <input class="form-control mb-3" name="priceModifier" type="number" min="0" step="1" value="${empty editArea ? 0 : editArea.priceModifier}">
                <div class="form-check form-switch mb-3">
                    <input class="form-check-input" type="checkbox" name="isActive" value="true" ${empty editArea || editArea.isActive ? 'checked' : ''}>
                    <label class="form-check-label"><fmt:message key="admin.common.active.switch" /></label>
                </div>
                <button class="btn btn-dark w-100" type="submit"><fmt:message key="admin.common.save" /></button>
            </form>
        </div>
        <div class="col-lg-8">
            <div class="table-responsive">
                <table class="table align-middle">
                    <thead><tr><th><fmt:message key="admin.areas.col.id" /></th><th><fmt:message key="admin.areas.col.name" /></th><th><fmt:message key="admin.areas.col.modifier" /></th><th><fmt:message key="admin.areas.col.status" /></th><th></th></tr></thead>
                    <tbody>
                        <c:forEach items="${areaList}" var="area">
                            <tr>
                                <td>${area.id}</td>
                                <td><strong>${area.name}</strong><div class="small text-secondary">${area.description}</div></td>
                                <td><fmt:formatNumber value="${area.priceModifier}" pattern="#,##0"/></td>
                                <td><span class="badge ${area.isActive ? 'text-bg-success' : 'text-bg-secondary'}">${area.isActive ? '<fmt:message key="admin.common.active" />' : '<fmt:message key="admin.common.inactive" />'}</span></td>
                                <td class="text-end">
                                    <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminAreas&id=${area.id}"><fmt:message key="admin.areas.btn.edit" /></a>
                                    <a class="btn btn-outline-secondary btn-sm" href="MainController?action=toggleArea&id=${area.id}&enabled=${!area.isActive}">${area.isActive ? '<fmt:message key="admin.areas.btn.disable" />' : '<fmt:message key="admin.areas.btn.enable" />'}</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>
<jsp:include page="/footer.jsp" />