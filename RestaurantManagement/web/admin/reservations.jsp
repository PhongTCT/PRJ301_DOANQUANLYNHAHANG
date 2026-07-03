<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Le Royal - Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@500;600&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; font-family: 'Inter', sans-serif; }
        .sidebar { min-height: 100vh; background-color: #1a1d20; color: white; }
        .sidebar a { color: rgba(255,255,255,.7); text-decoration: none; padding: 12px 20px; display: block; border-radius: 8px; margin-bottom: 5px; transition: 0.2s; }
        .sidebar a:hover, .sidebar a.active { background-color: rgba(255,255,255,0.1); color: white; }
        .card { border-radius: 12px; }
        .status-badge { font-weight: 500; font-size: 0.85rem; padding: 0.4em 0.8em; }
    </style>
    <link href="${pageContext.request.contextPath}/assets/css/admin-royal.css" rel="stylesheet">
</head>
<body class="admin-royal">
    <div class="container-fluid p-0">
        <div class="d-flex">
            <jsp:include page="/admin/sidebar.jsp">
                <jsp:param name="active" value="reservations"/>
            </jsp:include>

            <!-- Main Content -->
            <div class="flex-grow-1 p-5">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h2 class="fw-bold mb-0">Reservation Management</h2>
                        <p class="text-muted">View and manage all table bookings</p>
                    </div>
                </div>

                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fa-solid fa-check-circle me-2"></i>${successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        <c:remove var="successMessage" scope="session" />
                    </div>
                </c:if>

                <div class="card shadow-sm border-0 mb-4">
                    <div class="card-body bg-white">
                        <form action="reservations" method="GET" class="row g-3 align-items-end">
                            <div class="col-md-3">
                                <label class="form-label small text-muted">Date</label>
                                <input type="date" class="form-control" name="date" value="${param.date}">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label small text-muted">Status</label>
                                <select class="form-select" name="status">
                                    <option value="">All Statuses</option>
                                    <option value="PENDING" ${param.status == 'PENDING' ? 'selected' : ''}>Pending</option>
                                    <option value="CONFIRMED" ${param.status == 'CONFIRMED' ? 'selected' : ''}>Confirmed</option>
                                    <option value="CHECKED_IN" ${param.status == 'CHECKED_IN' ? 'selected' : ''}>Checked In</option>
                                    <option value="COMPLETED" ${param.status == 'COMPLETED' ? 'selected' : ''}>Completed</option>
                                    <option value="CANCELLED" ${param.status == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small text-muted">Phone Number</label>
                                <input type="text" class="form-control" name="phone" placeholder="Search by phone..." value="${param.phone}">
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-primary w-100"><i class="fa-solid fa-filter me-2"></i>Filter</button>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="card shadow-sm border-0">
                    <div class="card-body p-0">
                        <table class="table table-hover mb-0 align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th class="ps-4">ID</th>
                                    <th>Customer</th>
                                    <th>Date & Time</th>
                                    <th>Guests</th>
                                    <th>Status</th>
                                    <th class="text-end pe-4">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty reservations}">
                                        <tr>
                                            <td colspan="6" class="text-center py-5 text-muted">
                                                <i class="fa-regular fa-folder-open fs-1 mb-3 d-block"></i>
                                                No reservations found.
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach items="${reservations}" var="res">
                                            <tr>
                                                <td class="ps-4 fw-bold text-secondary">#${res.id}</td>
                                                <td>
                                                    <div class="fw-bold">${empty res.user ? res.guestName : res.user.fullName}</div>
                                                    <div class="small text-muted"><i class="fa-solid fa-phone me-1"></i>${empty res.user ? res.guestPhone : res.user.phone}</div>
                                                </td>
                                                <td>
                                                    <div><i class="fa-regular fa-calendar me-1"></i><fmt:formatDate value="${res.reservationDate}" pattern="dd/MM/yyyy" /></div>
                                                    <div class="fw-bold text-primary"><i class="fa-regular fa-clock me-1"></i><fmt:formatDate value="${res.reservationTime}" pattern="HH:mm" /></div>
                                                </td>
                                                <td>
                                                    <span class="badge bg-light text-dark border"><i class="fa-solid fa-user me-1"></i>${res.adultsCount} Adults</span>
                                                    <c:if test="${res.childrenCount > 0}">
                                                        <span class="badge bg-light text-dark border"><i class="fa-solid fa-child me-1"></i>${res.childrenCount} Children</span>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${res.status == 'PENDING'}"><span class="badge bg-warning text-dark status-badge">Pending</span></c:when>
                                                        <c:when test="${res.status == 'CONFIRMED'}"><span class="badge bg-info text-dark status-badge">Confirmed</span></c:when>
                                                        <c:when test="${res.status == 'CHECKED_IN'}"><span class="badge bg-primary status-badge">Checked In</span></c:when>
                                                        <c:when test="${res.status == 'COMPLETED'}"><span class="badge bg-success status-badge">Completed</span></c:when>
                                                        <c:when test="${res.status == 'CANCELLED'}"><span class="badge bg-danger status-badge">Cancelled</span></c:when>
                                                    </c:choose>
                                                </td>
                                                <td class="text-end pe-4">
                                                    <!-- Actions based on status -->
                                                    <c:if test="${res.status == 'PENDING'}">
                                                        <form action="reservations" method="POST" class="d-inline">
                                                            <input type="hidden" name="action" value="updateStatus">
                                                            <input type="hidden" name="id" value="${res.id}">
                                                            <input type="hidden" name="status" value="CONFIRMED">
                                                            <button type="submit" class="btn btn-sm btn-outline-info" title="Confirm"><i class="fa-solid fa-check"></i></button>
                                                        </form>
                                                    </c:if>
                                                    <c:if test="${res.status == 'CONFIRMED'}">
                                                        <form action="reservations" method="POST" class="d-inline">
                                                            <input type="hidden" name="action" value="updateStatus">
                                                            <input type="hidden" name="id" value="${res.id}">
                                                            <input type="hidden" name="status" value="CHECKED_IN">
                                                            <button type="submit" class="btn btn-sm btn-outline-primary" title="Check In"><i class="fa-solid fa-sign-in-alt"></i></button>
                                                        </form>
                                                    </c:if>
                                                    <c:if test="${res.status == 'CHECKED_IN'}">
                                                        <form action="reservations" method="POST" class="d-inline">
                                                            <input type="hidden" name="action" value="updateStatus">
                                                            <input type="hidden" name="id" value="${res.id}">
                                                            <input type="hidden" name="status" value="COMPLETED">
                                                            <button type="submit" class="btn btn-sm btn-outline-success" title="Complete"><i class="fa-solid fa-check-double"></i></button>
                                                        </form>
                                                    </c:if>
                                                    <c:if test="${res.status != 'CANCELLED' && res.status != 'COMPLETED'}">
                                                        <form action="reservations" method="POST" class="d-inline" onsubmit="return confirm('Are you sure you want to cancel this reservation?');">
                                                            <input type="hidden" name="action" value="updateStatus">
                                                            <input type="hidden" name="id" value="${res.id}">
                                                            <input type="hidden" name="status" value="CANCELLED">
                                                            <button type="submit" class="btn btn-sm btn-outline-danger" title="Cancel"><i class="fa-solid fa-ban"></i></button>
                                                        </form>
                                                    </c:if>
                                                    
                                                    <button class="btn btn-sm btn-light ms-1 border" data-bs-toggle="modal" data-bs-target="#detailsModal${res.id}" title="Details">
                                                        <i class="fa-solid fa-eye"></i>
                                                    </button>
                                                    
                                                    <!-- Details Modal -->
                                                    <div class="modal fade text-start" id="detailsModal${res.id}" tabindex="-1">
                                                        <div class="modal-dialog modal-lg">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title fw-bold"><i class="fa-solid fa-receipt me-2 text-primary"></i>Reservation #${res.id} Details</h5>
                                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                                </div>
                                                                <div class="modal-body">
                                                                    <div class="row mb-4">
                                                                        <div class="col-sm-6">
                                                                            <h6 class="text-muted small text-uppercase">Customer</h6>
                                                                            <div class="fw-bold">${empty res.user ? res.guestName : res.user.fullName}</div>
                                                                            <div>${empty res.user ? res.guestPhone : res.user.phone}</div>
                                                                            <div class="mt-2 text-muted small">Adults: ${res.adultsCount} | Children: ${res.childrenCount}</div>
                                                                        </div>
                                                                        <div class="col-sm-6 text-sm-end">
                                                                            <h6 class="text-muted small text-uppercase">Time</h6>
                                                                            <div class="fw-bold"><fmt:formatDate value="${res.reservationDate}" pattern="dd/MM/yyyy" /></div>
                                                                            <div class="text-primary fw-bold"><fmt:formatDate value="${res.reservationTime}" pattern="HH:mm" /></div>
                                                                        </div>
                                                                    </div>
                                                                    
                                                                    <h6 class="fw-bold border-bottom pb-2"><i class="fa-solid fa-chair me-2"></i>Tables</h6>
                                                                    <ul class="list-group list-group-flush mb-4">
                                                                        <c:forEach items="${res.reservationTables}" var="rt">
                                                                            <li class="list-group-item px-0 d-flex justify-content-between">
                                                                                <span>Table ${rt.diningTable.tableCode} <small class="text-muted">(${rt.diningTable.capacity} seats)</small></span>
                                                                                <span class="text-success fw-bold"><fmt:formatNumber value="${rt.diningTable.basePrice}" pattern="#,##0" />đ</span>
                                                                            </li>
                                                                        </c:forEach>
                                                                        <c:if test="${empty res.reservationTables}">
                                                                            <li class="list-group-item px-0 text-muted small">No tables assigned.</li>
                                                                        </c:if>
                                                                    </ul>
                                                                    
                                                                    <h6 class="fw-bold border-bottom pb-2"><i class="fa-solid fa-utensils me-2"></i>Menu Items</h6>
                                                                    <ul class="list-group list-group-flush mb-4">
                                                                        <c:forEach items="${res.reservationMenuItems}" var="rmi">
                                                                            <li class="list-group-item px-0 d-flex justify-content-between">
                                                                                <span>${not empty rmi.menuItem ? rmi.menuItem.itemName : rmi.menuSet.setName} <span class="badge bg-secondary ms-1">x${rmi.quantity}</span></span>
                                                                                <span class="text-success fw-bold"><fmt:formatNumber value="${rmi.unitPrice * rmi.quantity}" pattern="#,##0" />đ</span>
                                                                            </li>
                                                                        </c:forEach>
                                                                        <c:if test="${empty res.reservationMenuItems}">
                                                                            <li class="list-group-item px-0 text-muted small">No menu items ordered.</li>
                                                                        </c:if>
                                                                    </ul>
                                                                    
                                                                    <h6 class="fw-bold border-bottom pb-2"><i class="fa-solid fa-star me-2"></i>Add-on Services</h6>
                                                                    <ul class="list-group list-group-flush">
                                                                        <c:forEach items="${res.reservationAddons}" var="ra">
                                                                            <li class="list-group-item px-0 d-flex justify-content-between">
                                                                                <span>${ra.addonService.serviceName} <span class="badge bg-secondary ms-1">x${ra.quantity}</span></span>
                                                                                <span class="text-success fw-bold"><fmt:formatNumber value="${ra.unitPrice * ra.quantity}" pattern="#,##0" />đ</span>
                                                                            </li>
                                                                        </c:forEach>
                                                                        <c:if test="${empty res.reservationAddons}">
                                                                            <li class="list-group-item px-0 text-muted small">No add-on services requested.</li>
                                                                        </c:if>
                                                                    </ul>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
