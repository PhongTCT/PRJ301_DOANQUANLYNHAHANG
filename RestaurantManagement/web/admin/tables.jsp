<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${sessionScope.lang == 'en' ? 'Table Management - Admin Dashboard' : 'Quản lý Bàn - Admin Dashboard'}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@500;600&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; font-family: 'Inter', sans-serif; }
        .sidebar { min-height: 100vh; background-color: #1a1d20; color: white; }
        .sidebar a { color: rgba(255,255,255,.7); text-decoration: none; padding: 12px 20px; display: block; border-radius: 8px; margin-bottom: 5px; transition: 0.2s; }
        .sidebar a:hover, .sidebar a.active { background-color: rgba(255,255,255,0.1); color: white; }
        .card { border-radius: 12px; }
    </style>
    <link href="${pageContext.request.contextPath}/assets/css/admin-royal.css" rel="stylesheet">
</head>
<body class="admin-royal">
    <div class="d-flex">
        <jsp:include page="/admin/sidebar.jsp">
            <jsp:param name="active" value="tables"/>
        </jsp:include>

        <!-- Main Content -->
        <div class="flex-grow-1 p-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="fw-bold m-0">${sessionScope.lang == 'en' ? 'Table List' : 'Danh sách Bàn'}</h2>
                <button class="btn btn-primary rounded-pill px-4" data-bs-toggle="modal" data-bs-target="#addModal">
                    <i class="fa-solid fa-plus me-1"></i> ${sessionScope.lang == 'en' ? 'Add New Table' : 'Thêm bàn mới'}
                </button>
            </div>

            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible fade show rounded-3" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i> ${sessionScope.lang == 'en' ? sessionScope.successMessage : sessionScope.successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="successMessage" scope="session" />
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show rounded-3" role="alert">
                    <i class="fa-solid fa-circle-exclamation me-2"></i> ${sessionScope.lang == 'en' ? sessionScope.errorMessage : sessionScope.errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="errorMessage" scope="session" />
            </c:if>

            <div class="card shadow-sm border-0">
                <div class="card-body p-0">
                    <table class="table table-hover align-middle m-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4 py-3">${sessionScope.lang == 'en' ? 'Table Code' : 'Mã Bàn'}</th>
                                <th>${sessionScope.lang == 'en' ? 'Room/Area' : 'Khu vực'}</th>
                                <th>${sessionScope.lang == 'en' ? 'Capacity' : 'Sức chứa'}</th>
                                <th>${sessionScope.lang == 'en' ? 'Booking Fee' : 'Phí đặt bàn'}</th>
                                <th>${sessionScope.lang == 'en' ? 'Status' : 'Trạng thái'}</th>
                                <th class="text-end pe-4">${sessionScope.lang == 'en' ? 'Action' : 'Hành động'}</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${tables}" var="t">
                                <tr>
                                    <td class="ps-4 fw-bold text-primary">${t.tableCode}</td>
                                    <td>${sessionScope.lang == 'en' ? t.room.roomNameEn : t.room.roomName}</td>
                                    <td><i class="fa-solid fa-user-group me-1 text-muted"></i> ${t.capacity}</td>
                                    <td><fmt:formatNumber value="${t.basePrice}" pattern="#,##0"/>đ</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${t.status == 'AVAILABLE'}"><span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill px-3 py-1">${sessionScope.lang == 'en' ? 'Available' : 'Trống'}</span></c:when>
                                            <c:when test="${t.status == 'RESERVED'}"><span class="badge bg-warning-subtle text-warning border border-warning-subtle rounded-pill px-3 py-1">${sessionScope.lang == 'en' ? 'Reserved' : 'Đã đặt'}</span></c:when>
                                            <c:when test="${t.status == 'OCCUPIED'}"><span class="badge bg-danger-subtle text-danger border border-danger-subtle rounded-pill px-3 py-1">${sessionScope.lang == 'en' ? 'Occupied' : 'Đang sử dụng'}</span></c:when>
                                        </c:choose>
                                    </td>
                                    <td class="text-end pe-4">
                                        <button class="btn btn-sm btn-light border shadow-sm rounded-circle me-1" style="width:32px; height:32px;" data-bs-toggle="modal" data-bs-target="#editModal${t.id}" title="Sửa"><i class="fa-solid fa-pen text-primary"></i></button>
                                        <button class="btn btn-sm btn-light border shadow-sm rounded-circle" style="width:32px; height:32px;" data-bs-toggle="modal" data-bs-target="#deleteModal${t.id}" title="Xóa"><i class="fa-solid fa-trash text-danger"></i></button>
                                    </td>
                                </tr>

                                <!-- Edit Modal -->
                                <div class="modal fade" id="editModal${t.id}" tabindex="-1">
                                    <div class="modal-dialog modal-dialog-centered">
                                        <div class="modal-content border-0 shadow">
                                            <form action="${pageContext.request.contextPath}/admin/tables" method="post">
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="id" value="${t.id}">
                                                <div class="modal-header border-0 pb-0">
                                                    <h5 class="modal-title fw-bold">${sessionScope.lang == 'en' ? 'Update Table: ' : 'Cập nhật Bàn: '} ${t.tableCode}</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                </div>
                                                <div class="modal-body py-4">
                                                    <div class="row">
                                                        <div class="col-md-6 mb-3">
                                                            <label class="form-label text-muted small fw-bold">${sessionScope.lang == 'en' ? 'TABLE CODE' : 'MÃ BÀN'}</label>
                                                            <input type="text" name="tableCode" class="form-control form-control-lg" value="${t.tableCode}" required>
                                                        </div>
                                                        <div class="col-md-6 mb-3">
                                                            <label class="form-label text-muted small fw-bold">${sessionScope.lang == 'en' ? 'CAPACITY (GUESTS)' : 'SỨC CHỨA (NGƯỜI)'}</label>
                                                            <input type="number" name="capacity" class="form-control form-control-lg" value="${t.capacity}" min="1" required>
                                                        </div>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label text-muted small fw-bold">${sessionScope.lang == 'en' ? 'ROOM / AREA' : 'PHÒNG / KHU VỰC'}</label>
                                                        <select name="roomId" class="form-select form-select-lg">
                                                            <c:forEach items="${rooms}" var="r">
                                                                <option value="${r.id}" ${t.room.id == r.id ? 'selected' : ''}>${sessionScope.lang == 'en' ? r.roomNameEn : r.roomName}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-md-6 mb-3">
                                                            <label class="form-label text-muted small fw-bold">${sessionScope.lang == 'en' ? 'BOOKING FEE' : 'PHÍ ĐẶT BÀN'}</label>
                                                            <input type="number" name="basePrice" class="form-control form-control-lg" value="${t.basePrice}" min="0" required>
                                                        </div>
                                                        <div class="col-md-6 mb-3">
                                                            <label class="form-label text-muted small fw-bold">${sessionScope.lang == 'en' ? 'STATUS' : 'TRẠNG THÁI'}</label>
                                                            <select name="status" class="form-select form-select-lg">
                                                                <option value="AVAILABLE" ${t.status == 'AVAILABLE' ? 'selected' : ''}>${sessionScope.lang == 'en' ? 'Available' : 'Trống'}</option>
                                                                <option value="RESERVED" ${t.status == 'RESERVED' ? 'selected' : ''}>${sessionScope.lang == 'en' ? 'Reserved' : 'Đã đặt'}</option>
                                                                <option value="OCCUPIED" ${t.status == 'OCCUPIED' ? 'selected' : ''}>${sessionScope.lang == 'en' ? 'Occupied' : 'Đang sử dụng'}</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="modal-footer border-0 pt-0">
                                                    <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">${sessionScope.lang == 'en' ? 'Cancel' : 'Hủy'}</button>
                                                    <button type="submit" class="btn btn-primary rounded-pill px-4">${sessionScope.lang == 'en' ? 'Save Changes' : 'Lưu thay đổi'}</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>

                                <!-- Delete Modal -->
                                <div class="modal fade" id="deleteModal${t.id}" tabindex="-1">
                                    <div class="modal-dialog modal-dialog-centered">
                                        <div class="modal-content border-0 shadow">
                                            <form action="${pageContext.request.contextPath}/admin/tables" method="post">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="${t.id}">
                                                <div class="modal-header border-0 pb-0">
                                                    <h5 class="modal-title fw-bold text-danger">${sessionScope.lang == 'en' ? 'Confirm Hide' : 'Xác nhận ẩn bàn'}</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                </div>
                                                <div class="modal-body py-4">
                                                    ${sessionScope.lang == 'en' ? 'Are you sure you want to hide table' : 'Bạn có chắc chắn muốn ẩn bàn'} <strong class="text-danger">${t.tableCode}</strong>?
                                                </div>
                                                <div class="modal-footer border-0 pt-0">
                                                    <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">${sessionScope.lang == 'en' ? 'Cancel' : 'Hủy'}</button>
                                                    <button type="submit" class="btn btn-danger rounded-pill px-4">${sessionScope.lang == 'en' ? 'Hide Table' : 'Đồng ý'}</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:if test="${empty tables}">
                                <tr><td colspan="6" class="text-center text-muted py-5">${sessionScope.lang == 'en' ? 'No tables found.' : 'Chưa có dữ liệu bàn.'}</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Modal -->
    <div class="modal fade" id="addModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <form action="${pageContext.request.contextPath}/admin/tables" method="post">
                    <input type="hidden" name="action" value="add">
                    <div class="modal-header border-0 pb-0">
                        <h5 class="modal-title fw-bold">${sessionScope.lang == 'en' ? 'Add New Table' : 'Thêm bàn mới'}</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body py-4">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted small fw-bold">${sessionScope.lang == 'en' ? 'TABLE CODE' : 'MÃ BÀN'}</label>
                                <input type="text" name="tableCode" class="form-control form-control-lg" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted small fw-bold">${sessionScope.lang == 'en' ? 'CAPACITY (GUESTS)' : 'SỨC CHỨA (NGƯỜI)'}</label>
                                <input type="number" name="capacity" class="form-control form-control-lg" value="2" min="1" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">${sessionScope.lang == 'en' ? 'ROOM / AREA' : 'PHÒNG / KHU VỰC'}</label>
                            <select name="roomId" class="form-select form-select-lg">
                                <c:forEach items="${rooms}" var="r">
                                    <option value="${r.id}">${sessionScope.lang == 'en' ? r.roomNameEn : r.roomName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted small fw-bold">${sessionScope.lang == 'en' ? 'BOOKING FEE' : 'PHÍ ĐẶT BÀN'}</label>
                                <input type="number" name="basePrice" class="form-control form-control-lg" value="0" min="0" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted small fw-bold">${sessionScope.lang == 'en' ? 'STATUS' : 'TRẠNG THÁI'}</label>
                                <select name="status" class="form-select form-select-lg">
                                    <option value="AVAILABLE" selected>${sessionScope.lang == 'en' ? 'Available' : 'Trống'}</option>
                                    <option value="RESERVED">${sessionScope.lang == 'en' ? 'Reserved' : 'Đã đặt'}</option>
                                    <option value="OCCUPIED">${sessionScope.lang == 'en' ? 'Occupied' : 'Đang sử dụng'}</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">${sessionScope.lang == 'en' ? 'Cancel' : 'Hủy'}</button>
                        <button type="submit" class="btn btn-primary rounded-pill px-4">${sessionScope.lang == 'en' ? 'Add Table' : 'Thêm Bàn'}</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

