<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="header.jsp" />

<main class="container my-5 py-4">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <section class="surface p-4">
                <div class="text-center mb-4">
                    <span class="badge price-badge mb-2">Secure access</span>
                    <h1 class="h3 fw-bold mb-1">Login</h1>
                    <p class="muted small mb-0">Use an active account to continue.</p>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger py-2 small">${error}</div>
                </c:if>

                <form action="MainController" method="POST">
                    <input type="hidden" name="action" value="dologin">
                    <div class="mb-3">
                        <label class="form-label small muted">Email</label>
                        <input type="email" name="email" class="form-control bg-dark text-light border-secondary" placeholder="admin@restaurant.com" required>
                    </div>
                    <div class="mb-4">
                        <label class="form-label small muted">Password</label>
                        <input type="password" name="password" class="form-control bg-dark text-light border-secondary" placeholder="123456" required>
                    </div>
                    <button type="submit" class="btn btn-gold w-100">Login</button>
                </form>

                <div class="mt-4 small muted">
                    <div><code>admin@restaurant.com / 123456</code></div>
                    <div><code>staff@restaurant.com / 123456</code></div>
                    <div><code>customer@gmail.com / 123456</code></div>
                </div>
            </section>
        </div>
    </div>
</main>

<jsp:include page="footer.jsp" />
