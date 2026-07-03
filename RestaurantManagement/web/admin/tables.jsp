<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/header.jsp" />
<main class="container py-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div><p class="text-uppercase text-secondary small mb-1">Restaurant Admin</p><h1 class="h3 mb-0">Dining tables</h1></div>
        <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminRooms">Back to rooms</a>
    </div>
    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
    <c:if test="${param.saved == '1'}"><div class="alert alert-success">Saved successfully.</div></c:if>
    <div class="row g-4">
        <div class="col-lg-4">
            <form class="border rounded-3 p-4 bg-light" method="post" action="MainController">
                <input type="hidden" name="action" value="saveDiningTable">
                <input type="hidden" name="id" value="${editTable.id}">
                <h2 class="h5 mb-3">${empty editTable ? 'Create table' : 'Edit table'}</h2>
                <label class="form-label">Room</label>
                <select class="form-select mb-3" name="roomId" required>
                    <c:forEach items="${rooms}" var="room"><option value="${room.id}" ${not empty editTable && editTable.room.id == room.id ? 'selected' : ''}>${room.roomName}</option></c:forEach>
                </select>
                <label class="form-label">Table code</label>
                <input class="form-control mb-3" name="tableCode" value="${editTable.tableCode}" required>
                <label class="form-label">Capacity</label>
                <input class="form-control mb-3" name="capacity" type="number" min="1" value="${empty editTable ? 2 : editTable.capacity}" required>
                <label class="form-label">Base price</label>
                <input class="form-control mb-3" name="basePrice" type="number" min="0" step="1" value="${empty editTable ? 0 : editTable.basePrice}">
                <label class="form-label">Image URL</label>
                <input class="form-control mb-3" name="imageUrl" value="${editTable.imageUrl}" placeholder="assets/img/le-royal/seating/dining-room.jpg">
                <label class="form-label">Status</label>
                <select class="form-select mb-3" name="status">
                    <option value="AVAILABLE" ${editTable.status == 'AVAILABLE' ? 'selected' : ''}>AVAILABLE</option>
                    <option value="RESERVED" ${editTable.status == 'RESERVED' ? 'selected' : ''}>RESERVED</option>
                    <option value="OCCUPIED" ${editTable.status == 'OCCUPIED' ? 'selected' : ''}>OCCUPIED</option>
                </select>
                <div class="form-check form-switch mb-3"><input class="form-check-input" type="checkbox" name="isActive" value="true" ${empty editTable || editTable.isActive ? 'checked' : ''}><label class="form-check-label">Active</label></div>
                <button class="btn btn-dark w-100" type="submit">Save</button>
            </form>
        </div>
        <div class="col-lg-8">
            <div class="row g-3 mb-4">
                <c:forEach items="${tableList}" var="tb" varStatus="loop">
                    <c:set var="tableImage" value="${empty tb.imageUrl ? 'assets/img/le-royal/seating/dining-room.jpg' : tb.imageUrl}" />
                    <div class="col-md-6">
                        <article class="border rounded-3 overflow-hidden h-100 bg-white">
                            <div class="position-relative">
                                <img src="${tableImage}" class="w-100" style="height: 180px; object-fit: cover;" alt="${tb.tableCode}">
                                <span class="badge position-absolute top-0 end-0 m-2 ${tb.status == 'AVAILABLE' ? 'text-bg-success' : tb.status == 'RESERVED' ? 'text-bg-warning' : 'text-bg-danger'}">${tb.status}</span>
                            </div>
                            <div class="p-3">
                                <div class="d-flex justify-content-between align-items-start gap-3">
                                    <div>
                                        <h2 class="h6 mb-1">${tb.tableCode}</h2>
                                        <div class="small text-secondary">${tb.room.roomName}</div>
                                    </div>
                                    <span class="badge ${tb.isActive ? 'text-bg-success' : 'text-bg-secondary'}">${tb.isActive ? 'Active' : 'Inactive'}</span>
                                </div>
                                <div class="d-flex flex-wrap gap-2 mt-3 small text-secondary">
                                    <span class="border rounded-pill px-2 py-1">${tb.capacity} seats</span>
                                    <span class="border rounded-pill px-2 py-1"><fmt:formatNumber value="${tb.basePrice}" pattern="#,##0"/></span>
                                </div>
                                <div class="d-flex gap-2 mt-3">
                                    <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminTables&id=${tb.id}">Edit</a>
                                    <a class="btn btn-outline-secondary btn-sm" href="MainController?action=toggleDiningTable&id=${tb.id}&enabled=${!tb.isActive}">${tb.isActive ? 'Disable' : 'Enable'}</a>
                                </div>
                            </div>
                        </article>
                    </div>
                </c:forEach>
            </div>
            <div class="table-responsive">
                <table class="table align-middle">
                    <thead><tr><th>Image</th><th>ID</th><th>Code</th><th>Room</th><th>Capacity</th><th>Status</th><th>Active</th><th></th></tr></thead>
                    <tbody>
                        <c:forEach items="${tableList}" var="tb" varStatus="loop">
                            <c:set var="tableImage" value="${empty tb.imageUrl ? 'assets/img/le-royal/seating/dining-room.jpg' : tb.imageUrl}" />
                            <tr>
                                <td><img src="${tableImage}" style="width: 76px; height: 52px; object-fit: cover;" class="rounded-2" alt="${tb.tableCode}"></td><td>${tb.id}</td><td><strong>${tb.tableCode}</strong></td><td>${tb.room.roomName}</td><td>${tb.capacity}</td><td><span class="badge ${tb.status == 'AVAILABLE' ? 'text-bg-success' : tb.status == 'RESERVED' ? 'text-bg-warning' : 'text-bg-danger'}">${tb.status}</span></td>
                                <td><span class="badge ${tb.isActive ? 'text-bg-success' : 'text-bg-secondary'}">${tb.isActive ? 'Active' : 'Inactive'}</span></td>
                                <td class="text-end"><a class="btn btn-outline-dark btn-sm" href="MainController?action=adminTables&id=${tb.id}">Edit</a> <a class="btn btn-outline-secondary btn-sm" href="MainController?action=toggleDiningTable&id=${tb.id}&enabled=${!tb.isActive}">${tb.isActive ? 'Disable' : 'Enable'}</a></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>
<jsp:include page="/footer.jsp" />
