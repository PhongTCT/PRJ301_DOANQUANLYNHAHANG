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
        .category-tabs { display: flex; overflow-x: auto; gap: 10px; padding-bottom: 10px; }
        .category-tabs::-webkit-scrollbar { height: 6px; }
        .category-tabs::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 10px; }
        .cat-btn { white-space: nowrap; padding: 8px 16px; border-radius: 20px; border: 1px solid #cbd5e1; background: white; color: #475569; font-weight: 500; transition: all 0.2s; }
        .cat-btn:hover, .cat-btn.active { background: #4F46E5; color: white; border-color: #4F46E5; }
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
                        <div class="category-tabs">
                            <button class="cat-btn active" onclick="filterCategory('ALL', this)">All Items</button>
                            <button class="cat-btn" onclick="filterCategory('combo', this)"><i class="fa-solid fa-layer-group me-1"></i><fmt:message key="booking.step3.tab.combo"/></button>
                            <button class="cat-btn" onclick="filterCategory('1', this)">Khai Vị</button>
                            <button class="cat-btn" onclick="filterCategory('2', this)">Món Chính</button>
                            <button class="cat-btn" onclick="filterCategory('3', this)">Tráng Miệng</button>
                            <button class="cat-btn" onclick="filterCategory('4', this)"><fmt:message key="booking.step3.tab.drink"/></button>
                            <button class="cat-btn" onclick="filterCategory('service', this)"><fmt:message key="booking.step3.tab.service"/></button>
                        </div>
                    </div>
                    
                    <div class="card-body p-4 bg-light bg-opacity-50">
                        <div class="row row-cols-1 row-cols-md-2 g-3" id="menuGrid">
                            
                            <!-- COMBO SETS -->
                            <c:forEach items="${menuSets}" var="set">
                                <div class="col filter-item" data-category="combo">
                                    <div class="card h-100 border-0 shadow-sm rounded-3">
                                        <div class="row g-0 h-100">
                                            <div class="col-4">
                                                <c:set var="imgUrl" value="${set.imageUrl != null ? set.imageUrl : 'https://images.unsplash.com/photo-1563379926898-05f4575a45d8?w=300&h=300&fit=crop'}" />
                                                <img src="${imgUrl}" class="img-fluid rounded-start h-100 object-fit-cover" alt="Combo">
                                            </div>
                                            <div class="col-8">
                                                <div class="card-body py-2 px-3 d-flex flex-column h-100">
                                                    <h6 class="card-title fw-bold mb-1 text-truncate">${set.setName}</h6>
                                                    <p class="card-text small text-muted mb-2 text-truncate" title="${set.description}">${set.description}</p>
                                                    <div class="d-flex justify-content-between align-items-center mt-auto">
                                                        <span class="text-success fw-bold"><fmt:formatNumber value="${set.discountedPrice}" pattern="#,##0"/>đ</span>
                                                        <button type="button" class="btn btn-sm btn-outline-primary rounded-circle" style="width: 28px; height: 28px; padding: 0;" onclick="addToCart('combo', ${set.id}, this.getAttribute('data-name'), ${set.discountedPrice})" data-name="Set: ${fn:escapeXml(set.setName)}"><i class="fa-solid fa-plus"></i></button>

                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>

                            <!-- MENU ITEMS -->
                            <c:forEach items="${menuItems}" var="item">
                                <div class="col filter-item" data-category="${item.category.id}">
                                    <div class="card h-100 border-0 shadow-sm rounded-3">
                                        <div class="row g-0 h-100">
                                            <div class="col-4">
                                                <c:set var="imgUrl" value="${item.imageUrl != null ? item.imageUrl : 'https://images.unsplash.com/photo-1544025162-8315ea07525b?w=300&h=300&fit=crop'}" />
                                                <img src="${imgUrl}" class="img-fluid rounded-start h-100 object-fit-cover" alt="Item">
                                            </div>
                                            <div class="col-8">
                                                <div class="card-body py-2 px-3 d-flex flex-column h-100">
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

                            <!-- SERVICES / ADDONS -->
                            <c:forEach items="${addons}" var="addon">
                                <div class="col filter-item" data-category="service">
                                    <div class="card h-100 border-0 shadow-sm rounded-3">
                                        <div class="row g-0 h-100">
                                            <div class="col-4">
                                                <c:set var="addonImgUrl" value="${addon.imageUrl != null ? addon.imageUrl : 'https://images.unsplash.com/photo-1544025162-8315ea07525b?w=300&h=300&fit=crop'}" />
                                                <img src="${addonImgUrl}" class="img-fluid rounded-start h-100 object-fit-cover" alt="Addon">

                                            </div>
                                            <div class="col-8">
                                                <div class="card-body py-2 px-3 d-flex flex-column h-100">
                                                    <h6 class="card-title fw-bold mb-1 text-truncate">${addon.serviceName}</h6>
                                                    <p class="card-text small text-muted mb-2 text-truncate" title="${addon.description}">${addon.description}</p>
                                                    <div class="d-flex justify-content-between align-items-center mt-auto">
                                                        <span class="text-success fw-bold"><fmt:formatNumber value="${addon.price}" pattern="#,##0"/>đ</span>
                                                        <button type="button" class="btn btn-sm btn-outline-primary rounded-circle" style="width: 28px; height: 28px; padding: 0;" onclick="addToCart('addon', ${addon.id}, this.getAttribute('data-name'), ${addon.price})" data-name="${fn:escapeXml(addon.serviceName)}"><i class="fa-solid fa-plus"></i></button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>

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
                                <c:if test="${sessionScope.bookingDraft.hasSurcharge}">
                                <li class="list-group-item p-3 bg-warning bg-opacity-10 border-warning border-opacity-25">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="fw-medium text-warning-emphasis"><i class="fa-solid fa-bolt me-1"></i>Phụ thu lễ (${sessionScope.bookingDraft.surchargePercent}%)</span>
                                        <span class="fw-bold text-warning-emphasis" id="cartSurcharge">0đ</span>
                                    </div>
                                </li>
                                </c:if>
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

        let surchargePercent = parseFloat("${not empty sessionScope.bookingDraft.surchargePercent ? sessionScope.bookingDraft.surchargePercent : 0}");
        
        // Cart Logic
        let cart = {
            menu: {},
            addon: {},
            combo: {}

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
            let list = document.getElementById('cartItemsList');
            let emptyMsg = document.getElementById('emptyCartMsg');
            let total = 0;
            let hasItems = false;
            
            // clear list except empty message
            Array.from(list.children).forEach(child => {
                if (child.id !== 'emptyCartMsg') child.remove();
            });

            const types = ['combo', 'menu', 'addon'];
            types.forEach(t => {
                for (let id in cart[t]) {
                    hasItems = true;
                    let item = cart[t][id];
                    let lineTotal = item.price * item.qty;
                    total += lineTotal;
                    
                    let li = document.createElement('li');
                    li.className = 'list-group-item px-3 py-2 border-0 border-bottom';
                    li.innerHTML = '<div class="d-flex justify-content-between align-items-center mb-1">' +
                        '<span class="fw-bold small text-truncate" style="max-width: 60%;">' + item.name + '</span>' +
                        '<span class="fw-bold text-success small">' + formatCurrency(lineTotal) + '</span>' +
                        '</div>' +
                        '<div class="d-flex justify-content-between align-items-center">' +
                        '<span class="text-muted small">' + formatCurrency(item.price) + '</span>' +
                        '<div class="btn-group btn-group-sm border rounded">' +
                        '<button type="button" class="btn btn-light px-2" onclick="updateQty(\'' + t + '\', ' + id + ', -1)"><i class="fa-solid fa-minus" style="font-size: 10px;"></i></button>' +
                        '<span class="btn btn-light px-3 fw-bold border-start border-end" style="pointer-events: none;">' + item.qty + '</span>' +
                        '<button type="button" class="btn btn-light px-2" onclick="updateQty(\'' + t + '\', ' + id + ', 1)"><i class="fa-solid fa-plus" style="font-size: 10px;"></i></button>' +
                        '</div>' +
                        '</div>';
                    list.appendChild(li);
                }
            });


            if (!hasItems) {
                list.appendChild(emptyMsg);
                emptyMsg.style.display = 'block';
            } else {
                emptyMsg.style.display = 'none';
            }

            if (surchargePercent > 0) {
                let surchargeAmt = (total * surchargePercent) / 100;
                let cartSurchargeEl = document.getElementById('cartSurcharge');
                if (cartSurchargeEl) cartSurchargeEl.innerText = formatCurrency(surchargeAmt);
                total += surchargeAmt;
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
            for (let id in cart['set']) {
                this.insertAdjacentHTML('beforeend', '<input type="hidden" class="dynamic-cart-input" name="menuSetId" value="' + id + '">');
                this.insertAdjacentHTML('beforeend', '<input type="hidden" class="dynamic-cart-input" name="menuSetQty" value="' + cart['set'][id].qty + '">');
            }
            for (let id in cart['addon']) {
                this.insertAdjacentHTML('beforeend', '<input type="hidden" class="dynamic-cart-input" name="addonId" value="' + id + '">');
                this.insertAdjacentHTML('beforeend', '<input type="hidden" class="dynamic-cart-input" name="addonQty" value="' + cart['addon'][id].qty + '">');
            }
            for (let id in cart['combo']) {
                this.insertAdjacentHTML('beforeend', '<input type="hidden" class="dynamic-cart-input" name="menuSetId" value="' + id + '">');
                this.insertAdjacentHTML('beforeend', '<input type="hidden" class="dynamic-cart-input" name="menuSetQty" value="' + cart['combo'][id].qty + '">');
            }
        });

        // Filter Menu Categories
        function filterCategory(catId, btnEl) {
            document.querySelectorAll('.cat-btn').forEach(b => b.classList.remove('active', 'bg-primary', 'text-white'));
            btnEl.classList.add('active');
            
            document.querySelectorAll('.filter-item').forEach(card => {
                if (catId === 'ALL' || card.dataset.category === catId) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        }
    </script>
</body>
</html>
