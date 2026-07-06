<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quick Bill POS - Le Royal</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Marcellus&family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; font-family: 'Manrope', sans-serif; overflow-x: hidden; }
        .sidebar { min-height: 100vh; background-color: #1a1d20; color: white; }
        .sidebar a { color: rgba(255,255,255,.7); text-decoration: none; padding: 12px 20px; display: block; border-radius: 8px; margin-bottom: 5px; transition: 0.2s; }
        .sidebar a:hover, .sidebar a.active { background-color: rgba(255,255,255,0.1); color: white; }
        
        .pos-layout { height: 100vh; display: flex; flex-direction: column; }
        .main-content { flex: 1; display: flex; overflow: hidden; padding: 15px; gap: 15px; }
        
        /* Menu Section */
        .menu-section { flex: 0 0 65%; display: flex; flex-direction: column; background: white; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); overflow: hidden; }
        .category-tabs { display: flex; overflow-x: auto; padding: 15px; gap: 10px; border-bottom: 1px solid #e5e7eb; background: #f8fafc; }
        .cat-btn { white-space: nowrap; padding: 8px 16px; border-radius: 20px; border: 1px solid #cbd5e1; background: white; color: #475569; font-weight: 500; transition: all 0.2s; }
        .cat-btn:hover, .cat-btn.active { background: #4F46E5; color: white; border-color: #4F46E5; }
        
        .menu-items-grid { flex: 1; overflow-y: auto; padding: 15px; display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); gap: 15px; align-content: start; }
        .menu-item-card { border: 1px solid #e2e8f0; border-radius: 10px; overflow: hidden; transition: all 0.2s; background: white; display: flex; flex-direction: column; height: 220px; position: relative; }
        .menu-item-card:hover { border-color: #4F46E5; box-shadow: 0 4px 12px rgba(79, 70, 229, 0.15); transform: translateY(-2px); }
        .menu-item-img { height: 130px; min-height: 130px; object-fit: cover; width: 100%; border-bottom: 1px solid #f1f5f9; }
        .menu-item-img-placeholder { height: 130px; min-height: 130px; width: 100%; background: #f1f5f9; display: flex; align-items: center; justify-content: center; color: #94a3b8; font-size: 2rem; border-bottom: 1px solid #e2e8f0; }
        .menu-item-info { padding: 10px; display: flex; flex-direction: column; justify-content: space-between; height: 90px; background: white; z-index: 2; }
        .menu-item-name { font-weight: 600; font-size: 0.9rem; color: #1e293b; margin-bottom: 5px; line-height: 1.2; overflow: hidden; text-overflow: ellipsis; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; }
        .menu-item-price { font-weight: 700; color: #059669; font-size: 0.95rem; margin-top: auto; }
        
        /* Cart Section */
        .cart-section { flex: 1; display: flex; flex-direction: column; background: white; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); overflow: hidden; }
        .cart-header { padding: 15px; border-bottom: 1px solid #e5e7eb; background: #4F46E5; color: white; }
        .cart-items { flex: 1; overflow-y: auto; padding: 0; }
        .cart-item { display: flex; justify-content: space-between; align-items: center; padding: 12px 15px; border-bottom: 1px solid #f1f5f9; }
        .cart-item-info { flex: 1; padding-right: 10px; }
        .cart-item-name { font-weight: 600; color: #334155; font-size: 0.9rem; margin-bottom: 2px; }
        .cart-item-price { color: #64748b; font-size: 0.85rem; }
        .qty-control { display: flex; align-items: center; gap: 8px; background: #f8fafc; padding: 4px; border-radius: 20px; border: 1px solid #e2e8f0; }
        .qty-btn { width: 24px; height: 24px; border-radius: 50%; border: none; background: white; color: #4F46E5; font-weight: bold; display: flex; align-items: center; justify-content: center; box-shadow: 0 1px 3px rgba(0,0,0,0.1); transition: 0.2s; }
        .qty-btn:hover { background: #4F46E5; color: white; }
        .qty-value { font-weight: 600; min-width: 20px; text-align: center; font-size: 0.9rem; }
        .cart-item-total { font-weight: 700; color: #0f172a; width: 70px; text-align: right; }
        .remove-btn { color: #ef4444; background: none; border: none; padding: 5px; cursor: pointer; transition: 0.2s; }
        .remove-btn:hover { transform: scale(1.2); }
        
        .cart-footer { padding: 15px; border-top: 1px solid #e5e7eb; background: #f8fafc; }
        .summary-row { display: flex; justify-content: space-between; margin-bottom: 8px; color: #475569; font-size: 0.9rem; }
        .summary-total { display: flex; justify-content: space-between; margin-top: 10px; padding-top: 10px; border-top: 2px dashed #cbd5e1; font-weight: 700; font-size: 1.25rem; color: #0f172a; }
        
        /* Options */
        .dining-options { display: flex; gap: 10px; margin-bottom: 15px; }
        .dining-opt-btn { flex: 1; padding: 10px; border: 2px solid #e2e8f0; border-radius: 8px; background: white; color: #64748b; font-weight: 600; text-align: center; cursor: pointer; transition: 0.2s; }
        .dining-opt-btn.active { border-color: #4F46E5; background: #EEF2FF; color: #4F46E5; }
        .dining-opt-btn input { display: none; }
        
        .table-selector { margin-bottom: 15px; transition: all 0.3s ease; }
        .table-selector.hidden { display: none; }
        
        /* Empty Cart State */
        .empty-cart { display: flex; flex-direction: column; align-items: center; justify-content: center; height: 100%; color: #94a3b8; padding: 20px; text-align: center; }
        .empty-cart i { font-size: 3rem; margin-bottom: 10px; color: #cbd5e1; }
    </style>
    <link href="${pageContext.request.contextPath}/assets/css/admin-royal.css" rel="stylesheet">
</head>
<body class="admin-royal">
    <div class="d-flex">
        <jsp:include page="/admin/sidebar.jsp">
            <jsp:param name="active" value="quick-bill"/>
        </jsp:include>

        <!-- Main Content -->
        <div style="flex: 1; height: 100vh; display: flex; flex-direction: column; overflow: hidden;">
            
            <div class="main-content">
                <!-- Menu Section -->
                <div class="menu-section">
                    <div class="category-tabs">
                        <button class="cat-btn active" onclick="filterCategory('ALL', this)">All Items</button>
                        <button class="cat-btn" onclick="filterCategory('combo', this)"><i class="fa-solid fa-layer-group me-1"></i>Combo Sets</button>
                        <c:forEach items="${categories}" var="cat">
                            <button class="cat-btn" onclick="filterCategory('${cat.id}', this)">${cat.categoryName}</button>
                        </c:forEach>
                    </div>
                    
                    <div class="menu-items-grid" id="menuGrid">
                        <!-- Menu Items -->
                        <c:forEach items="${menuItems}" var="item">
                            <div class="menu-item-card" data-category="${item.category.id}">
                                <c:set var="itemDisplayName" value="${item.itemName}" />
                                <c:choose>
                                    <c:when test="${not empty item.imageUrl}">
                                        <c:choose>
                                            <c:when test="${fn:startsWith(item.imageUrl, 'http')}">
                                                <img src="${item.imageUrl}" alt="${itemDisplayName}" class="menu-item-img">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}/${item.imageUrl}" alt="${itemDisplayName}" class="menu-item-img">
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:when test="${item.itemName == 'Crab Asparagus Soup'}">
                                        <img src="${pageContext.request.contextPath}/assets/img/le-royal/Crab Salad with Cream Sauce and Squid Ink Crisps.png" alt="${itemDisplayName}" class="menu-item-img">
                                    </c:when>
                                    <c:when test="${item.itemName == 'Lotus Stem Salad'}">
                                        <img src="${pageContext.request.contextPath}/assets/img/le-royal/Vegetable Terrine with Herb Sorbet.png" alt="${itemDisplayName}" class="menu-item-img">
                                    </c:when>
                                    <c:when test="${item.itemName == 'Black Pepper Beef Tenderloin'}">
                                        <img src="${pageContext.request.contextPath}/assets/img/le-royal/Roasted Beef with Red Wine Jus.png" alt="${itemDisplayName}" class="menu-item-img">
                                    </c:when>
                                    <c:when test="${item.itemName == 'Pan Seared Salmon'}">
                                        <img src="${pageContext.request.contextPath}/assets/img/le-royal/Seared Fish with Herb Puree.png" alt="${itemDisplayName}" class="menu-item-img">
                                    </c:when>
                                    <c:when test="${item.itemName == 'Bordeaux Red Wine'}">
                                        <img src="${pageContext.request.contextPath}/assets/img/le-royal/RosÃ© Wine.jpg" alt="${itemDisplayName}" class="menu-item-img">
                                    </c:when>
                                    <c:when test="${item.itemName == 'Fresh Orange Juice'}">
                                        <img src="${pageContext.request.contextPath}/assets/img/le-royal/Passion Fruit Fizz.jpg" alt="${itemDisplayName}" class="menu-item-img">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/assets/img/le-royal/Herb Tart.png" alt="${itemDisplayName}" class="menu-item-img">
                                    </c:otherwise>
                                </c:choose>
                                <div class="menu-item-info">
                                    <div class="menu-item-name">${itemDisplayName}</div>
                                    <div class="d-flex justify-content-between align-items-end mt-auto">
                                        <div class="menu-item-price"><fmt:formatNumber value="${item.basePrice}" pattern="#,##0"/> â‚«</div>
                                        <button type="button" class="btn btn-sm btn-outline-primary rounded-circle shadow-sm d-flex align-items-center justify-content-center" style="width: 28px; height: 28px; padding: 0;" onclick="addToCart('${item.id}', `${fn:escapeXml(itemDisplayName)}`, ${item.basePrice}, 'item')">
                                            <i class="fa-solid fa-plus"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        <!-- Combo Sets -->
                        <c:forEach items="${menuSets}" var="set">
                            <div class="menu-item-card" data-category="combo">
                                <c:set var="setDisplayName" value="${not empty set.setNameVi ? set.setNameVi : set.setName}" />
                                <c:choose>
                                    <c:when test="${not empty set.imageUrl}">
                                        <c:choose>
                                            <c:when test="${fn:startsWith(set.imageUrl, 'http')}">
                                                <img src="${set.imageUrl}" alt="${setDisplayName}" class="menu-item-img">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}/${set.imageUrl}" alt="${setDisplayName}" class="menu-item-img">
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/assets/img/le-royal/Signature Set.webp" alt="${setDisplayName}" class="menu-item-img">
                                    </c:otherwise>
                                </c:choose>
                                <div class="menu-item-info">
                                    <div class="menu-item-name">
                                        <span class="badge bg-warning text-dark me-1" style="font-size: 0.7rem;">SET</span>
                                        ${setDisplayName}
                                    </div>
                                    <div class="d-flex justify-content-between align-items-end mt-auto">
                                        <div class="menu-item-price"><fmt:formatNumber value="${set.discountedPrice}" pattern="#,##0"/> â‚«</div>
                                        <button type="button" class="btn btn-sm btn-outline-primary rounded-circle shadow-sm d-flex align-items-center justify-content-center" style="width: 28px; height: 28px; padding: 0;" onclick="addToCart('S_${set.id}', `${fn:escapeXml(setDisplayName)}`, ${set.discountedPrice}, 'set')">
                                            <i class="fa-solid fa-plus"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
                
                <!-- Cart Section -->
                <div class="cart-section">
                    <div class="cart-header">
                        <h5 class="m-0 fw-bold"><i class="fa-solid fa-cart-shopping me-2"></i>Current Order</h5>
                    </div>
                    
                    <div class="cart-items" id="cartItems">
                        <div class="empty-cart" id="emptyCart">
                            <i class="fa-solid fa-basket-shopping"></i>
                            <p class="m-0 fw-medium">No items in cart</p>
                            <small>Click items from the menu to add them</small>
                        </div>
                    </div>
                    
                    <div class="cart-footer">
                        <form id="checkoutForm">
                            <!-- Dining Options -->
                            <div class="dining-options">
                                <label class="dining-opt-btn active" id="btnDineIn">
                                    <input type="radio" name="diningType" value="DINE_IN" checked onchange="toggleDiningType()">
                                    <i class="fa-solid fa-bell-concierge me-1"></i> Dine In
                                </label>
                                <label class="dining-opt-btn" id="btnTakeAway">
                                    <input type="radio" name="diningType" value="TAKE_AWAY" onchange="toggleDiningType()">
                                    <i class="fa-solid fa-bag-shopping me-1"></i> Take Away
                                </label>
                            </div>
                            
                            <!-- Guest Count & Table Selection (Only for Dine In) -->
                            <div id="dineInOptions">
                                <div class="mb-3 mt-3">
                                    <label class="form-label fw-bold text-secondary" style="font-size: 0.85rem;">Number of Guests</label>
                                    <input type="number" class="form-control fw-medium" name="guestCount" id="guestCount" min="1" value="1">
                                </div>
                                
                                <div class="table-selector" id="tableSelectorDiv">
                                    <select class="form-select fw-medium" name="tableId" id="tableId" style="border-color: #cbd5e1;">
                                        <option value="" data-capacity="0">-- Select Table --</option>
                                        <c:forEach items="${availableTables}" var="t">
                                            <option value="${t.id}" data-price="${t.basePrice}" data-capacity="${t.capacity}">Table ${t.tableCode} (Cap: ${t.capacity}) - Base: <fmt:formatNumber value="${t.basePrice}" pattern="#,##0"/>â‚«</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="summary-row mt-3">
                                <span>Subtotal</span>
                                <span id="summarySubtotal" class="fw-bold text-dark">0 â‚«</span>
                            </div>
                            <div class="summary-row" id="tableFeeRow">
                                <span>Table Base Price</span>
                                <span id="summaryTableFee" class="fw-bold text-dark">0 â‚«</span>
                            </div>
                            <div class="summary-total">
                                <span>Total</span>
                                <span id="summaryTotal" class="text-primary">0 â‚«</span>
                            </div>
                            
                            <button type="button" class="btn btn-primary w-100 py-3 mt-3 fw-bold fs-5 shadow-sm" onclick="submitOrder()" style="border-radius: 10px;">
                                <i class="fa-solid fa-file-invoice-dollar me-2"></i>Checkout & Print Bill
                            </button>
                        </form>
                    </div>
                </div>
            </div>
            
        </div>
    </div>
    
    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        let cart = {};
        
        // Format Currency
        const formatMoney = (amount) => {
            return new Intl.NumberFormat('vi-VN').format(amount) + ' â‚«';
        };

        // Filter Menu Categories
        function filterCategory(catId, btnEl) {
            document.querySelectorAll('.cat-btn').forEach(b => b.classList.remove('active'));
            btnEl.classList.add('active');
            
            document.querySelectorAll('.menu-item-card').forEach(card => {
                if (catId === 'ALL' || card.dataset.category === catId) {
                    card.style.display = 'flex';
                } else {
                    card.style.display = 'none';
                }
            });
        }
        
        // Add to Cart
        function addToCart(id, name, price) {
            if (cart[id]) {
                cart[id].qty += 1;
            } else {
                cart[id] = { name, price, qty: 1 };
            }
            renderCart();
        }
        
        // Update Quantity
        function updateQty(id, change) {
            if (cart[id]) {
                cart[id].qty += change;
                if (cart[id].qty <= 0) {
                    delete cart[id];
                }
                renderCart();
            }
        }
        
        // Remove Item
        function removeItem(id) {
            delete cart[id];
            renderCart();
        }
        
        // Render Cart UI
        function renderCart() {
            const cartContainer = document.getElementById('cartItems');
            const emptyCart = document.getElementById('emptyCart');
            
            // Clear existing except empty state
            const existingItems = cartContainer.querySelectorAll('.cart-item');
            existingItems.forEach(el => el.remove());
            
            let itemSubtotal = 0;
            const keys = Object.keys(cart);
            
            if (keys.length === 0) {
                emptyCart.style.display = 'flex';
            } else {
                emptyCart.style.display = 'none';
                
                keys.forEach(id => {
                    const item = cart[id];
                    const safeId = JSON.stringify(id);
                    const itemTotal = item.price * item.qty;
                    itemSubtotal += itemTotal;
                    
                    const div = document.createElement('div');
                    div.className = 'cart-item';
                    div.innerHTML = `
                        <div class="cart-item-info">
                            <div class="cart-item-name">` + item.name + `</div>
                            <div class="cart-item-price">` + formatMoney(item.price) + `</div>
                        </div>
                        <div class="qty-control me-3">
                            <button type="button" class="qty-btn" onclick="updateQty(`+safeId+`, -1)"><i class="fa-solid fa-minus fs-7"></i></button>
                            <span class="qty-value">` + item.qty + `</span>
                            <button type="button" class="qty-btn" onclick="updateQty(`+safeId+`, 1)"><i class="fa-solid fa-plus fs-7"></i></button>
                        </div>
                        <div class="cart-item-total">` + formatMoney(itemTotal) + `</div>
                        <button type="button" class="remove-btn ms-2" onclick="removeItem(`+safeId+`)"><i class="fa-solid fa-trash"></i></button>
                    `;
                    cartContainer.appendChild(div);
                });
            }
            
            calculateTotals(itemSubtotal);
        }
        
        // Handle Dining Type Toggle
        function toggleDiningType() {
            const isDineIn = document.querySelector('input[name="diningType"]:checked').value === 'DINE_IN';
            
            document.getElementById('btnDineIn').classList.toggle('active', isDineIn);
            document.getElementById('btnTakeAway').classList.toggle('active', !isDineIn);
            
            const dineInOptions = document.getElementById('dineInOptions');
            const tableFeeRow = document.getElementById('tableFeeRow');
            const tableSelect = document.getElementById('tableId');
            const guestCount = document.getElementById('guestCount');
            
            if (isDineIn) {
                dineInOptions.classList.remove('hidden');
                dineInOptions.style.display = 'block';
                tableFeeRow.style.display = 'flex';
            } else {
                dineInOptions.classList.add('hidden');
                dineInOptions.style.display = 'none';
                tableFeeRow.style.display = 'none';
                tableSelect.value = ""; // Reset table selection
                guestCount.value = "1"; // Reset guest count
            }
            
            // Recalculate totals
            const currentItemSubtotal = Object.values(cart).reduce((sum, item) => sum + (item.price * item.qty), 0);
            calculateTotals(currentItemSubtotal);
        }
        
        // Handle Table Change to update fees
        document.getElementById('tableId').addEventListener('change', function() {
            const currentItemSubtotal = Object.values(cart).reduce((sum, item) => sum + (item.price * item.qty), 0);
            calculateTotals(currentItemSubtotal);
        });
        
        // Filter tables based on guest count
        document.getElementById('guestCount').addEventListener('input', function() {
            const guestCount = parseInt(this.value) || 1;
            const tableSelect = document.getElementById('tableId');
            const options = tableSelect.querySelectorAll('option:not([value=""])');
            let hasValidSelection = false;
            
            options.forEach(opt => {
                const capacity = parseInt(opt.getAttribute('data-capacity')) || 0;
                if (capacity < guestCount) {
                    opt.style.display = 'none';
                    opt.disabled = true;
                } else {
                    opt.style.display = '';
                    opt.disabled = false;
                }
                
                if (opt.selected && opt.disabled) {
                    tableSelect.value = '';
                } else if (opt.selected && !opt.disabled) {
                    hasValidSelection = true;
                }
            });
            
            if (!hasValidSelection && tableSelect.value !== '') {
                tableSelect.value = '';
                const currentItemSubtotal = Object.values(cart).reduce((sum, item) => sum + (item.price * item.qty), 0);
                calculateTotals(currentItemSubtotal);
            }
        });
        
        // Calculate and Update Summary
        function calculateTotals(itemSubtotal) {
            document.getElementById('summarySubtotal').innerText = formatMoney(itemSubtotal);
            
            let tableFee = 0;
            const isDineIn = document.querySelector('input[name="diningType"]:checked').value === 'DINE_IN';
            
            if (isDineIn) {
                const tableSelect = document.getElementById('tableId');
                if (tableSelect.selectedIndex > 0) {
                    tableFee = parseFloat(tableSelect.options[tableSelect.selectedIndex].dataset.price || 0);
                }
            }
            
            document.getElementById('summaryTableFee').innerText = formatMoney(tableFee);
            
            const total = itemSubtotal + tableFee;
            document.getElementById('summaryTotal').innerText = formatMoney(total);
        }
        
        // Submit Order
        function submitOrder() {
            if (Object.keys(cart).length === 0) {
                Swal.fire('Empty Cart', 'Please add some items to the cart first.', 'warning');
                return;
            }
            
            const isDineIn = document.querySelector('input[name="diningType"]:checked').value === 'DINE_IN';
            const tableId = document.getElementById('tableId').value;
            const guestCount = parseInt(document.getElementById('guestCount').value) || 1;
            
            if (isDineIn) {
                if (!tableId) {
                    Swal.fire('Table Required', 'Please select a table for Dine In.', 'warning');
                    return;
                }
                if (!guestCount || guestCount < 1) {
                    Swal.fire('Invalid Input', 'Please enter a valid number of guests.', 'warning');
                    return;
                }
                
                // Validate capacity
                const tableSelect = document.getElementById('tableId');
                const selectedOption = tableSelect.options[tableSelect.selectedIndex];
                const capacity = parseInt(selectedOption.getAttribute('data-capacity')) || 0;
                
                if (guestCount > capacity) {
                    Swal.fire('Over Capacity', 'The number of guests (' + guestCount + ') exceeds the selected table capacity (' + capacity + '). Please select a larger table.', 'warning');
                    return;
                }
            }
            
            // Prepare payload as URL encoded params to avoid needing JSON parser in Java
            const params = new URLSearchParams();
            params.append('action', 'checkout');
            params.append('diningType', isDineIn ? 'DINE_IN' : 'TAKE_AWAY');
            params.append('guestCount', guestCount);
            if (isDineIn) {
                params.append('tableId', tableId);
            }
            
            const keys = Object.keys(cart);
            for (let i = 0; i < keys.length; i++) {
                let actualId = keys[i];
                let type = "item";
                if (keys[i].startsWith("S_")) {
                    actualId = keys[i].substring(2);
                    type = "set";
                }
                params.append('itemIds', actualId);
                params.append('itemTypes', type);
                params.append('itemQtys', cart[keys[i]].qty);
            }
            
            // Show loading
            Swal.fire({
                title: 'Processing Payment...',
                text: 'Please wait',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });
            
            // Send request
            fetch('${pageContext.request.contextPath}/admin/quick-bill', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params.toString()
            })
            .then(response => {
                if (!response.ok) throw new Error('Network response was not ok');
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    Swal.fire({
                        icon: 'success',
                        title: 'Payment Successful!',
                        text: 'Invoice generated successfully.',
                        confirmButtonText: 'Print Bill & New Order'
                    }).then(() => {
                        window.location.reload(); // Reload for new order
                    });
                } else {
                    Swal.fire('Error', data.message || 'Failed to process order.', 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                Swal.fire('Error', 'An error occurred while processing the order.', 'error');
            });
        }
    </script>
</body>
</html>
