<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cau hinh hang - Le Royal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@500;600&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root{--royal-ink:#171410;--royal-muted:#70675b;--royal-gold:#b99a52;--royal-line:#e8dfcf;--royal-paper:#fbfaf7}
        body{margin:0;background:radial-gradient(circle at top right,rgba(185,154,82,.12),transparent 34rem),linear-gradient(180deg,#fbfaf7 0%,#f3efe8 100%);color:var(--royal-ink);font-family:"Inter",Arial,sans-serif}
        .admin-main{min-width:0;padding:2rem}.admin-shell{max-width:1280px;margin:0 auto}
        .admin-hero{display:grid;grid-template-columns:minmax(0,1fr) auto;align-items:end;gap:1.5rem;padding:1.25rem 0 1.5rem}
        .admin-kicker,.admin-section-label,.admin-table thead th{color:#917337;font-size:.72rem;font-weight:800;letter-spacing:.13em!important;text-transform:uppercase}
        .admin-title{margin:.3rem 0 .4rem;font-family:"Cormorant Garamond",Georgia,serif;font-size:clamp(2.6rem,5vw,4.7rem);font-weight:600;line-height:.92}
        .admin-copy{max-width:680px;margin:0;color:var(--royal-muted);line-height:1.7}
        .admin-primary-action{display:inline-flex;align-items:center;justify-content:center;gap:.5rem;min-height:44px;padding:0 1.1rem;border:0;background:var(--royal-ink);color:#fff;font-weight:700;text-decoration:none;transition:transform .22s ease,background-color .22s ease,box-shadow .22s ease}
        .admin-primary-action:hover{background:#2d2618;color:#fff;transform:translateY(-2px);box-shadow:0 .8rem 1.8rem rgba(45,38,24,.16)}
        .admin-alert{border:0;border-left:3px solid currentColor;border-radius:0;box-shadow:0 .8rem 1.8rem rgba(94,77,45,.08)}
        .admin-panel{overflow:hidden;background:rgba(255,255,255,.86);border:1px solid var(--royal-line);box-shadow:0 1rem 2.5rem rgba(94,77,45,.09)}
        .admin-panel-header{display:flex;align-items:center;justify-content:space-between;gap:1rem;padding:1.05rem 1.25rem;border-bottom:1px solid var(--royal-line)}
        .admin-table{margin:0}.admin-table thead th{padding:1rem;background:#f8f3ea;border-bottom:1px solid var(--royal-line);white-space:nowrap}
        .admin-table tbody td{padding:1rem;border-color:#efe6d7;vertical-align:middle}
        .admin-form .form-control,.admin-form .form-select{border-radius:0;border:1px solid #ded4c5;background:#fbfaf7;padding:.6rem .75rem;font-size:.9rem}
        .admin-form .form-control:focus,.admin-form .form-select:focus{border-color:#b99a52;box-shadow:0 0 0 .2rem rgba(185,154,82,.2)}
        .admin-form .form-label{font-size:.82rem;font-weight:700;color:#574f43;margin-bottom:.25rem}
        .admin-form .form-check-input:checked{background-color:#b99a52;border-color:#b99a52}
        .admin-modal .modal-content{border:0;border-radius:0;box-shadow:0 1.5rem 4rem rgba(23,20,16,.18)}
        .admin-modal .modal-header,.admin-modal .modal-footer{border-color:var(--royal-line);background:#fbf7ef}
        .admin-modal-title{font-family:"Cormorant Garamond",Georgia,serif;font-size:2rem;font-weight:600}
        .admin-sidebar{width:260px;min-width:260px;max-width:260px;min-height:100vh;flex:0 0 260px;background:radial-gradient(circle at top left,rgba(185,154,82,.16),transparent 22rem),#171a1d;color:#fff;padding:18px 16px;border-right:1px solid rgba(185,154,82,.22);position:sticky;top:0;align-self:start}.admin-sidebar__brand{min-height:58px;display:flex;align-items:center;margin:8px 2px 26px;color:#fff;font-family:"Cormorant Garamond",Georgia,serif;font-size:1.75rem;font-weight:600;letter-spacing:.04em}.admin-sidebar__link{min-height:44px;color:rgba(255,255,255,.76);text-decoration:none;padding:11px 14px;display:flex;align-items:center;gap:10px;border:1px solid transparent;border-radius:0;margin-bottom:6px;font-weight:600;transition:background-color .22s,color .22s,border-color .22s,transform .22s;white-space:nowrap}.admin-sidebar__link:hover,.admin-sidebar__link.active{background-color:rgba(255,255,255,.08);border-color:rgba(185,154,82,.32);color:#fff;transform:translateX(2px)}.admin-sidebar__link.active{background:linear-gradient(90deg,rgba(185,154,82,.24),rgba(255,255,255,.08));box-shadow:inset 2px 0 0 #b99a52}.admin-sidebar__link i{width:18px;text-align:center;color:#d5bc79}
    </style>
</head>
<body>
<div class="d-flex">
    <jsp:include page="/admin/sidebar.jsp"><jsp:param name="active" value="rank-config"/></jsp:include>
    <main class="admin-main flex-grow-1">
        <div class="admin-shell">
            <section class="admin-hero">
                <div>
                    <div class="admin-kicker">Loyalty Settings</div>
                    <h1 class="admin-title">Cau hinh hang</h1>
                    <p class="admin-copy">Quan ly nguong diem, ty le tich diem, giam gia va quyen VIP/VVIP cho tung hang thanh vien.</p>
                </div>
                <button type="button" class="admin-primary-action" data-bs-toggle="modal" data-bs-target="#rankConfigModal">
                    <i class="fa-solid fa-plus"></i>Them hang
                </button>
            </section>

            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success admin-alert">${sessionScope.successMessage}<c:remove var="successMessage" scope="session"/></div>
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger admin-alert">${sessionScope.errorMessage}<c:remove var="errorMessage" scope="session"/></div>
            </c:if>

            <section class="admin-panel">
                <div class="admin-panel-header">
                    <div><div class="admin-section-label">Rank list</div><h2 class="h4 fw-semibold mb-0 mt-1">Danh sach hang</h2></div>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle admin-table">
                        <thead>
                            <tr><th class="ps-4">Hang</th><th>Nguong diem</th><th>Giam gia</th><th>Tich diem</th><th>VIP</th><th>VVIP</th><th>Trang thai</th><th class="text-end pe-4">Thao tac</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${ranks}" var="r">
                                <tr>
                                    <td class="ps-4 fw-bold">${r.rankName}</td>
                                    <td><fmt:formatNumber value="${r.minPointThreshold}" pattern="#,##0"/> pts</td>
                                    <td>${r.discountPercent}%</td>
                                    <td>${r.pointsPerThousandVnd}pt / 1Kd</td>
                                    <td><c:choose><c:when test="${r.canBookVip}"><i class="fa-solid fa-check text-success"></i></c:when><c:otherwise><i class="fa-solid fa-times text-muted"></i></c:otherwise></c:choose></td>
                                    <td><c:choose><c:when test="${r.canBookVvip}"><i class="fa-solid fa-check text-success"></i></c:when><c:otherwise><i class="fa-solid fa-times text-muted"></i></c:otherwise></c:choose></td>
                                    <td><span class="badge ${r.isActive ? 'bg-success' : 'bg-secondary'} rounded-0">${r.isActive ? 'Active' : 'Inactive'}</span></td>
                                    <td class="text-end pe-4">
                                        <button class="btn btn-sm btn-outline-secondary border rounded-0" data-bs-toggle="modal" data-bs-target="#editRankConfig${r.id}">
                                            <i class="fa-solid fa-pen"></i>Sua
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty ranks}">
                                <tr><td colspan="8" class="text-center text-muted py-5">Chua co cau hinh hang nao.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </section>
        </div>
    </main>
</div>

<div class="modal fade admin-modal" id="rankConfigModal" tabindex="-1" aria-labelledby="rankConfigModalTitle" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <form method="post" action="${pageContext.request.contextPath}/admin/rank-config" class="admin-form">
                <div class="modal-header">
                    <div><div class="admin-kicker">New rank</div><h5 id="rankConfigModalTitle" class="admin-modal-title modal-title mb-0">Them hang</h5></div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Dong"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label">Ten hang</label>
                            <select name="rankName" class="form-select" required>
                                <c:forEach items="${rankNames}" var="rn"><option value="${rn}">${rn}</option></c:forEach>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Nguong diem</label>
                            <input type="number" name="minPointThreshold" class="form-control" min="0" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Giam gia %</label>
                            <input type="number" step="0.01" name="discountPercent" class="form-control" min="0" value="0" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Tich diem / 1Kd</label>
                            <input type="number" name="pointsPerThousandVnd" class="form-control" min="0" value="1" required>
                        </div>
                        <div class="col-md-4 d-flex align-items-end gap-3">
                            <div class="form-check"><input type="checkbox" name="canBookVip" class="form-check-input" value="true" id="newVip"><label class="form-check-label" for="newVip">VIP</label></div>
                            <div class="form-check"><input type="checkbox" name="canBookVvip" class="form-check-input" value="true" id="newVvip"><label class="form-check-label" for="newVvip">VVIP</label></div>
                        </div>
                        <div class="col-md-4 d-flex align-items-end">
                            <div class="form-check"><input type="checkbox" name="isActive" class="form-check-input" value="true" id="newActive" checked><label class="form-check-label" for="newActive">Active</label></div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Huy</button>
                    <button type="submit" class="admin-primary-action">Tao hang</button>
                </div>
            </form>
        </div>
    </div>
</div>

<c:forEach items="${ranks}" var="r">
    <div class="modal fade admin-modal" id="editRankConfig${r.id}" tabindex="-1" aria-labelledby="editRankConfigTitle${r.id}" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <form method="post" action="${pageContext.request.contextPath}/admin/rank-config" class="admin-form">
                    <input type="hidden" name="id" value="${r.id}">
                    <div class="modal-header">
                        <div><div class="admin-kicker">Edit rank</div><h5 id="editRankConfigTitle${r.id}" class="admin-modal-title modal-title mb-0">Sua ${r.rankName}</h5></div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Dong"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label">Nguong diem</label>
                                <input type="number" name="minPointThreshold" class="form-control" value="${r.minPointThreshold}" min="0" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Giam gia %</label>
                                <input type="number" step="0.01" name="discountPercent" class="form-control" value="${r.discountPercent}" min="0" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Tich diem / 1Kd</label>
                                <input type="number" name="pointsPerThousandVnd" class="form-control" value="${r.pointsPerThousandVnd}" min="0" required>
                            </div>
                            <div class="col-md-4 d-flex align-items-end gap-3">
                                <div class="form-check"><input type="checkbox" name="canBookVip" class="form-check-input" value="true" id="editVip${r.id}" ${r.canBookVip ? 'checked' : ''}><label class="form-check-label" for="editVip${r.id}">VIP</label></div>
                                <div class="form-check"><input type="checkbox" name="canBookVvip" class="form-check-input" value="true" id="editVvip${r.id}" ${r.canBookVvip ? 'checked' : ''}><label class="form-check-label" for="editVvip${r.id}">VVIP</label></div>
                            </div>
                            <div class="col-md-4 d-flex align-items-end">
                                <div class="form-check"><input type="checkbox" name="isActive" class="form-check-input" value="true" id="editActive${r.id}" ${r.isActive ? 'checked' : ''}><label class="form-check-label" for="editActive${r.id}">Active</label></div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Huy</button>
                        <button type="submit" class="admin-primary-action">Luu thay doi</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</c:forEach>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>