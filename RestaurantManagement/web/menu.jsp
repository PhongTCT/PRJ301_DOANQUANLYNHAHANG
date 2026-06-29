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
                    <span class="eyebrow mb-2"><i class="fa-solid fa-book-open"></i> <fmt:message key="menupage.eyebrow"/></span>
                    <h1 class="display-5 fw-bold mb-3"><fmt:message key="menupage.title"/></h1>
                    <p class="muted mb-0"><fmt:message key="menupage.desc"/></p>
                </div>
                <div class="col-lg-5">
                    <div class="surface-soft p-3">
                        <div class="d-flex align-items-center gap-3">
                            <img src="https://images.unsplash.com/photo-1490645935967-10de6ba17061?auto=format&fit=crop&w=500&q=80" class="rounded-4" style="width:96px;height:96px;object-fit:cover;" alt="Fresh ingredients">
                            <div>
                                <div class="fw-bold"><fmt:message key="menupage.ready.title"/></div>
                                <div class="small muted"><fmt:message key="menupage.ready.desc"/></div>
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
                            <h2 class="h5 fw-bold mb-0">
                                <c:choose>
                                    <c:when test="${sessionScope.lang == 'en' and fn:contains(item.itemName, 'Gỏi Ngó Sen')}">Lotus Stem Salad with Shrimp & Pork</c:when>
                                    <c:when test="${sessionScope.lang == 'en' and fn:contains(item.itemName, 'Súp Măng Tây')}">Crab & Green Asparagus Soup</c:when>
                                    <c:when test="${sessionScope.lang == 'en' and fn:contains(item.itemName, 'Bò Úc Nướng')}">Grilled Australian Beef Tenderloin</c:when>
                                    <c:when test="${sessionScope.lang == 'en' and fn:contains(item.itemName, 'Cá Hồi')}">Pan Seared Salmon with Passion Fruit</c:when>
                                    <c:otherwise>${item.itemName}</c:otherwise>
                                </c:choose>
                            </h2>
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
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="category-pill small">
                                <c:choose>
                                    <c:when test="${sessionScope.lang == 'en' and fn:contains(item.category.categoryName, 'Khai Vị')}">Appetizer</c:when>
                                    <c:when test="${sessionScope.lang == 'en' and fn:contains(item.category.categoryName, 'Chính')}">Main Course</c:when>
                                    <c:when test="${sessionScope.lang == 'en' and fn:contains(item.category.categoryName, 'Tráng Miệng')}">Dessert</c:when>
                                    <c:when test="${sessionScope.lang == 'en' and fn:contains(item.category.categoryName, 'Uống')}">Drink</c:when>
                                    <c:otherwise>${item.category.categoryName}</c:otherwise>
                                </c:choose>
                            </span>
                            <a href="MainController?action=booking" class="btn btn-outline-brand btn-sm px-3">
                                <i class="fa-solid fa-plus me-1"></i><fmt:message key="menupage.btn.add"/>
                            </a>
                        </div>
                    </article>
                </div>
            </c:forEach>
        </div>
    </section>
</main>

<jsp:include page="footer.jsp" />
