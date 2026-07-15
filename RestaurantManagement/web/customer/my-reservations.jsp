<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<fmt:setLocale value="${sessionScope.lang == 'vi' ? 'vi_VN' : 'en_US'}" />
<fmt:setBundle basename="i18n.messages" />
<fmt:message key="reservation.cancel.confirm" var="cancelConfirmText"/>
<fmt:message key="reservation.modal.close" var="modalCloseLabel"/>
<jsp:include page="/header.jsp" />
<style>
    .reserve-page{min-height:80vh;background:radial-gradient(circle at top left,rgba(185,154,82,.14),transparent 34rem),linear-gradient(180deg,#fbfaf7 0%,#f3efe7 100%);color:#191714}
    .reserve-shell{max-width:1180px}
    .reserve-hero{padding:3.25rem 0 2.25rem}
    .reserve-kicker,.reserve-section-label,.reserve-meta-label{letter-spacing:.14em!important;text-transform:uppercase;font-size:.72rem;font-weight:700;color:#9a7d3e}
    .reserve-title{max-width:760px;font-size:clamp(3rem,7vw,5.75rem);line-height:.9;text-wrap:balance}
    .reserve-copy{max-width:620px;color:#6f685d;line-height:1.8}
    .reserve-summary{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:1px;background:rgba(185,154,82,.26);border:1px solid rgba(185,154,82,.28)}
    .reserve-summary__item{background:rgba(255,255,255,.78);padding:1.15rem}
    .reserve-summary__number{font-family:"Marcellus",Georgia,serif;font-size:2.4rem;line-height:1;font-weight:600;font-variant-numeric:tabular-nums}
    .reserve-panel{background:rgba(255,255,255,.82);border:1px solid #e7e0d2;box-shadow:0 1rem 2.5rem rgba(94,77,45,.08)}
    .reserve-panel__header{display:flex;align-items:center;justify-content:space-between;gap:1rem;padding:1.25rem 1.35rem;border-bottom:1px solid #e7e0d2}
    .reserve-table{width:100%;margin:0}
    .reserve-table th{padding:.95rem 1rem;color:#8a7440;font-size:.72rem;letter-spacing:.12em!important;text-transform:uppercase;background:#f7f2e8;border-bottom:1px solid #e7e0d2;font-weight:700;white-space:nowrap}
    .reserve-table td{padding:1rem;border-color:#eee6d8;vertical-align:middle}
    .reserve-status{display:inline-flex;align-items:center;gap:.4rem;min-height:30px;padding:.3rem .65rem;font-size:.78rem;font-weight:700;white-space:nowrap;border:1px solid}
    .reserve-status--pending{border-color:rgba(255,193,7,.35);background:#fffbe6;color:#856404}
    .reserve-status--confirmed{border-color:rgba(13,202,240,.3);background:#e7f7fe;color:#026c8a}
    .reserve-status--checkedin{border-color:rgba(13,110,253,.25);background:#e8f0fe;color:#1a4fa0}
    .reserve-status--completed{border-color:rgba(25,135,84,.25);background:#edf7f1;color:#1c6a45}
    .reserve-status--cancelled{border-color:rgba(220,53,69,.25);background:#fde8ea;color:#a11f2f}
    .reserve-id{font-weight:800;color:#191714;font-variant-numeric:tabular-nums}
    .reserve-time{font-weight:700;color:#b99a52;font-size:.92rem}
    .reserve-guest-tag{display:inline-flex;align-items:center;width:fit-content;min-height:26px;padding:.2rem .5rem;border:1px solid #e1d3ba;background:#fbf7ef;color:#715c2d;font-size:.76rem;font-weight:600}
    .reserve-action{display:inline-flex;align-items:center;gap:.4rem;min-height:38px;padding:0 .85rem;border:1px solid #ded4c5;background:#fff;color:#191714;font-weight:600;font-size:.84rem;text-decoration:none;transition:transform .2s ease,border-color .2s ease,background-color .2s ease}
    .reserve-action:hover{border-color:#b99a52;background:#fbf7ef;color:#191714;transform:translateY(-1px)}
    .reserve-action--primary{background:#171410;color:#fff;border-color:#171410}
    .reserve-action--primary:hover{background:#2d2618;color:#fff;border-color:#2d2618;transform:translateY(-2px)}
    .reserve-action--danger{color:#a11f2f;border-color:rgba(220,53,69,.3)}
    .reserve-action--danger:hover{border-color:#dc3545;background:#fde8ea;color:#a11f2f}
    .reserve-empty{padding:3rem 1rem;text-align:center;color:#766f66}
    .reserve-empty i{color:#b99a52;font-size:2rem;margin-bottom:.75rem}
    .reserve-booking-link{display:inline-flex;align-items:center;gap:.45rem;padding:.75rem 1rem;background:#171410;color:#fff;text-decoration:none;transition:transform .22s ease,background-color .22s ease}
    .reserve-booking-link:hover,.reserve-booking-link:focus{background:#2d2618;color:#fff;transform:translateY(-2px)}
    .reserve-modal .modal-content{border:0;border-radius:0;box-shadow:0 1.5rem 4rem rgba(23,20,16,.18)}
    .reserve-modal .modal-header,.reserve-modal .modal-footer{border-color:#e7e0d2;background:#fbf7ef}
    .reserve-modal-title{font-family:"Marcellus",Georgia,serif;font-size:2rem;font-weight:600}
    .reserve-detail-label{letter-spacing:.12em!important;text-transform:uppercase;font-size:.72rem;font-weight:700;color:#9a7d3e}
    .reserve-detail-item{display:flex;justify-content:space-between;padding:.5rem 0}
    .reserve-detail-item+.reserve-detail-item{border-top:1px solid #eee6d8}
    @media(max-width:575.98px){.reserve-summary{grid-template-columns:1fr}}
</style>

<main class="reserve-page">
    <div class="container reserve-shell">
        <section class="reserve-hero">
            <div class="row g-4 align-items-end">
                <div class="col-lg-8">
                    <div class="reserve-kicker mb-3"><fmt:message key="reservation.eyebrow"/></div>
                    <h1 class="reserve-title mb-3"><fmt:message key="reservation.title"/></h1>
                    <p class="reserve-copy mb-0"><fmt:message key="reservation.subtitle"/></p>
                </div>
                <div class="col-lg-4">
                    <div class="reserve-summary">
                        <div class="reserve-summary__item">
                            <div class="reserve-meta-label mb-2"><fmt:message key="reservation.total"/></div>
                            <div class="reserve-summary__number">${fn:length(myReservations)}</div>
                        </div>
                        <div class="reserve-summary__item">
                            <div class="reserve-meta-label mb-2"><fmt:message key="reservation.upcoming"/></div>
                            <div class="reserve-summary__number">
                                <c:set var="upcoming" value="0"/>
                                <c:forEach items="${myReservations}" var="r"><c:if test="${r.status == 'PENDING' || r.status == 'CONFIRMED'}"><c:set var="upcoming" value="${upcoming + 1}"/></c:if></c:forEach>
                                ${upcoming}
                            </div>
                        </div>
                        <div class="reserve-summary__item">
                            <div class="reserve-meta-label mb-2"><fmt:message key="reservation.completed"/></div>
                            <div class="reserve-summary__number">
                                <c:set var="done" value="0"/>
                                <c:forEach items="${myReservations}" var="r"><c:if test="${r.status == 'COMPLETED' || r.status == 'CHECKED_IN'}"><c:set var="done" value="${done + 1}"/></c:if></c:forEach>
                                ${done}
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

        <section class="reserve-panel mb-5" aria-labelledby="reserveTableTitle">
            <div class="reserve-panel__header">
                <div>
                    <div class="reserve-section-label"><fmt:message key="reservation.section"/></div>
                    <h2 id="reserveTableTitle" class="h4 fw-semibold mb-0 mt-1"><fmt:message key="reservation.heading"/></h2>
                </div>
                <a class="reserve-booking-link" href="${pageContext.request.contextPath}/MainController?action=booking">
                    <i class="fa-solid fa-plus"></i>
                    <fmt:message key="reservation.new"/>
                </a>
            </div>

            <c:choose>
                <c:when test="${empty myReservations}">
                    <div class="reserve-empty">
                        <i class="fa-solid fa-calendar-plus d-block"></i>
                        <div class="fw-semibold mb-1"><fmt:message key="reservation.empty"/></div>
                        <div class="small"><fmt:message key="reservation.empty.sub"/></div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table align-middle reserve-table">
                            <thead>
                                <tr>
                                    <th class="ps-4"><fmt:message key="reservation.col.code"/></th>
                                    <th><fmt:message key="reservation.col.time"/></th>
                                    <th><fmt:message key="reservation.col.guests"/></th>
                                    <th><fmt:message key="reservation.col.status"/></th>
                                    <th class="text-end pe-4"><fmt:message key="reservation.col.action"/></th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${myReservations}" var="res">
                                    <tr>
                                        <td class="ps-4 reserve-id">#${res.id}</td>
                                        <td>
                                            <div><fmt:formatDate value="${res.reservationDate}" pattern="dd/MM/yyyy"/></div>
                                            <div class="reserve-time"><fmt:formatDate value="${res.reservationTime}" pattern="HH:mm"/></div>
                                        </td>
                                        <td>
                                            <span class="reserve-guest-tag"><i class="fa-solid fa-user me-1"></i>${res.adultsCount}</span>
                                            <c:if test="${res.childrenCount > 0}">
                                                <span class="reserve-guest-tag"><i class="fa-solid fa-child me-1"></i>${res.childrenCount}</span>
                                            </c:if>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${res.status == 'PENDING'}"><span class="reserve-status reserve-status--pending"><i class="fa-regular fa-clock"></i><fmt:message key="reservation.status.pending"/></span></c:when>
                                                <c:when test="${res.status == 'CONFIRMED'}"><span class="reserve-status reserve-status--confirmed"><i class="fa-regular fa-circle-check"></i><fmt:message key="reservation.status.confirmed"/></span></c:when>
                                                <c:when test="${res.status == 'CHECKED_IN'}"><span class="reserve-status reserve-status--checkedin"><i class="fa-solid fa-check"></i><fmt:message key="reservation.status.checkedin"/></span></c:when>
                                                <c:when test="${res.status == 'COMPLETED'}"><span class="reserve-status reserve-status--completed"><i class="fa-solid fa-check-double"></i><fmt:message key="reservation.status.completed"/></span></c:when>
                                                <c:when test="${res.status == 'CANCELLED'}"><span class="reserve-status reserve-status--cancelled"><i class="fa-solid fa-ban"></i><fmt:message key="reservation.status.cancelled"/></span></c:when>
                                            </c:choose>
                                        </td>
                                        <td class="text-end pe-4">
                                            <button class="reserve-action" data-bs-toggle="modal" data-bs-target="#detailsModal${res.id}">
                                                <i class="fa-regular fa-eye"></i><fmt:message key="reservation.detail"/>
                                            </button>
                                            <c:if test="${res.status == 'PENDING' || res.status == 'CONFIRMED'}">
                                                <form action="${pageContext.request.contextPath}/customer/reservations" method="POST" class="d-inline" onsubmit="return confirm('${cancelConfirmText}');">
                                                    <input type="hidden" name="action" value="cancel">
                                                    <input type="hidden" name="id" value="${res.id}">
                                                    <button type="submit" class="reserve-action reserve-action--danger"><i class="fa-solid fa-ban"></i><fmt:message key="reservation.cancel"/></button>
                                                </form>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
    </div>
</main>

<c:forEach items="${myReservations}" var="res">
    <div class="modal fade reserve-modal" id="detailsModal${res.id}" tabindex="-1" aria-labelledby="detailsModalTitle${res.id}" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <div>
                        <div class="reserve-kicker"><fmt:message key="reservation.section"/></div>
                        <h5 id="detailsModalTitle${res.id}" class="reserve-modal-title modal-title mb-0"><fmt:message key="reservation.modal.title"><fmt:param value="${res.id}"/></fmt:message></h5>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="${modalCloseLabel}"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="reserve-detail-label mb-2"><i class="fa-solid fa-chair me-2"></i><fmt:message key="reservation.modal.tables"/></div>
                    <c:forEach items="${res.reservationTables}" var="rt">
                        <div class="reserve-detail-item">
                            <span><fmt:message key="booking.table"/> ${rt.diningTable.tableCode} <span class="text-muted small">(<fmt:message key="reservation.table.capacity"><fmt:param value="${rt.diningTable.capacity}"/></fmt:message>)</span></span>
                            <span class="fw-bold"><fmt:formatNumber value="${rt.diningTable.basePrice}" pattern="#,##0"/>d</span>
                        </div>
                    </c:forEach>
                    <c:if test="${empty res.reservationTables}">
                        <div class="text-muted small mb-3"><fmt:message key="reservation.modal.no.tables"/></div>
                    </c:if>

                    <div class="reserve-detail-label mt-4 mb-2"><i class="fa-solid fa-utensils me-2"></i><fmt:message key="reservation.modal.menu"/></div>
                    <c:forEach items="${res.reservationMenuItems}" var="rmi">
                        <div class="reserve-detail-item">
                            <span>${not empty rmi.menuItem ? (not empty rmi.menuItem.itemNameVi ? rmi.menuItem.itemNameVi : rmi.menuItem.itemName) : (not empty rmi.menuSet.setNameVi ? rmi.menuSet.setNameVi : rmi.menuSet.setName)} <span class="badge bg-secondary ms-1">x${rmi.quantity}</span></span>
                            <span class="fw-bold"><fmt:formatNumber value="${rmi.unitPrice * rmi.quantity}" pattern="#,##0"/>d</span>
                        </div>
                    </c:forEach>
                    <c:if test="${empty res.reservationMenuItems}">
                        <div class="text-muted small mb-3"><fmt:message key="reservation.modal.no.menu"/></div>
                    </c:if>

                    <div class="reserve-detail-label mt-4 mb-2"><i class="fa-solid fa-star me-2"></i><fmt:message key="reservation.modal.addons"/></div>
                    <c:forEach items="${res.reservationAddons}" var="ra">
                        <div class="reserve-detail-item">
                            <span>${ra.addonService.serviceName} <span class="badge bg-secondary ms-1">x${ra.quantity}</span></span>
                            <span class="fw-bold"><fmt:formatNumber value="${ra.unitPrice * ra.quantity}" pattern="#,##0"/>d</span>
                        </div>
                    </c:forEach>
                    <c:if test="${empty res.reservationAddons}">
                        <div class="text-muted small mb-3"><fmt:message key="reservation.modal.no.addons"/></div>
                    </c:if>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light border" data-bs-dismiss="modal"><fmt:message key="reservation.modal.close"/></button>
                </div>
            </div>
        </div>
    </div>
</c:forEach>

<jsp:include page="/footer.jsp" />
