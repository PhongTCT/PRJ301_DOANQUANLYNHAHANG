<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'vi'}" scope="session" />
<fmt:setBundle basename="i18n.messages" scope="session" />

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="booking.title"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        .item-img { width: 100%; height: 100px; object-fit: cover; }
    </style>
</head>
<body class="bg-light pb-5">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
        <div class="container">
            <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/"><i class="fa-solid fa-utensils me-2"></i>Restaurant</a>
        </div>
    </nav>

    <div class="container">
        <!-- Progress Indicator -->
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
                            <!-- FOOD TAB -->
                            <div class="tab-pane fade show active" id="food-pane" role="tabpanel" tabindex="0">
                                <div class="row row-cols-1 row-cols-md-2 g-3">
                                    <c:forEach items="${menuItems}" var="item">
                                        <div class="col">
                                            <div class="card h-100 border-0 shadow-sm rounded-3">
                                                <div class="row g-0">
                                                    <div class="col-4">
                                                        <c:set var="imgUrl" value="${item.imageUrl != null ? item.imageUrl : 'https://images.unsplash.com/photo-1544025162-8315ea07525b?w=300&h=300&fit=crop'}" />
                                                        <img src="${imgUrl}" class="img-fluid rounded-start h-100 object-fit-cover" alt="Food">
                                                    </div>
                                                    <div class="col-8">
                                                        <div class="card-body py-2 px-3">
                                                            <h6 class="card-title fw-bold mb-1 text-truncate">${sessionScope.lang == 'en' ? item.itemNameEn : item.itemName}</h6>
                                                            <p class="card-text small text-muted mb-2 text-truncate" title="${sessionScope.lang == 'en' ? item.descriptionEn : item.description}">${sessionScope.lang == 'en' ? item.descriptionEn : item.description}</p>
                                                            <div class="d-flex justify-content-between align-items-center mt-auto">
                                                                <span class="text-success fw-bold"><fmt:formatNumber value="${item.basePrice}" pattern="#,##0"/>đ</span>
                                                                <button type="button" class="btn btn-sm btn-outline-primary rounded-circle" style="width: 28px; height: 28px; padding: 0;" onclick="addToCart('menu', ${item.id}, this.getAttribute('data-name'), ${item.basePrice})" data-name="${fn:escapeXml(sessionScope.lang == 'en' ? item.itemNameEn : item.itemName)}"><i class="fa-solid fa-plus"></i></button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                            
                            <!-- COMBO TAB -->
                            <div class="tab-pane fade" id="combo-pane" role="tabpanel" tabindex="0">
                                <div class="row row-cols-1 row-cols-md-2 g-3">
                                    <c:forEach items="${menuSets}" var="set">
                                        <div class="col">
                                            <div class="card h-100 border-0 shadow-sm rounded-3">
                                                <div class="row g-0">
                                                    <div class="col-4">
                                                        <c:set var="imgUrl" value="${set.imageUrl != null ? set.imageUrl : 'https://images.unsplash.com/photo-1563379926898-05f4575a45d8?w=300&h=300&fit=crop'}" />
                                                        <img src="${imgUrl}" class="img-fluid rounded-start h-100 object-fit-cover" alt="Combo">
                                                    </div>
                                                    <div class="col-8">
                                                        <div class="card-body py-2 px-3">
                                                            <h6 class="card-title fw-bold mb-1 text-truncate">${set.setName}</h6>
                                                            <p class="card-text small text-muted mb-2 text-truncate" title="${set.description}">${set.description}</p>
                                                            <div class="d-flex justify-content-between align-items-center mt-auto">
                                                                <span class="text-success fw-bold"><fmt:formatNumber value="${set.discountedPrice}" pattern="#,##0"/>đ</span>
                                                                <!-- Note: We treat combo as a pseudo-menu item or addon depending on backend support, assuming addon for now -->
                                                                <button type="button" class="btn btn-sm btn-outline-primary rounded-circle" style="width: 28px; height: 28px; padding: 0;" onclick="addToCart('addon', ${set.id}, this.getAttribute('data-name'), ${set.discountedPrice})" data-name="Set: ${fn:escapeXml(set.setName)}"><i class="fa-solid fa-plus"></i></button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                    <c:if test="${empty menuSets}">
                                        <p class="text-muted w-100 text-center py-4">No combo sets available.</p>
                                    </c:if>
                                </div>
                            </div>
                            
                            <!-- SERVICES TAB -->
                            <div class="tab-pane fade" id="service-pane" role="tabpanel" tabindex="0">
                                <div class="list-group">
                                    <c:forEach items="${addons}" var="addon">
                                        <div class="list-group-item d-flex justify-content-between align-items-center bg-white border-0 shadow-sm rounded-3 mb-2 p-3">
                                            <div>
                                                <strong class="d-block mb-1">${addon.serviceName}</strong>
                                                <span class="d-block small text-muted">${addon.description}</span>
                                            </div>
                                            <div class="text-end">
                                                <span class="fw-bold text-success d-block mb-2"><fmt:formatNumber value="${addon.price}" pattern="#,##0"/>đ</span>
                                                <button type="button" class="btn btn-sm btn-outline-primary" onclick="addToCart('addon', ${addon.id}, this.getAttribute('data-name'), ${addon.price})" data-name="${fn:escapeXml(addon.serviceName)}">Thêm</button>
                                            </div>
                                        </div>
                                    </c:forEach>
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
                            <!-- Cart Items Container -->
                            <ul class="list-group list-group-flush" id="cartItemsList">
                                <li class="list-group-item p-4 text-center text-muted" id="emptyCartMsg">
                                    <i class="fa-solid fa-cart-arrow-down fa-3x mb-3 text-light"></i>
                                    <p class="mb-0">Chưa có món nào được chọn</p>
                                </li>
                            </ul>
                            
                            <!-- Cart Summary -->
                            <ul class="list-group list-group-flush border-top">
                                <li class="list-group-item p-3 bg-light">
                                    <div class="d-flex justify-content-between mb-1">
                                        <span class="text-muted small"><fmt:message key="booking.step3.cart.deposit"/></span>
                                        <span class="fw-medium">Tùy thuộc quy định</span>
                                    </div>
                                </li>
                                <li class="list-group-item p-3">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="fw-bold fs-5"><fmt:message key="booking.step3.cart.total"/></span>
                                        <span class="fw-bold fs-4 text-primary" id="cartTotal">0đ</span>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div class="card-footer bg-white border-0 p-3 rounded-bottom-4">
                            <form action="${pageContext.request.contextPath}/MainController" method="POST" id="bookingForm">
                                <input type="hidden" name="action" value="saveStep3">
                                <!-- Hidden inputs will be injected here by Javascript -->
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
        // Simple tab styling toggle
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

        // Cart Logic
        let cart = {
            menu: {},
            addon: {}
        };

        function addToCart(type, id, name, price) {
            if (!cart[type][id]) {
                cart[type][id] = { name: name, price: price, qty: 1 };
            } else {
                cart[type][id].qty++;
            }
            renderCart();
        }

        function updateQty(type, id, delta) {
            if (cart[type][id]) {
                cart[type][id].qty += delta;
                if (cart[type][id].qty <= 0) {
                    delete cart[type][id];
                }
                renderCart();
            }
        }

        function removeCartItem(type, id) {
            if (cart[type][id]) {
                delete cart[type][id];
                renderCart();
            }
        }

        function formatCurrency(amount) {
            return new Intl.NumberFormat('vi-VN').format(amount) + 'đ';
        }

        function renderCart() {
            const list = document.getElementById('cartItemsList');
            const emptyMsg = document.getElementById('emptyCartMsg');
            let total = 0;
            let hasItems = false;

            // Clear current items (except empty message if it was hidden)
            list.innerHTML = '';

            const renderType = (type, prefixId) => {
                for (let id in cart[type]) {
                    hasItems = true;
                    let item = cart[type][id];
                    total += item.price * item.qty;

                    let li = document.createElement('li');
                    li.className = 'list-group-item p-3';
                    li.innerHTML = `
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <div class="fw-medium text-dark">` + item.name + `</div>
                            <button type="button" class="btn-close btn-sm" style="font-size: 0.6rem;" onclick="removeCartItem('`+type+`', `+id+`)"></button>
                        </div>
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="input-group input-group-sm w-auto">
                                <button class="btn btn-outline-secondary px-2" type="button" onclick="updateQty('`+type+`', `+id+`, -1)"><i class="fa-solid fa-minus"></i></button>
                                <input type="text" class="form-control text-center px-0 fw-bold" value="`+item.qty+`" style="max-width: 40px;" readonly>
                                <button class="btn btn-outline-secondary px-2" type="button" onclick="updateQty('`+type+`', `+id+`, 1)"><i class="fa-solid fa-plus"></i></button>
                            </div>
                            <span class="text-success fw-bold">` + formatCurrency(item.price * item.qty) + `</span>
                        </div>
                    `;
                    list.appendChild(li);
                }
            };

            renderType('menu', 'menuItemId');
            renderType('addon', 'addonId');

            if (!hasItems) {
                list.appendChild(emptyMsg);
                emptyMsg.style.display = 'block';
            }

            document.getElementById('cartTotal').innerText = formatCurrency(total);
        }

        // On Form Submit, inject hidden inputs
        document.getElementById('bookingForm').addEventListener('submit', function(e) {
            // Remove any old dynamic inputs
            document.querySelectorAll('.dynamic-cart-input').forEach(el => el.remove());

            for (let id in cart['menu']) {
                this.insertAdjacentHTML('beforeend', '<input type="hidden" class="dynamic-cart-input" name="menuItemId" value="' + id + '">');
                this.insertAdjacentHTML('beforeend', '<input type="hidden" class="dynamic-cart-input" name="menuItemQty" value="' + cart['menu'][id].qty + '">');
            }
            for (let id in cart['addon']) {
                this.insertAdjacentHTML('beforeend', '<input type="hidden" class="dynamic-cart-input" name="addonId" value="' + id + '">');
                this.insertAdjacentHTML('beforeend', '<input type="hidden" class="dynamic-cart-input" name="addonQty" value="' + cart['addon'][id].qty + '">');
            }
        });
    </script>
</body>
</html>
