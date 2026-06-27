<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="header.jsp" />

<section class="hero">
    <div class="container">
        <div class="row">
            <div class="col-lg-7">
                <span class="badge price-badge mb-3">Fine dining and online booking</span>
                <h1 class="display-3 fw-bold mb-3">Le Royal</h1>
                <p class="lead muted mb-4">Reserve the right table, preview signature dishes, and enjoy a calm fine dining experience.</p>
                <div class="d-flex flex-wrap gap-2">
                    <a href="MainController?action=booking" class="btn btn-gold btn-lg">
                        <i class="fa-regular fa-calendar-check me-2"></i>Book a Table
                    </a>
                    <a href="MainController?action=menu" class="btn btn-outline-light btn-lg">View Menu</a>
                </div>
            </div>
        </div>
    </div>
</section>

<main class="container my-5">
    <c:if test="${not empty pageError}">
        <div class="alert alert-warning">${pageError}</div>
    </c:if>

    <section class="mb-5">
        <div class="d-flex justify-content-between align-items-end mb-3">
            <div>
                <h2 class="h3 fw-bold mb-1">Featured Menu</h2>
                <p class="muted mb-0">Popular dishes from the active menu catalog.</p>
            </div>
            <a href="MainController?action=menu" class="btn btn-outline-warning btn-sm">All Items</a>
        </div>
        <div class="row g-3">
            <c:forEach items="${featuredMenu}" var="item">
                <div class="col-md-4">
                    <article class="surface h-100 p-3">
                        <div class="d-flex justify-content-between gap-3 mb-2">
                            <h3 class="h5 mb-0">${item.itemName}</h3>
                            <span class="badge price-badge align-self-start">
                                <fmt:formatNumber value="${item.basePrice}" pattern="#,##0"/> VND
                            </span>
                        </div>
                        <p class="muted small mb-3">${item.description}</p>
                        <span class="small text-warning">${item.category.categoryName}</span>
                    </article>
                </div>
            </c:forEach>
        </div>
    </section>

    <section>
        <div class="d-flex justify-content-between align-items-end mb-3">
            <div>
                <h2 class="h3 fw-bold mb-1">Dining Spaces</h2>
                <p class="muted mb-0">Choose from standard rooms, private spaces, and premium seating.</p>
            </div>
            <a href="MainController?action=booking" class="btn btn-outline-warning btn-sm">Book Now</a>
        </div>
        <div class="row g-3">
            <c:forEach items="${tables}" var="tb">
                <div class="col-lg-3 col-sm-6">
                    <article class="surface h-100 p-3">
                        <div class="table-code">${tb.tableCode}</div>
                        <div class="muted small mb-2">${tb.room.roomName}</div>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="small"><i class="fa-solid fa-users me-1"></i>${tb.capacity} guests</span>
                            <span class="badge ${tb.status == 'AVAILABLE' ? 'bg-success' : 'bg-danger'}">${tb.status}</span>
                        </div>
                    </article>
                </div>
            </c:forEach>
        </div>
    </section>
</main>

<jsp:include page="footer.jsp" />
