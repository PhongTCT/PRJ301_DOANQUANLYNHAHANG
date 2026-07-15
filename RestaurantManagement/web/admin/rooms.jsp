<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setLocale value="${sessionScope.lang == 'vi' ? 'vi_VN' : 'en_US'}" />
<fmt:setBundle basename="i18n.messages" />
<c:set var="isEn" value="${sessionScope.lang == 'en'}" />
<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isEn ? 'Rooms' : 'Phòng'} - Le Royal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Marcellus&family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-royal.css">
</head>
<body class="admin-royal">
<div class="d-flex">
    <jsp:include page="/admin/sidebar.jsp">
        <jsp:param name="active" value="rooms"/>
    </jsp:include>
    <main class="flex-grow-1">
        <div class="admin-shell">
            <div class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-4">
                <div>
                    <p class="text-uppercase text-secondary small mb-1"><fmt:message key="admin.dashboard.workspace.title" /></p>
                    <h1 class="h3 mb-1">${isEn ? 'Rooms' : 'Phòng'}</h1>
                    <p class="text-secondary mb-0">${isEn ? 'Create dining rooms inside each area and set Standard, VIP, or VVIP access.' : 'Tạo phòng trong từng khu vực và đặt quyền Standard, VIP hoặc VVIP.'}</p>
                </div>
                <div class="d-flex flex-wrap gap-2">
                    <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminAreas">
                        <i class="fa-solid fa-map-location-dot me-2"></i>${isEn ? 'Areas' : 'Khu vực'}
                    </a>
                    <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminTables">
                        <i class="fa-solid fa-chair me-2"></i>${isEn ? 'Dining tables' : 'Bàn'}
                    </a>
                    <button class="btn btn-dark btn-sm" type="button" data-bs-toggle="collapse" data-bs-target="#roomFormPanel" aria-expanded="${not empty editRoom ? 'true' : 'false'}">
                        <i class="fa-solid fa-plus me-2"></i>${isEn ? 'Create room' : 'Thêm phòng'}
                    </button>
                </div>
            </div>

            <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
            <c:if test="${param.saved == '1'}"><div class="alert alert-success"><fmt:message key="admin.common.saved.success" /></div></c:if>

            <section id="roomFormPanel" class="collapse ${not empty editRoom ? 'show' : ''} mb-4">
                <form class="card" method="post" action="MainController">
                    <div class="card-body p-4">
                        <input type="hidden" name="action" value="saveRoom">
                        <input type="hidden" name="id" value="${editRoom.id}">
                        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-3">
                            <div>
                                <div class="admin-section-label">${isEn ? 'Room editor' : 'Trình sửa phòng'}</div>
                                <h2 class="h5 mb-0">
                                    <c:choose>
                                        <c:when test="${empty editRoom}">${isEn ? 'Create room' : 'Thêm phòng'}</c:when>
                                        <c:otherwise>${isEn ? 'Edit room' : 'Sửa phòng'}</c:otherwise>
                                    </c:choose>
                                </h2>
                            </div>
                            <c:if test="${not empty editRoom}">
                                <a class="btn btn-outline-secondary btn-sm" href="MainController?action=adminRooms">${isEn ? 'Clear' : 'Xóa chọn'}</a>
                            </c:if>
                        </div>

                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label">${isEn ? 'Area' : 'Khu vực'}</label>
                                <select id="draftRoomArea" class="form-select" name="areaId" required>
                                    <c:forEach items="${areas}" var="area">
                                        <option value="${area.id}" ${not empty editRoom && editRoom.area.id == area.id ? 'selected' : ''}>${area.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">${isEn ? 'Room name' : 'Tên phòng'}</label>
                                <input id="draftRoomName" class="form-control" name="roomName" value="${editRoom.roomName}" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">${isEn ? 'Room type' : 'Loại phòng'}</label>
                                <select id="draftRoomType" class="form-select" name="roomType">
                                    <option value="STANDARD" ${editRoom.roomType == 'STANDARD' ? 'selected' : ''}>STANDARD</option>
                                    <option value="VIP" ${editRoom.roomType == 'VIP' ? 'selected' : ''}>VIP</option>
                                    <option value="VVIP" ${editRoom.roomType == 'VVIP' ? 'selected' : ''}>VVIP</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">${isEn ? 'Capacity' : 'Sức chứa'}</label>
                                <input id="draftRoomCapacity" class="form-control" name="capacity" type="number" min="1" value="${empty editRoom ? 2 : editRoom.capacity}" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">${isEn ? 'Price per session' : 'Phí theo buổi'}</label>
                                <input id="draftRoomPrice" class="form-control" name="pricePerSession" type="number" min="0" step="1" value="${empty editRoom ? 0 : editRoom.pricePerSession}">
                            </div>
                            <div class="col-md-3 d-flex align-items-end">
                                <div class="form-check form-switch mb-2">
                                    <input id="draftRoomActive" class="form-check-input" type="checkbox" name="isActive" value="true" ${empty editRoom || editRoom.isActive ? 'checked' : ''}>
                                    <label class="form-check-label" for="draftRoomActive">${isEn ? 'Available' : 'Hoạt động'}</label>
                                </div>
                            </div>
                            <div class="col-md-3 d-flex align-items-end">
                                <button class="btn btn-dark w-100" type="submit"><fmt:message key="admin.common.save" /></button>
                            </div>

                            <div class="col-lg-8">
                                <div class="border rounded-3 p-3 h-100">
                                    <div class="d-flex gap-2 mb-2">
                                        <span class="badge text-bg-light border">STANDARD</span>
                                        <span class="small text-secondary">${isEn ? 'Bookable by every customer rank.' : 'Mọi hạng khách hàng đều có thể đặt.'}</span>
                                    </div>
                                    <div class="d-flex gap-2 mb-2">
                                        <span class="badge text-bg-warning">VIP</span>
                                        <span class="small text-secondary">${isEn ? 'Requires a rank with VIP booking access.' : 'Yêu cầu hạng có quyền đặt phòng VIP.'}</span>
                                    </div>
                                    <div class="d-flex gap-2">
                                        <span class="badge text-bg-dark">VVIP</span>
                                        <span class="small text-secondary">${isEn ? 'Requires a rank with VVIP booking access.' : 'Yêu cầu hạng có quyền đặt phòng VVIP.'}</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4">
                                <aside class="admin-draft-preview rounded-3 p-3 h-100">
                                    <p class="text-uppercase text-secondary small mb-1">${isEn ? 'Draft preview' : 'Xem trước'}</p>
                                    <div class="d-flex justify-content-between align-items-start gap-3">
                                        <div>
                                            <h3 id="roomPreviewName" class="h5 mb-1">${empty editRoom.roomName ? 'Salon Prive' : editRoom.roomName}</h3>
                                            <p id="roomPreviewMeta" class="text-secondary small mb-2">2 guests - Area</p>
                                            <span id="roomPreviewPrice" class="badge text-bg-light border text-dark">0</span>
                                        </div>
                                        <span id="roomPreviewType" class="badge text-bg-light border">STANDARD</span>
                                    </div>
                                </aside>
                            </div>
                        </div>
                    </div>
                </form>
            </section>

            <section class="card">
                <div class="card-body p-4">
                    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-3">
                        <div>
                            <div class="admin-section-label">${isEn ? 'Room list' : 'Danh sách phòng'}</div>
                            <h2 class="h5 mb-0">${isEn ? 'Dining rooms' : 'Các phòng trong nhà hàng'}</h2>
                        </div>
                    </div>

                    <div class="row g-2 mb-3">
                        <div class="col-md-5">
                            <input id="roomSearch" class="form-control" type="search" placeholder="${isEn ? 'Search room or area' : 'Tìm phòng hoặc khu vực'}">
                        </div>
                        <div class="col-md-4">
                            <select id="roomTypeFilter" class="form-select">
                                <option value="">${isEn ? 'All room types' : 'Tất cả loại phòng'}</option>
                                <option value="STANDARD">STANDARD</option>
                                <option value="VIP">VIP</option>
                                <option value="VVIP">VVIP</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <select id="roomStatusFilter" class="form-select">
                                <option value="">${isEn ? 'All status' : 'Tất cả trạng thái'}</option>
                                <option value="active">${isEn ? 'Available' : 'Hoạt động'}</option>
                                <option value="inactive">${isEn ? 'Hidden' : 'Đã ẩn'}</option>
                            </select>
                        </div>
                    </div>

                    <div class="table-responsive">
                        <table class="table align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>${isEn ? 'Room' : 'Phòng'}</th>
                                    <th>${isEn ? 'Area' : 'Khu vực'}</th>
                                    <th>${isEn ? 'Type' : 'Loại'}</th>
                                    <th>${isEn ? 'Capacity' : 'Sức chứa'}</th>
                                    <th>${isEn ? 'Price per session' : 'Phí theo buổi'}</th>
                                    <th>${isEn ? 'Status' : 'Trạng thái'}</th>
                                    <th class="text-end"></th>
                                </tr>
                            </thead>
                            <tbody id="roomRows">
                                <c:forEach items="${roomList}" var="room">
                                    <tr data-room-row data-search="${room.roomName} ${room.area.name}" data-type="${room.roomType}" data-status="${room.isActive ? 'active' : 'inactive'}">
                                        <td><strong>${room.roomName}</strong></td>
                                        <td>${room.area.name}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${room.roomType == 'VIP'}">
                                                    <span class="badge text-bg-warning">VIP</span>
                                                    <div class="small text-secondary mt-1">${isEn ? 'VIP access' : 'Quyền VIP'}</div>
                                                </c:when>
                                                <c:when test="${room.roomType == 'VVIP'}">
                                                    <span class="badge text-bg-dark">VVIP</span>
                                                    <div class="small text-secondary mt-1">${isEn ? 'VVIP access' : 'Quyền VVIP'}</div>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge text-bg-light border">STANDARD</span>
                                                    <div class="small text-secondary mt-1">${isEn ? 'All ranks' : 'Mọi hạng'}</div>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${room.capacity}</td>
                                        <td><fmt:formatNumber value="${room.pricePerSession}" pattern="#,##0"/></td>
                                        <td>
                                            <span class="badge ${room.isActive ? 'text-bg-success' : 'text-bg-secondary'}">
                                                ${room.isActive ? (isEn ? 'Available' : 'Hoạt động') : (isEn ? 'Hidden' : 'Đã ẩn')}
                                            </span>
                                        </td>
                                        <td class="text-end">
                                            <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminRooms&id=${room.id}">${isEn ? 'Edit' : 'Sửa'}</a>
                                            <a class="btn btn-outline-secondary btn-sm" href="MainController?action=toggleRoom&id=${room.id}&enabled=${!room.isActive}">${room.isActive ? (isEn ? 'Hide' : 'Ẩn') : (isEn ? 'Show' : 'Hiện')}</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <tr id="roomEmptyRow" class="d-none">
                                    <td colspan="7" class="text-center text-secondary py-5">${isEn ? 'No matching rooms found.' : 'Không có phòng phù hợp.'}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="d-flex justify-content-between align-items-center mt-3">
                        <div id="roomPageInfo" class="small text-secondary"></div>
                        <div class="btn-group">
                            <button id="roomPrev" type="button" class="btn btn-outline-secondary btn-sm">${isEn ? 'Previous' : 'Trước'}</button>
                            <button id="roomNext" type="button" class="btn btn-outline-secondary btn-sm">${isEn ? 'Next' : 'Sau'}</button>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </main>
</div>

<script>
    (function () {
        var isEn = ${isEn ? 'true' : 'false'};
        var nameInput = document.getElementById('draftRoomName');
        var areaInput = document.getElementById('draftRoomArea');
        var typeInput = document.getElementById('draftRoomType');
        var capacityInput = document.getElementById('draftRoomCapacity');
        var priceInput = document.getElementById('draftRoomPrice');
        var previewName = document.getElementById('roomPreviewName');
        var previewMeta = document.getElementById('roomPreviewMeta');
        var previewType = document.getElementById('roomPreviewType');
        var previewPrice = document.getElementById('roomPreviewPrice');

        function money(value) {
            var number = Number(value || 0);
            return (isNaN(number) ? 0 : number).toLocaleString('vi-VN');
        }

        function updatePreview() {
            var type = typeInput.value || 'STANDARD';
            var area = areaInput.options[areaInput.selectedIndex] ? areaInput.options[areaInput.selectedIndex].text : 'Area';
            previewName.textContent = (nameInput.value || '').trim() || 'Salon Prive';
            previewMeta.textContent = (capacityInput.value || '2') + ' guests - ' + area;
            previewPrice.textContent = money(priceInput.value);
            previewType.textContent = type;
            previewType.className = type === 'VIP' ? 'badge text-bg-warning' : (type === 'VVIP' ? 'badge text-bg-dark' : 'badge text-bg-light border');
        }
        [nameInput, areaInput, typeInput, capacityInput, priceInput].forEach(function (field) {
            if (field) field.addEventListener('input', updatePreview);
            if (field) field.addEventListener('change', updatePreview);
        });
        updatePreview();

        var search = document.getElementById('roomSearch');
        var typeFilter = document.getElementById('roomTypeFilter');
        var statusFilter = document.getElementById('roomStatusFilter');
        var rows = Array.prototype.slice.call(document.querySelectorAll('[data-room-row]'));
        var empty = document.getElementById('roomEmptyRow');
        var pageInfo = document.getElementById('roomPageInfo');
        var prev = document.getElementById('roomPrev');
        var next = document.getElementById('roomNext');
        var page = 1;
        var perPage = 8;
        var visibleRows = [];

        function applyFilters() {
            var query = (search.value || '').toLowerCase().trim();
            var selectedType = typeFilter.value;
            var selectedStatus = statusFilter.value;
            visibleRows = rows.filter(function (row) {
                var matchesSearch = !query || (row.getAttribute('data-search') || '').toLowerCase().indexOf(query) >= 0;
                var matchesType = !selectedType || row.getAttribute('data-type') === selectedType;
                var matchesStatus = !selectedStatus || row.getAttribute('data-status') === selectedStatus;
                return matchesSearch && matchesType && matchesStatus;
            });
            var maxPage = Math.max(1, Math.ceil(visibleRows.length / perPage));
            if (page > maxPage) page = maxPage;
            renderPage();
        }

        function renderPage() {
            var maxPage = Math.max(1, Math.ceil(visibleRows.length / perPage));
            rows.forEach(function (row) { row.classList.add('d-none'); });
            visibleRows.slice((page - 1) * perPage, page * perPage).forEach(function (row) { row.classList.remove('d-none'); });
            if (empty) empty.classList.toggle('d-none', visibleRows.length !== 0);
            pageInfo.textContent = visibleRows.length ? (page + ' / ' + maxPage + ' - ' + visibleRows.length + ' ' + (isEn ? 'rooms' : 'phòng')) : '0 ' + (isEn ? 'rooms' : 'phòng');
            prev.disabled = page <= 1;
            next.disabled = page >= maxPage;
        }

        [search, typeFilter, statusFilter].forEach(function (field) {
            if (field) field.addEventListener(field.tagName === 'SELECT' ? 'change' : 'input', function () { page = 1; applyFilters(); });
        });
        if (prev) prev.addEventListener('click', function () { if (page > 1) { page--; renderPage(); } });
        if (next) next.addEventListener('click', function () {
            var maxPage = Math.max(1, Math.ceil(visibleRows.length / perPage));
            if (page < maxPage) { page++; renderPage(); }
        });
        applyFilters();
    })();
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
