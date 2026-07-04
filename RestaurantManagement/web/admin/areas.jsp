<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/header.jsp" />
<main class="container py-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
            <p class="text-uppercase text-secondary small mb-1">Restaurant Admin</p>
            <h1 class="h3 mb-0">Areas</h1>
        </div>
        <div class="btn-group flex-wrap">
            <a class="btn btn-dark btn-sm" href="MainController?action=adminAreas">Areas</a>
            <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminRooms">Rooms</a>
            <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminTables">Tables</a>
            <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminCategories">Categories</a>
            <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminMenuItems">Items</a>
            <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminMenuItemSizes">Sizes</a>
            <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminMenuSets">Sets</a>
            <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminAddonServices">Addons</a>
        </div>
    </div>
    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
    <c:if test="${param.saved == '1'}"><div class="alert alert-success">Saved successfully.</div></c:if>
    <div class="row g-4">
        <div class="col-lg-4">
            <form class="border rounded-3 p-4 bg-light" method="post" action="MainController">
                <input type="hidden" name="action" value="saveArea">
                <input type="hidden" name="id" value="${editArea.id}">
                <h2 class="h5 mb-3">${empty editArea ? 'Create area' : 'Edit area'}</h2>
                <label class="form-label">Name</label>
                <input class="form-control mb-3" name="name" value="${editArea.name}" required>
                <label class="form-label">Description</label>
                <textarea class="form-control mb-3" name="description" rows="3">${editArea.description}</textarea>
                <label class="form-label">Price modifier</label>
                <input class="form-control mb-3" name="priceModifier" type="number" min="0" step="1" value="${empty editArea ? 0 : editArea.priceModifier}">
                <div class="form-check form-switch mb-3">
                    <input class="form-check-input" type="checkbox" name="isActive" value="true" ${empty editArea || editArea.isActive ? 'checked' : ''}>
                    <label class="form-check-label">Active</label>
                </div>
                <button class="btn btn-dark w-100" type="submit">Save</button>
            </form>
        </div>
        <div class="col-lg-8">
            <div class="table-responsive">
                <table class="table align-middle">
                    <thead><tr><th>ID</th><th>Name</th><th>Modifier</th><th>Status</th><th></th></tr></thead>
                    <tbody>
                        <c:forEach items="${areaList}" var="area">
                            <tr>
                                <td>${area.id}</td>
                                <td><strong>${area.name}</strong><div class="small text-secondary">${area.description}</div></td>
                                <td><fmt:formatNumber value="${area.priceModifier}" pattern="#,##0"/></td>
                                <td><span class="badge ${area.isActive ? 'text-bg-success' : 'text-bg-secondary'}">${area.isActive ? 'Active' : 'Inactive'}</span></td>
                                <td class="text-end">
                                    <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminAreas&id=${area.id}">Edit</a>
                                    <a class="btn btn-outline-secondary btn-sm" href="MainController?action=toggleArea&id=${area.id}&enabled=${!area.isActive}">${area.isActive ? 'Disable' : 'Enable'}</a>
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
