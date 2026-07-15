<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setLocale value="${sessionScope.lang}" scope="session" />
<fmt:setBundle basename="i18n.messages" scope="session" />
<jsp:include page="header.jsp" />

<section class="hero">
    <video class="hero-video" autoplay muted loop playsinline poster="https://images.unsplash.com/photo-1661163081367-6402f4f864e0?auto=format&fit=crop&w=1500&q=84">
        <source src="https://cdn.pixabay.com/video/2022/11/30/141046-776768279_large.mp4" type="video/mp4">
    </video>
    <div class="hero-overlay"></div>
    <div class="container hero-content">
        <div class="row">
            <div class="col-lg-6">
                <span class="badge text-bg-light border text-dark text-uppercase fw-semibold mb-4"><fmt:message key="hero.eyebrow"/></span>
                <h1 class="hero-title mb-4"><fmt:message key="hero.title"/></h1>
                <p class="hero-copy mb-5"><fmt:message key="hero.copy"/></p>
                <div class="d-flex flex-wrap gap-2">
                    <a href="MainController?action=booking" class="btn btn-dark"><fmt:message key="hero.btn.book"/></a>
                    <a href="MainController?action=menu" class="btn btn-outline-dark"><fmt:message key="hero.btn.menu"/></a>
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
                    <span class="badge text-bg-light border text-dark text-uppercase fw-semibold"><fmt:message key="home.restaurant.eyebrow"/></span>
                    <h2 class="display-5 mt-3 mb-4"><fmt:message key="home.restaurant.title"/></h2>
                    <div class="gold-rule mb-4"></div>
                    <p class="text-secondary fs-5"><fmt:message key="home.restaurant.copy1"/></p>
                    <p class="text-secondary mb-0"><fmt:message key="home.restaurant.copy2"/></p>
                </div>
            </div>
        </div>
    </section>

    <section class="py-5 bg-light border-top border-bottom signature-journey">
        <div class="container">
            <div class="d-flex align-items-end justify-content-between flex-wrap gap-3 mb-5">
                <div>
                    <span class="badge text-bg-light border text-dark text-uppercase fw-semibold"><fmt:message key="home.signature.eyebrow"/></span>
                    <h2 class="display-5 mt-3 mb-0"><fmt:message key="home.signature.title"/></h2>
                </div>
                <a href="MainController?action=menu" class="btn btn-outline-dark"><fmt:message key="home.signature.btn"/></a>
            </div>
            <div class="journey-path" data-journey-path>
                <div class="journey-line" aria-hidden="true">
                    <svg class="journey-line-svg" viewBox="0 0 100 100" preserveAspectRatio="none" focusable="false">
                        <path class="journey-line-base" d="M50 3 C2 8 2 13 50 16 C98 20 98 26 50 31 C2 36 2 42 50 47 C98 52 98 58 50 63 C2 68 2 74 50 79 C98 84 98 91 50 97" />
                        <path class="journey-line-progress" data-journey-progress pathLength="100" d="M50 3 C2 8 2 13 50 16 C98 20 98 26 50 31 C2 36 2 42 50 47 C98 52 98 58 50 63 C2 68 2 74 50 79 C98 84 98 91 50 97" />
                    </svg>
                </div>
                <article class="journey-point journey-point-left">
                    <svg class="journey-marker" aria-hidden="true" viewBox="0 0 72 72" focusable="false">
                        <path class="journey-stem" d="M35 63C40 53 31 47 36 39" />
                        <path class="journey-petal" d="M36 31C27 23 28 10 38 7C47 12 47 24 36 31Z" />
                        <path class="journey-petal" d="M39 34C49 25 62 28 64 38C58 45 47 43 39 34Z" />
                        <path class="journey-petal" d="M35 37C43 46 39 58 29 60C23 53 26 42 35 37Z" />
                        <path class="journey-petal" d="M32 34C21 39 11 33 10 23C20 18 29 24 32 34Z" />
                        <circle class="journey-core" cx="36" cy="35" r="3.4" />
                    </svg>
                    <div class="journey-card">
                        <img src="assets/img/le-royal/Seasonal Tasting Set.jpg" alt="Seasonal tasting menu">
                        <div class="journey-copy">
                            <h3><fmt:message key="home.menu1.title" /></h3>
                            <p><fmt:message key="home.menu1.copy" /></p>
                        </div>
                    </div>
                </article>
                <article class="journey-point journey-point-right">
                    <svg class="journey-marker" aria-hidden="true" viewBox="0 0 72 72" focusable="false">
                        <path class="journey-stem" d="M35 63C40 53 31 47 36 39" />
                        <path class="journey-petal" d="M36 31C27 23 28 10 38 7C47 12 47 24 36 31Z" />
                        <path class="journey-petal" d="M39 34C49 25 62 28 64 38C58 45 47 43 39 34Z" />
                        <path class="journey-petal" d="M35 37C43 46 39 58 29 60C23 53 26 42 35 37Z" />
                        <path class="journey-petal" d="M32 34C21 39 11 33 10 23C20 18 29 24 32 34Z" />
                        <circle class="journey-core" cx="36" cy="35" r="3.4" />
                    </svg>
                    <div class="journey-card">
                        <img src="assets/img/le-royal/menu/grilled-spiny-lobster.jpg" alt="Signature plated dish">
                        <div class="journey-copy">
                            <h3><fmt:message key="home.menu2.title"/></h3>
                            <p><fmt:message key="home.menu2.copy"/></p>
                        </div>
                    </div>
                </article>
                <article class="journey-point journey-point-left">
                    <svg class="journey-marker" aria-hidden="true" viewBox="0 0 72 72" focusable="false">
                        <path class="journey-stem" d="M35 63C40 53 31 47 36 39" />
                        <path class="journey-petal" d="M36 31C27 23 28 10 38 7C47 12 47 24 36 31Z" />
                        <path class="journey-petal" d="M39 34C49 25 62 28 64 38C58 45 47 43 39 34Z" />
                        <path class="journey-petal" d="M35 37C43 46 39 58 29 60C23 53 26 42 35 37Z" />
                        <path class="journey-petal" d="M32 34C21 39 11 33 10 23C20 18 29 24 32 34Z" />
                        <circle class="journey-core" cx="36" cy="35" r="3.4" />
                    </svg>
                    <div class="journey-card">
                        <img src="assets/img/le-royal/seating/private-table.jpg" alt="Private dining table">
                        <div class="journey-copy">
                            <h3><fmt:message key="home.journey.seating.title" /></h3>
                            <p><fmt:message key="home.journey.seating.copy" /></p>
                        </div>
                    </div>
                </article>
                <article class="journey-point journey-point-right">
                    <svg class="journey-marker" aria-hidden="true" viewBox="0 0 72 72" focusable="false">
                        <path class="journey-stem" d="M35 63C40 53 31 47 36 39" />
                        <path class="journey-petal" d="M36 31C27 23 28 10 38 7C47 12 47 24 36 31Z" />
                        <path class="journey-petal" d="M39 34C49 25 62 28 64 38C58 45 47 43 39 34Z" />
                        <path class="journey-petal" d="M35 37C43 46 39 58 29 60C23 53 26 42 35 37Z" />
                        <path class="journey-petal" d="M32 34C21 39 11 33 10 23C20 18 29 24 32 34Z" />
                        <circle class="journey-core" cx="36" cy="35" r="3.4" />
                    </svg>
                    <div class="journey-card">
                        <img src="assets/img/le-royal/Private Live Pianist.jpg" alt="Private live pianist service">
                        <div class="journey-copy">
                            <h3><fmt:message key="home.journey.service.title" /></h3>
                            <p><fmt:message key="home.journey.service.copy" /></p>
                        </div>
                    </div>
                </article>
                <article class="journey-point journey-point-left">
                    <svg class="journey-marker" aria-hidden="true" viewBox="0 0 72 72" focusable="false">
                        <path class="journey-stem" d="M35 63C40 53 31 47 36 39" />
                        <path class="journey-petal" d="M36 31C27 23 28 10 38 7C47 12 47 24 36 31Z" />
                        <path class="journey-petal" d="M39 34C49 25 62 28 64 38C58 45 47 43 39 34Z" />
                        <path class="journey-petal" d="M35 37C43 46 39 58 29 60C23 53 26 42 35 37Z" />
                        <path class="journey-petal" d="M32 34C21 39 11 33 10 23C20 18 29 24 32 34Z" />
                        <circle class="journey-core" cx="36" cy="35" r="3.4" />
                    </svg>
                    <div class="journey-card">
                        <img src="assets/img/le-royal/seating/counter-seat.jpg" alt="Chef counter seating">
                        <div class="journey-copy">
                            <h3><fmt:message key="home.journey.counter.title" /></h3>
                            <p><fmt:message key="home.journey.counter.copy" /></p>
                        </div>
                    </div>
                </article>
                <article class="journey-point journey-point-right">
                    <svg class="journey-marker" aria-hidden="true" viewBox="0 0 72 72" focusable="false">
                        <path class="journey-stem" d="M35 63C40 53 31 47 36 39" />
                        <path class="journey-petal" d="M36 31C27 23 28 10 38 7C47 12 47 24 36 31Z" />
                        <path class="journey-petal" d="M39 34C49 25 62 28 64 38C58 45 47 43 39 34Z" />
                        <path class="journey-petal" d="M35 37C43 46 39 58 29 60C23 53 26 42 35 37Z" />
                        <path class="journey-petal" d="M32 34C21 39 11 33 10 23C20 18 29 24 32 34Z" />
                        <circle class="journey-core" cx="36" cy="35" r="3.4" />
                    </svg>
                    <div class="journey-card">
                        <img src="assets/img/le-royal/menu/sommelier-candle.jpg" alt="Sommelier pairing detail">
                        <div class="journey-copy">
                            <h3><fmt:message key="home.journey.pairing.title" /></h3>
                            <p><fmt:message key="home.journey.pairing.copy" /></p>
                        </div>
                    </div>
                </article>
                <article class="journey-point journey-point-left">
                    <svg class="journey-marker" aria-hidden="true" viewBox="0 0 72 72" focusable="false">
                        <path class="journey-stem" d="M35 63C40 53 31 47 36 39" />
                        <path class="journey-petal" d="M36 31C27 23 28 10 38 7C47 12 47 24 36 31Z" />
                        <path class="journey-petal" d="M39 34C49 25 62 28 64 38C58 45 47 43 39 34Z" />
                        <path class="journey-petal" d="M35 37C43 46 39 58 29 60C23 53 26 42 35 37Z" />
                        <path class="journey-petal" d="M32 34C21 39 11 33 10 23C20 18 29 24 32 34Z" />
                        <circle class="journey-core" cx="36" cy="35" r="3.4" />
                    </svg>
                    <div class="journey-card">
                        <img src="assets/img/le-royal/seating/event-long-table.jpg" alt="Guests sharing a fine dining evening">
                        <div class="journey-copy">
                            <h3><fmt:message key="home.journey.personal.title" /></h3>
                            <p><fmt:message key="home.journey.personal.copy" /></p>
                        </div>
                    </div>
                    <svg class="journey-final-flourish" aria-hidden="true" viewBox="0 0 100 100" preserveAspectRatio="none" focusable="false">
                        <path class="journey-final-vine" d="M50 7C39 15 25 17 16 28C3 44 7 66 24 75C36 81 48 72 48 58C43 72 50 80 63 77C66 76 69 75 72 75" />
                        <text class="journey-final-word" x="72" y="78">Le Royal</text>
                    </svg>
                </article>
            </div>
        </div>
    </section>

    <section class="py-5">
        <div class="container">
            <div class="row g-4">
                <div class="col-lg-4">
                    <article class="card shadow-sm border-0 h-100 p-5">
                        <span class="badge text-bg-light border text-dark text-uppercase fw-semibold"><fmt:message key="home.action.book.eyebrow"/></span>
                        <h3 class="display-6 mt-3 mb-3"><fmt:message key="home.action.book.title"/></h3>
                        <p class="text-secondary mb-4"><fmt:message key="home.action.book.copy"/></p>
                        <a href="MainController?action=booking" class="btn btn-dark"><fmt:message key="nav.booking"/></a>
                    </article>
                </div>
                <div class="col-lg-4">
                    <article class="card shadow-sm border-0 h-100 p-5">
                        <span class="badge text-bg-light border text-dark text-uppercase fw-semibold"><fmt:message key="home.action.visit.eyebrow"/></span>
                        <h3 class="display-6 mt-3 mb-3"><fmt:message key="home.action.visit.title"/></h3>
                        <p class="text-secondary mb-4"><fmt:message key="home.action.visit.copy"/></p>
                        <a href="MainController?action=booking" class="btn btn-outline-dark"><fmt:message key="home.action.visit.btn"/></a>
                    </article>
                </div>
                <div class="col-lg-4">
                    <article class="card shadow-sm border-0 h-100 p-5">
                        <span class="badge text-bg-light border text-dark text-uppercase fw-semibold"><fmt:message key="home.action.private.eyebrow"/></span>
                        <h3 class="display-6 mt-3 mb-3"><fmt:message key="home.action.private.title"/></h3>
                        <p class="text-secondary mb-4"><fmt:message key="home.action.private.copy"/></p>
                        <a href="MainController?action=booking" class="btn btn-outline-dark"><fmt:message key="home.action.private.btn"/></a>
                    </article>
                </div>
            </div>
        </div>
    </section>
</main>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        var path = document.querySelector('[data-journey-path]');
        var base = document.querySelector('.journey-line-base');
        var progress = document.querySelector('[data-journey-progress]');
        var points = document.querySelectorAll('.journey-point');
        if (!path || !base || !progress || !points.length) {
            return;
        }

        function updateJourneyLine() {
            var rect = path.getBoundingClientRect();
            var lineRect = progress.closest('.journey-line').getBoundingClientRect();
            var markerStops = Array.prototype.map.call(points, function (point) {
                var marker = point.querySelector('.journey-marker');
                var markerRect = marker ? marker.getBoundingClientRect() : point.getBoundingClientRect();
                var markerCenter = markerRect.top + markerRect.height * 0.5;
                return Math.max(0, Math.min(100, ((markerCenter - lineRect.top) / lineRect.height) * 100));
            });
            var dynamicPath = markerStops.reduce(function (commands, stop, index) {
                if (index === 0) {
                    return 'M50 ' + stop.toFixed(2);
                }
                var previous = markerStops[index - 1];
                var span = stop - previous;
                var swingX = index % 2 === 1 ? 2 : 98;
                var mid = previous + span * 0.5;
                var controlA = previous + span * 0.22;
                var controlB = previous + span * 0.78;
                return commands
                        + ' C50 ' + controlA.toFixed(2) + ' ' + swingX + ' ' + controlA.toFixed(2) + ' ' + swingX + ' ' + mid.toFixed(2)
                        + ' C' + swingX + ' ' + controlB.toFixed(2) + ' 50 ' + controlB.toFixed(2) + ' 50 ' + stop.toFixed(2);
            }, '');
            base.setAttribute('d', dynamicPath);
            progress.setAttribute('d', dynamicPath);
            var viewportAnchor = window.innerHeight * 0.62;
            var total = rect.height - viewportAnchor;
            var current = viewportAnchor - rect.top;
            var percent = Math.max(0, Math.min(100, (current / total) * 100));
            var progressLength = 100;
            path.style.setProperty('--journey-progress', percent.toFixed(2));
            progress.style.strokeDasharray = progressLength + ' ' + progressLength;
            progress.style.strokeDashoffset = (progressLength - (progressLength * percent / 100)).toFixed(2);
            points.forEach(function (point, index) {
                var marker = point.querySelector('.journey-marker');
                var markerRect = marker ? marker.getBoundingClientRect() : point.getBoundingClientRect();
                var markerCenter = markerRect.top + markerRect.height * 0.5;
                if (markerCenter <= viewportAnchor) {
                    point.classList.add('is-visible');
                } else {
                    point.classList.remove('is-visible');
                }
            });
        }

        updateJourneyLine();
        window.addEventListener('scroll', updateJourneyLine, {passive: true});
        window.addEventListener('resize', updateJourneyLine);
    });
</script>

<jsp:include page="footer.jsp" />
