<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="header.jsp" />

<main>
    <section class="section-band py-5">
        <div class="container">
            <div class="row align-items-center g-4">
                <div class="col-lg-7">
                    <span class="eyebrow mb-2"><i class="fa-solid fa-book-open"></i> Menu catalog</span>
                    <h1 class="display-5 fw-bold mb-3">Active Dishes</h1>
                    <p class="muted mb-0">Seasonal dishes, fresh drinks, and favorites prepared for every dining occasion.</p>
                </div>
                <div class="col-lg-5">
                    <div class="surface-soft p-3">
                        <div class="d-flex align-items-center gap-3">
                            <img src="https://images.unsplash.com/photo-1490645935967-10de6ba17061?auto=format&fit=crop&w=500&q=80" class="rounded-4" style="width:96px;height:96px;object-fit:cover;" alt="Fresh ingredients">
                            <div>
                                <div class="fw-bold">Kitchen ready</div>
                                <div class="small muted">Order ahead when you reserve a table.</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="container py-5">
        <c:if test="${not empty pageError}">
            <div class="alert alert-warning">${pageError}</div>
        </c:if>

        <div class="row g-4">
            <c:forEach items="${menuList}" var="item" varStatus="loop">
                <div class="col-lg-4 col-md-6">
                    <article class="surface h-100 p-3 shadow-lift">
                        <c:choose>
                            <c:when test="${loop.index mod 4 == 0}">
                                <img class="card-image mb-3" src="https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?auto=format&fit=crop&w=900&q=80" alt="Fresh menu dish">
                            </c:when>
                            <c:when test="${loop.index mod 4 == 1}">
                                <img class="card-image mb-3" src="https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=900&q=80" alt="Soup and vegetables">
                            </c:when>
                            <c:when test="${loop.index mod 4 == 2}">
                                <img class="card-image mb-3" src="https://images.unsplash.com/photo-1551183053-bf91a1d81141?auto=format&fit=crop&w=900&q=80" alt="Pasta main course">
                            </c:when>
                            <c:otherwise>
                                <img class="card-image mb-3" src="https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?auto=format&fit=crop&w=900&q=80" alt="Fresh drink">
                            </c:otherwise>
                        </c:choose>
                        <div class="d-flex justify-content-between gap-3 mb-2">
                            <h2 class="h5 fw-bold mb-0">${item.itemName}</h2>
                            <span class="badge price-badge align-self-start">
                                <fmt:formatNumber value="${item.basePrice}" pattern="#,##0"/> VND
                            </span>
                        </div>
                        <p class="muted small mb-3">${item.description}</p>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="category-pill small">${item.category.categoryName}</span>
                            <a href="MainController?action=booking" class="btn btn-outline-brand btn-sm px-3">
                                <i class="fa-solid fa-plus me-1"></i>Add
                            </a>
                        </div>
                    </article>
                </div>
            </c:forEach>
        </div>
    </section>
</main>

<jsp:include page="footer.jsp" />
