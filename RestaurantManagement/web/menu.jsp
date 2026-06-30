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
                    <span class="badge text-bg-light border text-dark text-uppercase fw-semibold">Menu</span>
                    <h1 class="display-4 mt-3 mb-3">A seasonal dialogue between Asia and Europe.</h1>
                    <p class="text-secondary fs-5 mb-0">Fine dining menus inspired by contemporary Michelin restaurants: clean seafood, layered broths, careful sauces, and restrained desserts.</p>
                </div>
                <div class="col-lg-4 text-lg-end">
                    <a href="MainController?action=booking" class="btn btn-dark">Reserve</a>
                </div>
            </div>
        </div>
    </section>

    <section class="py-5 bg-light border-top border-bottom">
        <div class="container">
            <div class="d-flex align-items-end justify-content-between flex-wrap gap-3 mb-5">
                <div>
                    <span class="badge text-bg-light border text-dark text-uppercase fw-semibold">Tasting Menus</span>
                    <h2 class="display-5 mt-3 mb-0">Set menus</h2>
                </div>
                <div class="small text-secondary">Prices are per guest.</div>
            </div>
            <div class="row g-4">
                <div class="col-lg-3 col-md-6">
                    <article class="card shadow-sm border-0 h-100 p-4 ">
                        <span class="badge text-bg-light border text-dark px-3 py-1 mb-4">3 Courses</span>
                        <h3 class="h2">Seasonal Lunch</h3>
                        <ul class="text-secondary small ps-3 mt-3 mb-4">
                            <li>Green mango, tiger prawn, young herbs</li>
                            <li>Sea bass, lemongrass beurre blanc</li>
                            <li>Coconut panna cotta, passion fruit</li>
                        </ul>
                        <div class="set-price">690,000 VND</div>
                    </article>
                </div>
                <div class="col-lg-3 col-md-6">
                    <article class="card shadow-sm border-0 h-100 p-4 ">
                        <span class="badge text-bg-light border text-dark px-3 py-1 mb-4">6 Courses</span>
                        <h3 class="h2">Le Royal Tasting</h3>
                        <ul class="text-secondary small ps-3 mt-3 mb-4">
                            <li>Hokkaido scallop, basil oil</li>
                            <li>Duck consomme, black truffle</li>
                            <li>Wagyu beef cheek, star anise jus</li>
                        </ul>
                        <div class="set-price">1,450,000 VND</div>
                    </article>
                </div>
                <div class="col-lg-3 col-md-6">
                    <article class="card shadow-sm border-0 h-100 p-4 ">
                        <span class="badge text-bg-light border text-dark px-3 py-1 mb-4">8 Courses</span>
                        <h3 class="h2">Chef's Prestige</h3>
                        <ul class="text-secondary small ps-3 mt-3 mb-4">
                            <li>Caviar tartlet, creme fraiche</li>
                            <li>Lobster, saffron coconut veloute</li>
                            <li>A5 Wagyu, red wine jus</li>
                        </ul>
                        <div class="set-price">2,450,000 VND</div>
                    </article>
                </div>
                <div class="col-lg-3 col-md-6">
                    <article class="card shadow-sm border-0 h-100 p-4 ">
                        <span class="badge text-bg-light border text-dark px-3 py-1 mb-4">Vegetarian</span>
                        <h3 class="h2">Garden Menu</h3>
                        <ul class="text-secondary small ps-3 mt-3 mb-4">
                            <li>Baby corn, miso sesame</li>
                            <li>Mushroom consomme, young herbs</li>
                            <li>Pandan coconut parfait</li>
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
                <span class="badge text-bg-light border text-dark text-uppercase fw-semibold">A La Carte</span>
                <h2 class="display-5 mt-3 mb-0">Dishes</h2>
            </div>

            <c:if test="${not empty pageError}">
                <div class="alert alert-warning">${pageError}</div>
            </c:if>

            <c:choose>
                <c:when test="${not empty menuList}">
                    <div class="row g-4">
                        <c:forEach items="${menuList}" var="item" varStatus="status">
                            <c:set var="fallbackImage" value="${status.index % 6}" />
                            <div class="col-lg-4 col-md-6">
                                <article class="card shadow-sm border-0  h-100">
                                    <c:choose>
                                        <c:when test="${not empty item.imageUrl}">
                                            <img src="${item.imageUrl}" class="card-image" alt="${item.itemName}">
                                        </c:when>
                                        <c:when test="${item.itemName == 'Pan Seared Salmon'}">
                                            <img src="https://monngon-danang.com/content/images/size/w1200/2025/03/cach-lam-ca-hoi-sot-chanh-leo.jpeg" class="card-image" alt="${item.itemName}">
                                        </c:when>
                                        <c:when test="${item.itemName == 'Fresh Orange Juice'}">
                                            <img src="https://www.kitchentreaty.com/wp-content/uploads/2025/03/fresh-squeezed-orange-juice-2-420x560.jpg" class="card-image" alt="${item.itemName}">
                                        </c:when>
                                        <c:otherwise>
                                            <c:choose>
                                                <c:when test="${fallbackImage == 0}"><img src="https://epicurevietnam.com/Data/Sites/1/media/dining/other-cities/199/dou-of-abalon-and-canabineros-prawn-%282%29.jpg" class="card-image" alt="${item.itemName}"></c:when>
                                                <c:when test="${fallbackImage == 1}"><img src="https://epicurevietnam.com/Data/Sites/1/media/dining/other-cities/199/lobster-salad.jpg" class="card-image" alt="${item.itemName}"></c:when>
                                                <c:when test="${fallbackImage == 2}"><img src="https://epicurevietnam.com/Data/Sites/1/media/dining/other-cities/199/toothfish-%282%29.jpg" class="card-image" alt="${item.itemName}"></c:when>
                                                <c:when test="${fallbackImage == 3}"><img src="https://epicurevietnam.com/Data/Sites/1/media/art-of-pause/art-of-pause-1.jpg" class="card-image" alt="${item.itemName}"></c:when>
                                                <c:when test="${fallbackImage == 4}"><img src="https://epicurevietnam.com/Data/Sites/1/media/dining/other-cities/199/lobster-salad.jpg" class="card-image" alt="${item.itemName}"></c:when>
                                                <c:otherwise><img src="https://epicurevietnam.com/Data/Sites/1/media/art-of-pause/art-of-pause-1.jpg" class="card-image" alt="${item.itemName}"></c:otherwise>
                                            </c:choose>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="p-4">
                                        <div class="d-flex justify-content-between align-items-center gap-2 mb-3">
                                            <span class="badge text-bg-light border text-dark px-3 py-1">${item.category.categoryName}</span>
                                            <span class="badge text-bg-light border text-dark px-3 py-1"><fmt:formatNumber value="${item.basePrice}" pattern="#,##0"/> VND</span>
                                        </div>
                                        <h3 class="h2 mb-2">${item.itemName}</h3>
                                        <p class="text-secondary mb-4">${item.description}</p>
                                        <a href="MainController?action=booking" class="btn btn-dark btn-sm">Book</a>
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
                                <img src="https://epicurevietnam.com/Data/Sites/1/media/dining/other-cities/199/dou-of-abalon-and-canabineros-prawn-%282%29.jpg" class="card-image" alt="Scallop dish">
                                <div class="p-4">
                                    <div class="d-flex justify-content-between gap-2 mb-3"><span class="badge text-bg-light border text-dark px-3 py-1">Starter</span><span class="badge text-bg-light border text-dark px-3 py-1">320k</span></div>
                                    <h3 class="h2">Scallop, Green Mango</h3>
                                    <p class="text-secondary mb-4">Seared scallop, green mango, basil oil, toasted rice, lime beurre blanc.</p>
                                    <a href="MainController?action=booking" class="btn btn-dark btn-sm">Book</a>
                                </div>
                            </article>
                        </div>
                        <div class="col-lg-4 col-md-6">
                            <article class="card shadow-sm border-0  h-100">
                                <img src="https://epicurevietnam.com/Data/Sites/1/media/dining/other-cities/199/lobster-salad.jpg" class="card-image" alt="Duck consomme">
                                <div class="p-4">
                                    <div class="d-flex justify-content-between gap-2 mb-3"><span class="badge text-bg-light border text-dark px-3 py-1">Broth</span><span class="badge text-bg-light border text-dark px-3 py-1">280k</span></div>
                                    <h3 class="h2">Duck Consomme</h3>
                                    <p class="text-secondary mb-4">Clear duck consomme, black truffle, young herbs, caramelized shallot.</p>
                                    <a href="MainController?action=booking" class="btn btn-dark btn-sm">Book</a>
                                </div>
                            </article>
                        </div>
                        <div class="col-lg-4 col-md-6">
                            <article class="card shadow-sm border-0  h-100">
                                <img src="https://epicurevietnam.com/Data/Sites/1/media/dining/other-cities/199/toothfish-%282%29.jpg" class="card-image" alt="Wagyu beef">
                                <div class="p-4">
                                    <div class="d-flex justify-content-between gap-2 mb-3"><span class="badge text-bg-light border text-dark px-3 py-1">Main</span><span class="badge text-bg-light border text-dark px-3 py-1">780k</span></div>
                                    <h3 class="h2">Wagyu, Star Anise Jus</h3>
                                    <p class="text-secondary mb-4">Slow-cooked wagyu cheek, root vegetables, fermented pepper, red wine jus.</p>
                                    <a href="MainController?action=booking" class="btn btn-dark btn-sm">Book</a>
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
