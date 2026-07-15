<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'en'}" scope="session" />
<fmt:setBundle basename="i18n.messages" scope="session" />

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="booking.title"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Marcellus&family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/minimal.css">
    <link href="${pageContext.request.contextPath}/assets/css/admin-royal.css" rel="stylesheet">
</head>
<body class="bg-light pb-5 admin-royal">
    <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom shadow-sm sticky-top mb-4">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center gap-3" href="${pageContext.request.contextPath}/MainController?action=home">
                <span class="brand-emblem" aria-hidden="true">
                    <svg class="brand-symbol" viewBox="0 0 64 64" focusable="false">
                        <path class="brand-symbol-l" d="M25 10V54H43" />
                        <path class="brand-symbol-r" d="M33 14C46 10 54 17 53 28C52 38 41 41 33 34" />
                        <path class="brand-symbol-r" d="M35 37C44 41 50 48 53 56" />
                    </svg>
                </span>
                <span class="brand-text">Le Royal</span>
            </a>
        </div>
    </nav>

    <div class="container">
        <!-- Progress Indicator -->
        <div class="row justify-content-center mb-5">
            <div class="col-md-8">
                <div class="position-relative m-4">
                    <div class="progress" style="height: 2px;">
                        <div class="progress-bar" role="progressbar" style="width: 75%;" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100"></div>
                    </div>
                    <a href="MainController?action=booking&step=1" class="position-absolute top-0 start-0 translate-middle btn btn-sm btn-primary rounded-pill" style="width: 2rem; height:2rem;">1</a>
                    <button type="button" class="position-absolute top-0 start-50 translate-middle btn btn-sm btn-primary rounded-pill" style="width: 2rem; height:2rem;">2</button>
                    <button type="button" class="position-absolute top-0 start-100 translate-middle btn btn-sm btn-secondary rounded-pill" style="width: 2rem; height:2rem;">3</button>
                </div>
                <div class="d-flex justify-content-between text-muted small mt-2">
                    <span class="text-primary"><a href="MainController?action=booking&step=1" class="text-decoration-none text-primary"><fmt:message key="booking.wizard.step1"/></a></span>
                    <span class="fw-bold text-dark"><fmt:message key="booking.wizard.step2"/></span>
                    <span><fmt:message key="booking.wizard.step3"/></span>
                </div>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                <i class="fa-solid fa-circle-exclamation me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        
        <c:if test="${not empty pageError}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                <i class="fa-solid fa-circle-exclamation me-2"></i><strong>Lỗi trang:</strong> ${pageError}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <c:if test="${not empty sessionScope.surchargeWarning}">
            <div class="alert alert-warning alert-dismissible fade show shadow-sm" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i><strong>Lưu ý Phụ thu:</strong> ${sessionScope.surchargeWarning}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <h3 class="fw-bold mb-1"><i class="fa-solid fa-chair text-primary me-2"></i><fmt:message key="booking.step2.title"/></h3>
                <p class="text-muted mb-0 small">
                    <fmt:message key="booking.step2.desc">
                        <fmt:param value="${sessionScope.bookingDraft.adultsCount + sessionScope.bookingDraft.childrenCount}"/>
                    </fmt:message>
                </p>
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/MainController" method="POST">
            <input type="hidden" name="action" value="selectTable">
            
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4 mb-5">
                <c:forEach items="${tables}" var="tb">
                    <c:set var="isAvail" value="true" />
                    <c:set var="tableImgUrl" value="${empty tb.imageUrl ? 'assets/img/le-royal/seating/dining-room.jpg' : tb.imageUrl}" />
                    <c:set var="roomType" value="${tb.room.roomType}" />
                    
                    <div class="col">
                        <div class="card h-100 shadow-sm border-0 rounded-4 bg-white">
                            <div class="position-relative">
                                <c:choose>
                                    <c:when test="${fn:startsWith(tableImgUrl, 'http') || fn:startsWith(tableImgUrl, '/')}">
                                        <img src="${tableImgUrl}" class="card-img-top rounded-top-4" alt="${tb.tableCode}" style="height: 160px; object-fit: cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/${tableImgUrl}" class="card-img-top rounded-top-4" alt="${tb.tableCode}" style="height: 160px; object-fit: cover;">
                                    </c:otherwise>
                                </c:choose>
                                <span class="badge bg-success position-absolute top-0 end-0 m-2">
                                    <fmt:message key="booking.status.available"/>
                                </span>
                            </div>
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h5 class="card-title fw-bold mb-0"><fmt:message key="admin.tables.col.table" /> ${tb.tableCode}</h5>
                                </div>
                                <h6 class="card-subtitle mb-3 text-muted small"><i class="fa-solid fa-map-location-dot me-1"></i>${tb.room.roomName}</h6>
                                
                                <ul class="list-group list-group-flush small mb-3">
                                    <li class="list-group-item px-0 d-flex justify-content-between align-items-center bg-transparent border-0 py-1">
                                        <span class="text-muted"><i class="fa-solid fa-crown me-2"></i><fmt:message key="booking.membership"/></span>
                                        <c:choose>
                                            <c:when test="${roomType == 'VIP'}">
                                                <span class="badge text-bg-warning"><fmt:message key="booking.membership.vip"/></span>
                                            </c:when>
                                            <c:when test="${roomType == 'VVIP'}">
                                                <span class="badge text-bg-dark"><fmt:message key="booking.membership.vvip"/></span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge text-bg-light border"><fmt:message key="booking.membership.all"/></span>
                                            </c:otherwise>
                                        </c:choose>
                                    </li>
                                    <li class="list-group-item px-0 d-flex justify-content-between align-items-center bg-transparent border-0 py-1">
                                        <span class="text-muted"><i class="fa-solid fa-users me-2"></i><fmt:message key="booking.capacity"/></span>
                                        <span class="fw-medium">${tb.capacity} <fmt:message key="spaces.guests"/></span>
                                    </li>
                                    <li class="list-group-item px-0 d-flex justify-content-between align-items-center bg-transparent border-0 py-1">
                                        <span class="text-muted"><i class="fa-solid fa-tag me-2"></i><fmt:message key="booking.baseprice"/></span>
                                        <span class="fw-bold text-success"><fmt:formatNumber value="${tb.bookingFee}" pattern="#,##0"/> đ</span>
                                    </li>
                                </ul>
                            </div>
                            <div class="card-footer bg-transparent border-0 p-3 pt-0 text-center">
                                <input type="checkbox" class="btn-check table-checkbox" id="table_${tb.id}" name="tableId" value="${tb.id}" data-capacity="${tb.capacity}">
                                <label class="btn btn-outline-primary w-100 rounded-pill fw-medium" for="table_${tb.id}"><fmt:message key="booking.table.select"/></label>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
            
            <nav class="navbar fixed-bottom bg-white border-top shadow-lg p-3">
                <div class="container d-flex justify-content-between align-items-center">
                    <div>
                        <span class="text-muted small d-block mb-1"><fmt:message key="booking.capacity.total"/>: <strong id="selectedCapacity" class="text-dark fs-6">0</strong> / ${sessionScope.bookingDraft.adultsCount + sessionScope.bookingDraft.childrenCount} <fmt:message key="spaces.guests"/></span>
                        <span class="text-primary fw-bold" id="selectedCountText">0</span>
                    </div>
                    <div>
                        <a href="MainController?action=booking&step=1" class="btn btn-light border px-4 rounded-pill me-2"><fmt:message key="booking.btn.back"/></a>
                        <button type="submit" class="btn btn-primary px-4 rounded-pill fw-bold shadow-sm" id="btnNext" disabled><fmt:message key="booking.btn.nextMenu"/> <i class="fa-solid fa-arrow-right ms-2"></i></button>
                    </div>
                </div>
            </nav>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const checkboxes = document.querySelectorAll('.table-checkbox');
            const capacityDisplay = document.getElementById('selectedCapacity');
            const countDisplay = document.getElementById('selectedCountText');
            const btnNext = document.getElementById('btnNext');
            
            // Lấy mẫu chuỗi text từ resource bundle cho javascript (fallback)
            const countTemplate = '<fmt:message key="booking.table.count"><fmt:param value="COUNT_PLACEHOLDER"/></fmt:message>';
            const requiredCapacity = parseInt('${sessionScope.bookingDraft.adultsCount + sessionScope.bookingDraft.childrenCount}') || 0;
            
            function updateSelection() {
                let totalCap = 0;
                let count = 0;
                checkboxes.forEach(cb => {
                    if (cb.checked) {
                        totalCap += parseInt(cb.getAttribute('data-capacity') || 0);
                        count++;
                        cb.closest('.card').classList.add('border-primary', 'shadow');
                        cb.closest('.card').classList.remove('border-0', 'shadow-sm');
                    } else {
                        cb.closest('.card').classList.remove('border-primary', 'shadow');
                        cb.closest('.card').classList.add('border-0', 'shadow-sm');
                    }
                });
                
                capacityDisplay.textContent = totalCap;
                countDisplay.textContent = countTemplate.replace("COUNT_PLACEHOLDER", count);
                
                if (count === 0) {
                    btnNext.disabled = true;
                } else {
                    btnNext.disabled = totalCap < requiredCapacity;
                }
            }
            updateSelection();
            checkboxes.forEach(cb => cb.addEventListener('change', updateSelection));
        });
    </script>
</body>
</html>
