<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="${sessionScope.lang == 'vi' ? 'vi_VN' : 'en_US'}" />
<fmt:setBundle basename="i18n.messages" />
<!DOCTYPE html>
<html lang="${sessionScope.lang == 'en' ? 'en' : 'vi'}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="admin.users.title" /> - Le Royal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Marcellus&family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root{--royal-ink:#171410;--royal-muted:#70675b;--royal-gold:#b99a52;--royal-line:#e8dfcf;--royal-paper:#fbfaf7}
        body{margin:0;background:radial-gradient(circle at top right,rgba(185,154,82,.12),transparent 34rem),linear-gradient(180deg,#fbfaf7 0%,#f3efe8 100%);color:var(--royal-ink);font-family:"Manrope",Arial,sans-serif}
        .admin-main{min-width:0;padding:2rem}.admin-shell{max-width:1280px;margin:0 auto}
        .admin-hero{display:grid;grid-template-columns:minmax(0,1fr) auto;align-items:end;gap:1.5rem;padding:1.25rem 0 1.5rem}
        .admin-kicker,.admin-section-label,.admin-table thead th{color:#917337;font-size:.72rem;font-weight:800;letter-spacing:.13em!important;text-transform:uppercase}
        .admin-title{margin:.3rem 0 .4rem;font-family:"Marcellus",Georgia,serif;font-size:clamp(2.6rem,5vw,4.7rem);font-weight:600;line-height:.92}
        .admin-copy{max-width:680px;margin:0;color:var(--royal-muted);line-height:1.7}
        .admin-alert{border:0;border-left:3px solid currentColor;border-radius:0;box-shadow:0 .8rem 1.8rem rgba(94,77,45,.08)}
        .admin-panel{overflow:hidden;background:rgba(255,255,255,.86);border:1px solid var(--royal-line);box-shadow:0 1rem 2.5rem rgba(94,77,45,.09)}
        .admin-panel-header{display:flex;align-items:center;justify-content:space-between;gap:1rem;padding:1.05rem 1.25rem;border-bottom:1px solid var(--royal-line)}
        .admin-panel-footer{padding:.75rem 1.25rem;border-top:1px solid var(--royal-line);background:#f8f3ea;font-size:.82rem}
        .admin-table{margin:0}.admin-table thead th{padding:1rem;background:#f8f3ea;border-bottom:1px solid var(--royal-line);white-space:nowrap}
        .admin-table tbody td{padding:1rem;border-color:#efe6d7;vertical-align:middle}
        .admin-table tbody tr:last-child td{border-bottom:0}
        .admin-form .form-control,.admin-form .form-select,.admin-form .input-group-text{border-radius:0;border:1px solid #ded4c5;background:#fbfaf7;padding:.6rem .75rem;font-size:.9rem}
        .admin-form .form-control:focus,.admin-form .form-select:focus{border-color:#b99a52;box-shadow:0 0 0 .2rem rgba(185,154,82,.2)}
        .admin-search{max-width:340px}.admin-search .input-group-text{background:#fbfaf7;border-right:0;color:#917337;padding:.6rem .75rem}
        .admin-search .form-control{border-left:0;padding-left:0}.admin-search .form-control:focus+.input-group-text,.admin-search .form-control:focus{border-color:#b99a52;box-shadow:0 0 0 .2rem rgba(185,154,82,.2)}
        .badge-role{font-weight:700;letter-spacing:.04em;padding:.25em .65em;border-radius:0}
        .admin-actions .dropdown-toggle{border-radius:0;border-color:#ded4c5;font-size:.82rem;padding:.3rem .7rem}
        .admin-actions .dropdown-menu{border-radius:0;border-color:var(--royal-line);box-shadow:0 .5rem 1.5rem rgba(23,20,16,.12);padding:.25rem}
        .admin-actions .dropdown-item{padding:.5rem .85rem;font-size:.85rem}
        .admin-actions .dropdown-item:hover{background:#f8f3ea}
        .admin-modal .modal-content{border:0;border-radius:0;box-shadow:0 1.5rem 4rem rgba(23,20,16,.18)}
        .admin-modal .modal-header,.admin-modal .modal-footer{border-color:var(--royal-line);background:#fbf7ef}
        .admin-modal-title{font-family:"Marcellus",Georgia,serif;font-size:2rem;font-weight:600}
        .admin-stats{display:flex;gap:1.5rem;flex-wrap:wrap;padding:.25rem 0 .75rem}
        .admin-stat{font-size:.85rem;color:var(--royal-muted)}.admin-stat strong{color:var(--royal-ink);font-weight:700}
        .admin-empty{text-align:center;padding:3rem 1rem;color:var(--royal-muted);font-size:.9rem}
        .admin-empty i{font-size:2.5rem;color:#d4c9b9;margin-bottom:.75rem}
        .admin-sidebar{width:260px;min-width:260px;max-width:260px;min-height:100vh;flex:0 0 260px;background:radial-gradient(circle at top left,rgba(185,154,82,.16),transparent 22rem),#171a1d;color:#fff;padding:18px 16px;border-right:1px solid rgba(185,154,82,.22);position:sticky;top:0;align-self:start}.admin-sidebar__brand{min-height:58px;display:flex;align-items:center;margin:8px 2px 26px;color:#fff;font-family:"Marcellus",Georgia,serif;font-size:1.75rem;font-weight:600;letter-spacing:.04em}.admin-sidebar__link{min-height:44px;color:rgba(255,255,255,.76);text-decoration:none;padding:11px 14px;display:flex;align-items:center;gap:10px;border:1px solid transparent;border-radius:0;margin-bottom:6px;font-weight:600;transition:background-color .22s,color .22s,border-color .22s,transform .22s;white-space:nowrap}.admin-sidebar__link:hover,.admin-sidebar__link.active{background-color:rgba(255,255,255,.08);border-color:rgba(185,154,82,.32);color:#fff;transform:translateX(2px)}.admin-sidebar__link.active{background:linear-gradient(90deg,rgba(185,154,82,.24),rgba(255,255,255,.08));box-shadow:inset 2px 0 0 #b99a52}.admin-sidebar__link i{width:18px;text-align:center;color:#d5bc79}
    </style>
</head>
<body>
<div class="d-flex">
    <jsp:include page="/admin/sidebar.jsp"><jsp:param name="active" value="users"/></jsp:include>
    <main class="admin-main flex-grow-1">
        <div class="admin-shell">
            <section class="admin-hero">
                <div>
                    <div class="admin-kicker"><fmt:message key="admin.users.title" /></div>
                    <h1 class="admin-title"><fmt:message key="admin.users.list" /></h1>
                    <c:choose>
                        <c:when test="${isAdmin}">
                            <p class="admin-copy"><fmt:message key="admin.users.desc" /></p>
                        </c:when>
                        <c:otherwise>
                            <p class="admin-copy"><fmt:message key="admin.users.desc.view" /></p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>

            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success admin-alert">${sessionScope.successMessage}<c:remove var="successMessage" scope="session"/></div>
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger admin-alert">${sessionScope.errorMessage}<c:remove var="errorMessage" scope="session"/></div>
            </c:if>

            <section class="admin-panel">
                <div class="admin-panel-header">
                    <div>
                        <div class="admin-section-label"><fmt:message key="admin.users.list" /></div>
                        <h2 class="h4 fw-semibold mb-0 mt-1"><fmt:message key="admin.users.list.sub" /> <span class="text-secondary fw-normal fs-6">(${fn:length(users)} <fmt:message key="admin.users.records" />)</span></h2>
                    </div>
                    <c:if test="${isAdmin || isStaff}">
                        <button class="btn btn-dark btn-sm" style="border-radius:0" data-bs-toggle="modal" data-bs-target="#addUserModal">
                            <i class="fa-solid fa-plus me-1"></i><fmt:message key="admin.users.add" />
                        </button>
                    </c:if>
                </div>

                <div class="p-3 pb-0">
                    <form method="GET" action="${pageContext.request.contextPath}/admin/users" class="admin-form d-flex align-items-center gap-2 admin-search">
                        <div class="input-group">
                            <span class="input-group-text"><i class="fa-solid fa-search"></i></span>
                            <input type="text" name="keyword" class="form-control" placeholder="<fmt:message key="admin.users.search" />" value="${keyword}">
                        </div>
                        <c:if test="${not empty keyword}">
                            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-sm btn-outline-secondary" style="border-radius:0;border-color:#ded4c5"><fmt:message key="admin.users.clear" /></a>
                        </c:if>
                    </form>
                    <div class="admin-stats">
                        <span class="admin-stat"><strong>${fn:length(users)} <fmt:message key="admin.users.records" /></strong></span>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle admin-table">
                        <thead>
                            <tr>
                                <th class="ps-4"><fmt:message key="admin.users.col.id" /></th>
                                <th><fmt:message key="admin.users.col.username" /></th>
                                <th><fmt:message key="admin.users.col.fullname" /></th>
                                <th><fmt:message key="admin.users.col.email" /></th>
                                <th><fmt:message key="admin.users.col.phone" /></th>
                                <th><fmt:message key="admin.users.col.role" /></th>
                                <th><fmt:message key="admin.users.col.status" /></th>
                                <th class="text-end pe-4"><fmt:message key="admin.users.col.actions" /></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="u" items="${users}">
                                <tr>
                                    <td class="ps-4 text-secondary">${u.id}</td>
                                    <td class="fw-medium">${u.username}</td>
                                    <td>${u.fullName}</td>
                                    <td>${u.email}</td>
                                    <td>${u.phone != null ? u.phone : '-'}</td>
                                    <td>
                                        <span class="badge badge-role
                                            ${u.role == 'ADMIN' ? 'bg-dark' : u.role == 'STAFF' ? 'bg-warning text-dark' : 'bg-secondary'}">${u.role}</span>
                                    </td>
                                    <td>
                                        <span class="badge badge-role
                                            ${u.status == 'ACTIVE' ? 'bg-success' : u.status == 'BANNED' ? 'bg-dark' : 'bg-warning text-dark'}">${u.status}</span>
                                    </td>
                                    <td class="text-end pe-4 admin-actions">
                                        <c:choose>
                                            <c:when test="${isAdmin}">
                                                <div class="dropdown d-inline-block">
                                                    <button class="btn btn-sm dropdown-toggle admin-actions-dropdown" type="button" data-bs-toggle="dropdown">
                                                        <i class="fa-solid fa-ellipsis-vertical"></i>
                                                    </button>
                                                    <ul class="dropdown-menu dropdown-menu-end shadow-sm">
                                                        <c:if test="${u.role != 'ADMIN'}">
                                                            <c:choose>
                                                                <c:when test="${u.status == 'ACTIVE'}">
                                                                    <li><button class="dropdown-item text-danger" data-bs-toggle="modal" data-bs-target="#banModal${u.id}"><i class="fa-solid fa-ban me-2"></i><fmt:message key="admin.users.btn.ban" /></button></li>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <li>
                                                                        <form method="POST" action="${pageContext.request.contextPath}/admin/users" class="d-inline">
                                                                            <input type="hidden" name="action" value="unban">
                                                                            <input type="hidden" name="userId" value="${u.id}">
                                                                            <input type="hidden" name="keyword" value="${keyword}">
                                                                            <button class="dropdown-item text-success"><i class="fa-solid fa-check me-2"></i><fmt:message key="admin.users.btn.unban" /></button>
                                                                        </form>
                                                                    </li>
                                                                </c:otherwise>
                                                            </c:choose>
                                                            <li><hr class="dropdown-divider"></li>
                                                            <li>
                                                                <form method="POST" action="${pageContext.request.contextPath}/admin/users" class="d-inline">
                                                                    <input type="hidden" name="action" value="changeRole">
                                                                    <input type="hidden" name="userId" value="${u.id}">
                                                                    <input type="hidden" name="keyword" value="${keyword}">
                                                                    <select name="role" class="dropdown-item border-0 bg-transparent" onchange="this.form.submit()" style="padding:.5rem .85rem;font-size:inherit">
                                                                        <option value="" disabled selected><fmt:message key="admin.users.btn.changerole" /></option>
                                                                        <option value="CUSTOMER"><fmt:message key="admin.users.role.customer" /></option>
                                                                        <option value="STAFF"><fmt:message key="admin.users.role.staff" /></option>
                                                                    </select>
                                                                </form>
                                                            </li>
                                                            <li><hr class="dropdown-divider"></li>
                                                            <li>
                                                                <form method="POST" action="${pageContext.request.contextPath}/admin/users" class="d-inline" onsubmit="var p=prompt('<fmt:message key="admin.users.btn.resetpw" />:');if(p){this.querySelector('[name=newPassword]').value=p;return true}return false">
                                                                    <input type="hidden" name="action" value="resetPassword">
                                                                    <input type="hidden" name="userId" value="${u.id}">
                                                                    <input type="hidden" name="keyword" value="${keyword}">
                                                                    <input type="hidden" name="newPassword" value="">
                                                                    <button class="dropdown-item"><i class="fa-solid fa-key me-2"></i><fmt:message key="admin.users.btn.resetpw" /></button>
                                                                </form>
                                                            </li>
                                                        </c:if>
                                                        <c:if test="${u.role == 'ADMIN'}">
                                                            <li><span class="dropdown-item text-secondary disabled"><i class="fa-solid fa-lock me-2"></i><fmt:message key="admin.users.protected" /></span></li>
                                                        </c:if>
                                                    </ul>
                                                </div>

                                                <c:if test="${u.role != 'ADMIN' && u.status == 'ACTIVE'}">
                                                    <div class="modal fade admin-modal" id="banModal${u.id}" tabindex="-1">
                                                        <div class="modal-dialog modal-sm modal-dialog-centered">
                                                            <div class="modal-content">
                                                                <div class="modal-body text-center py-4">
                                                                    <i class="fa-solid fa-ban text-danger fs-3 mb-3"></i>
                                                                    <h5 class="fw-bold mb-2"><fmt:message key="admin.users.modal.ban.title" /></h5>
                                                                    <p class="small text-secondary mb-0"><fmt:message key="admin.users.modal.ban.desc"><fmt:param value="${u.username}"/></fmt:message></p>
                                                                </div>
                                                                <div class="modal-footer border-0 justify-content-center pt-0">
                                                                    <form method="POST" action="${pageContext.request.contextPath}/admin/users">
                                                                        <input type="hidden" name="action" value="ban">
                                                                        <input type="hidden" name="userId" value="${u.id}">
                                                                        <input type="hidden" name="keyword" value="${keyword}">
                                                                        <button type="button" class="btn btn-light border" data-bs-dismiss="modal" style="border-radius:0"><fmt:message key="admin.users.modal.ban.cancel" /></button>
                                                                        <button type="submit" class="btn btn-dark" style="border-radius:0"><fmt:message key="admin.users.modal.ban.confirm" /></button>
                                                                    </form>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-secondary small"><fmt:message key="admin.users.viewonly" /></span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty users}">
                                <tr>
                                    <td colspan="8">
                                        <div class="admin-empty">
                                            <i class="fa-regular fa-user"></i>
                                            <p class="mb-0"><fmt:message key="admin.users.empty" /></p>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <div class="admin-panel-footer d-flex justify-content-between align-items-center">
                    <span>${fn:length(users)} <fmt:message key="admin.users.records" /></span>
                    <c:if test="${not empty keyword and fn:length(users) > 0}">
                        <span><fmt:message key="admin.users.filtered" /> <strong>"${keyword}"</strong></span>
                    </c:if>
                </div>
            </section>
        </div>
    </main>
</div>

<!-- Add User Modal -->
<div class="modal fade admin-modal" id="addUserModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title admin-modal-title" style="font-size:1.5rem"><fmt:message key="admin.users.add.title" /></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="POST" action="${pageContext.request.contextPath}/admin/users" class="admin-form">
                <input type="hidden" name="action" value="create">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-bold"><fmt:message key="admin.users.add.username" /> <span class="text-danger">*</span></label>
                        <input type="text" name="username" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold"><fmt:message key="admin.users.add.email" /> <span class="text-danger">*</span></label>
                        <input type="email" name="email" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold"><fmt:message key="admin.users.add.password" /> <span class="text-danger">*</span></label>
                        <input type="password" name="password" class="form-control" required minlength="6">
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold"><fmt:message key="admin.users.add.fullname" /> <span class="text-danger">*</span></label>
                        <input type="text" name="fullName" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold"><fmt:message key="admin.users.add.phone" /></label>
                        <input type="text" name="phone" class="form-control">
                    </div>
                    <c:if test="${isAdmin}">
                        <div class="mb-3">
                            <label class="form-label small fw-bold"><fmt:message key="admin.users.add.role" /> <span class="text-danger">*</span></label>
                            <select name="role" class="form-select" required>
                                <option value="CUSTOMER"><fmt:message key="admin.users.add.role.customer" /></option>
                                <option value="STAFF"><fmt:message key="admin.users.add.role.staff" /></option>
                                <option value="ADMIN"><fmt:message key="admin.users.add.role.admin" /></option>
                            </select>
                        </div>
                    </c:if>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light border" data-bs-dismiss="modal" style="border-radius:0"><fmt:message key="admin.users.modal.cancel" /></button>
                    <button type="submit" class="btn btn-dark" style="border-radius:0"><fmt:message key="admin.users.add.submit" /></button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
