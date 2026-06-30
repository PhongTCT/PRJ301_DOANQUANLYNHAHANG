<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'vi'}" scope="session" />
<fmt:setBundle basename="i18n.messages" scope="session" />

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="booking.title"/></title>
    <!-- Include Bootstrap 5 via CDN for styling -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body class="bg-light">
    <!-- Basic Navigation Header placeholder, normally jsp:include header.jsp -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
        <div class="container">
            <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/"><i class="fa-solid fa-utensils me-2"></i>Restaurant</a>
        </div>
    </nav>

    <div class="container pb-5">
        <!-- Progress Indicator -->
        <div class="row justify-content-center mb-5">
            <div class="col-md-8">
                <div class="position-relative m-4">
                    <div class="progress" style="height: 2px;">
                        <div class="progress-bar" role="progressbar" style="width: 25%;" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
                    </div>
                    <button type="button" class="position-absolute top-0 start-0 translate-middle btn btn-sm btn-primary rounded-pill" style="width: 2rem; height:2rem;">1</button>
                    <button type="button" class="position-absolute top-0 start-50 translate-middle btn btn-sm btn-secondary rounded-pill" style="width: 2rem; height:2rem;">2</button>
                    <button type="button" class="position-absolute top-0 start-100 translate-middle btn btn-sm btn-secondary rounded-pill" style="width: 2rem; height:2rem;">3</button>
                </div>
                <div class="d-flex justify-content-between text-muted small mt-2">
                    <span class="fw-bold text-dark"><fmt:message key="booking.wizard.step1"/></span>
                    <span><fmt:message key="booking.wizard.step2"/></span>
                    <span><fmt:message key="booking.wizard.step3"/></span>
                </div>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                <i class="fa-solid fa-circle-exclamation me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="card shadow border-0 rounded-4">
                    <div class="card-header bg-white border-0 pt-4 pb-0 px-4">
                        <h4 class="fw-bold mb-1"><i class="fa-regular fa-calendar-check text-primary me-2"></i><fmt:message key="booking.step1.info.title"/></h4>
                        <p class="text-muted small"><fmt:message key="booking.step1.info.desc"/></p>
                    </div>
                    <div class="card-body p-4">
                        <form action="${pageContext.request.contextPath}/MainController" method="POST">
                            <input type="hidden" name="action" value="dobooking">
                            
                            <!-- Date and Time -->
                            <div class="row g-3 mb-4">
                                <div class="col-sm-6">
                                    <div class="form-floating">
                                        <c:if test="${not empty sessionScope.bookingDraft.reservationDate}">
                                            <fmt:formatDate value="${sessionScope.bookingDraft.reservationDate}" pattern="yyyy-MM-dd" var="draftDate" />
                                        </c:if>
                                        <input type="date" class="form-control" id="reservationDate" name="reservationDate" value="${draftDate}" required>
                                        <label for="reservationDate"><fmt:message key="booking.date"/></label>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="form-floating">
                                        <input type="time" class="form-control" id="reservationTime" name="reservationTime" value="${sessionScope.bookingDraft.reservationTime}" required>
                                        <label for="reservationTime"><fmt:message key="booking.time"/></label>
                                    </div>
                                </div>
                            </div>

                            <!-- Guests count -->
                            <div class="row g-3 mb-4">
                                <div class="col-sm-6">
                                    <div class="form-floating">
                                        <input type="number" class="form-control" id="adultsCount" name="adultsCount" value="${not empty sessionScope.bookingDraft.adultsCount ? sessionScope.bookingDraft.adultsCount : 2}" min="1" required>
                                        <label for="adultsCount"><fmt:message key="booking.adults"/></label>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="form-floating">
                                        <input type="number" class="form-control" id="childrenCount" name="childrenCount" value="${not empty sessionScope.bookingDraft.childrenCount ? sessionScope.bookingDraft.childrenCount : 0}" min="0">
                                        <label for="childrenCount"><fmt:message key="booking.children.desc"/></label>
                                    </div>
                                </div>
                            </div>

                            <!-- Event Type -->
                            <div class="form-floating mb-5">
                                <select class="form-select" id="eventTypeId" name="eventTypeId" aria-label="Event Type">
                                    <option value="" selected><fmt:message key="booking.event.none"/></option>
                                    <c:forEach items="${eventTypes}" var="eventType">
                                        <c:choose>
                                            <c:when test="${sessionScope.bookingDraft.eventTypeId == eventType.id}">
                                                <option value="${eventType.id}" selected>${eventType.name}</option>
                                            </c:when>
                                            <c:otherwise>
                                                <option value="${eventType.id}">${eventType.name}</option>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </select>
                                <label for="eventTypeId"><fmt:message key="booking.event.opt"/></label>
                            </div>

                            <button type="submit" class="btn btn-primary btn-lg w-100 rounded-pill py-3 fw-bold shadow-sm">
                                <fmt:message key="booking.btn.next"/> <i class="fa-solid fa-arrow-right ms-2"></i>
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Prevent selecting past dates in HTML5 date picker
            const dateInput = document.getElementById('reservationDate');
            if (dateInput) {
                // Get local date string in YYYY-MM-DD format
                const today = new Date();
                today.setMinutes(today.getMinutes() - today.getTimezoneOffset());
                dateInput.setAttribute('min', today.toISOString().split('T')[0]);
            }
        });
    </script>
</body>
</html>
