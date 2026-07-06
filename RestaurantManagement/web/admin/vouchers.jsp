<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quáº£n lÃ½ voucher - Le Royal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Marcellus&family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --royal-ink: #171410;
            --royal-muted: #70675b;
            --royal-gold: #b99a52;
            --royal-line: #e8dfcf;
            --royal-paper: #fbfaf7;
            --royal-panel: #ffffff;
        }

        html {
            height: 100%;
            width: 100%;
            max-width: 100%;
            overscroll-behavior: none;
            overflow-x: hidden;
            overflow-y: hidden;
        }

        *,
        *::before,
        *::after {
            box-sizing: border-box;
            letter-spacing: 0;
        }

        body {
            margin: 0;
            height: 100%;
            width: 100%;
            max-width: 100%;
            overscroll-behavior: none;
            overflow-x: hidden;
            overflow-y: hidden;
            background:
                radial-gradient(circle at top right, rgba(185, 154, 82, 0.12), transparent 34rem),
                linear-gradient(180deg, #fbfaf7 0%, #f3efe8 100%);
            color: var(--royal-ink);
            font-family: "Manrope", Arial, sans-serif;
        }

        .admin-layout {
            width: 100%;
            max-width: 100vw;
            height: 100vh;
            min-height: 0;
            overflow-x: hidden;
            overflow-y: hidden;
            align-items: stretch;
        }

        .admin-voucher-main {
            flex: 1 1 auto;
            min-width: 0;
            min-height: 0;
            height: 100vh;
            width: calc(100% - 260px);
            max-width: calc(100vw - 260px);
            overflow-x: hidden;
            overflow-y: auto;
            overscroll-behavior: contain;
            padding: 2rem;
        }

        .admin-voucher-shell {
            width: 100%;
            min-width: 0;
            max-width: 1280px;
            margin: 0 auto;
        }

        .admin-voucher-hero {
            display: grid;
            grid-template-columns: minmax(0, 1fr) auto;
            align-items: end;
            gap: 1.5rem;
            padding: 1.25rem 0 1.5rem;
        }

        .admin-kicker,
        .admin-section-label,
        .admin-table thead th,
        .admin-fieldset-title {
            color: #917337;
            font-size: 0.72rem;
            font-weight: 800;
            letter-spacing: 0.13em !important;
            text-transform: uppercase;
        }

        .admin-voucher-title {
            margin: 0.3rem 0 0.4rem;
            font-family: "Marcellus", Georgia, serif;
            font-size: clamp(2.6rem, 5vw, 4.7rem);
            font-weight: 600;
            line-height: 0.92;
        }

        .admin-voucher-copy {
            max-width: 680px;
            margin: 0;
            color: var(--royal-muted);
            line-height: 1.7;
        }

        .admin-primary-action {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            min-height: 44px;
            padding: 0 1.1rem;
            border: 0;
            background: var(--royal-ink);
            color: #fff;
            font-weight: 700;
            text-decoration: none;
            transition: transform 0.22s ease, background-color 0.22s ease, box-shadow 0.22s ease;
        }

        .admin-primary-action:hover,
        .admin-primary-action:focus {
            background: #2d2618;
            color: #fff;
            transform: translateY(-2px);
            box-shadow: 0 0.8rem 1.8rem rgba(45, 38, 24, 0.16);
        }

        .admin-stat-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 1px;
            margin-bottom: 1.25rem;
            background: rgba(185, 154, 82, 0.28);
            border: 1px solid rgba(185, 154, 82, 0.3);
        }

        .admin-stat {
            min-width: 0;
            background: rgba(255, 255, 255, 0.84);
            padding: 1.15rem 1.2rem;
        }

        .admin-stat strong {
            display: block;
            margin-top: 0.35rem;
            font-family: "Marcellus", Georgia, serif;
            font-size: 2.3rem;
            line-height: 1;
            font-weight: 600;
            font-variant-numeric: tabular-nums;
            overflow-wrap: anywhere;
        }

        .admin-alert {
            border: 0;
            border-left: 3px solid currentColor;
            border-radius: 0;
            box-shadow: 0 0.8rem 1.8rem rgba(94, 77, 45, 0.08);
        }

        .admin-panel {
            overflow: hidden;
            max-width: 100%;
            background: rgba(255, 255, 255, 0.86);
            border: 1px solid var(--royal-line);
            box-shadow: 0 1rem 2.5rem rgba(94, 77, 45, 0.09);
        }

        .admin-panel-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1rem;
            padding: 1.05rem 1.25rem;
            border-bottom: 1px solid var(--royal-line);
        }

        .voucher-table-wrap {
            width: 100%;
            max-width: 100%;
            overflow-x: auto;
            overscroll-behavior-x: contain;
        }

        .admin-table {
            width: 100%;
            min-width: 0;
            table-layout: fixed;
            margin: 0;
        }

        .admin-table th,
        .admin-table td {
            min-width: 0;
            overflow-wrap: anywhere;
        }

        .admin-table th:nth-child(1) { width: 15%; }
        .admin-table th:nth-child(2) { width: 15%; }
        .admin-table th:nth-child(3) { width: 12%; }
        .admin-table th:nth-child(4) { width: 19%; }
        .admin-table th:nth-child(5) { width: 11%; }
        .admin-table th:nth-child(6) { width: 13%; }
        .admin-table th:nth-child(7) { width: 15%; }

        .admin-table thead th {
            padding: 1rem 1rem;
            background: #f8f3ea;
            border-bottom: 1px solid var(--royal-line);
            white-space: nowrap;
        }

        .admin-table tbody td {
            padding: 1rem;
            border-color: #efe6d7;
            vertical-align: middle;
        }

        .voucher-code-cell {
            display: grid;
            gap: 0.3rem;
            min-width: 0;
        }

        .voucher-code-text {
            font-size: 1rem;
            font-weight: 800;
            color: var(--royal-ink);
            font-variant-numeric: tabular-nums;
            overflow-wrap: anywhere;
        }

        .voucher-type-tag,
        .voucher-status,
        .voucher-use-tag {
            display: inline-flex;
            align-items: center;
            width: fit-content;
            min-height: 30px;
            padding: 0.3rem 0.55rem;
            border: 1px solid #e1d3ba;
            background: #fbf7ef;
            color: #715c2d;
            font-size: 0.76rem;
            font-weight: 700;
            white-space: nowrap;
            max-width: 100%;
        }

        .voucher-status.is-on {
            border-color: rgba(25, 135, 84, 0.25);
            background: #edf7f1;
            color: #1c6a45;
        }

        .voucher-status.is-off {
            border-color: rgba(108, 117, 125, 0.25);
            background: #f2f3f4;
            color: #5d646b;
        }

        .voucher-discount {
            font-family: "Marcellus", Georgia, serif;
            font-size: 1.7rem;
            line-height: 1;
            font-weight: 600;
            color: var(--royal-ink);
        }

        .voucher-discount-note,
        .voucher-condition,
        .voucher-date {
            color: var(--royal-muted);
            font-size: 0.86rem;
        }

        .voucher-actions {
            display: inline-flex;
            align-items: center;
            justify-content: flex-end;
            gap: 0.45rem;
            white-space: nowrap;
        }

        .voucher-icon-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 36px;
            height: 36px;
            border: 1px solid #ded4c5;
            background: #fff;
            color: var(--royal-ink);
            transition: transform 0.18s ease, border-color 0.18s ease, background-color 0.18s ease;
        }

        .voucher-icon-btn:hover,
        .voucher-icon-btn:focus {
            border-color: var(--royal-gold);
            background: #fbf7ef;
            color: var(--royal-ink);
            transform: translateY(-1px);
        }

        .voucher-icon-btn:active,
        .admin-primary-action:active {
            transform: translateY(0) scale(0.98);
        }

        .voucher-empty-row {
            padding: 3rem 1rem;
            color: var(--royal-muted);
            text-align: center;
        }

        .voucher-empty-row i {
            display: block;
            margin-bottom: 0.75rem;
            color: var(--royal-gold);
            font-size: 2rem;
        }

        .admin-modal .modal-content {
            border: 0;
            border-radius: 0;
            box-shadow: 0 1.5rem 4rem rgba(23, 20, 16, 0.18);
        }

        .admin-modal .modal-header,
        .admin-modal .modal-footer {
            border-color: var(--royal-line);
            background: #fbf7ef;
        }

        .admin-modal-title {
            font-family: "Marcellus", Georgia, serif;
            font-size: 2rem;
            font-weight: 600;
        }

        @media (max-width: 991.98px) {
            .admin-layout {
                align-items: stretch;
            }

            .admin-voucher-main {
                width: 100%;
                max-width: 100vw;
                height: 100vh;
                padding: 1.25rem;
            }

            .admin-voucher-hero {
                grid-template-columns: 1fr;
            }

            .admin-stat-grid {
                grid-template-columns: 1fr;
            }

            .admin-table {
                min-width: 780px;
                table-layout: auto;
            }
        }
    </style>
</head>
<body>
<div class="d-flex admin-layout">
    <jsp:include page="/admin/sidebar.jsp">
        <jsp:param name="active" value="vouchers"/>
    </jsp:include>

    <main class="admin-voucher-main flex-grow-1">
        <div class="admin-voucher-shell">
            <section class="admin-voucher-hero">
                <div>
                    <div class="admin-kicker">Le Royal Operations</div>
                    <h1 class="admin-voucher-title">Quáº£n lÃ½ voucher</h1>
                    <p class="admin-voucher-copy">Táº¡o vÃ  theo dÃµi mÃ£ Æ°u Ä‘Ã£i cho tá»•ng hÃ³a Ä‘Æ¡n. Trang nÃ y giá»¯ sá»‘ lÆ°á»£ng, thá»i háº¡n vÃ  tráº¡ng thÃ¡i báº­t/táº¯t Ä‘á»ƒ Ä‘á»™i váº­n hÃ nh kiá»ƒm soÃ¡t khuyáº¿n mÃ£i rÃµ hÆ¡n.</p>
                </div>
                <c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
                    <button type="button" class="admin-primary-action" data-bs-toggle="modal" data-bs-target="#voucherModal">
                        <i class="fa-solid fa-plus"></i>
                        ThÃªm voucher
                    </button>
                </c:if>
            </section>

            <div class="admin-stat-grid">
                <div class="admin-stat">
                    <div class="admin-section-label">Tá»•ng mÃ£</div>
                    <strong>${fn:length(vouchers)}</strong>
                </div>
                <div class="admin-stat">
                    <div class="admin-section-label">Äang theo dÃµi</div>
                    <strong>Manual</strong>
                </div>
                <div class="admin-stat">
                    <div class="admin-section-label">Nguá»“n dÃ¹ng</div>
                    <strong>Invoice</strong>
                </div>
            </div>

            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success admin-alert">${sessionScope.successMessage}</div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger admin-alert">${sessionScope.errorMessage}</div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>

            <section class="admin-panel" aria-labelledby="voucherTableTitle">
                <div class="admin-panel-header">
                    <div>
                        <div class="admin-section-label">Voucher list</div>
                        <h2 id="voucherTableTitle" class="h4 fw-semibold mb-0 mt-1">Danh sÃ¡ch mÃ£ Æ°u Ä‘Ã£i</h2>
                    </div>
                    <span class="voucher-use-tag"><i class="fa-solid fa-ticket me-2"></i>${fn:length(vouchers)} mÃ£</span>
                </div>

                <div class="table-responsive voucher-table-wrap">
                    <table class="table table-hover align-middle admin-table">
                        <thead>
                            <tr>
                                <th class="ps-4">Code</th>
                                <th>Giáº£m giÃ¡</th>
                                <th>Äiá»u kiá»‡n</th>
                                <th>Thá»i háº¡n</th>
                                <th>Sá»‘ lÆ°á»£ng</th>
                                <th>Tráº¡ng thÃ¡i</th>
                                <c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
                                    <th class="text-end pe-4">Thao tÃ¡c</th>
                                </c:if>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${vouchers}" var="v">
                                <tr>
                                    <td class="ps-4">
                                        <div class="voucher-code-cell">
                                            <span class="voucher-code-text">${v.voucherCode}</span>
                                            <span class="voucher-type-tag">${v.voucherType}</span>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="voucher-discount">
                                            <c:choose>
                                                <c:when test="${not empty v.discountPercent}">${v.discountPercent}%</c:when>
                                                <c:otherwise><fmt:formatNumber value="${v.discountAmount}" pattern="#,##0"/>Ä‘</c:otherwise>
                                            </c:choose>
                                        </div>
                                        <c:if test="${not empty v.maxDiscount}">
                                            <div class="voucher-discount-note">Tá»‘i Ä‘a <fmt:formatNumber value="${v.maxDiscount}" pattern="#,##0"/>Ä‘</div>
                                        </c:if>
                                    </td>
                                    <td>
                                        <div class="voucher-condition">HÃ³a Ä‘Æ¡n tá»«</div>
                                        <div class="fw-semibold"><fmt:formatNumber value="${v.minOrderValue}" pattern="#,##0"/>Ä‘</div>
                                    </td>
                                    <td>
                                        <div class="voucher-date"><fmt:formatDate value="${v.validFrom}" pattern="dd/MM/yyyy HH:mm"/></div>
                                        <div class="fw-semibold"><fmt:formatDate value="${v.validTo}" pattern="dd/MM/yyyy HH:mm"/></div>
                                    </td>
                                    <td>
                                        <span class="voucher-use-tag">${v.usedCount}/${v.usageLimit}</span>
                                    </td>
                                    <td>
                                        <span class="voucher-status ${v.isActive ? 'is-on' : 'is-off'}">
                                            ${v.isActive ? 'Äang báº­t' : 'ÄÃ£ táº¯t'}
                                        </span>
                                    </td>
                                    <c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
                                        <td class="text-end pe-4">
                                            <div class="voucher-actions">
                                                <button type="button" class="voucher-icon-btn" title="Sá»­a voucher" data-bs-toggle="modal" data-bs-target="#editVoucher${v.id}">
                                                    <i class="fa-solid fa-pen"></i>
                                                </button>
                                                <form method="post" action="${pageContext.request.contextPath}/admin/vouchers" class="d-inline">
                                                    <input type="hidden" name="action" value="toggle">
                                                    <input type="hidden" name="id" value="${v.id}">
                                                    <button type="submit" class="voucher-icon-btn" title="${v.isActive ? 'Táº¯t voucher' : 'Báº­t voucher'}">
                                                        <i class="fa-solid fa-power-off"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </c:if>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty vouchers}">
                                <tr>
                                    <td colspan="${sessionScope.currentUser.role == 'ADMIN' ? 7 : 6}" class="voucher-empty-row">
                                        <i class="fa-solid fa-ticket"></i>
                                        ChÆ°a cÃ³ voucher. Táº¡o mÃ£ Ä‘áº§u tiÃªn Ä‘á»ƒ báº¯t Ä‘áº§u quáº£n lÃ½ Æ°u Ä‘Ã£i.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </section>
        </div>
    </main>
</div>

<c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
<div class="modal fade admin-modal" id="voucherModal" tabindex="-1" aria-labelledby="voucherModalTitle" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <form method="post" action="${pageContext.request.contextPath}/admin/vouchers">
                <input type="hidden" name="action" value="save">
                <input type="hidden" name="isActive" value="true">
                <input type="hidden" name="usedCount" value="0">
                <div class="modal-header">
                    <div>
                        <div class="admin-kicker">New privilege</div>
                        <h5 id="voucherModalTitle" class="admin-modal-title modal-title mb-0">ThÃªm voucher</h5>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="ÄÃ³ng"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label">MÃ£ voucher</label>
                            <input name="voucherCode" class="form-control" placeholder="ROYAL10" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Loáº¡i</label>
                            <select name="voucherType" class="form-select">
                                <c:forEach items="${voucherTypes}" var="t"><option value="${t}">${t}</option></c:forEach>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Sá»‘ lÆ°á»£ng</label>
                            <input type="number" name="usageLimit" class="form-control" min="1" value="1" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Giáº£m %</label>
                            <input type="number" step="0.01" name="discountPercent" class="form-control" placeholder="10">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Giáº£m tiá»n</label>
                            <input type="number" step="1000" name="discountAmount" class="form-control" placeholder="50000">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">ÄÆ¡n tá»‘i thiá»ƒu</label>
                            <input type="number" step="1000" name="minOrderValue" value="0" class="form-control">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Giáº£m tá»‘i Ä‘a</label>
                            <input type="number" step="1000" name="maxDiscount" class="form-control" placeholder="200000">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Tá»« ngÃ y</label>
                            <input type="datetime-local" name="validFrom" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Äáº¿n ngÃ y</label>
                            <input type="datetime-local" name="validTo" class="form-control" required>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Há»§y</button>
                    <button type="submit" class="admin-primary-action">Táº¡o voucher</button>
                </div>
            </form>
        </div>
    </div>
</div>
</c:if>

<c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
<c:forEach items="${vouchers}" var="v">
    <div class="modal fade admin-modal" id="editVoucher${v.id}" tabindex="-1" aria-labelledby="editVoucherTitle${v.id}" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <form method="post" action="${pageContext.request.contextPath}/admin/vouchers">
                    <input type="hidden" name="action" value="save">
                    <input type="hidden" name="id" value="${v.id}">
                    <input type="hidden" name="usedCount" value="${v.usedCount}">
                    <div class="modal-header">
                        <div>
                            <div class="admin-kicker">Edit privilege</div>
                            <h5 id="editVoucherTitle${v.id}" class="admin-modal-title modal-title mb-0">Sá»­a ${v.voucherCode}</h5>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="ÄÃ³ng"></button>
                    </div>
                    <div class="modal-body p-4">
                        <jsp:include page="/admin/voucher-form-fields.jsp">
                            <jsp:param name="prefix" value="${v.id}"/>
                        </jsp:include>
                    </div>
                    <script>
                        window['voucherData${v.id}'] = {
                            code: '${v.voucherCode}',
                            type: '${v.voucherType}',
                            percent: '${v.discountPercent}',
                            amount: '${v.discountAmount}',
                            min: '${v.minOrderValue}',
                            max: '${v.maxDiscount}',
                            limit: '${v.usageLimit}',
                            active: '${v.isActive}',
                            from: '<fmt:formatDate value="${v.validFrom}" pattern="yyyy-MM-dd'T'HH:mm"/>',
                            to: '<fmt:formatDate value="${v.validTo}" pattern="yyyy-MM-dd'T'HH:mm"/>'
                        };
                    </script>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Há»§y</button>
                        <button type="submit" class="admin-primary-action">LÆ°u thay Ä‘á»•i</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</c:forEach>
</c:if>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
document.querySelectorAll('[id^="editVoucher"]').forEach(function(modal) {
    modal.addEventListener('show.bs.modal', function() {
        var id = modal.id.replace('editVoucher', '');
        var d = window['voucherData' + id];
        if (!d) {
            return;
        }
        modal.querySelector('[name=voucherCode]').value = d.code;
        modal.querySelector('[name=voucherType]').value = d.type;
        modal.querySelector('[name=discountPercent]').value = d.percent;
        modal.querySelector('[name=discountAmount]').value = d.amount;
        modal.querySelector('[name=minOrderValue]').value = d.min;
        modal.querySelector('[name=maxDiscount]').value = d.max;
        modal.querySelector('[name=usageLimit]').value = d.limit;
        modal.querySelector('[name=isActive]').value = d.active;
        modal.querySelector('[name=validFrom]').value = d.from;
        modal.querySelector('[name=validTo]').value = d.to;
    });
});
</script>
</body>
</html>
