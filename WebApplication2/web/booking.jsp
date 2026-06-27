<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="header.jsp" />

<main>
    <section class="section-band py-5">
        <div class="container">
            <div class="row align-items-center g-4">
                <div class="col-lg-7">
                    <span class="eyebrow mb-2"><i class="fa-regular fa-calendar-check"></i> Online booking</span>
                    <h1 class="display-5 fw-bold mb-3">Choose Your Table</h1>
                    <p class="muted mb-0">Select a date, party size, event type, and a bright dining space that fits your occasion.</p>
                </div>
                <div class="col-lg-5">
                    <img src="https://images.unsplash.com/photo-1521017432531-fbd92d768814?auto=format&fit=crop&w=900&q=80" class="img-fluid rounded-4 shadow-lift" alt="Restaurant table ready for booking">
                </div>
            </div>
        </div>
    </section>

    <section class="container py-5">
        <c:if test="${not empty pageError}">
            <div class="alert alert-warning">${pageError}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>

        <form action="MainController" method="POST" class="surface p-4 mb-5 shadow-lift">
            <input type="hidden" name="action" value="dobooking">
            <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-4">
                <div>
                    <h2 class="h4 fw-bold mb-1">Reservation Details</h2>
                    <p class="muted small mb-0">Save your preferred time before choosing a table.</p>
                </div>
                <span class="category-pill small">Step 1</span>
            </div>
            <div class="row g-3 align-items-end">
                <div class="col-md-3">
                    <label class="form-label small fw-bold">Date</label>
                    <input type="date" name="reservationDate" class="form-control" required>
                </div>
                <div class="col-md-2">
                    <label class="form-label small fw-bold">Time</label>
                    <input type="time" name="reservationTime" class="form-control" required>
                </div>
                <div class="col-md-2">
                    <label class="form-label small fw-bold">Adults</label>
                    <input type="number" min="1" name="adultsCount" value="2" class="form-control" required>
                </div>
                <div class="col-md-2">
                    <label class="form-label small fw-bold">Children</label>
                    <input type="number" min="0" name="childrenCount" value="0" class="form-control">
                </div>
                <div class="col-md-3">
                    <label class="form-label small fw-bold">Event</label>
                    <select name="eventTypeId" class="form-select">
                        <c:forEach items="${eventTypes}" var="eventType">
                            <option value="${eventType.id}">${eventType.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-12">
                    <button type="submit" class="btn btn-brand px-4">
                        <i class="fa-regular fa-floppy-disk me-2"></i>Save Draft
                    </button>
                </div>
            </div>
        </form>

        <div class="d-flex align-items-end justify-content-between flex-wrap gap-3 mb-4">
            <div>
                <span class="eyebrow mb-2"><i class="fa-solid fa-chair"></i> Available seating</span>
                <h2 class="display-6 fw-bold mb-0">Tables</h2>
            </div>
            <div class="small muted">Green status means the table is ready to reserve.</div>
        </div>

        <div class="row g-4">
            <c:forEach items="${tables}" var="tb">
                <div class="col-lg-3 col-md-4 col-sm-6">
                    <article class="surface h-100 p-3 shadow-lift">
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <div>
                                <div class="table-code">${tb.tableCode}</div>
                                <div class="muted small">${tb.room.roomName}</div>
                            </div>
                            <span class="badge ${tb.status == 'AVAILABLE' ? 'text-bg-success' : 'text-bg-danger'}">${tb.status}</span>
                        </div>
                        <div class="surface-soft p-3 mb-3">
                            <div class="d-flex justify-content-between small mb-2">
                                <span class="muted"><i class="fa-solid fa-users me-1"></i>Capacity</span>
                                <span class="fw-bold">${tb.capacity} guests</span>
                            </div>
                            <div class="d-flex justify-content-between small">
                                <span class="muted"><i class="fa-solid fa-coins me-1"></i>Base price</span>
                                <span class="fw-bold text-success">
                                    <fmt:formatNumber value="${tb.basePrice}" pattern="#,##0"/> VND
                                </span>
                            </div>
                        </div>
                        <button class="btn ${tb.status == 'AVAILABLE' ? 'btn-brand' : 'btn-quiet'} btn-sm w-100" ${tb.status == 'AVAILABLE' ? '' : 'disabled'}>
                            Select Table
                        </button>
                    </article>
                </div>
            </c:forEach>
        </div>
    </section>
</main>

<jsp:include page="footer.jsp" />
