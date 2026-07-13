<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setLocale value="${sessionScope.lang == 'en' ? 'en_US' : 'vi_VN'}" />
<fmt:setBundle basename="i18n.messages" />
<jsp:include page="/header.jsp" />
<main class="container py-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div><p class="text-uppercase text-secondary small mb-1"><fmt:message key="admin.dashboard.workspace.title" /></p><h1 class="h3 mb-0"><fmt:message key="admin.rooms.title" /></h1></div>
        <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminAreas"><fmt:message key="admin.rooms.back" /></a>
    </div>
    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
    <c:if test="${param.saved == '1'}"><div class="alert alert-success"><fmt:message key="admin.common.saved.success" /></div></c:if>
    <div class="row g-4">
        <div class="col-lg-4">
            <form class="border rounded-3 p-4 bg-light" method="post" action="MainController">
                <input type="hidden" name="action" value="saveRoom">
                <input type="hidden" name="id" value="${editRoom.id}">
                <h2 class="h5 mb-3">${empty editRoom ? '<fmt:message key="admin.rooms.create" />' : '<fmt:message key="admin.rooms.edit" />'}</h2>
                <label class="form-label"><fmt:message key="admin.rooms.label.area" /></label>
                <select class="form-select mb-3" name="areaId" required>
                    <c:forEach items="${areas}" var="area">
                        <option value="${area.id}" ${not empty editRoom && editRoom.area.id == area.id ? 'selected' : ''}>${area.name}</option>
                    </c:forEach>
                </select>
                <label class="form-label"><fmt:message key="admin.rooms.label.name" /></label>
                <input class="form-control mb-3" name="roomName" value="${editRoom.roomName}" required>
                <label class="form-label"><fmt:message key="admin.rooms.label.type" /></label>
                <select class="form-select mb-3" name="roomType">
                    <option value="STANDARD" ${editRoom.roomType == 'STANDARD' ? 'selected' : ''}><fmt:message key="admin.rooms.type.standard" /></option>
                    <option value="VIP" ${editRoom.roomType == 'VIP' ? 'selected' : ''}><fmt:message key="admin.rooms.type.vip" /></option>
                    <option value="VVIP" ${editRoom.roomType == 'VVIP' ? 'selected' : ''}><fmt:message key="admin.rooms.type.vvip" /></option>
                </select>
                <label class="form-label"><fmt:message key="admin.rooms.label.capacity" /></label>
                <input class="form-control mb-3" name="capacity" type="number" min="1" value="${empty editRoom ? 2 : editRoom.capacity}" required>
                <label class="form-label"><fmt:message key="admin.rooms.label.price" /></label>
                <input class="form-control mb-3" name="pricePerSession" type="number" min="0" step="1" value="${empty editRoom ? 0 : editRoom.pricePerSession}">
                <div class="form-check form-switch mb-3"><input class="form-check-input" type="checkbox" name="isActive" value="true" ${empty editRoom || editRoom.isActive ? 'checked' : ''}><label class="form-check-label"><fmt:message key="admin.common.active.switch" /></label></div>
                <button class="btn btn-dark w-100" type="submit"><fmt:message key="admin.common.save" /></button>
            </form>
        </div>
        <div class="col-lg-8">
            <div class="table-responsive">
                <table class="table align-middle">
                    <thead><tr><th><fmt:message key="admin.rooms.col.id" /></th><th><fmt:message key="admin.rooms.col.room" /></th><th><fmt:message key="admin.rooms.col.area" /></th><th><fmt:message key="admin.rooms.col.type" /></th><th><fmt:message key="admin.rooms.col.capacity" /></th><th><fmt:message key="admin.rooms.col.status" /></th><th></th></tr></thead>
                    <tbody>
                        <c:forEach items="${roomList}" var="room">
                            <tr>
                                <td>${room.id}</td><td><strong>${room.roomName}</strong></td><td>${room.area.name}</td><td>${room.roomType}</td><td>${room.capacity}</td>
                                <td><span class="badge ${room.isActive ? 'text-bg-success' : 'text-bg-secondary'}">${room.isActive ? '<fmt:message key="admin.common.active" />' : '<fmt:message key="admin.common.inactive" />'}</span></td>
                                <td class="text-end"><a class="btn btn-outline-dark btn-sm" href="MainController?action=adminRooms&id=${room.id}"><fmt:message key="admin.rooms.btn.edit" /></a> <a class="btn btn-outline-secondary btn-sm" href="MainController?action=toggleRoom&id=${room.id}&enabled=${!room.isActive}">${room.isActive ? '<fmt:message key="admin.rooms.btn.disable" />' : '<fmt:message key="admin.rooms.btn.enable" />'}</a></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>
<jsp:include page="/footer.jsp" />