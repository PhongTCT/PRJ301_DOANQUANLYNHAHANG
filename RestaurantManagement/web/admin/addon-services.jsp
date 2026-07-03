<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/header.jsp" />
<main class="container py-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
            <p class="text-uppercase text-secondary small mb-1">Restaurant Admin</p>
            <h1 class="h3 mb-0">Addon services</h1>
        </div>
        <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminAreas">Restaurant admin</a>
    </div>
    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
    <c:if test="${param.saved == '1'}"><div class="alert alert-success">Saved successfully.</div></c:if>
    <div class="row g-4">
        <div class="col-lg-4">
            <form class="border rounded-3 p-4 bg-light" method="post" action="MainController">
                <input type="hidden" name="action" value="saveAddonService">
                <input type="hidden" name="id" value="${editAddon.id}">
                <h2 class="h5 mb-3">${empty editAddon ? 'Create addon' : 'Edit addon'}</h2>
                <label class="form-label">Service name</label>
                <input class="form-control mb-3" name="serviceName" value="${editAddon.serviceName}" required>
                <label class="form-label">Description</label>
                <textarea class="form-control mb-3" name="description" rows="3">${editAddon.description}</textarea>
                <label class="form-label">Price</label>
                <input class="form-control mb-3" name="price" type="number" min="0" step="1" value="${empty editAddon ? 0 : editAddon.price}">
                <label class="form-label">Image URL</label>
                <input class="form-control mb-3" name="imageUrl" value="${editAddon.imageUrl}" placeholder="assets/img/le-royal/Private Live Pianist.jpg">
                <div class="form-check form-switch mb-3">
                    <input class="form-check-input" type="checkbox" name="isAvailable" value="true" ${empty editAddon || editAddon.isAvailable ? 'checked' : ''}>
                    <label class="form-check-label">Available</label>
                </div>
                <button class="btn btn-dark w-100" type="submit">Save</button>
            </form>
        </div>
        <div class="col-lg-8">
            <div class="row g-3 mb-4">
                <c:forEach items="${addonList}" var="addon">
                    <c:set var="addonImage" value="${empty addon.imageUrl ? 'assets/img/le-royal/Champagne Welcome Service.jpg' : addon.imageUrl}" />
                    <div class="col-md-6">
                        <article class="border rounded-3 overflow-hidden h-100 bg-white">
                            <div class="position-relative">
                                <img src="${addonImage}" class="w-100" style="height: 180px; object-fit: cover;" alt="${addon.serviceName}">
                                <span class="badge position-absolute top-0 end-0 m-2 ${addon.isAvailable ? 'text-bg-success' : 'text-bg-secondary'}">${addon.isAvailable ? 'Available' : 'Hidden'}</span>
                            </div>
                            <div class="p-3">
                                <h2 class="h6 mb-1">${addon.serviceName}</h2>
                                <p class="small text-secondary mb-3">${addon.description}</p>
                                <div class="d-flex justify-content-between align-items-center gap-3">
                                    <strong><fmt:formatNumber value="${addon.price}" pattern="#,##0"/></strong>
                                    <div class="d-flex gap-2">
                                        <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminAddonServices&id=${addon.id}">Edit</a>
                                        <a class="btn btn-outline-secondary btn-sm" href="MainController?action=toggleAddonService&id=${addon.id}&enabled=${!addon.isAvailable}">${addon.isAvailable ? 'Hide' : 'Show'}</a>
                                    </div>
                                </div>
                            </div>
                        </article>
                    </div>
                </c:forEach>
            </div>
            <div class="table-responsive">
                <table class="table align-middle">
                    <thead>
                        <tr>
                            <th>Image</th>
                            <th>ID</th>
                            <th>Service</th>
                            <th>Price</th>
                            <th>Status</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${addonList}" var="addon">
                            <c:set var="addonImage" value="${empty addon.imageUrl ? 'assets/img/le-royal/Champagne Welcome Service.jpg' : addon.imageUrl}" />
                            <tr>
                                <td><img src="${addonImage}" style="width: 76px; height: 52px; object-fit: cover;" class="rounded-2" alt="${addon.serviceName}"></td>
                                <td>${addon.id}</td>
                                <td><strong>${addon.serviceName}</strong><div class="small text-secondary">${addon.description}</div></td>
                                <td><fmt:formatNumber value="${addon.price}" pattern="#,##0"/></td>
                                <td><span class="badge ${addon.isAvailable ? 'text-bg-success' : 'text-bg-secondary'}">${addon.isAvailable ? 'Available' : 'Hidden'}</span></td>
                                <td class="text-end">
                                    <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminAddonServices&id=${addon.id}">Edit</a>
                                    <a class="btn btn-outline-secondary btn-sm" href="MainController?action=toggleAddonService&id=${addon.id}&enabled=${!addon.isAvailable}">${addon.isAvailable ? 'Hide' : 'Show'}</a>
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
