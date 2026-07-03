<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="${sessionScope.lang == 'en' ? 'en_US' : 'vi_VN'}" />
<fmt:setBundle basename="i18n.messages" />
<jsp:include page="/header.jsp" />
<style>
    .rank-page{min-height:80vh;background:radial-gradient(circle at top left,rgba(185,154,82,.14),transparent 34rem),linear-gradient(180deg,#fbfaf7 0%,#f3efe7 100%);color:#191714}
    .rank-shell{max-width:1180px}
    .rank-hero{padding:3.25rem 0 2.25rem}
    .rank-kicker,.rank-section-label,.rank-meta-label{letter-spacing:.14em!important;text-transform:uppercase;font-size:.72rem;font-weight:700;color:#9a7d3e}
    .rank-title{max-width:760px;font-size:clamp(3rem,7vw,5.75rem);line-height:.9;text-wrap:balance}
    .rank-copy{max-width:620px;color:#6f685d;line-height:1.8}
    .rank-profile-card{background:rgba(255,255,255,.82);border:1px solid #e7e0d2;box-shadow:0 1rem 2.5rem rgba(94,77,45,.08);padding:1.5rem}
    .rank-badge{display:inline-flex;align-items:center;gap:.5rem;padding:.5rem 1rem;font-family:"Cormorant Garamond",Georgia,serif;font-size:1.8rem;font-weight:600;background:linear-gradient(135deg,#d4af37,#c5a028);color:#1a1a2e}
    .rank-stat{font-family:"Cormorant Garamond",Georgia,serif;font-size:2.2rem;line-height:1;font-weight:600;font-variant-numeric:tabular-nums}
    .rank-progress{height:8px;background:#e8e3db;border-radius:0;margin-top:.5rem}
    .rank-progress-bar{height:100%;background:linear-gradient(90deg,#d4af37,#c5a028);transition:width .6s ease}
    .rank-panel{background:rgba(255,255,255,.82);border:1px solid #e7e0d2;box-shadow:0 1rem 2.5rem rgba(94,77,45,.08)}
    .rank-panel__header{padding:1.25rem 1.35rem;border-bottom:1px solid #e7e0d2}
    .rank-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(220px,1fr));gap:1px;background:rgba(185,154,82,.26);border:1px solid rgba(185,154,82,.28)}
    .rank-card{background:rgba(255,255,255,.78);padding:1.35rem;transition:background .22s,transform .22s}
    .rank-card:hover{background:rgba(255,255,255,.95);transform:translateY(-2px)}
    .rank-card__name{font-family:"Cormorant Garamond",Georgia,serif;font-size:1.6rem;font-weight:600;color:#191714}
    .rank-card__label{font-size:.72rem;text-transform:uppercase;letter-spacing:.1em;color:#9a7d3e;font-weight:700}
    .rank-card__value{font-weight:700;color:#191714}
    .rank-card__status{display:inline-flex;align-items:center;gap:.35rem;padding:.3rem .65rem;font-size:.78rem;font-weight:700;border:1px solid}
    .rank-card__status--current{border-color:rgba(185,154,82,.5);background:#fbf7ef;color:#715c2d}
    .rank-card__status--locked{border-color:rgba(108,117,125,.25);background:#f2f3f4;color:#5d646b}
    .rank-card__status--unlocked{border-color:rgba(25,135,84,.25);background:#edf7f1;color:#1c6a45}
    .rank-deposit-btn{display:inline-flex;align-items:center;justify-content:center;gap:.5rem;min-height:44px;padding:0 1.1rem;border:0;background:#171410;color:#fff;font-weight:700;text-decoration:none;transition:transform .22s ease,background-color .22s ease,box-shadow .22s ease;border-radius:2px}
    .rank-deposit-btn:hover{background:#2d2618;color:#fff;transform:translateY(-2px);box-shadow:0 .8rem 1.8rem rgba(45,38,24,.16)}
    .rank-deposit-btn:disabled{opacity:.4;cursor:not-allowed;transform:none!important}
    .rank-table th{padding:.95rem 1rem;color:#8a7440;font-size:.72rem;letter-spacing:.12em!important;text-transform:uppercase;background:#f7f2e8;border-bottom:1px solid #e7e0d2;font-weight:700;white-space:nowrap}
    .rank-table td{padding:1rem;border-color:#eee6d8;vertical-align:middle;font-size:.9rem}
    .rank-trans-type{display:inline-flex;align-items:center;gap:.35rem;padding:.25rem .55rem;font-size:.76rem;font-weight:700;border:1px solid}
    .rank-trans-type--earn{border-color:rgba(25,135,84,.25);background:#edf7f1;color:#1c6a45}
    .rank-trans-type--redeem{border-color:rgba(220,53,69,.25);background:#fde8ea;color:#a11f2f}
    .rank-trans-type--topup{border-color:rgba(13,110,253,.25);background:#e8f0fe;color:#1a4fa0}
    .rank-trans-type--upgrade{border-color:rgba(185,154,82,.4);background:#fbf7ef;color:#715c2d}
    .rank-trans-type--decay{border-color:rgba(108,117,125,.25);background:#f2f3f4;color:#5d646b}
    .rank-trans-type--downgrade{border-color:rgba(220,53,69,.25);background:#fde8ea;color:#a11f2f}
    .rank-empty{padding:2rem;text-align:center;color:#766f66}
    .rank-empty i{color:#b99a52;font-size:1.5rem;margin-bottom:.5rem}
    @media(max-width:575.98px){.rank-grid{grid-template-columns:1fr}}
</style>

<main class="rank-page">
    <div class="container rank-shell">
        <section class="rank-hero">
            <div class="row g-4 align-items-end">
                <div class="col-lg-7">
                    <div class="rank-kicker mb-3">Loyalty Program</div>
                    <h1 class="rank-title mb-3">Hang & Diem cua toi</h1>
                    <p class="rank-copy mb-0">Tich diem moi lan dung bua, len hang de nhan them uu dai dac biet tu Le Royal.</p>
                </div>
                <div class="col-lg-5">
                    <div class="rank-profile-card">
                        <c:set var="profile" value="${rankInfo}"/>
                        <div class="d-flex align-items-center gap-3 mb-3">
                            <div class="rank-badge">${profile.currentRank.rankName}</div>
                            <div class="flex-grow-1">
                                <div class="rank-kicker mb-1">Tong chi tieu</div>
                                <div class="fw-bold"><fmt:formatNumber value="${profile.totalSpent}" pattern="#,##0"/>d</div>
                            </div>
                        </div>
                        <div class="row g-3">
                            <div class="col-6">
                                <div class="rank-meta-label mb-1">Diem tich luy</div>
                                <div class="rank-stat">${profile.loyaltyPoints}</div>
                            </div>
                            <div class="col-6">
                                <div class="rank-meta-label mb-1">Xu</div>
                                <div class="rank-stat"><fmt:formatNumber value="${profile.coinBalance}" pattern="#,##0"/></div>
                            </div>
                        </div>
                        <c:if test="${profile.nextRank != null}">
                            <div class="mt-3">
                                <div class="d-flex justify-content-between small">
                                    <span class="rank-meta-label">Con <strong>${profile.pointsToNext}</strong> diem den hang ${profile.nextRank.rankName}</span>
                                    <span class="rank-meta-label">${profile.loyaltyPoints}/${profile.nextRank.minPointThreshold}</span>
                                </div>
                                <div class="rank-progress">
                                    <c:set var="pct" value="${profile.nextRank.minPointThreshold > 0 ? (profile.loyaltyPoints * 100 / profile.nextRank.minPointThreshold) : 0}"/>
                                    <div class="rank-progress-bar" style="width:${pct > 100 ? 100 : pct}%"></div>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </section>

        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success alert-dismissible fade show border-0 border-start border-success border-3 rounded-0 shadow-sm" role="alert">
                <i class="fa-regular fa-circle-check me-2"></i>${sessionScope.successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                <c:remove var="successMessage" scope="session"/>
            </div>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show border-0 border-start border-danger border-3 rounded-0 shadow-sm" role="alert">
                <i class="fa-regular fa-circle-exclamation me-2"></i>${sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                <c:remove var="errorMessage" scope="session"/>
            </div>
        </c:if>

        <section class="rank-panel mb-5" aria-labelledby="rankGridTitle">
            <div class="rank-panel__header d-flex align-items-center justify-content-between">
                <div>
                    <div class="rank-section-label">Rank benefits</div>
                    <h2 id="rankGridTitle" class="h4 fw-semibold mb-0 mt-1">Cac hang thanh vien</h2>
                </div>
                <a href="${pageContext.request.contextPath}/customer/rank?action=history" class="btn btn-sm btn-outline-secondary rounded-0 border fw-semibold">Lich su giao dich</a>
            </div>
            <div class="rank-grid">
                <c:forEach items="${rankInfo.allRanks}" var="r">
                    <c:set var="isCurrent" value="${profile.currentRank != null && profile.currentRank.id == r.id}"/>
                    <c:set var="isUnlocked" value="${profile.loyaltyPoints >= r.minPointThreshold}"/>
                    <div class="rank-card">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <div class="rank-card__name">${r.rankName}</div>
                            <c:choose>
                                <c:when test="${isCurrent}"><span class="rank-card__status rank-card__status--current"><i class="fa-solid fa-crown"></i>Hien tai</span></c:when>
                                <c:when test="${isUnlocked}"><span class="rank-card__status rank-card__status--unlocked"><i class="fa-regular fa-circle-check"></i>Da mo</span></c:when>
                                <c:otherwise><span class="rank-card__status rank-card__status--locked"><i class="fa-solid fa-lock"></i>Khoa</span></c:otherwise>
                            </c:choose>
                        </div>
                        <div class="mb-2">
                            <span class="rank-card__label">Nguong diem</span>
                            <div class="rank-card__value"><fmt:formatNumber value="${r.minPointThreshold}" pattern="#,##0"/> pts</div>
                        </div>
                        <div class="mb-2">
                            <span class="rank-card__label">Giam gia</span>
                            <div class="rank-card__value">${r.discountPercent}%</div>
                        </div>
                        <div>
                            <span class="rank-card__label">Tich diem</span>
                            <div class="rank-card__value">${r.pointsPerThousandVnd}pt / 1Kd</div>
                        </div>
                        <div class="mt-2 small">
                            <c:if test="${r.canBookVip}"><span class="text-success"><i class="fa-regular fa-circle-check me-1"></i>VIP room</span></c:if>
                            <c:if test="${r.canBookVvip}"><span class="text-success ms-2"><i class="fa-regular fa-circle-check me-1"></i>VVIP room</span></c:if>
                        </div>
                        <c:if test="${r.rankName != 'BRONZE' && !isCurrent && !isUnlocked}">
                            <c:set var="gap" value="${r.minPointThreshold - profile.loyaltyPoints}"/>
                            <c:set var="depositAmount" value="${gap * 10000}"/>
                            <form method="post" action="${pageContext.request.contextPath}/customer/rank" class="mt-3">
                                <input type="hidden" name="action" value="topup">
                                <input type="hidden" name="targetRank" value="${r.rankName}">
                                <input type="hidden" name="amount" value="${depositAmount}">
                                <button type="submit" class="rank-deposit-btn w-100">
                                    <i class="fa-solid fa-arrow-up"></i>Nap <fmt:formatNumber value="${depositAmount}" pattern="#,##0"/>d
                                </button>
                            </form>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </section>
    </div>
</main>

<jsp:include page="/footer.jsp" />