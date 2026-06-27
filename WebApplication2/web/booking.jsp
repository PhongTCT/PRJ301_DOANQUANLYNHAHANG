<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="header.jsp" />

<main class="container my-5">
    <div class="mb-4">
        <span class="badge price-badge mb-2">Online booking</span>
        <h1 class="display-5 fw-bold mb-2">Choose Your Table</h1>
        <p class="muted mb-0">Select a date, party size, event type, and available table.</p>
    </div>

    <c:if test="${not empty pageError}">
        <div class="alert alert-warning">${pageError}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>
    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>

    <form action="MainController" method="POST" class="surface p-3 mb-4">
        <input type="hidden" name="action" value="dobooking">
        <div class="row g-3 align-items-end">
            <div class="col-md-3">
                <label class="form-label small muted">Date</label>
                <input type="date" name="reservationDate" class="form-control bg-dark text-light border-secondary" required>
            </div>
            <div class="col-md-2">
                <label class="form-label small muted">Time</label>
                <input type="time" name="reservationTime" class="form-control bg-dark text-light border-secondary" required>
            </div>
            <div class="col-md-2">
                <label class="form-label small muted">Adults</label>
                <input type="number" min="1" name="adultsCount" value="2" class="form-control bg-dark text-light border-secondary" required>
            </div>
            <div class="col-md-2">
                <label class="form-label small muted">Children</label>
                <input type="number" min="0" name="childrenCount" value="0" class="form-control bg-dark text-light border-secondary">
            </div>
            <div class="col-md-3">
                <label class="form-label small muted">Event</label>
                <select name="eventTypeId" class="form-select bg-dark text-light border-secondary">
                    <c:forEach items="${eventTypes}" var="eventType">
                        <option value="${eventType.id}">${eventType.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-12">
                <button type="submit" class="btn btn-gold">
                    <i class="fa-regular fa-floppy-disk me-2"></i>Save Draft
                </button>
            </div>
        </div>
    </form>

    <div class="row g-3">
        <c:forEach items="${tables}" var="tb">
            <div class="col-lg-3 col-md-4 col-sm-6">
                <article class="surface h-100 p-3">
                    <div class="d-flex justify-content-between align-items-start mb-2">
                        <div>
                            <div class="table-code">${tb.tableCode}</div>
                            <div class="muted small">${tb.room.roomName}</div>
                        </div>
                        <span class="badge ${tb.status == 'AVAILABLE' ? 'bg-success' : 'bg-danger'}">${tb.status}</span>
                    </div>
                    <p class="small muted mb-2">
                        <i class="fa-solid fa-users me-1"></i>${tb.capacity} guests
                    </p>
                    <p class="small muted mb-3">
                        <i class="fa-solid fa-coins me-1"></i>
                        <fmt:formatNumber value="${tb.basePrice}" pattern="#,##0"/> VND
                    </p>
                    <button class="btn btn-outline-warning btn-sm w-100" ${tb.status == 'AVAILABLE' ? '' : 'disabled'}>
                        Select Table
                    </button>
                </article>
            </div>
        </c:forEach>
    </div>
</main>

<jsp:include page="footer.jsp" />
