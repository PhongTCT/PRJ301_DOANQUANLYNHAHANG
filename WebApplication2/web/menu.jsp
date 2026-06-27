<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="header.jsp" />

<main class="container my-5">
    <div class="mb-4">
        <span class="badge price-badge mb-2">Menu catalog</span>
        <h1 class="display-5 fw-bold mb-2">Active Dishes</h1>
        <p class="muted mb-0">Seasonal dishes, drinks, and favorites prepared for every dining occasion.</p>
    </div>

    <c:if test="${not empty pageError}">
        <div class="alert alert-warning">${pageError}</div>
    </c:if>

    <div class="row g-3">
        <c:forEach items="${menuList}" var="item">
            <div class="col-lg-4 col-md-6">
                <article class="surface h-100 p-3">
                    <div class="d-flex justify-content-between gap-3 mb-2">
                        <h2 class="h5 mb-0">${item.itemName}</h2>
                        <span class="badge price-badge align-self-start">
                            <fmt:formatNumber value="${item.basePrice}" pattern="#,##0"/> VND
                        </span>
                    </div>
                    <p class="muted small mb-3">${item.description}</p>
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="small text-warning">${item.category.categoryName}</span>
                        <a href="MainController?action=booking" class="btn btn-outline-warning btn-sm">
                            <i class="fa-solid fa-plus me-1"></i>Add
                        </a>
                    </div>
                </article>
            </div>
        </c:forEach>
    </div>
</main>

<jsp:include page="footer.jsp" />
