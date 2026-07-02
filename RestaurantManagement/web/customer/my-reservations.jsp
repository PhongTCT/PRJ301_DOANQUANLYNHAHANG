<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<fmt:setLocale value="${sessionScope.lang == 'en' ? 'en_US' : 'vi_VN'}" />
<fmt:setBundle basename="i18n.messages" />

<jsp:include page="/header.jsp" />

<main class="bg-light py-5" style="min-height: 80vh;">
    <div class="container">
        <h2 class="fw-bold mb-4"><i class="fa-solid fa-clock-rotate-left me-2 text-primary"></i>My Reservations</h2>
        
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-check-circle me-2"></i>${sessionScope.successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                <c:remove var="successMessage" scope="session" />
            </div>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i>${sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                <c:remove var="errorMessage" scope="session" />
            </div>
        </c:if>

        <div class="card shadow-sm border-0">
            <div class="card-body p-0">
                <table class="table table-hover mb-0 align-middle">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-4">ID</th>
                            <th>Date & Time</th>
                            <th>Guests</th>
                            <th>Status</th>
                            <th class="text-end pe-4">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty myReservations}">
                                <tr>
                                    <td colspan="5" class="text-center py-5 text-muted">
                                        <i class="fa-solid fa-folder-open fs-1 mb-3 d-block"></i>
                                        You have no reservations yet.
                                        <div class="mt-3">
                                            <a href="${pageContext.request.contextPath}/MainController?action=booking" class="btn btn-primary rounded-pill">Book a Table Now</a>
                                        </div>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach items="${myReservations}" var="res">
                                    <tr>
                                        <td class="ps-4 fw-bold text-secondary">#${res.id}</td>
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
                                                <c:when test="${res.status == 'PENDING'}"><span class="badge bg-warning text-dark px-3 py-2">Pending</span></c:when>
                                                <c:when test="${res.status == 'CONFIRMED'}"><span class="badge bg-info text-dark px-3 py-2">Confirmed</span></c:when>
                                                <c:when test="${res.status == 'CHECKED_IN'}"><span class="badge bg-primary px-3 py-2">Checked In</span></c:when>
                                                <c:when test="${res.status == 'COMPLETED'}"><span class="badge bg-success px-3 py-2">Completed</span></c:when>
                                                <c:when test="${res.status == 'CANCELLED'}"><span class="badge bg-danger px-3 py-2">Cancelled</span></c:when>
                                            </c:choose>
                                        </td>
                                        <td class="text-end pe-4">
                                            <button class="btn btn-sm btn-outline-secondary rounded-pill me-1" data-bs-toggle="modal" data-bs-target="#detailsModal${res.id}">
                                                <i class="fa-solid fa-eye me-1"></i> Details
                                            </button>
                                            
                                            <c:if test="${res.status == 'PENDING' || res.status == 'CONFIRMED'}">
                                                <form action="${pageContext.request.contextPath}/customer/reservations" method="POST" class="d-inline" onsubmit="return confirm('Are you sure you want to cancel this reservation? This cannot be undone.');">
                                                    <input type="hidden" name="action" value="cancel">
                                                    <input type="hidden" name="id" value="${res.id}">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill">
                                                        <i class="fa-solid fa-ban me-1"></i> Cancel
                                                    </button>
                                                </form>
                                            </c:if>

                                            <!-- Details Modal -->
                                            <div class="modal fade text-start" id="detailsModal${res.id}" tabindex="-1">
                                                <div class="modal-dialog modal-lg modal-dialog-centered">
                                                    <div class="modal-content border-0 shadow">
                                                        <div class="modal-header bg-light border-0">
                                                            <h5 class="modal-title fw-bold"><i class="fa-solid fa-receipt me-2 text-primary"></i>Reservation #${res.id} Details</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <div class="modal-body p-4">
                                                            <h6 class="fw-bold border-bottom pb-2"><i class="fa-solid fa-chair me-2"></i>Tables</h6>
                                                            <ul class="list-group list-group-flush mb-4">
                                                                <c:forEach items="${res.reservationTables}" var="rt">
                                                                    <li class="list-group-item px-0 d-flex justify-content-between border-light">
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
                                                                    <li class="list-group-item px-0 d-flex justify-content-between border-light">
                                                                        <span>${not empty rmi.menuItem ? rmi.menuItem.itemName : rmi.menuSet.setName} <span class="badge bg-secondary ms-1">x${rmi.quantity}</span></span>
                                                                        <span class="text-success fw-bold"><fmt:formatNumber value="${rmi.unitPrice * rmi.quantity}" pattern="#,##0" />đ</span>
                                                                    </li>
                                                                </c:forEach>
                                                                <c:if test="${empty res.reservationMenuItems}">
                                                                    <li class="list-group-item px-0 text-muted small border-light">No menu items ordered.</li>
                                                                </c:if>
                                                            </ul>
                                                            
                                                            <h6 class="fw-bold border-bottom pb-2"><i class="fa-solid fa-star me-2"></i>Add-on Services</h6>
                                                            <ul class="list-group list-group-flush">
                                                                <c:forEach items="${res.reservationAddons}" var="ra">
                                                                    <li class="list-group-item px-0 d-flex justify-content-between border-light">
                                                                        <span>${ra.addonService.serviceName} <span class="badge bg-secondary ms-1">x${ra.quantity}</span></span>
                                                                        <span class="text-success fw-bold"><fmt:formatNumber value="${ra.unitPrice * ra.quantity}" pattern="#,##0" />đ</span>
                                                                    </li>
                                                                </c:forEach>
                                                                <c:if test="${empty res.reservationAddons}">
                                                                    <li class="list-group-item px-0 text-muted small border-light">No add-on services requested.</li>
                                                                </c:if>
                                                            </ul>
                                                        </div>
                                                        <div class="modal-footer border-0 bg-light">
                                                            <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Close</button>
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
</main>

<jsp:include page="/footer.jsp" />
