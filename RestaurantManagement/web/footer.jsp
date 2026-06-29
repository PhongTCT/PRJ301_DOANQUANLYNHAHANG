<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setBundle basename="i18n.messages" scope="session" />
<section class="container py-5">
    <div class="row g-4 align-items-center">
        <div class="col-lg-6">
            <span class="eyebrow mb-3"><i class="fa-solid fa-book-open"></i> <fmt:message key="story.eyebrow"/></span>
            <h2 class="display-6 fw-bold mb-3"><fmt:message key="story.title"/></h2>
            <p class="muted mb-3"><fmt:message key="story.copy1"/></p>
            <p class="muted mb-4"><fmt:message key="story.copy2"/></p>
            <div class="row g-3">
                <div class="col-sm-4">
                    <div class="surface-soft p-3 h-100">
                        <div class="fw-bold mb-1"><i class="fa-solid fa-utensils me-1" style="color:var(--accent);"></i><fmt:message key="story.point1.title"/></div>
                        <div class="small muted"><fmt:message key="story.point1.desc"/></div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="surface-soft p-3 h-100">
                        <div class="fw-bold mb-1"><i class="fa-solid fa-seedling me-1" style="color:var(--accent);"></i><fmt:message key="story.point2.title"/></div>
                        <div class="small muted"><fmt:message key="story.point2.desc"/></div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="surface-soft p-3 h-100">
                        <div class="fw-bold mb-1"><i class="fa-solid fa-champagne-glasses me-1" style="color:var(--accent);"></i><fmt:message key="story.point3.title"/></div>
                        <div class="small muted"><fmt:message key="story.point3.desc"/></div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-6">
            <img src="https://images.unsplash.com/photo-1414235077428-338989a2e8c0?auto=format&fit=crop&w=1100&q=82" class="img-fluid rounded-4 shadow-lift" alt="Elegant restaurant dining room">
        </div>
    </div>
</section>
<footer class="mt-5 py-5 section-band">
    <div class="container">
        <div class="row g-4 align-items-center">
            <div class="col-lg-6">
                <h5 class="fw-bold mb-2" style="color:var(--accent-dark);">LE ROYAL FINE DINING</h5>
                <p class="muted mb-0"><fmt:message key="footer.desc"/></p>
            </div>
            <div class="col-lg-6 text-lg-end">
                <div class="mb-3">
                    <a href="#" class="btn btn-quiet btn-sm me-2" aria-label="Facebook"><i class="fa-brands fa-facebook"></i></a>
                    <a href="#" class="btn btn-quiet btn-sm me-2" aria-label="Instagram"><i class="fa-brands fa-instagram"></i></a>
                    <a href="#" class="btn btn-quiet btn-sm" aria-label="TikTok"><i class="fa-brands fa-tiktok"></i></a>
                </div>
                <div class="d-flex justify-content-lg-end justify-content-start align-items-center gap-2 mb-2">
                    <button type="button" class="theme-circle-btn" data-day="1" style="background:#00b86b;"></button>
                    <button type="button" class="theme-circle-btn" data-day="2" style="background:#0066ff;"></button>
                    <button type="button" class="theme-circle-btn" data-day="3" style="background:#ff5e00;"></button>
                    <button type="button" class="theme-circle-btn" data-day="4" style="background:#9400d3;"></button>
                    <button type="button" class="theme-circle-btn" data-day="5" style="background:#ff0055;"></button>
                    <button type="button" class="theme-circle-btn" data-day="6" style="background:#d68000;"></button>
                    <button type="button" class="theme-circle-btn" data-day="0" style="background:#e62e6b;"></button>
                </div>
                <span class="muted small">&copy; 2026 <fmt:message key="footer.copyright"/></span>
            </div>
        </div>
    </div>
</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
