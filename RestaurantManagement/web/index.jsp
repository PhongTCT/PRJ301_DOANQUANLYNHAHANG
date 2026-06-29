<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="${sessionScope.lang}" scope="session" />
<fmt:setBundle basename="i18n.messages" scope="session" />
<jsp:include page="header.jsp" />

<section class="hero">
    <div class="container">
        <div class="hero-panel">
            <span class="eyebrow mb-3"><i class="fa-solid fa-seedling"></i> <fmt:message key="hero.eyebrow"/></span>
            <h1 class="hero-title mb-4"><fmt:message key="hero.title"/></h1>
            <p class="hero-copy mb-4"><fmt:message key="hero.copy"/></p>
            <div class="d-flex flex-wrap gap-2 mb-4">
                <a href="MainController?action=booking" class="btn btn-brand btn-lg px-4">
                    <i class="fa-regular fa-calendar-check me-2"></i><fmt:message key="hero.btn.book"/>
                </a>
                <a href="MainController?action=menu" class="btn btn-quiet btn-lg px-4"><fmt:message key="hero.btn.menu"/></a>
            </div>
            <div class="row g-2">
                <div class="col-sm-4">
                    <div class="hero-stat">
                        <div class="fw-bold fs-5"><fmt:message key="hero.stat1.title"/></div>
                        <div class="small muted"><fmt:message key="hero.stat1.sub"/></div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="hero-stat">
                        <div class="fw-bold fs-5"><fmt:message key="hero.stat2.title"/></div>
                        <div class="small muted"><fmt:message key="hero.stat2.sub"/></div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="hero-stat">
                        <div class="fw-bold fs-5"><fmt:message key="hero.stat3.title"/></div>
                        <div class="small muted"><fmt:message key="hero.stat3.sub"/></div>
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
                <span class="eyebrow mb-2"><i class="fa-solid fa-bowl-food"></i> <fmt:message key="menu.eyebrow"/></span>
                <h2 class="display-6 fw-bold mb-2"><fmt:message key="menu.title"/></h2>
                <p class="muted mb-0"><fmt:message key="menu.desc"/></p>
            </div>
            <div class="col-lg-4 text-lg-end">
                <a href="MainController?action=menu" class="btn btn-outline-brand px-4"><fmt:message key="menu.btn.all"/></a>
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
                            <h3 class="h5 fw-bold mb-0">
                                <c:choose>
                                    <c:when test="${sessionScope.lang == 'en' and fn:contains(item.itemName, 'Gỏi Ngó Sen')}">Lotus Stem Salad with Shrimp & Pork</c:when>
                                    <c:when test="${sessionScope.lang == 'en' and fn:contains(item.itemName, 'Súp Măng Tây')}">Crab & Green Asparagus Soup</c:when>
                                    <c:when test="${sessionScope.lang == 'en' and fn:contains(item.itemName, 'Bò Úc Nướng')}">Grilled Australian Beef Tenderloin</c:when>
                                    <c:when test="${sessionScope.lang == 'en' and fn:contains(item.itemName, 'Cá Hồi')}">Pan Seared Salmon with Passion Fruit</c:when>
                                    <c:otherwise>${item.itemName}</c:otherwise>
                                </c:choose>
                            </h3>
                            <span class="badge price-badge align-self-start">
                                <fmt:formatNumber value="${item.basePrice}" pattern="#,##0"/> VND
                            </span>
                        </div>
                        <p class="muted small mb-3">
                            <c:choose>
                                <c:when test="${sessionScope.lang == 'en' and fn:contains(item.itemName, 'Gỏi Ngó Sen')}">Crunchy lotus stem salad tossed with fresh tiger shrimp and savory pork belly</c:when>
                                <c:when test="${sessionScope.lang == 'en' and fn:contains(item.itemName, 'Súp Măng Tây')}">Hot rich soup served with shredded fresh crab meat and tender green asparagus</c:when>
                                <c:when test="${sessionScope.lang == 'en' and fn:contains(item.itemName, 'Bò Úc Nướng')}">Premium Australian beef tenderloin grilled to perfection with rich black pepper sauce</c:when>
                                <c:when test="${sessionScope.lang == 'en' and fn:contains(item.itemName, 'Cá Hồi')}">Fresh Atlantic salmon seared with golden butter and tangy passion fruit sauce</c:when>
                                <c:otherwise>${item.description}</c:otherwise>
                            </c:choose>
                        </p>
                        <span class="category-pill small">
                            <c:choose>
                                <c:when test="${sessionScope.lang == 'en' and fn:contains(item.category.categoryName, 'Khai Vị')}">Appetizer</c:when>
                                <c:when test="${sessionScope.lang == 'en' and fn:contains(item.category.categoryName, 'Chính')}">Main Course</c:when>
                                <c:when test="${sessionScope.lang == 'en' and fn:contains(item.category.categoryName, 'Tráng Miệng')}">Dessert</c:when>
                                <c:when test="${sessionScope.lang == 'en' and fn:contains(item.category.categoryName, 'Uống')}">Drink</c:when>
                                <c:otherwise>${item.category.categoryName}</c:otherwise>
                            </c:choose>
                        </span>
                    </article>
                </div>
            </c:forEach>
        </div>
    </section>

    <section class="section-band py-5">
        <div class="container">
            <div class="row g-4 align-items-center">
                <div class="col-lg-5">
                    <span class="eyebrow mb-2"><i class="fa-solid fa-chair"></i> <fmt:message key="spaces.eyebrow"/></span>
                    <h2 class="display-6 fw-bold mb-3"><fmt:message key="spaces.title"/></h2>
                    <p class="muted mb-4"><fmt:message key="spaces.desc"/></p>
                    <a href="MainController?action=booking" class="btn btn-brand px-4"><fmt:message key="spaces.btn.book"/></a>
                </div>
                <div class="col-lg-7">
                    <div class="row g-3">
                        <c:forEach items="${tables}" var="tb">
                            <div class="col-sm-6">
                                <article class="surface h-100 p-3">
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
                                    <div class="d-flex justify-content-between align-items-center small">
                                        <span class="muted"><i class="fa-solid fa-users me-1"></i>${tb.capacity} <fmt:message key="spaces.guests"/></span>
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
