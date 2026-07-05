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
                    <span class="badge text-bg-light border text-dark text-uppercase fw-semibold"><fmt:message key="menu.hero.badge"/></span>
                    <h1 class="display-4 mt-3 mb-3"><fmt:message key="menu.hero.title"/></h1>
                    <p class="text-secondary fs-5 mb-0"><fmt:message key="menu.hero.copy"/></p>
                </div>
                <div class="col-lg-4 text-lg-end">
                    <a href="MainController?action=booking" class="btn btn-dark"><fmt:message key="menu.reserve"/></a>
                </div>
            </div>
        </div>
    </section>

    <section class="py-5 bg-light border-top border-bottom">
        <div class="container">
            <div class="d-flex align-items-end justify-content-between flex-wrap gap-3 mb-5">
                <div>
                    <span class="badge text-bg-light border text-dark text-uppercase fw-semibold"><fmt:message key="menu.sets.badge"/></span>
                    <h2 class="display-5 mt-3 mb-0"><fmt:message key="menu.sets.title"/></h2>
                </div>
                <div class="small text-secondary"><fmt:message key="menu.price.note"/></div>
            </div>
            <div class="row g-4">
                <div class="col-lg-3 col-md-6">
                    <article class="card shadow-sm border-0 h-100 p-4 ">
                        <span class="badge text-bg-light border text-dark px-3 py-1 mb-4"><fmt:message key="menu.set1.badge"/></span>
                        <h3 class="h2"><fmt:message key="menu.set1.title"/></h3>
                        <ul class="text-secondary small ps-3 mt-3 mb-4">
                            <li><fmt:message key="menu.set1.item1"/></li>
                            <li><fmt:message key="menu.set1.item2"/></li>
                            <li><fmt:message key="menu.set1.item3"/></li>
                        </ul>
                        <div class="set-price">690,000 VND</div>
                    </article>
                </div>
                <div class="col-lg-3 col-md-6">
                    <article class="card shadow-sm border-0 h-100 p-4 ">
                        <span class="badge text-bg-light border text-dark px-3 py-1 mb-4"><fmt:message key="menu.set2.badge"/></span>
                        <h3 class="h2"><fmt:message key="menu.set2.title"/></h3>
                        <ul class="text-secondary small ps-3 mt-3 mb-4">
                            <li><fmt:message key="menu.set2.item1"/></li>
                            <li><fmt:message key="menu.set2.item2"/></li>
                            <li><fmt:message key="menu.set2.item3"/></li>
                        </ul>
                        <div class="set-price">1,450,000 VND</div>
                    </article>
                </div>
                <div class="col-lg-3 col-md-6">
                    <article class="card shadow-sm border-0 h-100 p-4 ">
                        <span class="badge text-bg-light border text-dark px-3 py-1 mb-4"><fmt:message key="menu.set3.badge"/></span>
                        <h3 class="h2"><fmt:message key="menu.set3.title"/></h3>
                        <ul class="text-secondary small ps-3 mt-3 mb-4">
                            <li><fmt:message key="menu.set3.item1"/></li>
                            <li><fmt:message key="menu.set3.item2"/></li>
                            <li><fmt:message key="menu.set3.item3"/></li>
                        </ul>
                        <div class="set-price">2,450,000 VND</div>
                    </article>
                </div>
                <div class="col-lg-3 col-md-6">
                    <article class="card shadow-sm border-0 h-100 p-4 ">
                        <span class="badge text-bg-light border text-dark px-3 py-1 mb-4"><fmt:message key="menu.set4.badge"/></span>
                        <h3 class="h2"><fmt:message key="menu.set4.title"/></h3>
                        <ul class="text-secondary small ps-3 mt-3 mb-4">
                            <li><fmt:message key="menu.set4.item1"/></li>
                            <li><fmt:message key="menu.set4.item2"/></li>
                            <li><fmt:message key="menu.set4.item3"/></li>
                        </ul>
                        <div class="set-price">980,000 VND</div>
                    </article>
                </div>
            </div>
        </div>
    </section>

    <section class="py-5">
        <div class="container">
            <div class="text-center mb-5">
                <span class="badge text-bg-light border text-dark text-uppercase fw-semibold"><fmt:message key="menu.alacarte.badge"/></span>
                <h2 class="display-5 mt-3 mb-0"><fmt:message key="menu.alacarte.title"/></h2>
            </div>

            <c:if test="${not empty pageError}">
                <div class="alert alert-warning">${pageError}</div>
            </c:if>

            <c:choose>
                <c:when test="${not empty menuList}">
                    <div class="row g-4">
                        <c:forEach items="${menuList}" var="item" varStatus="status">
                            <c:set var="fallbackImage" value="${status.index % 6}" />
                            <c:set var="itemNameText" value="${sessionScope.lang == 'vi' ? (not empty item.itemNameVi ? item.itemNameVi : item.itemName) : (not empty item.itemName ? item.itemName : item.itemNameVi)}" />
                            <c:set var="itemDescriptionText" value="${sessionScope.lang == 'vi' ? (not empty item.descriptionVi ? item.descriptionVi : item.description) : (not empty item.description ? item.description : item.descriptionVi)}" />
                            <c:set var="categoryNameText" value="${sessionScope.lang == 'vi' ? (not empty item.category.categoryNameVi ? item.category.categoryNameVi : item.category.categoryName) : (not empty item.category.categoryName ? item.category.categoryName : item.category.categoryNameVi)}" />
                            <div class="col-lg-4 col-md-6">
                                <article class="card shadow-sm border-0  h-100">
                                    <c:choose>
                                        <c:when test="${not empty item.imageUrl}">
                                            <img src="${item.imageUrl}" class="card-image" alt="${itemNameText}">
                                        </c:when>
                                        <c:when test="${item.itemName == 'Pan Seared Salmon'}">
                                            <img src="https://monngon-danang.com/content/images/size/w1200/2025/03/cach-lam-ca-hoi-sot-chanh-leo.jpeg" class="card-image" alt="${itemNameText}">
                                        </c:when>
                                        <c:when test="${item.itemName == 'Fresh Orange Juice'}">
                                            <img src="https://www.kitchentreaty.com/wp-content/uploads/2025/03/fresh-squeezed-orange-juice-2-420x560.jpg" class="card-image" alt="${itemNameText}">
                                        </c:when>
                                        <c:otherwise>
                                            <c:choose>
                                                <c:when test="${fallbackImage == 0}"><img src="https://epicurevietnam.com/Data/Sites/1/media/dining/other-cities/199/dou-of-abalon-and-canabineros-prawn-%282%29.jpg" class="card-image" alt="${itemNameText}"></c:when>
                                                <c:when test="${fallbackImage == 1}"><img src="https://epicurevietnam.com/Data/Sites/1/media/dining/other-cities/199/lobster-salad.jpg" class="card-image" alt="${itemNameText}"></c:when>
                                                <c:when test="${fallbackImage == 2}"><img src="https://epicurevietnam.com/Data/Sites/1/media/dining/other-cities/199/toothfish-%282%29.jpg" class="card-image" alt="${itemNameText}"></c:when>
                                                <c:when test="${fallbackImage == 3}"><img src="https://epicurevietnam.com/Data/Sites/1/media/art-of-pause/art-of-pause-1.jpg" class="card-image" alt="${itemNameText}"></c:when>
                                                <c:when test="${fallbackImage == 4}"><img src="https://epicurevietnam.com/Data/Sites/1/media/dining/other-cities/199/lobster-salad.jpg" class="card-image" alt="${itemNameText}"></c:when>
                                                <c:otherwise><img src="https://epicurevietnam.com/Data/Sites/1/media/art-of-pause/art-of-pause-1.jpg" class="card-image" alt="${itemNameText}"></c:otherwise>
                                            </c:choose>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="p-4">
                                        <div class="d-flex justify-content-between align-items-center gap-2 mb-3">
                                            <span class="badge text-bg-light border text-dark px-3 py-1">${categoryNameText}</span>
                                            <span class="badge text-bg-light border text-dark px-3 py-1"><fmt:formatNumber value="${item.basePrice}" pattern="#,##0"/> VND</span>
                                        </div>
                                        <h3 class="h2 mb-2">${itemNameText}</h3>
                                        <p class="text-secondary mb-4">${itemDescriptionText}</p>
                                        <a href="MainController?action=booking" class="btn btn-dark btn-sm"><fmt:message key="menu.book"/></a>
                                    </div>
                                </article>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="row g-4">
                        <div class="col-lg-4 col-md-6">
                            <article class="card shadow-sm border-0  h-100">
                                <img src="https://epicurevietnam.com/Data/Sites/1/media/dining/other-cities/199/dou-of-abalon-and-canabineros-prawn-%282%29.jpg" class="card-image" alt="<fmt:message key='menu.fallback1.title'/>">
                                <div class="p-4">
                                    <div class="d-flex justify-content-between gap-2 mb-3"><span class="badge text-bg-light border text-dark px-3 py-1"><fmt:message key="menu.fallback1.category"/></span><span class="badge text-bg-light border text-dark px-3 py-1">320k</span></div>
                                    <h3 class="h2"><fmt:message key="menu.fallback1.title"/></h3>
                                    <p class="text-secondary mb-4"><fmt:message key="menu.fallback1.copy"/></p>
                                    <a href="MainController?action=booking" class="btn btn-dark btn-sm"><fmt:message key="menu.book"/></a>
                                </div>
                            </article>
                        </div>
                        <div class="col-lg-4 col-md-6">
                            <article class="card shadow-sm border-0  h-100">
                                <img src="https://epicurevietnam.com/Data/Sites/1/media/dining/other-cities/199/lobster-salad.jpg" class="card-image" alt="<fmt:message key='menu.fallback2.title'/>">
                                <div class="p-4">
                                    <div class="d-flex justify-content-between gap-2 mb-3"><span class="badge text-bg-light border text-dark px-3 py-1"><fmt:message key="menu.fallback2.category"/></span><span class="badge text-bg-light border text-dark px-3 py-1">280k</span></div>
                                    <h3 class="h2"><fmt:message key="menu.fallback2.title"/></h3>
                                    <p class="text-secondary mb-4"><fmt:message key="menu.fallback2.copy"/></p>
                                    <a href="MainController?action=booking" class="btn btn-dark btn-sm"><fmt:message key="menu.book"/></a>
                                </div>
                            </article>
                        </div>
                        <div class="col-lg-4 col-md-6">
                            <article class="card shadow-sm border-0  h-100">
                                <img src="https://epicurevietnam.com/Data/Sites/1/media/dining/other-cities/199/toothfish-%282%29.jpg" class="card-image" alt="<fmt:message key='menu.fallback3.title'/>">
                                <div class="p-4">
                                    <div class="d-flex justify-content-between gap-2 mb-3"><span class="badge text-bg-light border text-dark px-3 py-1"><fmt:message key="menu.fallback3.category"/></span><span class="badge text-bg-light border text-dark px-3 py-1">780k</span></div>
                                    <h3 class="h2"><fmt:message key="menu.fallback3.title"/></h3>
                                    <p class="text-secondary mb-4"><fmt:message key="menu.fallback3.copy"/></p>
                                    <a href="MainController?action=booking" class="btn btn-dark btn-sm"><fmt:message key="menu.book"/></a>
                                </div>
                            </article>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>
</main>

<jsp:include page="footer.jsp" />
