<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="${sessionScope.lang == 'en' ? 'en_US' : 'vi_VN'}" />
<fmt:setBundle basename="i18n.messages" />
<jsp:include page="/header.jsp" />
<style>
    .invoice-page{min-height:80vh;background:radial-gradient(circle at top left,rgba(185,154,82,.14),transparent 34rem),linear-gradient(180deg,#fbfaf7 0%,#f3efe7 100%);color:#191714}
    .invoice-shell{max-width:1180px}
    .invoice-hero{padding:3.25rem 0 2.25rem}
    .invoice-kicker,.invoice-section-label,.invoice-meta-label{letter-spacing:.14em!important;text-transform:uppercase;font-size:.72rem;font-weight:700;color:#9a7d3e}
    .invoice-title{max-width:760px;font-size:clamp(3rem,7vw,5.75rem);line-height:.9;text-wrap:balance}
    .invoice-copy{max-width:620px;color:#6f685d;line-height:1.8}
    .invoice-summary{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:1px;background:rgba(185,154,82,.26);border:1px solid rgba(185,154,82,.28)}
    .invoice-summary__item{background:rgba(255,255,255,.78);padding:1.15rem}
    .invoice-summary__number{font-family:"Marcellus",Georgia,serif;font-size:2.4rem;line-height:1;font-weight:600;font-variant-numeric:tabular-nums}
    .invoice-panel{background:rgba(255,255,255,.82);border:1px solid #e7e0d2;box-shadow:0 1rem 2.5rem rgba(94,77,45,.08)}
    .invoice-panel__header{display:flex;align-items:center;justify-content:space-between;gap:1rem;padding:1.25rem 1.35rem;border-bottom:1px solid #e7e0d2}
    .invoice-table{width:100%;margin:0}
    .invoice-table th{padding:.95rem 1rem;color:#8a7440;font-size:.72rem;letter-spacing:.12em!important;text-transform:uppercase;background:#f7f2e8;border-bottom:1px solid #e7e0d2;font-weight:700;white-space:nowrap}
    .invoice-table td{padding:1rem;border-color:#eee6d8;vertical-align:middle}
    .invoice-id{font-weight:800;color:#191714;font-variant-numeric:tabular-nums}
    .invoice-amount{font-family:"Marcellus",Georgia,serif;font-size:1.5rem;line-height:1;font-weight:600;color:#191714}
    .invoice-discount{color:#2a7a4b;font-weight:600}
    .invoice-voucher-tag{display:inline-flex;align-items:center;min-height:26px;padding:.2rem .5rem;border:1px solid #e1d3ba;background:#fbf7ef;color:#715c2d;font-size:.76rem;font-weight:600}
    .invoice-paid-tag{display:inline-flex;align-items:center;gap:.35rem;min-height:30px;padding:.3rem .65rem;font-size:.78rem;font-weight:700;border:1px solid}
    .invoice-paid-tag--paid{border-color:rgba(25,135,84,.25);background:#edf7f1;color:#1c6a45}
    .invoice-paid-tag--pending{border-color:rgba(255,193,7,.35);background:#fffbe6;color:#856404}
    .invoice-paid-tag--unpaid{border-color:rgba(108,117,125,.25);background:#f2f3f4;color:#5d646b}
    .invoice-date{color:#766f66;font-size:.84rem}
    .invoice-pay-btn{display:inline-flex;align-items:center;gap:.4rem;min-height:38px;padding:0 .85rem;background:#171410;color:#fff;font-weight:600;font-size:.84rem;text-decoration:none;transition:transform .2s ease,background-color .2s ease}
    .invoice-pay-btn:hover{background:#2d2618;color:#fff;transform:translateY(-1px)}
    .invoice-empty{padding:3rem 1rem;text-align:center;color:#766f66}
    .invoice-empty i{color:#b99a52;font-size:2rem;margin-bottom:.75rem}
    @media(max-width:575.98px){.invoice-summary{grid-template-columns:1fr}}
</style>

<main class="invoice-page">
    <div class="container invoice-shell">
        <section class="invoice-hero">
            <div class="row g-4 align-items-end">
                <div class="col-lg-8">
                    <div class="invoice-kicker mb-3">Billing Record</div>
                    <h1 class="invoice-title mb-3">HÃ³a Ä‘Æ¡n cá»§a tÃ´i</h1>
                    <p class="invoice-copy mb-0">Tra cá»©u lá»‹ch sá»­ thanh toÃ¡n, kiá»ƒm tra tráº¡ng thÃ¡i vÃ  thá»±c hiá»‡n thanh toÃ¡n cÃ¡c hÃ³a Ä‘Æ¡n cÃ²n ná»£.</p>
                </div>
                <div class="col-lg-4">
                    <div class="invoice-summary">
                        <div class="invoice-summary__item">
                            <div class="invoice-meta-label mb-2">Tá»•ng hÃ³a Ä‘Æ¡n</div>
                            <div class="invoice-summary__number">${fn:length(invoices)}</div>
                        </div>
                        <div class="invoice-summary__item">
                            <div class="invoice-meta-label mb-2">ÄÃ£ thanh toÃ¡n</div>
                            <div class="invoice-summary__number">
                                <c:set var="paidCount" value="0"/>
                                <c:forEach items="${invoices}" var="i"><c:if test="${i.paymentStatus == 'PAID'}"><c:set var="paidCount" value="${paidCount + 1}"/></c:if></c:forEach>
                                ${paidCount}
                            </div>
                        </div>
                        <div class="invoice-summary__item">
                            <div class="invoice-meta-label mb-2">ChÆ°a thanh toÃ¡n</div>
                            <div class="invoice-summary__number">
                                <c:set var="unpaidCount" value="0"/>
                                <c:forEach items="${invoices}" var="i"><c:if test="${i.paymentStatus != 'PAID'}"><c:set var="unpaidCount" value="${unpaidCount + 1}"/></c:if></c:forEach>
                                ${unpaidCount}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="invoice-panel mb-5" aria-labelledby="invoiceTableTitle">
            <div class="invoice-panel__header">
                <div>
                    <div class="invoice-section-label">Invoices</div>
                    <h2 id="invoiceTableTitle" class="h4 fw-semibold mb-0 mt-1">Lá»‹ch sá»­ hÃ³a Ä‘Æ¡n</h2>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table align-middle invoice-table">
                    <thead>
                        <tr>
                            <th class="ps-4">MÃ£</th>
                            <th>Äáº·t bÃ n</th>
                            <th>Tá»•ng</th>
                            <th>Æ¯u Ä‘Ã£i</th>
                            <th>Voucher</th>
                            <th>Thanh toÃ¡n</th>
                            <th>NgÃ y táº¡o</th>
                            <th class="text-end pe-4">Thao tÃ¡c</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty invoices}">
                                <tr>
                                    <td colspan="8" class="invoice-empty">
                                        <i class="fa-regular fa-file-lines d-block"></i>
                                        <div class="fw-semibold mb-1">Báº¡n chÆ°a cÃ³ hÃ³a Ä‘Æ¡n nÃ o</div>
                                        <div class="small">HÃ³a Ä‘Æ¡n sáº½ xuáº¥t hiá»‡n sau khi báº¡n Ä‘áº·t bÃ n vÃ  hoÃ n táº¥t bá»¯a Äƒn táº¡i Le Royal.</div>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach items="${invoices}" var="i">
                                    <tr>
                                        <td class="ps-4 invoice-id">#${i.id}</td>
                                        <td><c:if test="${not empty i.reservation}"><span class="fw-semibold">#${i.reservation.id}</span></c:if></td>
                                        <td class="invoice-amount"><fmt:formatNumber value="${i.totalAmount}" pattern="#,##0"/>Ä‘</td>
                                        <td class="invoice-discount"><fmt:formatNumber value="${i.voucherDiscount + i.pointsDiscount}" pattern="#,##0"/>Ä‘</td>
                                        <td>
                                            <c:forEach items="${i.voucherRedemptions}" var="vr"><span class="invoice-voucher-tag">${vr.voucher.voucherCode}</span></c:forEach>
                                            <c:if test="${empty i.voucherRedemptions}"><span class="text-muted small">-</span></c:if>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${i.paymentStatus == 'PAID'}">
                                                    <span class="invoice-paid-tag invoice-paid-tag--paid"><i class="fa-regular fa-circle-check"></i>ÄÃ£ TT</span>
                                                </c:when>
                                                <c:when test="${i.paymentStatus == 'PENDING'}">
                                                    <span class="invoice-paid-tag invoice-paid-tag--pending"><i class="fa-regular fa-clock"></i>Chá» TT</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="invoice-paid-tag invoice-paid-tag--unpaid"><i class="fa-solid fa-ban"></i>ChÆ°a TT</span>
                                                </c:otherwise>
                                            </c:choose>
                                            <div class="text-muted small mt-1"><fmt:formatNumber value="${i.totalAmount}" pattern="#,##0"/>Ä‘ - ${i.paymentMethod}</div>
                                        </td>
                                        <td class="invoice-date"><fmt:formatDate value="${i.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                        <td class="text-end pe-4">
                                            <c:if test="${i.paymentStatus == 'PENDING' and i.paymentMethod == 'VNPAY'}">
                                                <a class="invoice-pay-btn" href="${pageContext.request.contextPath}/payment/vnpay-pay?invoiceId=${i.id}">
                                                    <i class="fa-solid fa-credit-card"></i>Thanh toÃ¡n
                                                </a>
                                            </c:if>
                                        </td>
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