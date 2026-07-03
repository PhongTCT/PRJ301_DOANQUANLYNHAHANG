<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${sessionScope.lang == 'en' ? 'Surcharge Management - Admin Dashboard' : 'Quản lý Phụ thu Lễ - Admin Dashboard'}</title>
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
            <jsp:param name="active" value="surcharges"/>
        </jsp:include>

        <!-- Main Content -->
        <div class="flex-grow-1 p-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="fw-bold m-0">${sessionScope.lang == 'en' ? 'Holiday Surcharges List' : 'Danh sách Phụ thu Lễ'}</h2>
                <button class="btn btn-primary rounded-pill px-4" data-bs-toggle="modal" data-bs-target="#addModal">
                    <i class="fa-solid fa-plus me-1"></i> ${sessionScope.lang == 'en' ? 'Add New Holiday' : 'Thêm ngày lễ mới'}
                </button>
            </div>

            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible fade show rounded-3" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i> ${sessionScope.successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="successMessage" scope="session" />
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show rounded-3" role="alert">
                    <i class="fa-solid fa-circle-exclamation me-2"></i> ${sessionScope.errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="errorMessage" scope="session" />
            </c:if>

            <div class="card shadow-sm border-0">
                <div class="card-body p-0">
                    <table class="table table-hover align-middle m-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4 py-3">ID</th>
                                <th>${sessionScope.lang == 'en' ? 'Holiday Name' : 'Tên Ngày Lễ'}</th>
                                <th>${sessionScope.lang == 'en' ? 'Applied Date' : 'Ngày Áp Dụng'}</th>
                                <th>${sessionScope.lang == 'en' ? 'Surcharge' : 'Phụ thu'} (%)</th>
                                <th>${sessionScope.lang == 'en' ? 'Status' : 'Trạng thái'}</th>
                                <th class="text-end pe-4">${sessionScope.lang == 'en' ? 'Action' : 'Hành động'}</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${surcharges}" var="s">
                                <tr>
                                    <td class="ps-4">${s.id}</td>
                                    <td class="fw-bold">${s.holidayName}</td>
                                    <td><fmt:formatDate value="${s.surchargeDate}" pattern="dd/MM/yyyy" /></td>
                                    <td><span class="badge bg-danger rounded-pill px-3 py-2 fs-6">+${s.surchargePercent}%</span></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${s.isActive}"><span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill px-3 py-1">${sessionScope.lang == 'en' ? 'Active' : 'Đang kích hoạt'}</span></c:when>
                                            <c:otherwise><span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle rounded-pill px-3 py-1">${sessionScope.lang == 'en' ? 'Disabled' : 'Vô hiệu hóa'}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end pe-4">
                                        <button class="btn btn-sm btn-light border shadow-sm rounded-circle me-1" style="width:32px; height:32px;" data-bs-toggle="modal" data-bs-target="#editModal${s.id}" title="Sửa"><i class="fa-solid fa-pen text-primary"></i></button>
                                        <button class="btn btn-sm btn-light border shadow-sm rounded-circle" style="width:32px; height:32px;" data-bs-toggle="modal" data-bs-target="#deleteModal${s.id}" title="Xóa"><i class="fa-solid fa-trash text-danger"></i></button>
                                    </td>
                                </tr>

                                <!-- Edit Modal -->
                                <div class="modal fade" id="editModal${s.id}" tabindex="-1">
                                    <div class="modal-dialog modal-dialog-centered">
                                        <div class="modal-content border-0 shadow">
                                            <form action="${pageContext.request.contextPath}/admin/surcharges" method="post">
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="id" value="${s.id}">
                                                <div class="modal-header border-0 pb-0">
                                                    <h5 class="modal-title fw-bold">Cập nhật: ${s.holidayName}</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                </div>
                                                <div class="modal-body py-4">
                                                    <div class="mb-3">
                                                        <label class="form-label text-muted small fw-bold">TÊN NGÀY LỄ</label>
                                                        <input type="text" name="holidayName" class="form-control form-control-lg" value="${s.holidayName}" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label text-muted small fw-bold">NGÀY ÁP DỤNG</label>
                                                        <input type="date" name="surchargeDate" class="form-control form-control-lg" value="<fmt:formatDate value='${s.surchargeDate}' pattern='yyyy-MM-dd'/>" required>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-md-6 mb-3">
                                                            <label class="form-label text-muted small fw-bold">PHỤ THU (%)</label>
                                                            <input type="number" name="surchargePercent" class="form-control form-control-lg" value="${s.surchargePercent}" min="0" max="100" required>
                                                        </div>
                                                        <div class="col-md-6 mb-3">
                                                            <label class="form-label text-muted small fw-bold">TRẠNG THÁI</label>
                                                            <select name="isActive" class="form-select form-select-lg">
                                                                <option value="true" ${s.isActive ? 'selected' : ''}>Hoạt động</option>
                                                                <option value="false" ${!s.isActive ? 'selected' : ''}>Vô hiệu hóa</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="modal-footer border-0 pt-0">
                                                    <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Hủy</button>
                                                    <button type="submit" class="btn btn-primary rounded-pill px-4">Lưu thay đổi</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>

                                <!-- Delete Modal -->
                                <div class="modal fade" id="deleteModal${s.id}" tabindex="-1">
                                    <div class="modal-dialog modal-dialog-centered">
                                        <div class="modal-content border-0 shadow">
                                            <form action="${pageContext.request.contextPath}/admin/surcharges" method="post">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="${s.id}">
                                                <div class="modal-header border-0 pb-0">
                                                    <h5 class="modal-title fw-bold text-danger">Xác nhận xóa</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                </div>
                                                <div class="modal-body py-4">
                                                    Bạn có chắc chắn muốn vô hiệu hóa ngày lễ <strong class="text-danger">${s.holidayName}</strong> không?<br>
                                                    Thao tác này chỉ ẩn ngày lễ đi chứ không xóa khỏi dữ liệu gốc.
                                                </div>
                                                <div class="modal-footer border-0 pt-0">
                                                    <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Hủy</button>
                                                    <button type="submit" class="btn btn-danger rounded-pill px-4">Đồng ý xóa</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:if test="${empty surcharges}">
                                <tr><td colspan="6" class="text-center text-muted py-5">Chưa có ngày lễ nào được thiết lập.</td></tr>
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
                <form action="${pageContext.request.contextPath}/admin/surcharges" method="post">
                    <input type="hidden" name="action" value="add">
                    <div class="modal-header border-0 pb-0">
                        <h5 class="modal-title fw-bold">Thêm ngày lễ mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body py-4">
                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">TÊN NGÀY LỄ</label>
                            <input type="text" name="holidayName" class="form-control form-control-lg" placeholder="VD: Lễ Quốc Khánh" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">NGÀY ÁP DỤNG</label>
                            <input type="date" name="surchargeDate" class="form-control form-control-lg" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-muted small fw-bold">PHỤ THU (%)</label>
                            <div class="input-group input-group-lg">
                                <input type="number" name="surchargePercent" class="form-control" value="15" min="0" max="100" required>
                                <span class="input-group-text bg-white">%</span>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary rounded-pill px-4">Thêm mới</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
