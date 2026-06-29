<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'vi'}" scope="session" />
<fmt:setBundle basename="i18n.messages" scope="session" />

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="booking.title"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
        <div class="container">
            <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/"><i class="fa-solid fa-utensils me-2"></i>Restaurant</a>
        </div>
    </nav>

    <div class="container pb-5">
        <div class="row justify-content-center mb-5">
            <div class="col-md-8">
                <div class="position-relative m-4">
                    <div class="progress" style="height: 2px;">
                        <div class="progress-bar" role="progressbar" style="width: 100%;" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100"></div>
                    </div>
                    <a href="MainController?action=booking&step=1" class="position-absolute top-0 start-0 translate-middle btn btn-sm btn-primary rounded-pill" style="width: 2rem; height:2rem;">1</a>
                    <a href="MainController?action=booking&step=2" class="position-absolute top-0 start-50 translate-middle btn btn-sm btn-primary rounded-pill" style="width: 2rem; height:2rem;">2</a>
                    <button type="button" class="position-absolute top-0 start-100 translate-middle btn btn-sm btn-primary rounded-pill" style="width: 2rem; height:2rem;">3</button>
                </div>
                <div class="d-flex justify-content-between text-muted small mt-2">
                    <span class="text-primary"><a href="MainController?action=booking&step=1" class="text-decoration-none text-primary"><fmt:message key="booking.wizard.step1"/></a></span>
                    <span class="text-primary"><a href="MainController?action=booking&step=2" class="text-decoration-none text-primary"><fmt:message key="booking.wizard.step2"/></a></span>
                    <span class="fw-bold text-dark"><fmt:message key="booking.wizard.step3"/></span>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-lg-8">
                <div class="card shadow-sm border-0 rounded-4 mb-4">
                    <div class="card-header bg-white border-bottom-0 pt-4 pb-0 px-4">
                        <ul class="nav nav-tabs border-bottom-0" id="menuTabs" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active fw-bold text-dark border-0 border-bottom border-primary border-3 bg-transparent pb-3" id="food-tab" data-bs-toggle="tab" data-bs-target="#food-pane" type="button" role="tab"><fmt:message key="booking.step3.tab.food"/></button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link text-muted border-0 bg-transparent pb-3" id="combo-tab" data-bs-toggle="tab" data-bs-target="#combo-pane" type="button" role="tab"><fmt:message key="booking.step3.tab.combo"/></button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link text-muted border-0 bg-transparent pb-3" id="service-tab" data-bs-toggle="tab" data-bs-target="#service-pane" type="button" role="tab"><fmt:message key="booking.step3.tab.service"/></button>
                            </li>
                        </ul>
                    </div>
                    
                    <div class="card-body p-4 bg-light bg-opacity-50">
                        <div class="tab-content" id="menuTabContent">
                            <div class="tab-pane fade show active" id="food-pane" role="tabpanel" tabindex="0">
                                <div class="row row-cols-1 row-cols-md-2 g-3">
                                    <div class="col">
                                        <div class="card h-100 border-0 shadow-sm rounded-3">
                                            <div class="row g-0">
                                                <div class="col-4">
                                                    <img src="https://images.unsplash.com/photo-1544025162-8315ea07525b?w=300&h=300&fit=crop" class="img-fluid rounded-start h-100 object-fit-cover" alt="Steak">
                                                </div>
                                                <div class="col-8">
                                                    <div class="card-body py-2 px-3">
                                                        <h6 class="card-title fw-bold mb-1 text-truncate">Bò bít tết thượng hạng</h6>
                                                        <p class="card-text small text-muted mb-2 text-truncate">Kèm sốt tiêu đen và khoai tây</p>
                                                        <div class="d-flex justify-content-between align-items-center mt-auto">
                                                            <span class="text-success fw-bold">450.000đ</span>
                                                            <button class="btn btn-sm btn-outline-primary rounded-circle" style="width: 28px; height: 28px; padding: 0;"><i class="fa-solid fa-plus"></i></button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col">
                                        <div class="card h-100 border-0 shadow-sm rounded-3">
                                            <div class="row g-0">
                                                <div class="col-4">
                                                    <img src="https://images.unsplash.com/photo-1563379926898-05f4575a45d8?w=300&h=300&fit=crop" class="img-fluid rounded-start h-100 object-fit-cover" alt="Wine">
                                                </div>
                                                <div class="col-8">
                                                    <div class="card-body py-2 px-3">
                                                        <h6 class="card-title fw-bold mb-1 text-truncate">Rượu vang đỏ Bordeaux</h6>
                                                        <p class="card-text small text-muted mb-2 text-truncate">Nhập khẩu từ Pháp</p>
                                                        <div class="d-flex justify-content-between align-items-center mt-auto">
                                                            <span class="text-success fw-bold">1.250.000đ</span>
                                                            <button class="btn btn-sm btn-outline-primary rounded-circle" style="width: 28px; height: 28px; padding: 0;"><i class="fa-solid fa-plus"></i></button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="tab-pane fade" id="combo-pane" role="tabpanel" tabindex="0">
                                <p class="text-muted text-center py-5"><fmt:message key="booking.step3.loading"/></p>
                            </div>
                            
                            <div class="tab-pane fade" id="service-pane" role="tabpanel" tabindex="0">
                                <div class="list-group">
                                    <label class="list-group-item d-flex gap-3 bg-white border-0 shadow-sm rounded-3 mb-2 p-3">
                                        <input class="form-check-input flex-shrink-0" type="checkbox" value="" style="font-size: 1.375em;">
                                        <span class="pt-1 form-checked-content w-100">
                                            <strong class="d-block mb-1">Trang trí sinh nhật cơ bản</strong>
                                            <span class="d-block small text-muted mb-2">Bong bóng, nến và bảng tên</span>
                                            <span class="fw-bold text-success">200.000đ</span>
                                        </span>
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-4">
                <div class="position-sticky" style="top: 2rem;">
                    <div class="card shadow border-0 rounded-4">
                        <div class="card-header bg-primary text-white border-0 py-3 rounded-top-4">
                            <h5 class="fw-bold mb-0"><i class="fa-solid fa-basket-shopping me-2"></i><fmt:message key="booking.step3.cart.title"/></h5>
                        </div>
                        <div class="card-body p-0">
                            <ul class="list-group list-group-flush">
                                <li class="list-group-item p-3">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <div class="fw-medium text-dark">Bò bít tết thượng hạng</div>
                                        <button type="button" class="btn-close btn-sm" style="font-size: 0.6rem;"></button>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div class="input-group input-group-sm w-auto">
                                            <button class="btn btn-outline-secondary px-2" type="button"><i class="fa-solid fa-minus"></i></button>
                                            <input type="text" class="form-control text-center px-0" value="2" style="max-width: 40px;" readonly>
                                            <button class="btn btn-outline-secondary px-2" type="button"><i class="fa-solid fa-plus"></i></button>
                                        </div>
                                        <span class="text-success fw-bold">900.000đ</span>
                                    </div>
                                </li>
                                <li class="list-group-item p-3 bg-light">
                                    <div class="d-flex justify-content-between mb-1">
                                        <span class="text-muted small"><fmt:message key="booking.step3.cart.deposit"/></span>
                                        <span class="fw-medium">500.000đ</span>
                                    </div>
                                    <div class="d-flex justify-content-between mb-1">
                                        <span class="text-muted small"><fmt:message key="booking.step3.cart.vat"/></span>
                                        <span class="fw-medium">72.000đ</span>
                                    </div>
                                </li>
                                <li class="list-group-item p-3">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="fw-bold fs-5"><fmt:message key="booking.step3.cart.total"/></span>
                                        <span class="fw-bold fs-4 text-primary">1.472.000đ</span>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div class="card-footer bg-white border-0 p-3 rounded-bottom-4">
                            <form action="${pageContext.request.contextPath}/MainController" method="POST">
                                <input type="hidden" name="action" value="saveStep3">
                                <button type="submit" class="btn btn-primary btn-lg w-100 rounded-pill fw-bold shadow-sm">
                                    <fmt:message key="booking.btn.finish"/> <i class="fa-solid fa-check ms-2"></i>
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.querySelectorAll('button[data-bs-toggle="tab"]').forEach(tab => {
            tab.addEventListener('shown.bs.tab', event => {
                document.querySelectorAll('button[data-bs-toggle="tab"]').forEach(t => {
                    t.classList.remove('text-dark', 'fw-bold', 'border-bottom', 'border-primary', 'border-3');
                    t.classList.add('text-muted', 'border-0');
                });
                event.target.classList.remove('text-muted', 'border-0');
                event.target.classList.add('text-dark', 'fw-bold', 'border-bottom', 'border-primary', 'border-3');
            });
        });
    </script>
</body>
</html>
