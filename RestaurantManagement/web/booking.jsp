<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="${sessionScope.lang}" scope="session" />
<fmt:setBundle basename="i18n.messages" scope="session" />
<jsp:include page="header.jsp" />

<main>
    <section class="section-band py-5">
        <div class="container">
            <div class="row align-items-center g-4">
                <div class="col-lg-7">
                    <span class="eyebrow mb-2"><i class="fa-regular fa-calendar-check"></i> <fmt:message key="booking.eyebrow"/></span>
                    <h1 class="display-5 fw-bold mb-3"><fmt:message key="booking.title"/></h1>
                    <p class="muted mb-0"><fmt:message key="booking.desc"/></p>
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
                    <h2 class="h4 fw-bold mb-1"><fmt:message key="booking.details.title"/></h2>
                    <p class="muted small mb-0"><fmt:message key="booking.details.desc"/></p>
                </div>
                <span class="category-pill small"><fmt:message key="booking.step1"/></span>
            </div>
            <div class="row g-3 align-items-end">
                <div class="col-md-3">
                    <label class="form-label small fw-bold"><fmt:message key="booking.date"/></label>
                    <input type="date" name="reservationDate" class="form-control" required>
                </div>
                <div class="col-md-2">
                    <label class="form-label small fw-bold"><fmt:message key="booking.time"/></label>
                    <input type="time" name="reservationTime" class="form-control" required>
                </div>
                <div class="col-md-2">
                    <label class="form-label small fw-bold"><fmt:message key="booking.adults"/></label>
                    <input type="number" min="1" name="adultsCount" value="2" class="form-control" required>
                </div>
                <div class="col-md-2">
                    <label class="form-label small fw-bold"><fmt:message key="booking.children"/></label>
                    <input type="number" min="0" name="childrenCount" value="0" class="form-control">
                </div>
                <div class="col-md-3">
                    <label class="form-label small fw-bold"><fmt:message key="booking.event"/></label>
                    <select name="eventTypeId" class="form-select">
                        <c:forEach items="${eventTypes}" var="eventType">
                            <option value="${eventType.id}">${eventType.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-12">
                    <button type="submit" class="btn btn-brand px-4">
                        <i class="fa-regular fa-floppy-disk me-2"></i><fmt:message key="booking.btn.save"/>
                    </button>
                </div>
            </div>
        </form>

        <div class="d-flex align-items-end justify-content-between flex-wrap gap-3 mb-4">
            <div>
                <span class="eyebrow mb-2"><i class="fa-solid fa-chair"></i> <fmt:message key="booking.tables.eyebrow"/></span>
                <h2 class="display-6 fw-bold mb-0"><fmt:message key="booking.tables.title"/></h2>
            </div>
            <div class="small muted"><fmt:message key="booking.tables.desc"/></div>
        </div>

        <div class="row g-4">
            <c:forEach items="${tables}" var="tb">
                <div class="col-lg-3 col-md-4 col-sm-6">
                    <article class="surface h-100 p-3 shadow-lift">
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <div>
                                <div class="table-code">${tb.tableCode}</div>
                                <div class="muted small">
                                    <c:choose>
                                        <c:when test="${sessionScope.lang == 'en' and fn:contains(tb.room.roomName, 'Khu chung')}">Standard Dining Area</c:when>
                                        <c:when test="${sessionScope.lang == 'en' and fn:contains(tb.room.roomName, 'VIP Vàng')}">Golden VIP Room</c:when>
                                        <c:when test="${sessionScope.lang == 'en' and fn:contains(tb.room.roomName, 'Sân Vườn')}">Rose Garden Patio</c:when>
                                        <c:when test="${sessionScope.lang == 'en' and fn:contains(tb.room.roomName, 'Biệt Thự')}">Royal VVIP Villa</c:when>
                                        <c:otherwise>${tb.room.roomName}</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <span class="badge ${tb.status == 'AVAILABLE' ? 'text-bg-success' : 'text-bg-danger'}">
                                <c:choose>
                                    <c:when test="${sessionScope.lang == 'en'}">${tb.status}</c:when>
                                    <c:when test="${tb.status == 'AVAILABLE'}">Sẵn sàng</c:when>
                                    <c:when test="${tb.status == 'RESERVED'}">Đã đặt</c:when>
                                    <c:when test="${tb.status == 'OCCUPIED'}">Đang dùng</c:when>
                                    <c:otherwise>${tb.status}</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="surface-soft p-3 mb-3">
                            <div class="d-flex justify-content-between small mb-2">
                                <span class="muted"><i class="fa-solid fa-users me-1"></i><fmt:message key="booking.capacity"/></span>
                                <span class="fw-bold">${tb.capacity} <fmt:message key="spaces.guests"/></span>
                            </div>
                            <div class="d-flex justify-content-between small">
                                <span class="muted"><i class="fa-solid fa-coins me-1"></i><fmt:message key="booking.baseprice"/></span>
                                <span class="fw-bold text-success">
                                    <fmt:formatNumber value="${tb.basePrice}" pattern="#,##0"/> VND
                                </span>
                            </div>
                        </div>
                        <button class="btn ${tb.status == 'AVAILABLE' ? 'btn-brand' : 'btn-quiet'} btn-sm w-100" ${tb.status == 'AVAILABLE' ? '' : 'disabled'}>
                            <fmt:message key="booking.btn.select"/>
                        </button>
                    </article>
                </div>
            </c:forEach>
        </div>
    </section>
</main>

<jsp:include page="footer.jsp" />
