<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/header.jsp" />
<main class="container py-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div><p class="text-uppercase text-secondary small mb-1">Restaurant Admin</p><h1 class="h3 mb-0">Rooms</h1></div>
        <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminAreas">Back to areas</a>
    </div>
    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
    <c:if test="${param.saved == '1'}"><div class="alert alert-success">Saved successfully.</div></c:if>
    <div class="row g-4">
        <div class="col-lg-4">
            <form class="border rounded-3 p-4 bg-light" method="post" action="MainController">
                <input type="hidden" name="action" value="saveRoom">
                <input type="hidden" name="id" value="${editRoom.id}">
                <h2 class="h5 mb-3">${empty editRoom ? 'Create room' : 'Edit room'}</h2>
                <label class="form-label">Area</label>
                <select class="form-select mb-3" name="areaId" required>
                    <c:forEach items="${areas}" var="area">
                        <option value="${area.id}" ${not empty editRoom && editRoom.area.id == area.id ? 'selected' : ''}>${area.name}</option>
                    </c:forEach>
                </select>
                <label class="form-label">Room name</label>
                <input class="form-control mb-3" name="roomName" value="${editRoom.roomName}" required>
                <label class="form-label">Room type</label>
                <select class="form-select mb-3" name="roomType">
                    <option value="STANDARD" ${editRoom.roomType == 'STANDARD' ? 'selected' : ''}>STANDARD</option>
                    <option value="VIP" ${editRoom.roomType == 'VIP' ? 'selected' : ''}>VIP</option>
                    <option value="VVIP" ${editRoom.roomType == 'VVIP' ? 'selected' : ''}>VVIP</option>
                </select>
                <label class="form-label">Capacity</label>
                <input class="form-control mb-3" name="capacity" type="number" min="1" value="${empty editRoom ? 2 : editRoom.capacity}" required>
                <label class="form-label">Price per session</label>
                <input class="form-control mb-3" name="pricePerSession" type="number" min="0" step="1" value="${empty editRoom ? 0 : editRoom.pricePerSession}">
                <div class="form-check form-switch mb-3"><input class="form-check-input" type="checkbox" name="isActive" value="true" ${empty editRoom || editRoom.isActive ? 'checked' : ''}><label class="form-check-label">Active</label></div>
                <button class="btn btn-dark w-100" type="submit">Save</button>
            </form>
        </div>
        <div class="col-lg-8">
            <div class="table-responsive">
                <table class="table align-middle">
                    <thead><tr><th>ID</th><th>Room</th><th>Area</th><th>Type</th><th>Capacity</th><th>Status</th><th></th></tr></thead>
                    <tbody>
                        <c:forEach items="${roomList}" var="room">
                            <tr>
                                <td>${room.id}</td><td><strong>${room.roomName}</strong></td><td>${room.area.name}</td><td>${room.roomType}</td><td>${room.capacity}</td>
                                <td><span class="badge ${room.isActive ? 'text-bg-success' : 'text-bg-secondary'}">${room.isActive ? 'Active' : 'Inactive'}</span></td>
                                <td class="text-end"><a class="btn btn-outline-dark btn-sm" href="MainController?action=adminRooms&id=${room.id}">Edit</a> <a class="btn btn-outline-secondary btn-sm" href="MainController?action=toggleRoom&id=${room.id}&enabled=${!room.isActive}">${room.isActive ? 'Disable' : 'Enable'}</a></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>
<jsp:include page="/footer.jsp" />
