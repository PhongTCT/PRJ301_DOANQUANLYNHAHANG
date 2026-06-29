<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="header.jsp" />

<main class="container py-5">
    <div class="row justify-content-center align-items-center g-4">
        <div class="col-lg-6">
            <div class="pe-lg-4">
                <span class="eyebrow mb-3"><i class="fa-solid fa-lock"></i> Secure access</span>
                <h1 class="display-5 fw-bold mb-3">Welcome Back</h1>
                <p class="muted mb-4">Sign in to keep your booking draft, manage reservations, and continue the dining plan you started.</p>
                <img src="https://images.unsplash.com/photo-1550966871-3ed3cdb5ed0c?auto=format&fit=crop&w=900&q=80" class="img-fluid rounded-4 shadow-lift" alt="Bright restaurant dining room">
            </div>
        </div>
        <div class="col-md-8 col-lg-5">
            <section class="surface p-4 shadow-lift">
                <div class="mb-4">
                    <h2 class="h3 fw-bold mb-1">Login</h2>
                    <p class="muted small mb-0">Use an active account to continue.</p>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger py-2 small">${error}</div>
                </c:if>

                <form action="MainController" method="POST">
                    <input type="hidden" name="action" value="dologin">
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Email</label>
                        <input type="email" name="email" class="form-control" placeholder="admin@restaurant.com" required>
                    </div>
                    <div class="mb-4">
                        <label class="form-label small fw-bold">Password</label>
                        <input type="password" name="password" class="form-control" placeholder="123456" required>
                    </div>
                    <button type="submit" class="btn btn-brand w-100">Login</button>
                </form>

                <div class="surface-soft p-3 mt-4 small">
                    <div class="fw-bold mb-2">Quick test accounts</div>
                    <div class="mb-1"><code>admin@restaurant.com / 123456</code></div>
                    <div class="mb-1"><code>staff@restaurant.com / 123456</code></div>
                    <div><code>customer@gmail.com / 123456</code></div>
                </div>
            </section>
        </div>
    </div>
</main>

<jsp:include page="footer.jsp" />
