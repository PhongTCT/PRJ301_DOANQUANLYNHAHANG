<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setLocale value="${sessionScope.lang}" scope="session" />
<fmt:setBundle basename="i18n.messages" scope="session" />
<jsp:include page="header.jsp" />

<main>
    <section class="py-5">
        <div class="container">
            <div class="row align-items-end g-4">
                <div class="col-lg-8">
                    <span class="badge text-bg-light border text-dark text-uppercase fw-semibold">Booking</span>
                    <h1 class="display-4 mt-3 mb-3">Reserve a dining space.</h1>
                    <p class="text-secondary fs-5 mb-0">Choose a date, party size, occasion, and preferred room tier. Each seating category shows capacity and deposit clearly.</p>
                </div>
                <div class="col-lg-4 text-lg-end">
                    <a href="MainController?action=menu" class="btn btn-outline-dark">View Menu</a>
                </div>
            </div>
        </div>
    </section>

    <section class="py-5 bg-light border-top border-bottom">
        <div class="container">
            <c:if test="${not empty pageError}">
                <div class="alert alert-warning">${pageError}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert alert-success">${success}</div>
            </c:if>

            <div class="row g-5">
                <div class="col-lg-5">
                    <form action="MainController" method="POST" class="card shadow-sm border-0 p-4 p-lg-5 sticky-lg-top" style="top: 96px;">
                        <input type="hidden" name="action" value="dobooking">
                        <span class="badge text-bg-light border text-dark text-uppercase fw-semibold">Reservation Form</span>
                        <h2 class="display-6 mt-3 mb-4">Request a table</h2>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Date</label>
                                <input type="date" name="reservationDate" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Time</label>
                                <input type="time" name="reservationTime" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Adults</label>
                                <input type="number" min="1" name="adultsCount" value="2" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Children</label>
                                <input type="number" min="0" name="childrenCount" value="0" class="form-control">
                            </div>
                            <div class="col-12">
                                <label class="form-label small fw-bold">Occasion</label>
                                <select name="eventTypeId" class="form-select">
                                    <c:forEach items="${eventTypes}" var="eventType">
                                        <option value="${eventType.id}">${eventType.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-12 pt-2">
                                <button type="submit" class="btn btn-dark w-100">Save Draft</button>
                            </div>
                        </div>
                    </form>
                </div>

                <div class="col-lg-7">
                    <div class="mb-4">
                        <span class="badge text-bg-light border text-dark text-uppercase fw-semibold">Dining Spaces</span>
                        <h2 class="display-5 mt-3 mb-3">Seating tiers</h2>
                        <p class="text-secondary mb-0">Minimal rooms, different levels of privacy, and transparent deposits.</p>
                    </div>
                    <div class="row g-4 mb-5">
                        <div class="col-md-6">
                            <article class="card shadow-sm border-0  h-100">
                                <img src="https://images.pexels.com/photos/3887985/pexels-photo-3887985.jpeg?auto=compress&cs=tinysrgb&w=900" class="space-image" alt="Main dining room">
                                <div class="p-4">
                                    <h3 class="h4">Main Dining Room</h3>
                                    <p class="text-secondary small">2-4 guests · bright room · best for first visits.</p>
                                    <div class="set-price">Deposit 300,000 VND</div>
                                </div>
                            </article>
                        </div>
                        <div class="col-md-6">
                            <article class="card shadow-sm border-0  h-100">
                                <img src="https://images.pexels.com/photos/29033149/pexels-photo-29033149.jpeg?auto=compress&cs=tinysrgb&w=900" class="space-image" alt="Window table">
                                <div class="p-4">
                                    <h3 class="h4">Window Table</h3>
                                    <p class="text-secondary small">2 guests · quiet corner · natural light.</p>
                                    <div class="set-price">Deposit 500,000 VND</div>
                                </div>
                            </article>
                        </div>
                        <div class="col-md-6">
                            <article class="card shadow-sm border-0  h-100">
                                <img src="https://images.pexels.com/photos/4577179/pexels-photo-4577179.jpeg?auto=compress&cs=tinysrgb&w=900" class="space-image" alt="Garden lounge">
                                <div class="p-4">
                                    <h3 class="h4">Garden Lounge</h3>
                                    <p class="text-secondary small">2-6 guests · relaxed luxury · evening cocktails.</p>
                                    <div class="set-price">Deposit 700,000 VND</div>
                                </div>
                            </article>
                        </div>
                        <div class="col-md-6">
                            <article class="card shadow-sm border-0  h-100">
                                <img src="https://images.pexels.com/photos/5863513/pexels-photo-5863513.jpeg?auto=compress&cs=tinysrgb&w=900" class="space-image" alt="Private dining room">
                                <div class="p-4">
                                    <h3 class="h4">Private Dining Room</h3>
                                    <p class="text-secondary small">6-10 guests · private service · business dinner.</p>
                                    <div class="set-price">Deposit 1,500,000 VND</div>
                                </div>
                            </article>
                        </div>
                        <div class="col-md-6">
                            <article class="card shadow-sm border-0  h-100">
                                <img src="https://images.pexels.com/photos/1989164/pexels-photo-1989164.jpeg?auto=compress&cs=tinysrgb&w=900" class="space-image" alt="Chef counter">
                                <div class="p-4">
                                    <h3 class="h4">Chef's Counter</h3>
                                    <p class="text-secondary small">2-6 guests · kitchen view · tasting menu focus.</p>
                                    <div class="set-price">Deposit 2,000,000 VND</div>
                                </div>
                            </article>
                        </div>
                        <div class="col-md-6">
                            <article class="card shadow-sm border-0  h-100">
                                <img src="https://images.pexels.com/photos/35452249/pexels-photo-35452249.jpeg?auto=compress&cs=tinysrgb&w=900" class="space-image" alt="Royal suite dining">
                                <div class="p-4">
                                    <h3 class="h4">Royal Suite Dining</h3>
                                    <p class="text-secondary small">8-14 guests · VIP suite · private celebration.</p>
                                    <div class="set-price">Deposit 3,500,000 VND</div>
                                </div>
                            </article>
                        </div>
                    </div>

                    <div class="d-flex align-items-end justify-content-between flex-wrap gap-3 mb-4">
                        <div>
                            <span class="badge text-bg-light border text-dark text-uppercase fw-semibold">Live Status</span>
                            <h2 class="display-6 mt-3 mb-0">Available tables</h2>
                        </div>
                        <div class="small text-secondary">Green status means ready to reserve.</div>
                    </div>
                    <div class="row g-4">
                        <c:forEach items="${tables}" var="tb">
                            <div class="col-md-6">
                                <article class="card shadow-sm border-0 h-100 p-4 ">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <div>
                                            <div class="table-code">${tb.tableCode}</div>
                                            <div class="text-secondary small">${tb.room.roomName}</div>
                                        </div>
                                        <span class="badge ${tb.status == 'AVAILABLE' ? 'text-bg-success' : 'text-bg-danger'}">${tb.status}</span>
                                    </div>
                                    <div class="d-flex justify-content-between small mb-2">
                                        <span class="text-secondary">Capacity</span>
                                        <span class="fw-bold">${tb.capacity} guests</span>
                                    </div>
                                    <div class="d-flex justify-content-between small mb-3">
                                        <span class="text-secondary">Base price</span>
                                        <span class="fw-bold text-success"><fmt:formatNumber value="${tb.basePrice}" pattern="#,##0"/> VND</span>
                                    </div>
                                    <button class="btn ${tb.status == 'AVAILABLE' ? 'btn-dark' : 'btn-outline-secondary'} btn-sm w-100" ${tb.status == 'AVAILABLE' ? '' : 'disabled'}>
                                        Select Table
                                    </button>
                                </article>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </section>
</main>

<jsp:include page="footer.jsp" />
