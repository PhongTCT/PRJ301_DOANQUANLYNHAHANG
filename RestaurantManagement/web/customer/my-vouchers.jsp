<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/header.jsp" />

<style>
    .voucher-page {
        min-height: 80vh;
        background:
            radial-gradient(circle at top left, rgba(185, 154, 82, 0.14), transparent 34rem),
            linear-gradient(180deg, #fbfaf7 0%, #f3efe7 100%);
        color: #191714;
    }

    .voucher-shell {
        max-width: 1180px;
    }

    .voucher-hero {
        position: relative;
        padding: 3.25rem 0 2.25rem;
    }

    .voucher-kicker,
    .voucher-section-label,
    .voucher-meta-label {
        letter-spacing: 0.14em !important;
        text-transform: uppercase;
        font-size: 0.72rem;
        font-weight: 700;
        color: #9a7d3e;
    }

    .voucher-title {
        max-width: 760px;
        font-size: clamp(3rem, 7vw, 5.75rem);
        line-height: 0.9;
        text-wrap: balance;
    }

    .voucher-copy {
        max-width: 620px;
        color: #6f685d;
        line-height: 1.8;
    }

    .voucher-summary {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 1px;
        background: rgba(185, 154, 82, 0.26);
        border: 1px solid rgba(185, 154, 82, 0.28);
    }

    .voucher-summary__item {
        background: rgba(255, 255, 255, 0.78);
        padding: 1.15rem;
    }

    .voucher-summary__number {
        font-family: "Marcellus", Georgia, serif;
        font-size: 2.4rem;
        line-height: 1;
        font-weight: 600;
        font-variant-numeric: tabular-nums;
    }

    .voucher-layout {
        display: grid;
        grid-template-columns: minmax(0, 1.35fr) minmax(320px, 0.65fr);
        gap: 1.5rem;
        padding-bottom: 4rem;
    }

    .voucher-panel {
        background: rgba(255, 255, 255, 0.82);
        border: 1px solid #e7e0d2;
        box-shadow: 0 1rem 2.5rem rgba(94, 77, 45, 0.08);
    }

    .voucher-panel__header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 1rem;
        padding: 1.25rem 1.35rem;
        border-bottom: 1px solid #e7e0d2;
    }

    .voucher-list {
        display: grid;
        gap: 1rem;
        padding: 1.25rem;
    }

    .voucher-ticket {
        position: relative;
        display: grid;
        grid-template-columns: minmax(0, 1fr) auto;
        gap: 1.25rem;
        min-height: 164px;
        padding: 1.35rem;
        overflow: hidden;
        background:
            linear-gradient(135deg, rgba(255, 255, 255, 0.94), rgba(255, 252, 246, 0.88)),
            radial-gradient(circle at 0 50%, transparent 0.72rem, #ffffff 0.76rem);
        border: 1px solid rgba(185, 154, 82, 0.34);
        transition: transform 0.24s ease, box-shadow 0.24s ease, border-color 0.24s ease;
    }

    .voucher-ticket:before,
    .voucher-ticket:after {
        content: "";
        position: absolute;
        top: 50%;
        width: 1.35rem;
        height: 1.35rem;
        border-radius: 50%;
        background: #f3efe7;
        border: 1px solid rgba(185, 154, 82, 0.32);
        transform: translateY(-50%);
    }

    .voucher-ticket:before {
        left: -0.72rem;
    }

    .voucher-ticket:after {
        right: -0.72rem;
    }

    .voucher-ticket:hover {
        transform: translateY(-3px);
        border-color: rgba(185, 154, 82, 0.72);
        box-shadow: 0 1rem 2rem rgba(94, 77, 45, 0.12);
    }

    .voucher-code {
        font-family: "Marcellus", Georgia, serif;
        font-size: clamp(2rem, 4vw, 3.4rem);
        line-height: 0.92;
        font-weight: 600;
        color: #171410;
        word-break: break-word;
    }

    .voucher-benefit {
        margin-top: 0.7rem;
        font-size: 1.06rem;
        color: #574f43;
    }

    .voucher-meta-grid {
        display: flex;
        flex-wrap: wrap;
        gap: 0.6rem;
        margin-top: 1rem;
    }

    .voucher-chip {
        display: inline-flex;
        align-items: center;
        gap: 0.42rem;
        min-height: 34px;
        padding: 0.35rem 0.65rem;
        background: #f8f4ec;
        border: 1px solid #e3d7be;
        color: #6b5a32;
        font-size: 0.84rem;
        font-weight: 600;
        white-space: nowrap;
    }

    .voucher-uses {
        align-self: stretch;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        min-width: 118px;
        padding-left: 1.25rem;
        border-left: 1px dashed rgba(185, 154, 82, 0.48);
        color: #6b5a32;
    }

    .voucher-uses strong {
        font-family: "Marcellus", Georgia, serif;
        font-size: 2.7rem;
        line-height: 1;
        color: #171410;
        font-variant-numeric: tabular-nums;
    }

    .voucher-empty {
        padding: 2rem;
        text-align: center;
        color: #766f66;
    }

    .voucher-empty i {
        color: #b99a52;
        font-size: 2rem;
        margin-bottom: 0.75rem;
    }

    .voucher-history {
        width: 100%;
        margin: 0;
    }

    .voucher-history th {
        padding: 0.95rem 1rem;
        color: #8a7440;
        font-size: 0.72rem;
        letter-spacing: 0.12em !important;
        text-transform: uppercase;
        background: #f7f2e8;
        border-bottom: 1px solid #e7e0d2;
    }

    .voucher-history td {
        padding: 1rem;
        border-color: #eee6d8;
        vertical-align: middle;
    }

    .voucher-history-code {
        font-weight: 800;
        color: #191714;
        font-variant-numeric: tabular-nums;
    }

    .voucher-booking-link {
        display: inline-flex;
        align-items: center;
        gap: 0.45rem;
        padding: 0.75rem 1rem;
        background: #171410;
        color: #fff;
        text-decoration: none;
        transition: transform 0.22s ease, background-color 0.22s ease;
    }

    .voucher-booking-link:hover,
    .voucher-booking-link:focus {
        background: #2d2618;
        color: #fff;
        transform: translateY(-2px);
    }

    @media (max-width: 991.98px) {
        .voucher-layout {
            grid-template-columns: 1fr;
        }
    }

    @media (max-width: 575.98px) {
        .voucher-summary {
            grid-template-columns: 1fr;
        }

        .voucher-ticket {
            grid-template-columns: 1fr;
        }

        .voucher-uses {
            align-items: flex-start;
            border-left: 0;
            border-top: 1px dashed rgba(185, 154, 82, 0.48);
            padding: 1rem 0 0;
        }
    }
</style>

<main class="voucher-page">
    <div class="container voucher-shell">
        <section class="voucher-hero">
            <div class="row g-4 align-items-end">
                <div class="col-lg-8">
                    <div class="voucher-kicker mb-3"><fmt:message key="voucher.eyebrow"/></div>
                    <h1 class="voucher-title mb-3"><fmt:message key="voucher.title"/></h1>
                    <p class="voucher-copy mb-0"><fmt:message key="voucher.subtitle"/></p>
                </div>
                <div class="col-lg-4">
                    <div class="voucher-summary">
                        <div class="voucher-summary__item">
                            <div class="voucher-meta-label mb-2"><fmt:message key="voucher.available"/></div>
                            <div class="voucher-summary__number">${fn:length(availableVouchers)}</div>
                        </div>
                        <div class="voucher-summary__item">
                            <div class="voucher-meta-label mb-2"><fmt:message key="voucher.used"/></div>
                            <div class="voucher-summary__number">${fn:length(usedVouchers)}</div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <div class="voucher-layout">
            <section class="voucher-panel" aria-labelledby="availableVoucherTitle">
                <div class="voucher-panel__header">
                    <div>
                        <div class="voucher-section-label"><fmt:message key="voucher.section.available"/></div>
                        <h2 id="availableVoucherTitle" class="h4 fw-semibold mb-0 mt-1"><fmt:message key="voucher.heading.available"/></h2>
                    </div>
                    <a class="voucher-booking-link" href="${pageContext.request.contextPath}/MainController?action=booking">
                        <i class="fa-solid fa-calendar-check"></i>
                        <fmt:message key="voucher.booking"/>
                    </a>
                </div>

                <c:choose>
                    <c:when test="${empty availableVouchers}">
                        <div class="voucher-empty">
                            <i class="fa-solid fa-ticket d-block"></i>
                            <div class="fw-semibold mb-1"><fmt:message key="voucher.empty"/></div>
                            <div class="small"><fmt:message key="voucher.empty.sub"/></div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="voucher-list">
                            <c:forEach items="${availableVouchers}" var="v">
                                <article class="voucher-ticket">
                                    <div>
                                        <div class="voucher-kicker mb-2">${v.voucherType}</div>
                                        <div class="voucher-code">${v.voucherCode}</div>
                                        <div class="voucher-benefit">
                                            <c:choose>
                                                <c:when test="${not empty v.discountPercent}">
                                                    <fmt:message key="voucher.discount.percent">
                                                        <fmt:param value="${v.discountPercent}"/>
                                                    </fmt:message>
                                                    <c:if test="${not empty v.maxDiscount}">,
                                                        <c:set var="formattedMaxDiscount">
                                                            <fmt:formatNumber value="${v.maxDiscount}" pattern="#,##0"/>
                                                        </c:set>
                                                        <fmt:message key="voucher.discount.max">
                                                            <fmt:param value="${formattedMaxDiscount}"/>
                                                        </fmt:message>
                                                    </c:if>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:set var="formattedDiscountAmount">
                                                        <fmt:formatNumber value="${v.discountAmount}" pattern="#,##0"/>
                                                    </c:set>
                                                    <fmt:message key="voucher.discount.amount">
                                                        <fmt:param value="${formattedDiscountAmount}"/>
                                                    </fmt:message>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="voucher-meta-grid">
                                            <span class="voucher-chip"><i class="fa-solid fa-bowl-food"></i>
                                                <c:set var="formattedMinOrder">
                                                    <fmt:formatNumber value="${v.minOrderValue}" pattern="#,##0"/>
                                                </c:set>
                                                <fmt:message key="voucher.from">
                                                    <fmt:param value="${formattedMinOrder}"/>
                                                </fmt:message>
                                            </span>
                                            <span class="voucher-chip"><i class="fa-regular fa-clock"></i>
                                                <c:set var="formattedValidTo">
                                                    <fmt:formatDate value="${v.validTo}" pattern="dd/MM/yyyy HH:mm"/>
                                                </c:set>
                                                <fmt:message key="voucher.until">
                                                    <fmt:param value="${formattedValidTo}"/>
                                                </fmt:message>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="voucher-uses">
                                        <fmt:message key="voucher.remaining">
                                            <fmt:param value="${v.remainingUses}"/>
                                        </fmt:message>
                                    </div>
                                </article>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>

            <aside class="voucher-panel" aria-labelledby="usedVoucherTitle">
                <div class="voucher-panel__header">
                    <div>
                        <div class="voucher-section-label"><fmt:message key="voucher.section.history"/></div>
                        <h2 id="usedVoucherTitle" class="h4 fw-semibold mb-0 mt-1"><fmt:message key="voucher.heading.used"/></h2>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="voucher-history table align-middle">
                        <thead>
                            <tr>
                                <th><fmt:message key="voucher.history.col.code"/></th>
                                <th><fmt:message key="voucher.history.col.invoice"/></th>
                                <th><fmt:message key="voucher.history.col.date"/></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${usedVouchers}" var="r">
                                <tr>
                                    <td class="voucher-history-code">${r.voucher.voucherCode}</td>
                                    <td>#${r.invoice.id}</td>
                                    <td><fmt:formatDate value="${r.usedAt}" pattern="dd/MM/yyyy"/></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty usedVouchers}">
                                <tr>
                                    <td colspan="3" class="text-center text-muted py-5">
                                        <i class="fa-regular fa-clock d-block mb-2"></i>
                                        <fmt:message key="voucher.empty.used"/>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </aside>
        </div>
    </div>
</main>

<jsp:include page="/footer.jsp" />
