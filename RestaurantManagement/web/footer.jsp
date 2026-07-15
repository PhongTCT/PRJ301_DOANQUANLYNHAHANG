<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:if test="${param.embed != '1'}">
<footer class="bg-dark text-light py-5">
    <div class="container">
        <div class="row g-5">
            <div class="col-lg-5">
                <h5 class="brand-text text-light mb-3">Le Royal</h5>
                <p class="text-secondary mb-4"><fmt:message key="footer.desc"/></p>
                <div class="d-flex gap-2">
                    <a href="#" class="btn btn-outline-secondary btn-sm" aria-label="Facebook"><i class="fa-brands fa-facebook"></i></a>
                    <a href="#" class="btn btn-outline-secondary btn-sm" aria-label="Instagram"><i class="fa-brands fa-instagram"></i></a>
                    <a href="#" class="btn btn-outline-secondary btn-sm" aria-label="TikTok"><i class="fa-brands fa-tiktok"></i></a>
                </div>
            </div>
            <div class="col-sm-6 col-lg-3">
                <div class="footer-heading small text-uppercase mb-3"><fmt:message key="footer.visit"/></div>
                <p class="text-secondary mb-1"><fmt:message key="footer.address1"/></p>
                <p class="text-secondary mb-0"><fmt:message key="footer.address2"/></p>
            </div>
            <div class="col-sm-6 col-lg-2">
                <div class="footer-heading small text-uppercase mb-3"><fmt:message key="footer.hours"/></div>
                <p class="text-secondary mb-0"><fmt:message key="footer.dinner"/></p>
            </div>
            <div class="col-lg-2">
                <div class="footer-heading small text-uppercase mb-3"><fmt:message key="footer.contact"/></div>
                <p class="text-secondary mb-1">0900 888 777</p>
                <p class="text-secondary mb-0">booking@leroyal.vn</p>
            </div>
        </div>
        <div class="border-top border-secondary border-opacity-25 mt-5 pt-4 d-flex flex-wrap justify-content-between gap-2">
            <span class="text-secondary small"><fmt:message key="footer.copyright"/></span>
            <span class="text-secondary small"><fmt:message key="footer.links"/></span>
        </div>
    </div>
</footer>
</c:if>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<c:if test="${param.embed == '1'}">
<script>
    document.addEventListener('DOMContentLoaded', function () {
        document.querySelectorAll('form').forEach(function (form) {
            if (!form.querySelector('input[name="embed"]')) {
                var input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'embed';
                input.value = '1';
                form.appendChild(input);
            }
        });
        document.querySelectorAll('a[href]').forEach(function (link) {
            var href = link.getAttribute('href');
            if (!href || href.indexOf('#') === 0 || href.indexOf('javascript:') === 0 || href.indexOf('embed=1') !== -1) {
                return;
            }
            if (href.indexOf('MainController') !== -1 || href.indexOf('AdminRestaurantController') !== -1) {
                link.setAttribute('href', href + (href.indexOf('?') === -1 ? '?' : '&') + 'embed=1');
            }
        });
    });
</script>
</c:if>
</body>
</html>
