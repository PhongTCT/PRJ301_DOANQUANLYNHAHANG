<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setLocale value="${sessionScope.lang}" scope="session" />
<fmt:setBundle basename="i18n.messages" scope="session" />
<jsp:include page="header.jsp" />

<section class="hero">
    <video class="hero-video" autoplay muted loop playsinline preload="metadata" poster="https://images.unsplash.com/photo-1661163081367-6402f4f864e0?auto=format&fit=crop&w=1500&q=84">
        <source src="assets/video/hero-restaurant.mp4" type="video/mp4">
    </video>
    <div class="hero-overlay"></div>
    <div class="container hero-content">
        <div class="row">
            <div class="col-lg-6">
                <span class="badge text-bg-light border text-dark text-uppercase fw-semibold mb-4">Contemporary Fine Dining</span>
                <h1 class="hero-title mb-4">Le Royal</h1>
                <p class="hero-copy mb-5">A quiet restaurant for seasonal Vietnamese ingredients, French technique, and a refined dining rhythm between Asia and Europe.</p>
                <div class="d-flex flex-wrap gap-2">
                    <a href="MainController?action=booking" class="btn btn-dark">Reserve</a>
                    <a href="MainController?action=menu" class="btn btn-outline-dark">Explore Menu</a>
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
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="container mt-4">
            <div class="alert alert-danger shadow-sm border-0">
                <i class="fa-solid fa-circle-exclamation me-2"></i>${sessionScope.errorMessage}
                <c:remove var="errorMessage" scope="session"/>
            </div>
        </div>
    </c:if>

    <section class="py-5">
        <div class="container">
            <div class="row align-items-center g-5">
                <div class="col-lg-6">
                    <img class="image-cover" src="https://images.unsplash.com/photo-1572715376701-98568319fd0b?auto=format&fit=crop&w=1200&q=84" alt="Chef plating a fine dining dish">
                </div>
                <div class="col-lg-5 offset-lg-1">
                    <span class="badge text-bg-light border text-dark text-uppercase fw-semibold">The Restaurant</span>
                    <h2 class="display-5 mt-3 mb-4">Minimal, seasonal, and deliberately quiet.</h2>
                    <div class="gold-rule mb-4"></div>
                    <p class="text-secondary fs-5">Le Royal is built around clean flavours, precise textures, and service that feels calm rather than ceremonial. The menu changes with produce, seafood, herbs, and fermentation from Vietnam, finished with European technique.</p>
                    <p class="text-secondary mb-0">The visual language is simple: white space, black typography, sharp photography, and a small amount of warm metal in the details.</p>
                </div>
            </div>
        </div>
    </section>

    <section class="py-5 bg-light border-top border-bottom">
        <div class="container">
            <div class="d-flex align-items-end justify-content-between flex-wrap gap-3 mb-5">
                <div>
                    <span class="badge text-bg-light border text-dark text-uppercase fw-semibold">Signature Menus</span>
                    <h2 class="display-5 mt-3 mb-0">Tasting experiences</h2>
                </div>
                <a href="MainController?action=menu" class="btn btn-outline-dark">View Menu</a>
            </div>
            <div class="row g-4">
                <div class="col-lg-4">
                    <article class="card shadow-sm border-0  h-100">
                        <img src="https://epicurevietnam.com/Data/Sites/1/media/dining/other-cities/199/dou-of-abalon-and-canabineros-prawn-%282%29.jpg" class="card-image" alt="Seasonal tasting menu">
                        <div class="p-4">
                            <div class="d-flex justify-content-between gap-2 mb-3">
                                <span class="badge text-bg-light border text-dark px-3 py-1">Lunch</span>
                                <span class="badge text-bg-light border text-dark px-3 py-1">690k</span>
                            </div>
                            <h3 class="h2">Seasonal Lunch</h3>
                            <p class="text-secondary mb-4">Three courses for a light fine dining lunch: seafood, garden herbs, and a fresh dessert.</p>
                            <a href="MainController?action=booking" class="btn btn-dark btn-sm">Book</a>
                        </div>
                    </article>
                </div>
                <div class="col-lg-4">
                    <article class="card shadow-sm border-0  h-100">
                        <img src="https://epicurevietnam.com/Data/Sites/1/media/dining/other-cities/199/lobster-salad.jpg" class="card-image" alt="Le Royal tasting menu">
                        <div class="p-4">
                            <div class="d-flex justify-content-between gap-2 mb-3">
                                <span class="badge text-bg-light border text-dark px-3 py-1">6 Courses</span>
                                <span class="badge text-bg-light border text-dark px-3 py-1">1.45m</span>
                            </div>
                            <h3 class="h2">Le Royal Tasting</h3>
                            <p class="text-secondary mb-4">A balanced Asian-European tasting menu with seafood, duck consommé, beef cheek, and tea pairing.</p>
                            <a href="MainController?action=booking" class="btn btn-dark btn-sm">Book</a>
                        </div>
                    </article>
                </div>
                <div class="col-lg-4">
                    <article class="card shadow-sm border-0  h-100">
                        <img src="https://epicurevietnam.com/Data/Sites/1/media/dining/other-cities/199/toothfish-%282%29.jpg" class="card-image" alt="Chef prestige menu">
                        <div class="p-4">
                            <div class="d-flex justify-content-between gap-2 mb-3">
                                <span class="badge text-bg-light border text-dark px-3 py-1">Prestige</span>
                                <span class="badge text-bg-light border text-dark px-3 py-1">2.45m</span>
                            </div>
                            <h3 class="h2">Chef's Prestige</h3>
                            <p class="text-secondary mb-4">A longer dinner with lobster, caviar, wagyu, seasonal vegetables, and composed desserts.</p>
                            <a href="MainController?action=booking" class="btn btn-dark btn-sm">Book</a>
                        </div>
                    </article>
                </div>
            </div>
        </div>
    </section>

    <section class="py-5">
        <div class="container">
            <div class="row g-4">
                <div class="col-lg-4">
                    <article class=" card shadow-sm border-0 h-100 p-5">
                        <span class="badge text-bg-light border text-dark text-uppercase fw-semibold">Book</span>
                        <h3 class="display-6 mt-3 mb-3">Reserve a table</h3>
                        <p class="text-secondary mb-4">Choose a date, number of guests, and preferred seating category.</p>
                        <a href="MainController?action=booking" class="btn btn-dark">Booking</a>
                    </article>
                </div>
                <div class="col-lg-4">
                    <article class=" card shadow-sm border-0 h-100 p-5">
                        <span class="badge text-bg-light border text-dark text-uppercase fw-semibold">Visit</span>
                        <h3 class="display-6 mt-3 mb-3">District 1</h3>
                        <p class="text-secondary mb-4">12 Le Loi Boulevard. Lunch from 11:30, dinner from 18:00.</p>
                        <a href="MainController?action=booking" class="btn btn-outline-dark">Plan Visit</a>
                    </article>
                </div>
                <div class="col-lg-4">
                    <article class=" card shadow-sm border-0 h-100 p-5">
                        <span class="badge text-bg-light border text-dark text-uppercase fw-semibold">Private Dining</span>
                        <h3 class="display-6 mt-3 mb-3">Rooms by tier</h3>
                        <p class="text-secondary mb-4">Window tables, garden lounge, chef counter, and private suites with deposits shown clearly.</p>
                        <a href="MainController?action=booking" class="btn btn-outline-dark">See Spaces</a>
                    </article>
                </div>
            </div>
        </div>
    </section>
</main>

<jsp:include page="footer.jsp" />
