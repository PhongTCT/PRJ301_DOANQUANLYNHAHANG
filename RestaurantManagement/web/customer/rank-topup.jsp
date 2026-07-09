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
.rank-badge{display:inline-flex;align-items:center;gap:.5rem;padding:.5rem 1rem;font-family:"Marcellus",Georgia,serif;font-size:1.8rem;font-weight:600;background:linear-gradient(135deg,#d4af37,#c5a028);color:#1a1a2e}
.rank-stat{font-family:"Marcellus",Georgia,serif;font-size:2.2rem;line-height:1;font-weight:600;font-variant-numeric:tabular-nums}
.rank-progress{height:8px;background:#e8e3db;border-radius:0;margin-top:.5rem}
.rank-progress-bar{height:100%;background:linear-gradient(90deg,#d4af37,#c5a028);transition:width .6s ease}
.rank-panel{background:rgba(255,255,255,.82);border:1px solid #e7e0d2;box-shadow:0 1rem 2.5rem rgba(94,77,45,.08)}
.rank-panel__header{padding:1.25rem 1.35rem;border-bottom:1px solid #e7e0d2}
.rank-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(220px,1fr));gap:1px;background:rgba(185,154,82,.26);border:1px solid rgba(185,154,82,.28)}
.rank-card{background:rgba(255,255,255,.78);padding:1.35rem;transition:background .22s,transform .22s}
.rank-card:hover{background:rgba(255,255,255,.95);transform:translateY(-2px)}
.rank-card__name{font-family:"Marcellus",Georgia,serif;font-size:1.6rem;font-weight:600;color:#191714}
.rank-card__label{font-size:.72rem;text-transform:uppercase;letter-spacing:.1em;color:#9a7d3e;font-weight:700}
.rank-card__value{font-weight:700;color:#191714}
.rank-card__status{display:inline-flex;align-items:center;gap:.35rem;padding:.3rem .65rem;font-size:.78rem;font-weight:700;border:1px solid}
.rank-card__status--current{border-color:rgba(185,154,82,.5);background:#fbf7ef;color:#715c2d}
.rank-card__status--locked{border-color:rgba(108,117,125,.25);background:#f2f3f4;color:#5d646b}
.rank-card__status--unlocked{border-color:rgba(25,135,84,.25);background:#edf7f1;color:#1c6a45}
.rank-deposit-btn{display:inline-flex;align-items:center;justify-content:center;gap:.5rem;min-height:44px;padding:0 1.1rem;border:0;background:#171410;color:#fff;font-weight:700;text-decoration:none;transition:transform .22s ease,background-color .22s ease,box-shadow .22s ease;border-radius:2px}
.rank-deposit-btn:hover{background:#2d2618;color:#fff;transform:translateY(-2px);box-shadow:0 .8rem 1.8rem rgba(45,38,24,.16)}
.rank-deposit-btn:disabled{opacity:.4;cursor:not-allowed;transform:none!important}
.topup-btn{display:inline-flex;align-items:center;gap:.55rem;min-height:44px;padding:0 1.4rem;border:0;background:#171410;color:#fff;font-weight:700;font-size:.88rem;text-decoration:none;transition:transform .22s,background .22s,box-shadow .22s}
.topup-btn:hover{background:#2d2618;color:#fff;transform:translateY(-2px);box-shadow:0 .5rem 1.2rem rgba(45,38,24,.12)}
.topup-btn--gold{background:linear-gradient(135deg,#d4af37,#c5a028);color:#1a1a2e}
.topup-btn--gold:hover{background:linear-gradient(135deg,#ddb83f,#c9a32c);color:#1a1a2e}
.topup-btn:disabled{opacity:.4;cursor:not-allowed;transform:none!important}
.topup-modal .modal-content{border:0;border-radius:0;background:#fbfaf7}
.topup-modal .modal-header{border-bottom:1px solid #e7e0d2;padding:1.25rem 1.5rem}
.topup-modal .modal-body{padding:1.5rem}
.topup-modal .modal-footer{border-top:1px solid #e7e0d2;padding:1rem 1.5rem}
.topup-radio-card{position:relative;display:flex;align-items:center;gap:1rem;padding:1rem 1.1rem;border:2px solid #e7e0d2;background:#fff;cursor:pointer;transition:border-color .2s,background .2s}
.topup-radio-card:hover{border-color:#c5a028}
.topup-radio-card.selected{border-color:#b99a52;background:#fbf7ef}
.topup-radio-card.disabled{opacity:.5;cursor:not-allowed;border-color:#e7e0d2!important;background:#f5f3ef!important}
.topup-radio-card input[type=radio]{position:absolute;opacity:0;pointer-events:none}
.topup-radio-card .rank{font-family:"Marcellus",Georgia,serif;font-size:1.3rem;font-weight:700;min-width:100px}
.topup-radio-card .detail{font-size:.82rem;color:#6f685d;flex-grow:1}
.topup-radio-card .amount{font-weight:700;color:#191714;white-space:nowrap}
.topup-preview-box{padding:1rem;background:#fff;border:1px solid #e7e0d2;margin-top:1rem}
.topup-preview-box .preview-row{display:flex;justify-content:space-between;align-items:center;padding:6px 0}
.topup-preview-box .preview-row+.preview-row{border-top:1px solid #f0ebe1;margin-top:6px;padding-top:6px}
.topup-preview-box .preview-label{color:#766f66;font-size:.85rem}
.topup-preview-box .preview-value{font-weight:700;font-size:.95rem}
.topup-free-badge{display:inline-block;padding:2px 10px;font-size:.78rem;font-weight:700;background:#198754;color:#fff}
.topup-amount-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(140px,1fr));gap:10px}
.topup-amount-card{position:relative;padding:1rem;text-align:center;border:2px solid #e7e0d2;background:#fff;cursor:pointer;transition:border-color .2s,background .2s,transform .2s}
.topup-amount-card:hover{border-color:#c5a028;transform:translateY(-2px)}
.topup-amount-card.selected{border-color:#b99a52;background:#fbf7ef}
.topup-amount-card .amount{font-family:"Marcellus",Georgia,serif;font-size:1.3rem;font-weight:700;color:#191714}
.topup-amount-card .label{font-size:.72rem;text-transform:uppercase;letter-spacing:.07em;color:#9a7d3e;margin-top:4px}
.topup-amount-card input[type=radio]{position:absolute;opacity:0;pointer-events:none}
</style>

<main class="rank-page">
<div class="container rank-shell">
<section class="rank-hero">
<div class="row g-4 align-items-end">
<div class="col-lg-7">
<div class="rank-kicker mb-3"><fmt:message key="rank.loyalty.program"/></div>
<h1 class="rank-title mb-3"><fmt:message key="rank.page.title"/></h1>
<p class="rank-copy mb-0"><fmt:message key="rank.page.subtitle"/></p>
</div>
<div class="col-lg-5">
<div class="rank-profile-card">
<c:set var="profile" value="${rankInfo}"/>
<div class="d-flex align-items-center gap-3 mb-3">
<div class="rank-badge">${profile.currentRank.rankName}</div>
<div class="flex-grow-1">
<div class="rank-kicker mb-1"><fmt:message key="rank.total.spent"/></div>
<div class="fw-bold"><fmt:formatNumber value="${profile.totalSpent}" pattern="#,##0"/>d</div>
</div>
</div>
<div class="row g-3">
<div class="col-6">
<div class="rank-meta-label mb-1"><fmt:message key="rank.points.label"/></div>
<div class="rank-stat">${profile.loyaltyPoints}</div>
</div>
<div class="col-6">
<div class="rank-meta-label mb-1"><fmt:message key="rank.coins.label"/></div>
<div class="rank-stat"><fmt:formatNumber value="${profile.coinBalance}" pattern="#,##0"/></div>
</div>
</div>
<c:if test="${profile.nextRank != null}">
<div class="mt-3">
<div class="d-flex justify-content-between small">
<span class="rank-meta-label"><fmt:message key="rank.next.goal"><fmt:param value="${profile.pointsToNext}"/><fmt:param value="${profile.nextRank.rankName}"/></fmt:message></span>
<span class="rank-meta-label">${profile.loyaltyPoints}/${profile.nextRank.minPointThreshold}</span>
</div>
<div class="rank-progress">
<c:set var="pct" value="${profile.nextRank.minPointThreshold > 0 ? (profile.loyaltyPoints * 100 / profile.nextRank.minPointThreshold) : 0}"/>
<div class="rank-progress-bar" style="width:${pct > 100 ? 100 : pct}%"></div>
</div>
</div>
</c:if>
<div class="d-flex gap-2 mt-3">
<button type="button" class="topup-btn topup-btn--gold flex-grow-1" data-bs-toggle="modal" data-bs-target="#rankTopUpModal">
<i class="fa-solid fa-crown"></i><fmt:message key="rank.nav.rank"/>
</button>
<button type="button" class="topup-btn flex-grow-1" data-bs-toggle="modal" data-bs-target="#xuTopUpModal">
<i class="fa-solid fa-coins"></i><fmt:message key="rank.nav.xu"/>
</button>
</div>
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
<div class="rank-section-label"><fmt:message key="rank.grid.eyebrow"/></div>
<h2 id="rankGridTitle" class="h4 fw-semibold mb-0 mt-1"><fmt:message key="rank.benefits.title"/></h2>
</div>
<a href="${pageContext.request.contextPath}/customer/rank?action=history" class="btn btn-sm btn-outline-secondary rounded-0 border fw-semibold"><fmt:message key="rank.history.link"/></a>
</div>
<div class="rank-grid">
<c:forEach items="${rankInfo.allRanks}" var="r">
<c:set var="isCurrent" value="${profile.currentRank != null && profile.currentRank.id == r.id}"/>
<c:set var="isUnlocked" value="${profile.loyaltyPoints >= r.minPointThreshold}"/>
<div class="rank-card">
<div class="d-flex justify-content-between align-items-start mb-2">
<div class="rank-card__name">${r.rankName}</div>
<c:choose>
<c:when test="${isCurrent}"><span class="rank-card__status rank-card__status--current"><i class="fa-solid fa-crown"></i><fmt:message key="rank.grid.current"/></span></c:when>
<c:when test="${isUnlocked}"><span class="rank-card__status rank-card__status--unlocked"><i class="fa-regular fa-circle-check"></i><fmt:message key="rank.grid.unlocked"/></span></c:when>
<c:otherwise><span class="rank-card__status rank-card__status--locked"><i class="fa-solid fa-lock"></i><fmt:message key="rank.grid.locked"/></span></c:otherwise>
</c:choose>
</div>
<div class="mb-2">
<span class="rank-card__label"><fmt:message key="rank.grid.threshold"/></span>
<div class="rank-card__value"><fmt:formatNumber value="${r.minPointThreshold}" pattern="#,##0"/> pts</div>
</div>
<div class="mb-2">
<span class="rank-card__label"><fmt:message key="rank.grid.discount"/></span>
<div class="rank-card__value">${r.discountPercent}%</div>
</div>
<div>
<span class="rank-card__label"><fmt:message key="rank.grid.points.rate.label"/></span>
<div class="rank-card__value"><fmt:message key="rank.grid.points.rate"><fmt:param value="${r.pointsPerThousandVnd}"/></fmt:message></div>
</div>
<div class="mt-2 small">
<c:if test="${r.canBookVip}"><span class="text-success"><i class="fa-regular fa-circle-check me-1"></i><fmt:message key="rank.grid.vip"/></span></c:if>
<c:if test="${r.canBookVvip}"><span class="text-success ms-2"><i class="fa-regular fa-circle-check me-1"></i><fmt:message key="rank.grid.vvip"/></span></c:if>
</div>
</div>
</c:forEach>
</div>
</section>
</div>
</main>

<div class="modal fade topup-modal" id="rankTopUpModal" tabindex="-1" aria-labelledby="rankTopUpModalTitle" aria-hidden="true">
<div class="modal-dialog modal-dialog-centered modal-lg">
<div class="modal-content">
<div class="modal-header">
<div>
<div class="rank-kicker mb-1"><fmt:message key="rank.loyalty.program"/></div>
<h5 class="modal-title fw-bold" id="rankTopUpModalTitle"><fmt:message key="rank.modal.title"/></h5>
</div>
<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<div class="modal-body">
<div class="rank-meta-label mb-2"><fmt:message key="rank.modal.select.rank"/></div>
<div class="d-flex flex-column gap-2 mb-3" id="rankTargetList">
<c:set var="currentPts" value="${profile.loyaltyPoints}"/>
<c:forEach items="${rankInfo.allRanks}" var="r">
<c:if test="${r.rankName != 'BRONZE'}">
<c:set var="gap" value="${r.minPointThreshold - currentPts}"/>
<c:set var="amount" value="${gap * 10000}"/>
<c:set var="disabled" value="${gap <= 0}"/>
<label class="topup-radio-card ${amount == rankTopUpAmount ? 'selected' : ''} ${disabled ? 'disabled' : ''}" data-amount="${amount}" data-rank="${r.rankName}" data-gap="${gap}">
<input type="radio" name="rankTarget" value="${r.rankName}" ${disabled ? 'disabled' : ''} data-amount="${amount}">
<span class="rank">${r.rankName}</span>
<span class="detail">
<fmt:message key="rank.modal.threshold"><fmt:param><fmt:formatNumber value="${r.minPointThreshold}" pattern="#,###"/></fmt:param><fmt:param><fmt:formatNumber value="${currentPts}" pattern="#,###"/></fmt:param></fmt:message>
<c:if test="${gap > 0}"> | <fmt:message key="rank.modal.gap"><fmt:param><fmt:formatNumber value="${gap}" pattern="#,###"/></fmt:param></fmt:message></c:if>
<c:if test="${gap <= 0}"> | <span class="text-success"><fmt:message key="rank.modal.sufficient"/></span></c:if>
</span>
<span class="amount">
<c:choose>
<c:when test="${gap <= 0}"><fmt:message key="rank.modal.placeholder"/></c:when>
<c:otherwise><fmt:formatNumber value="${amount}" pattern="#,##0"/>d</c:otherwise>
</c:choose>
</span>
</label>
</c:if>
</c:forEach>
</div>

<div class="mb-3">
<label class="rank-meta-label mb-1"><fmt:message key="rank.modal.voucher.label"/></label>
<input type="text" class="form-control form-control-sm rounded-0" id="rankVoucherCode" value="VipFree" placeholder="<fmt:message key="rank.modal.voucher.placeholder"/>">
</div>

<div class="topup-preview-box" id="rankPreviewBox">
<div class="preview-row">
<span class="preview-label"><fmt:message key="rank.modal.preview.original"/></span>
<span class="preview-value" id="rankOriginalAmount">0d</span>
</div>
<div class="preview-row">
<span class="preview-label"><fmt:message key="rank.modal.preview.rank"/></span>
<span class="preview-value" id="rankTargetName">-</span>
</div>
<div class="preview-row" id="rankDiscountRow">
<span class="preview-label"><fmt:message key="rank.modal.preview.discount"/></span>
<span class="preview-value text-success" id="rankDiscountAmount">0d</span>
</div>
<div class="preview-row fw-bold">
<span class="preview-label"><fmt:message key="rank.modal.preview.total"/></span>
<span class="preview-value" id="rankFinalAmount">0d</span>
</div>
<div class="small text-warning mt-2" id="rankSymbolicNotice" style="display:none">
<i class="fa-solid fa-info-circle"></i>
<fmt:message key="rank.modal.notice"/>
</div>
</div>
</div>
<div class="modal-footer">
<button type="button" class="btn btn-secondary rounded-0" data-bs-dismiss="modal"><fmt:message key="rank.modal.cancel"/></button>
<button type="button" class="topup-btn" id="rankCheckoutBtn" disabled>
<i class="fa-solid fa-arrow-right"></i> <fmt:message key="rank.modal.checkout"/>
</button>
</div>
</div>
</div>
</div>

<div class="modal fade topup-modal" id="xuTopUpModal" tabindex="-1" aria-labelledby="xuTopUpModalTitle" aria-hidden="true">
<div class="modal-dialog modal-dialog-centered">
<div class="modal-content">
<div class="modal-header">
<div>
<div class="rank-kicker mb-1"><fmt:message key="rank.loyalty.program"/></div>
<h5 class="modal-title fw-bold" id="xuTopUpModalTitle"><fmt:message key="xu.modal.title"/></h5>
</div>
<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<div class="modal-body">
<div class="rank-meta-label mb-2"><fmt:message key="xu.modal.select.amount"/></div>
<div class="topup-amount-grid mb-3" id="xuAmountGrid">
<label class="topup-amount-card selected" data-amount="500000">
<input type="radio" name="xuAmount" value="500000" checked>
<div class="amount">500K</div>
<div class="label"><fmt:message key="xu.modal.earnings"><fmt:param value="50"/><fmt:param value="50"/></fmt:message></div>
</label>
<label class="topup-amount-card" data-amount="1000000">
<input type="radio" name="xuAmount" value="1000000">
<div class="amount">1M</div>
<div class="label"><fmt:message key="xu.modal.earnings"><fmt:param value="100"/><fmt:param value="100"/></fmt:message></div>
</label>
<label class="topup-amount-card" data-amount="2000000">
<input type="radio" name="xuAmount" value="2000000">
<div class="amount">2M</div>
<div class="label"><fmt:message key="xu.modal.earnings"><fmt:param value="200"/><fmt:param value="200"/></fmt:message></div>
</label>
<label class="topup-amount-card" data-amount="5000000">
<input type="radio" name="xuAmount" value="5000000">
<div class="amount">5M</div>
<div class="label"><fmt:message key="xu.modal.earnings"><fmt:param value="500"/><fmt:param value="500"/></fmt:message></div>
</label>
</div>

<div class="mb-3">
<label class="rank-meta-label mb-1"><fmt:message key="xu.modal.voucher.label"/></label>
<input type="text" class="form-control form-control-sm rounded-0" id="xuVoucherCode" value="CoinFree" placeholder="<fmt:message key="xu.modal.voucher.placeholder"/>">
</div>

<div class="topup-preview-box" id="xuPreviewBox">
<div class="preview-row">
<span class="preview-label"><fmt:message key="xu.modal.preview.original"/></span>
<span class="preview-value" id="xuOriginalAmount">500,000d</span>
</div>
<div class="preview-row">
<span class="preview-label"><fmt:message key="xu.modal.preview.receive"/></span>
<span class="preview-value" id="xuCoinAmount">50 xu + 50 diem</span>
</div>
<div class="preview-row" id="xuDiscountRow">
<span class="preview-label"><fmt:message key="xu.modal.preview.discount"/></span>
<span class="preview-value text-success" id="xuDiscountAmount">-500,000d</span>
</div>
<div class="preview-row fw-bold">
<span class="preview-label"><fmt:message key="xu.modal.preview.total"/></span>
<span class="preview-value" id="xuFinalAmount"><span class="topup-free-badge"><fmt:message key="xu.modal.preview.free"/></span></span>
</div>
<div class="small text-warning mt-2" id="xuSymbolicNotice" style="display:none">
<i class="fa-solid fa-info-circle"></i>
<fmt:message key="xu.modal.notice"/>
</div>
</div>
</div>
<div class="modal-footer">
<button type="button" class="btn btn-secondary rounded-0" data-bs-dismiss="modal"><fmt:message key="xu.modal.cancel"/></button>
<button type="button" class="topup-btn" id="xuCheckoutBtn">
<i class="fa-solid fa-arrow-right"></i> <fmt:message key="xu.modal.checkout"/>
</button>
</div>
</div>
</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
(function () {
var ctx = '${pageContext.request.contextPath}';
var i18n = {
freeBadge: '<span class="topup-free-badge"><fmt:message key="rank.modal.preview.free"/></span>',
processing: '<i class="fa-solid fa-spinner fa-spin"></i> <fmt:message key="common.processing"/>',
checkout: '<i class="fa-solid fa-arrow-right"></i> <fmt:message key="rank.modal.checkout"/>',
errorPayment: '<fmt:message key="common.error.payment"/>'
};
var locale = '${sessionScope.lang == 'en' ? 'en-US' : 'vi-VN'}';
function fmt(n){return Number(n).toLocaleString(locale);}

function post(action, body, cb, errCb) {
var xhr = new XMLHttpRequest();
xhr.open('POST', ctx+'/customer/rank', true);
xhr.timeout = 15000;
xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded;charset=UTF-8');
xhr.onload=function(){
    if(xhr.status===200){
        try{cb(JSON.parse(xhr.responseText))}
        catch(e){if(errCb)errCb('Phan hoi khong hop le tu server.');else alert('Phan hoi khong hop le tu server.');}
    } else {
        if(errCb)errCb('Loi server: '+xhr.status);else alert('Loi server: '+xhr.status);
    }
};
xhr.onerror=function(){if(errCb)errCb('Loi ket noi mang.');else alert('Loi ket noi mang.');};
xhr.ontimeout=function(){if(errCb)errCb('Yeu cau qua thoi gian cho.');else alert('Yeu cau qua thoi gian cho.');};
xhr.send(body+'&action='+action);
}

function updateRankPreview() {
var sel = document.querySelector('#rankTargetList .selected');
if (!sel) return;
var amount = sel.getAttribute('data-amount');
var rank = sel.getAttribute('data-rank');
var voucher = document.getElementById('rankVoucherCode').value.trim();
document.getElementById('rankTargetName').textContent = rank;
document.getElementById('rankOriginalAmount').textContent = fmt(amount)+'d';
post('applyVoucher','topupType=RANK&originalAmount='+amount+'&voucherCode='+encodeURIComponent(voucher), function(d){
var discount = d.originalAmount - d.finalAmount;
document.getElementById('rankDiscountAmount').textContent = '-'+fmt(discount)+'d';
if(d.isFree){
document.getElementById('rankFinalAmount').innerHTML=i18n.freeBadge;
document.getElementById('rankSymbolicNotice').style.display='block';
} else {
document.getElementById('rankFinalAmount').textContent=fmt(d.finalAmount)+'d';
document.getElementById('rankSymbolicNotice').style.display='none';
}
document.getElementById('rankCheckoutBtn').disabled=false;
});
}

function updateXuPreview() {
var sel = document.querySelector('#xuAmountGrid .selected');
if (!sel) return;
var amount = sel.getAttribute('data-amount');
var voucher = document.getElementById('xuVoucherCode').value.trim();
document.getElementById('xuOriginalAmount').textContent = fmt(amount)+'d';
var earned = Math.floor(amount/10000);
document.getElementById('xuCoinAmount').textContent = fmt(earned)+' xu + '+fmt(earned)+' diem';
post('applyVoucher','topupType=XU&originalAmount='+amount+'&voucherCode='+encodeURIComponent(voucher), function(d){
var discount = d.originalAmount - d.finalAmount;
document.getElementById('xuDiscountAmount').textContent = '-'+fmt(discount)+'d';
if(d.isFree){
document.getElementById('xuFinalAmount').innerHTML=i18n.freeBadge;
document.getElementById('xuSymbolicNotice').style.display='block';
} else {
document.getElementById('xuFinalAmount').textContent=fmt(d.finalAmount)+'d';
document.getElementById('xuSymbolicNotice').style.display='none';
}
document.getElementById('xuCheckoutBtn').disabled=false;
});
}

document.querySelectorAll('#rankTargetList .topup-radio-card').forEach(function(c){
c.addEventListener('click',function(){
if(this.classList.contains('disabled')) return;
document.querySelectorAll('#rankTargetList .topup-radio-card').forEach(function(x){x.classList.remove('selected');});
this.classList.add('selected');
updateRankPreview();
});
});

document.querySelectorAll('#xuAmountGrid .topup-amount-card').forEach(function(c){
c.addEventListener('click',function(){
document.querySelectorAll('#xuAmountGrid .topup-amount-card').forEach(function(x){x.classList.remove('selected');});
this.classList.add('selected');
updateXuPreview();
});
});

document.getElementById('rankVoucherCode').addEventListener('input', function(){
if(document.querySelector('#rankTargetList .selected')) updateRankPreview();
});
document.getElementById('xuVoucherCode').addEventListener('input', updateXuPreview);

document.getElementById('rankCheckoutBtn').addEventListener('click', function(){
var sel = document.querySelector('#rankTargetList .selected');
if(!sel) return;
var amount = sel.getAttribute('data-amount');
var rank = sel.getAttribute('data-rank');
var voucher = document.getElementById('rankVoucherCode').value.trim();
var btn = this;
btn.disabled=true; btn.innerHTML=i18n.processing;
post('checkoutRank','targetRank='+rank+'&originalAmount='+amount+'&voucherCode='+encodeURIComponent(voucher), function(d){
btn.disabled=false; btn.innerHTML=i18n.checkout;
if(d.error){alert(d.error);return;}
if(d.paymentUrl){window.location.href=d.paymentUrl;}
else{alert('Loi xu ly thanh toan.');}
}, function(msg){btn.disabled=false; btn.innerHTML=i18n.checkout; alert(msg);});
});

document.getElementById('xuCheckoutBtn').addEventListener('click', function(){
var sel = document.querySelector('#xuAmountGrid .selected');
if(!sel) return;
var amount = sel.getAttribute('data-amount');
var voucher = document.getElementById('xuVoucherCode').value.trim();
var btn = this;
btn.disabled=true; btn.innerHTML=i18n.processing;
post('checkoutXu','originalAmount='+amount+'&voucherCode='+encodeURIComponent(voucher), function(d){
btn.disabled=false; btn.innerHTML=i18n.checkout;
if(d.error){alert(d.error);return;}
if(d.paymentUrl){window.location.href=d.paymentUrl;}
else{alert(i18n.errorPayment);}
}, function(msg){btn.disabled=false; btn.innerHTML=i18n.checkout; alert(msg);});
});

document.getElementById('rankTopUpModal').addEventListener('shown.bs.modal', function(){
var first = document.querySelector('#rankTargetList .topup-radio-card:not(.disabled)');
if(first){first.classList.add('selected');updateRankPreview();}
});
document.getElementById('xuTopUpModal').addEventListener('shown.bs.modal', updateXuPreview);
})();
</script>
<jsp:include page="/footer.jsp" />
