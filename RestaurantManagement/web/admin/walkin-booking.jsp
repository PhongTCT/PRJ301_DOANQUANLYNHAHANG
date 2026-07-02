<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Walk-in POS - Admin Dashboard</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; font-family: 'Inter', sans-serif; }
        .sidebar { min-height: 100vh; background-color: #1a1d20; color: white; }
        .sidebar a { color: rgba(255,255,255,.7); text-decoration: none; padding: 12px 20px; display: block; border-radius: 8px; margin-bottom: 5px; transition: 0.2s; }
        .sidebar a:hover, .sidebar a.active { background-color: rgba(255,255,255,0.1); color: white; }
        .card { border-radius: 12px; }
        .pos-container {
            max-width: 800px;
            margin: 0 auto;
        }
        .pos-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        }
        .pos-header {
            background: linear-gradient(135deg, #4F46E5 0%, #7C3AED 100%);
            color: white;
            border-radius: 15px 15px 0 0;
            padding: 1.5rem;
        }
        .table-card {
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            padding: 15px;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s;
        }
        .table-card:hover {
            border-color: #4F46E5;
            background-color: #EEF2FF;
        }
        .table-card.selected {
            border-color: #4F46E5;
            background-color: #4F46E5;
            color: white;
        }
        .table-radio {
            display: none;
        }
        .btn-pos {
            background: #4F46E5;
            color: white;
            font-weight: 600;
            padding: 12px 24px;
            border-radius: 8px;
            transition: all 0.3s;
        }
        .btn-pos:hover {
            background: #4338CA;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-2 sidebar p-4">
                <h4 class="mb-4 fw-bold text-white"><i class="fa-solid fa-utensils me-2"></i>Le Royal</h4>
                <a href="walkin" class="active"><i class="fa-solid fa-cash-register me-2"></i> Walk-in POS</a>
                <a href="reservations"><i class="fa-solid fa-clipboard-list me-2"></i> Reservations</a>
                <a href="surcharges"><i class="fa-solid fa-calendar-check me-2"></i> Holidays</a>
                <a href="#"><i class="fa-solid fa-chair me-2"></i> Tables</a>
                <hr class="border-secondary">
                <a href="/"><i class="fa-solid fa-arrow-left me-2"></i> Back to Site</a>
            </div>

            <!-- Main Content -->
            <div class="col-md-10 p-5">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="h3 mb-0 text-gray-800 fw-bold">Walk-in POS</h2>
                </div>

            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                    <i class="fa-solid fa-check-circle me-2"></i>${sessionScope.successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i>${sessionScope.errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>

            <div class="pos-container">
                <div class="card pos-card">
                    <div class="pos-header text-center">
                        <h4 class="mb-0"><i class="fa-solid fa-cash-register me-2"></i>New Walk-in Order</h4>
                        <p class="mb-0 text-white-50 mt-1">Create an instant reservation for walk-in customers (Type A)</p>
                    </div>
                    <div class="card-body p-4 p-md-5">
                        <form action="${pageContext.request.contextPath}/admin/walkin" method="POST">
                            
                            <!-- Customer Info -->
                            <h5 class="fw-bold mb-3"><i class="fa-solid fa-user me-2 text-primary"></i>1. Customer Information</h5>
                            <div class="row mb-4">
                                <div class="col-md-12">
                                    <label class="form-label fw-medium">Customer Phone Number <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-white"><i class="fa-solid fa-phone text-muted"></i></span>
                                        <input type="tel" class="form-control" name="phone" id="phoneInput" placeholder="Enter registered phone number..." required>
                                    </div>
                                    <small id="phoneError" class="text-danger mt-1 d-block fw-bold d-none"></small>
                                    <small class="text-muted mt-1 d-block"><i class="fa-solid fa-info-circle me-1"></i>Must be an existing Type A customer.</small>
                                </div>
                            </div>

                            <hr class="my-4">

                            <!-- Guests Count -->
                            <h5 class="fw-bold mb-3"><i class="fa-solid fa-users me-2 text-primary"></i>2. Guests</h5>
                            <div class="row mb-4">
                                <div class="col-md-6 mb-3 mb-md-0">
                                    <label class="form-label fw-medium">Adults <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" name="adultsCount" value="2" min="1" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-medium">Children</label>
                                    <input type="number" class="form-control" name="childrenCount" value="0" min="0">
                                </div>
                            </div>

                            <hr class="my-4">

                            <!-- Event Type -->
                            <h5 class="fw-bold mb-3"><i class="fa-solid fa-glass-cheers me-2 text-primary"></i>3. Event Type</h5>
                            <div class="row mb-4">
                                <div class="col-md-12">
                                    <label class="form-label fw-medium">Dining Purpose / Event</label>
                                    <select class="form-select" name="eventTypeId">
                                        <c:forEach items="${eventTypes}" var="et">
                                            <option value="${et.id}">${et.name}</option>
                                        </c:forEach>
                                    </select>
                                    <small class="text-muted mt-1 d-block"><i class="fa-solid fa-info-circle me-1"></i>Defaults to Normal Dining if not changed.</small>
                                </div>
                            </div>

                            <hr class="my-4">

                            <!-- Table Selection -->
                            <h5 class="fw-bold mb-3"><i class="fa-solid fa-chair me-2 text-primary"></i>4. Assign Table (Available Now) <span class="text-danger">*</span></h5>
                            <div class="row g-3 mb-4">
                                <c:if test="${empty availableTables}">
                                    <div class="col-12">
                                        <div class="alert alert-warning">
                                            <i class="fa-solid fa-exclamation-triangle me-2"></i>No tables available at the moment!
                                        </div>
                                    </div>
                                </c:if>
                                <c:forEach items="${availableTables}" var="t">
                                    <div class="col-6 col-md-4 col-lg-3 table-wrapper" data-capacity="${t.capacity}">
                                        <label class="w-100">
                                            <input type="radio" name="tableId" value="${t.id}" class="table-radio" required>
                                            <div class="table-card" onclick="selectCard(this)">
                                                <h5 class="mb-1 fw-bold">${t.tableCode}</h5>
                                                <small>${t.capacity} seats</small><br>
                                                <small class="fw-bold text-success"><fmt:formatNumber value="${t.basePrice}" pattern="#,##0"/>đ</small>
                                            </div>
                                        </label>
                                    </div>
                                </c:forEach>
                            </div>

                            <div class="text-end mt-5">
                                <button type="submit" id="submitBtn" class="btn btn-pos btn-lg w-100 w-md-auto" ${empty availableTables ? 'disabled' : ''}>
                                    <i class="fa-solid fa-bolt me-2"></i>Open Table & Create Order
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function selectCard(element) {
            document.querySelectorAll('.table-card').forEach(card => card.classList.remove('selected', 'text-white'));
            element.classList.add('selected', 'text-white');
            element.querySelectorAll('.text-success').forEach(el => el.classList.replace('text-success', 'text-white'));
        }

        function filterTables() {
            const adults = parseInt(document.querySelector('input[name="adultsCount"]').value) || 0;
            const children = parseInt(document.querySelector('input[name="childrenCount"]').value) || 0;
            const totalGuests = adults + children;
            
            document.querySelectorAll('.table-wrapper').forEach(wrapper => {
                const capacity = parseInt(wrapper.getAttribute('data-capacity')) || 0;
                if (capacity < totalGuests) {
                    wrapper.classList.add('d-none');
                    // Uncheck if it was selected
                    const radio = wrapper.querySelector('.table-radio');
                    if (radio && radio.checked) {
                        radio.checked = false;
                        const card = wrapper.querySelector('.table-card');
                        if (card) {
                            card.classList.remove('selected', 'text-white');
                        }
                    }
                } else {
                    wrapper.classList.remove('d-none');
                }
            });
        }
        
        document.addEventListener('DOMContentLoaded', () => {
            document.querySelector('input[name="adultsCount"]').addEventListener('input', filterTables);
            document.querySelector('input[name="childrenCount"]').addEventListener('input', filterTables);
            filterTables(); // run once on load

            const phoneInput = document.getElementById('phoneInput');
            const phoneError = document.getElementById('phoneError');
            const submitBtn = document.getElementById('submitBtn');

            phoneInput.addEventListener('blur', function() {
                const phone = this.value.trim();
                if (phone.length > 5) {
                    fetch('walkin?action=checkPhone&phone=' + encodeURIComponent(phone))
                        .then(response => response.json())
                        .then(data => {
                            if (data.hasActive) {
                                phoneError.innerHTML = '<i class="fa-solid fa-triangle-exclamation me-1"></i> Customer ' + data.customerName + ' already has an active reservation today. Cannot create another order.';
                                phoneError.classList.remove('d-none');
                                phoneInput.classList.add('is-invalid');
                                if (submitBtn) submitBtn.disabled = true;
                            } else {
                                phoneError.classList.add('d-none');
                                phoneInput.classList.remove('is-invalid');
                                if (submitBtn) submitBtn.disabled = false;
                            }
                        })
                        .catch(err => console.error('Error checking phone:', err));
                } else {
                    phoneError.classList.add('d-none');
                    phoneInput.classList.remove('is-invalid');
                    if (submitBtn) submitBtn.disabled = false;
                }
            });
        });
    </script>
</body>
</html>
