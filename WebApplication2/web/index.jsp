<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="header.jsp" />

<section class="hero">
    <div class="container">
        <div class="hero-panel">
            <span class="eyebrow mb-3"><i class="fa-solid fa-seedling"></i> Fresh table booking</span>
            <h1 class="hero-title mb-4">Le Royal</h1>
            <p class="hero-copy mb-4">Reserve a bright dining space, browse signature dishes, and prepare a memorable meal in just a few clicks.</p>
            <div class="d-flex flex-wrap gap-2 mb-4">
                <a href="MainController?action=booking" class="btn btn-brand btn-lg px-4">
                    <i class="fa-regular fa-calendar-check me-2"></i>Book a Table
                </a>
                <a href="MainController?action=menu" class="btn btn-quiet btn-lg px-4">View Menu</a>
            </div>
            <div class="row g-2">
                <div class="col-sm-4">
                    <div class="hero-stat">
                        <div class="fw-bold fs-5">Fresh</div>
                        <div class="small muted">daily menu</div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="hero-stat">
                        <div class="fw-bold fs-5">Private</div>
                        <div class="small muted">VIP rooms</div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="hero-stat">
                        <div class="fw-bold fs-5">Simple</div>
                        <div class="small muted">online booking</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<main>
    <c:if test="${not empty pageError}">
        <div class="container mt-4">
            <div class="alert alert-warning">${pageError}</div>
        </div>
    </c:if>

    <section class="container py-5">
        <div class="row align-items-end g-3 mb-4">
            <div class="col-lg-8">
                <span class="eyebrow mb-2"><i class="fa-solid fa-bowl-food"></i> Guest favorites</span>
                <h2 class="display-6 fw-bold mb-2">Featured Menu</h2>
                <p class="muted mb-0">Popular dishes from the active kitchen catalog.</p>
            </div>
            <div class="col-lg-4 text-lg-end">
                <a href="MainController?action=menu" class="btn btn-outline-brand px-4">All Items</a>
            </div>
        </div>

        <div class="row g-4">
            <c:forEach items="${featuredMenu}" var="item" varStatus="loop">
                <div class="col-md-4">
                    <article class="surface h-100 p-3 shadow-lift">
                        <c:choose>
                            <c:when test="${loop.index == 0}">
                                <img class="card-image mb-3" src="https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?auto=format&fit=crop&w=900&q=80" alt="Fresh salad dish">
                            </c:when>
                            <c:when test="${loop.index == 1}">
                                <img class="card-image mb-3" src="https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=900&q=80" alt="Warm soup bowl">
                            </c:when>
                            <c:otherwise>
                                <img class="card-image mb-3" src="https://images.unsplash.com/photo-1551183053-bf91a1d81141?auto=format&fit=crop&w=900&q=80" alt="Restaurant main course">
                            </c:otherwise>
                        </c:choose>
                        <div class="d-flex justify-content-between gap-3 mb-2">
                            <h3 class="h5 fw-bold mb-0">${item.itemName}</h3>
                            <span class="badge price-badge align-self-start">
                                <fmt:formatNumber value="${item.basePrice}" pattern="#,##0"/> VND
                            </span>
                        </div>
                        <p class="muted small mb-3">${item.description}</p>
                        <span class="category-pill small">${item.category.categoryName}</span>
                    </article>
                </div>
            </c:forEach>
        </div>
    </section>

    <section class="section-band py-5">
        <div class="container">
            <div class="row g-4 align-items-center">
                <div class="col-lg-5">
                    <span class="eyebrow mb-2"><i class="fa-solid fa-chair"></i> Seating choices</span>
                    <h2 class="display-6 fw-bold mb-3">Dining Spaces</h2>
                    <p class="muted mb-4">Choose from standard rooms, garden seating, private VIP spaces, and premium table setups.</p>
                    <a href="MainController?action=booking" class="btn btn-brand px-4">Book Now</a>
                </div>
                <div class="col-lg-7">
                    <div class="row g-3">
                        <c:forEach items="${tables}" var="tb">
                            <div class="col-sm-6">
                                <article class="surface h-100 p-3">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <div>
                                            <div class="table-code">${tb.tableCode}</div>
                                            <div class="muted small">${tb.room.roomName}</div>
                                        </div>
                                        <span class="badge ${tb.status == 'AVAILABLE' ? 'text-bg-success' : 'text-bg-danger'}">${tb.status}</span>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center small">
                                        <span class="muted"><i class="fa-solid fa-users me-1"></i>${tb.capacity} guests</span>
                                        <span class="fw-bold text-success">
                                            <fmt:formatNumber value="${tb.basePrice}" pattern="#,##0"/> VND
                                        </span>
                                    </div>
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
