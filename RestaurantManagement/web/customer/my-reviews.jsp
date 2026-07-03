<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="${sessionScope.lang == 'en' ? 'en_US' : 'vi_VN'}" />
<fmt:setBundle basename="i18n.messages" />
<jsp:include page="/header.jsp" />
<style>
    .review-page{min-height:80vh;background:radial-gradient(circle at top left,rgba(185,154,82,.14),transparent 34rem),linear-gradient(180deg,#fbfaf7 0%,#f3efe7 100%);color:#191714}
    .review-shell{max-width:1180px}
    .review-hero{padding:3.25rem 0 2.25rem}
    .review-kicker,.review-section-label{letter-spacing:.14em!important;text-transform:uppercase;font-size:.72rem;font-weight:700;color:#9a7d3e}
    .review-title{max-width:760px;font-size:clamp(3rem,7vw,5.75rem);line-height:.9;text-wrap:balance}
    .review-copy{max-width:620px;color:#6f685d;line-height:1.8}
    .review-summary{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:1px;background:rgba(185,154,82,.26);border:1px solid rgba(185,154,82,.28)}
    .review-summary__item{background:rgba(255,255,255,.78);padding:1.15rem}
    .review-summary__number{font-family:"Cormorant Garamond",Georgia,serif;font-size:2.4rem;line-height:1;font-weight:600;font-variant-numeric:tabular-nums}
    .review-panel{background:rgba(255,255,255,.82);border:1px solid #e7e0d2;box-shadow:0 1rem 2.5rem rgba(94,77,45,.08)}
    .review-panel__header{padding:1.25rem 1.35rem;border-bottom:1px solid #e7e0d2}
    .review-body{padding:1.35rem}
    .review-card{padding:1.25rem 0}
    .review-card+.review-card{border-top:1px solid #eee6d8}
    .review-card__meta{display:flex;justify-content:space-between;align-items:center}
    .review-reservation-id{font-weight:700;color:#191714}
    .review-stars{color:#b99a52;letter-spacing:.1em}
    .review-date{color:#766f66;font-size:.84rem}
    .review-comment{margin-top:.5rem;color:#574f43;line-height:1.7}
    .review-empty{padding:3rem 1rem;text-align:center;color:#766f66}
    .review-empty i{color:#b99a52;font-size:2rem;margin-bottom:.75rem}
    .review-form label{font-size:.84rem;font-weight:700;color:#574f43;margin-bottom:.3rem}
    .review-form .form-control,.review-form .form-select{border-radius:0;border:1px solid #ded4c5;background:#fbfaf7;padding:.6rem .75rem;font-size:.92rem}
    .review-form .form-control:focus,.review-form .form-select:focus{border-color:#b99a52;box-shadow:0 0 0 .2rem rgba(185,154,82,.2)}
    .review-submit{display:inline-flex;align-items:center;justify-content:center;gap:.5rem;min-height:44px;padding:0 1.1rem;border:0;background:#171410;color:#fff;font-weight:700;text-decoration:none;transition:transform .22s ease,background-color .22s ease,box-shadow .22s ease}
    .review-submit:hover{background:#2d2618;color:#fff;transform:translateY(-2px);box-shadow:0 .8rem 1.8rem rgba(45,38,24,.16)}
    @media(max-width:575.98px){.review-summary{grid-template-columns:1fr}}
</style>

<main class="review-page">
    <div class="container review-shell">
        <section class="review-hero">
            <div class="row g-4 align-items-end">
                <div class="col-lg-8">
                    <div class="review-kicker mb-3">Guest Voice</div>
                    <h1 class="review-title mb-3">Đánh giá của tôi</h1>
                    <p class="review-copy mb-0">Chia sẻ trải nghiệm của bạn sau mỗi bữa ăn và xem lại những đánh giá đã gửi.</p>
                </div>
                <div class="col-lg-4">
                    <div class="review-summary">
                        <div class="review-summary__item">
                            <div class="review-kicker mb-2">Đã gửi</div>
                            <div class="review-summary__number">${fn:length(myReviews)}</div>
                        </div>
                        <div class="review-summary__item">
                            <div class="review-kicker mb-2">Đã duyệt</div>
                            <div class="review-summary__number">
                                <c:set var="visible" value="0"/>
                                <c:forEach items="${myReviews}" var="r"><c:if test="${r.isVisible}"><c:set var="visible" value="${visible + 1}"/></c:if></c:forEach>
                                ${visible}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success alert-dismissible fade show border-0 border-start border-success border-3 rounded-0 shadow-sm" role="alert">
                <i class="fa-regular fa-circle-check me-2"></i>${sessionScope.successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                <c:remove var="successMessage" scope="session" />
            </div>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show border-0 border-start border-danger border-3 rounded-0 shadow-sm" role="alert">
                <i class="fa-regular fa-circle-exclamation me-2"></i>${sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                <c:remove var="errorMessage" scope="session" />
            </div>
        </c:if>

        <div class="row g-4 pb-5">
            <div class="col-lg-5">
                <section class="review-panel" aria-labelledby="submitReviewTitle">
                    <div class="review-panel__header">
                        <div class="review-section-label">Write</div>
                        <h2 id="submitReviewTitle" class="h4 fw-semibold mb-0 mt-1">Gửi đánh giá</h2>
                    </div>
                    <div class="review-body">
                        <form method="post" action="${pageContext.request.contextPath}/customer/reviews" class="review-form">
                            <div class="mb-3">
                                <label>Đơn đã hoàn thành</label>
                                <select name="reservationId" class="form-select" required>
                                    <option value="">Chọn mã đặt bàn</option>
                                    <c:forEach items="${myReservations}" var="r">
                                        <c:if test="${r.status == 'COMPLETED'}">
                                            <option value="${r.id}">#${r.id} - <fmt:formatDate value="${r.reservationDate}" pattern="dd/MM/yyyy"/></option>
                                        </c:if>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label>Số sao</label>
                                <input type="number" name="rating" class="form-control" min="1" max="5" value="5" required>
                            </div>
                            <div class="mb-3">
                                <label>Hình ảnh URL</label>
                                <input name="imageUrl" class="form-control" placeholder="https://...">
                            </div>
                            <div class="mb-3">
                                <label>Nội dung</label>
                                <textarea name="comment" class="form-control" rows="5" required></textarea>
                            </div>
                            <button class="review-submit w-100"><i class="fa-regular fa-paper-plane me-2"></i>Gửi đánh giá</button>
                        </form>
                    </div>
                </section>
            </div>
            <div class="col-lg-7">
                <section class="review-panel" aria-labelledby="historyTitle">
                    <div class="review-panel__header">
                        <div>
                            <div class="review-section-label">History</div>
                            <h2 id="historyTitle" class="h4 fw-semibold mb-0 mt-1">Lịch sử đánh giá</h2>
                        </div>
                    </div>
                    <div class="review-body">
                        <c:choose>
                            <c:when test="${empty myReviews}">
                                <div class="review-empty">
                                    <i class="fa-regular fa-star d-block"></i>
                                    <div class="fw-semibold mb-1">Bạn chưa có đánh giá nào</div>
                                    <div class="small">Hãy gửi đánh giá đầu tiên sau bữa ăn tại Le Royal.</div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach items="${myReviews}" var="r">
                                    <div class="review-card">
                                        <div class="review-card__meta">
                                            <span class="review-reservation-id">Reservation #${r.reservation.id}</span>
                                            <span class="badge ${r.isVisible ? 'bg-success' : 'bg-secondary'} rounded-0 fw-semibold">${r.isVisible ? 'Đã duyệt' : 'Chờ duyệt'}</span>
                                        </div>
                                        <div class="review-stars my-2">
                                            <c:forEach begin="1" end="${r.rating}"><i class="fa-solid fa-star"></i></c:forEach>
                                            <c:forEach begin="${r.rating + 1}" end="5"><i class="fa-regular fa-star"></i></c:forEach>
                                        </div>
                                        <div class="review-comment">${r.comment}</div>
                                        <div class="review-date mt-1"><fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm"/></div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </section>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/footer.jsp" />