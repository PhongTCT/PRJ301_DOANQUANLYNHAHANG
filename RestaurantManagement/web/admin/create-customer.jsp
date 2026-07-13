<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang == 'en' ? 'en_US' : 'vi_VN'}" />
<fmt:setBundle basename="i18n.messages" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title><fmt:message key="admin.createcustomer.title"/> - <fmt:message key="admin.createcustomer.sub"/></title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Marcellus&family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/admin-royal.css" rel="stylesheet">
</head>
<body class="bg-light admin-royal">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card shadow-sm border-0">
                    <div class="card-header bg-white border-0 pt-4 pb-0 text-center">
                        <h4 class="fw-bold mb-1"><fmt:message key="admin.createcustomer.title"/></h4>
                        <p class="text-muted small"><fmt:message key="admin.createcustomer.sub"/></p>
                    </div>
                    <div class="card-body p-4">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger shadow-sm border-0 mb-4">
                                <i class="fa-solid fa-circle-exclamation me-2"></i> ${error}
                            </div>
                        </c:if>
                        
                        <form action="${pageContext.request.contextPath}/admin/create-customer" method="POST">
                            <div class="mb-3 form-floating">
                                <input type="text" class="form-control" id="fullName" name="fullName" required placeholder="<fmt:message key='admin.createcustomer.fullname'/>">
                                <label for="fullName"><fmt:message key="admin.createcustomer.fullname"/></label>
                            </div>
                            
                            <div class="mb-3 form-floating">
                                <input type="tel" class="form-control" id="phone" name="phone" required placeholder="<fmt:message key='admin.createcustomer.phone'/>">
                                <label for="phone"><fmt:message key="admin.createcustomer.phone"/></label>
                            </div>
                            
                            <div class="mb-4 form-floating">
                                <input type="email" class="form-control" id="email" name="email" placeholder="<fmt:message key='admin.createcustomer.email'/>">
                                <label for="email"><fmt:message key="admin.createcustomer.email"/></label>
                            </div>
                            
                            <div class="alert alert-info border-0 small">
                                <i class="fa-solid fa-info-circle me-1"></i> <fmt:message key="admin.createcustomer.note"/>
                            </div>
                            
                            <div class="d-flex justify-content-between align-items-center">
                                <a href="${pageContext.request.contextPath}/admin/walkin" class="btn btn-outline-secondary">
                                    <i class="fa-solid fa-arrow-left me-1"></i> <fmt:message key="admin.createcustomer.back"/>
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fa-solid fa-user-plus me-1"></i> <fmt:message key="admin.createcustomer.btn"/>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
