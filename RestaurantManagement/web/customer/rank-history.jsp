<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="${sessionScope.lang == 'en' ? 'en_US' : 'vi_VN'}" />
<fmt:setBundle basename="i18n.messages" />
<jsp:include page="/header.jsp" />
<style>
    .rh-page{min-height:80vh;background:radial-gradient(circle at top left,rgba(185,154,82,.14),transparent 34rem),linear-gradient(180deg,#fbfaf7 0%,#f3efe7 100%);color:#191714}
    .rh-shell{max-width:1180px}
    .rh-hero{padding:3.25rem 0 2.25rem}
    .rh-kicker,.rh-section-label{letter-spacing:.14em!important;text-transform:uppercase;font-size:.72rem;font-weight:700;color:#9a7d3e}
    .rh-title{max-width:760px;font-size:clamp(3rem,7vw,5.75rem);line-height:.9;text-wrap:balance}
    .rh-copy{max-width:620px;color:#6f685d;line-height:1.8}
    .rh-panel{background:rgba(255,255,255,.82);border:1px solid #e7e0d2;box-shadow:0 1rem 2.5rem rgba(94,77,45,.08)}
    .rh-panel__header{padding:1.25rem 1.35rem;border-bottom:1px solid #e7e0d2}
    .rh-table th{padding:.95rem 1rem;color:#8a7440;font-size:.72rem;letter-spacing:.12em!important;text-transform:uppercase;background:#f7f2e8;border-bottom:1px solid #e7e0d2;font-weight:700;white-space:nowrap}
    .rh-table td{padding:1rem;border-color:#eee6d8;vertical-align:middle;font-size:.9rem}
    .rh-type{display:inline-flex;align-items:center;gap:.35rem;padding:.25rem .55rem;font-size:.76rem;font-weight:700;border:1px solid}
    .rh-type--earn{border-color:rgba(25,135,84,.25);background:#edf7f1;color:#1c6a45}
    .rh-type--redeem{border-color:rgba(220,53,69,.25);background:#fde8ea;color:#a11f2f}
    .rh-type--topup{border-color:rgba(13,110,253,.25);background:#e8f0fe;color:#1a4fa0}
    .rh-type--upgrade{border-color:rgba(185,154,82,.4);background:#fbf7ef;color:#715c2d}
    .rh-type--decay{border-color:rgba(108,117,125,.25);background:#f2f3f4;color:#5d646b}
    .rh-type--downgrade{border-color:rgba(220,53,69,.25);background:#fde8ea;color:#a11f2f}
    .rh-empty{padding:3rem 1rem;text-align:center;color:#766f66}
    .rh-empty i{color:#b99a52;font-size:2rem;margin-bottom:.75rem}
    .rh-back{display:inline-flex;align-items:center;gap:.45rem;padding:.65rem 1rem;border:1px solid #ded4c5;background:#fff;color:#191714;text-decoration:none;font-weight:600;font-size:.84rem;transition:transform .2s,border-color .2s}
    .rh-back:hover{border-color:#b99a52;background:#fbf7ef;color:#191714;transform:translateY(-1px)}
</style>

<main class="rh-page">
    <div class="container rh-shell">
        <section class="rh-hero">
            <div class="d-flex align-items-center justify-content-between">
                <div>
                    <div class="rh-kicker mb-3">Transaction Log</div>
                    <h1 class="rh-title mb-3">Lich su giao dich</h1>
                    <p class="rh-copy mb-0">Tat ca cac thay doi ve diem va hang thanh vien cua ban.</p>
                </div>
                <a href="${pageContext.request.contextPath}/customer/rank" class="rh-back"><i class="fa-solid fa-arrow-left"></i>Quay lai</a>
            </div>
        </section>

        <section class="rh-panel mb-5">
            <div class="rh-panel__header">
                <div class="rh-section-label">History</div>
            </div>
            <div class="table-responsive">
                <table class="table align-middle rh-table">
                    <thead>
                        <tr><th class="ps-4">Loai</th><th>Diem</th><th>Mo ta</th><th class="text-end pe-4">Ngay</th></tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty transactions}">
                                <tr><td colspan="4" class="rh-empty"><i class="fa-regular fa-clock d-block"></i><div class="fw-semibold">Chua co giao dich nao</div></td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach items="${transactions}" var="t">
                                    <tr>
                                        <td class="ps-4">
                                            <c:choose>
                                                <c:when test="${t.type == 'EARN'}"><span class="rh-type rh-type--earn"><i class="fa-regular fa-circle-check"></i>EARN</span></c:when>
                                                <c:when test="${t.type == 'REDEEM'}"><span class="rh-type rh-type--redeem"><i class="fa-solid fa-cart-shopping"></i>REDEEM</span></c:when>
                                                <c:when test="${t.type == 'TOPUP'}"><span class="rh-type rh-type--topup"><i class="fa-solid fa-arrow-up"></i>TOPUP</span></c:when>
                                                <c:when test="${t.type == 'RANK_UPGRADE'}"><span class="rh-type rh-type--upgrade"><i class="fa-solid fa-crown"></i>UPGRADE</span></c:when>
                                                <c:when test="${t.type == 'POINTS_DECAY'}"><span class="rh-type rh-type--decay"><i class="fa-solid fa-clock"></i>DECAY</span></c:when>
                                                <c:when test="${t.type == 'RANK_DOWNGRADE'}"><span class="rh-type rh-type--downgrade"><i class="fa-solid fa-arrow-down"></i>DOWN</span></c:when>
                                            </c:choose>
                                        </td>
                                        <td class="fw-bold ${t.pointsDelta >= 0 ? 'text-success' : 'text-danger'}">${t.pointsDelta >= 0 ? '+' : ''}${t.pointsDelta}</td>
                                        <td>${t.description}</td>
                                        <td class="text-end pe-4 text-muted small"><fmt:formatDate value="${t.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </section>
    </div>
</main>

<jsp:include page="/footer.jsp" />