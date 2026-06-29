<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:if test="${not empty param.lang}">
    <c:set var="lang" value="${param.lang}" scope="session" />
</c:if>
<c:if test="${empty sessionScope.lang}">
    <c:set var="lang" value="vi" scope="session" />
</c:if>
<fmt:setLocale value="${sessionScope.lang}" scope="session" />
<fmt:setBundle basename="i18n.messages" scope="session" />
<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Le Royal - Restaurant Booking</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@100;300;400;500;700&family=Noto+Serif:wght@400;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --page-bg: #f7fbf8;
            --surface: #ffffff;
            --surface-tint: #effaf4;
            --ink: #17312b;
            --muted: #65756f;
            --line: #dbe9e2;
            --accent: #12805c;
            --accent-dark: #0b5f45;
            --accent-soft: #dcf5e8;
            --coral: #f27a5e;
            --sun: #f6c85f;
            --shadow: 0 18px 48px rgba(30, 84, 64, 0.12);
            --btn-shadow: 0 10px 24px rgba(18, 128, 92, 0.22);
            --border-outline: rgba(18, 128, 92, 0.34);
            --focus-ring: 0 0 0 0.22rem rgba(18, 128, 92, 0.16);
            --surface-shadow: 0 12px 30px rgba(22, 68, 52, 0.08);
            --price-bg: #fff8df;
            --price-color: #806118;
            --price-border: #f3dfa3;
            --radius: 18px;
        }

        * {
            letter-spacing: 0;
        }

        body, .btn, .surface, .navbar-custom, .eyebrow, .badge, .category-pill, code, .nav-link, .brand-mark, .hero-stat {
            transition: background-color 0.4s ease, color 0.4s ease, border-color 0.4s ease, box-shadow 0.4s ease !important;
        }

        body {
            font-family: 'Be Vietnam Pro', sans-serif;
            background: var(--page-bg);
            color: var(--ink);
            min-height: 100vh;
        }

        a {
            text-decoration: none;
        }

        .navbar-custom {
            background: rgba(255, 255, 255, 0.92);
            backdrop-filter: blur(16px);
            border-bottom: 1px solid var(--line);
            min-height: 72px;
        }

        .navbar-brand {
            color: var(--accent-dark) !important;
            font-weight: 800;
            font-size: 1.35rem;
        }

        .brand-mark {
            width: 38px;
            height: 38px;
            border-radius: 12px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: var(--accent-soft);
            color: var(--accent-dark);
            margin-right: 8px;
        }

        .nav-link {
            color: var(--ink) !important;
            font-weight: 600;
            border-radius: 999px;
            padding: 8px 14px !important;
        }

        .nav-link:hover,
        .nav-link:focus {
            color: var(--accent-dark) !important;
            background: var(--accent-soft);
        }

        .navbar-toggler {
            border-color: var(--line);
            color: var(--accent-dark);
        }

        .btn-brand {
            background: var(--accent);
            color: #ffffff;
            border: 1px solid var(--accent);
            border-radius: 999px;
            font-weight: 800;
            box-shadow: var(--btn-shadow);
        }

        .btn-brand:hover,
        .btn-brand:focus {
            background: var(--accent-dark);
            border-color: var(--accent-dark);
            color: #ffffff;
        }

        .btn-quiet {
            background: #ffffff;
            color: var(--accent-dark);
            border: 1px solid var(--line);
            border-radius: 999px;
            font-weight: 800;
        }

        .btn-quiet:hover,
        .btn-quiet:focus {
            color: var(--accent-dark);
            border-color: var(--accent);
            background: var(--accent-soft);
        }

        .btn-outline-brand {
            background: #ffffff;
            color: var(--accent-dark);
            border: 1px solid var(--border-outline);
            border-radius: 999px;
            font-weight: 800;
        }

        .btn-outline-brand:hover,
        .btn-outline-brand:focus {
            color: #ffffff;
            background: var(--accent);
            border-color: var(--accent);
        }

        .language-switcher .language-btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            min-height: 32px;
            line-height: 1;
            font-weight: 700 !important;
        }

        .flag {
            position: relative;
            display: inline-block;
            width: 22px;
            height: 15px;
            border-radius: 2px;
            overflow: hidden;
            flex: 0 0 auto;
            box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.14) inset;
        }

        .flag-vn {
            background: #da251d;
        }

        .flag-vn::before {
            content: "";
            position: absolute;
            width: 8px;
            height: 8px;
            left: 50%;
            top: 50%;
            background: #ffdd00;
            transform: translate(-50%, -50%);
            clip-path: polygon(50% 0%, 61% 35%, 98% 35%, 68% 56%, 79% 91%, 50% 69%, 21% 91%, 32% 56%, 2% 35%, 39% 35%);
        }

        .flag-us {
            background: repeating-linear-gradient(
                to bottom,
                #b22234 0,
                #b22234 1.15px,
                #ffffff 1.15px,
                #ffffff 2.3px
            );
        }

        .flag-us::before {
            content: "";
            position: absolute;
            left: 0;
            top: 0;
            width: 10px;
            height: 8px;
            background: #3c3b6e;
        }

        .flag-us::after {
            content: "";
            position: absolute;
            left: 1.5px;
            top: 1.2px;
            width: 7px;
            height: 5.5px;
            background-image: radial-gradient(#ffffff 0.6px, transparent 0.7px);
            background-size: 2.4px 2px;
        }

        .surface {
            background: var(--surface);
            border: 1px solid var(--line);
            border-radius: var(--radius);
            box-shadow: var(--surface-shadow);
        }

        .surface-soft {
            background: var(--surface-tint);
            border: 1px solid var(--line);
            border-radius: var(--radius);
        }

        .muted {
            color: var(--muted);
        }

        .eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 12px;
            border-radius: 999px;
            background: var(--accent-soft);
            color: var(--accent-dark);
            font-weight: 800;
            font-size: 0.82rem;
        }

        .hero {
            min-height: 620px;
            display: flex;
            align-items: center;
            background:
                linear-gradient(90deg, color-mix(in srgb, var(--page-bg) 98%, transparent) 0%, color-mix(in srgb, var(--page-bg) 88%, transparent) 43%, color-mix(in srgb, var(--page-bg) 24%, transparent) 100%),
                url('https://images.unsplash.com/photo-1551218808-94e220e084d2?auto=format&fit=crop&w=1800&q=82') center/cover;
            border-bottom: 1px solid var(--line);
        }

        .hero-panel {
            max-width: 620px;
        }

        .hero-title {
            font-size: clamp(3rem, 7vw, 5.9rem);
            line-height: 0.96;
            font-weight: 800;
            color: var(--ink);
        }

        h1, h2, .logo, .navbar-brand, .hero-title, .btn, .btn-brand, .eyebrow {
            font-family: 'Noto Serif', 'Be Vietnam Pro', serif !important;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }

        .hero-copy {
            color: #43534d;
            font-size: 1.15rem;
            line-height: 1.7;
            max-width: 54ch;
        }

        .hero-stat {
            background: rgba(255, 255, 255, 0.86);
            border: 1px solid var(--line);
            border-radius: 16px;
            padding: 14px 16px;
            box-shadow: var(--shadow);
        }

        .price-badge {
            background: var(--price-bg);
            color: var(--price-color);
            border: 1px solid var(--price-border);
            border-radius: 999px;
            font-weight: 800;
        }

        .category-pill {
            background: var(--accent-soft);
            color: var(--accent-dark);
            border-radius: 999px;
            font-weight: 800;
            padding: 6px 10px;
        }

        .table-code {
            font-size: 1.55rem;
            line-height: 1;
            font-weight: 800;
        }

        .card-image {
            width: 100%;
            height: 170px;
            object-fit: cover;
            border-radius: 14px;
            border: 1px solid var(--line);
        }

        .section-band {
            background: #ffffff;
            border-top: 1px solid var(--line);
            border-bottom: 1px solid var(--line);
        }

        .form-control,
        .form-select {
            border-color: var(--line);
            border-radius: 14px;
            color: var(--ink);
            min-height: 46px;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: var(--accent);
            box-shadow: var(--focus-ring);
        }

        code {
            color: var(--accent-dark);
            background: var(--accent-soft);
            border-radius: 8px;
            padding: 2px 6px;
        }

        .shadow-lift {
            box-shadow: var(--shadow);
        }

        .theme-circle-btn {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            border: 2px solid #ffffff;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.18);
            cursor: pointer;
            padding: 0;
            outline: none;
            transition: transform 0.25s cubic-bezier(0.34, 1.56, 0.64, 1), box-shadow 0.25s ease, border-color 0.25s ease !important;
        }

        .theme-circle-btn:hover {
            transform: scale(1.25);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.28);
        }

        .theme-circle-btn.active {
            transform: scale(1.35);
            border: 2px solid var(--ink);
            box-shadow: 0 0 0 2px var(--surface), 0 4px 12px rgba(0, 0, 0, 0.3);
        }

        @media (max-width: 767px) {
            .hero {
                min-height: auto;
                padding: 72px 0;
                background:
                    linear-gradient(180deg, color-mix(in srgb, var(--page-bg) 98%, transparent), color-mix(in srgb, var(--page-bg) 82%, transparent)),
                    url('https://images.unsplash.com/photo-1551218808-94e220e084d2?auto=format&fit=crop&w=1100&q=80') center/cover;
            }

            .hero-title {
                font-size: 3.25rem;
            }

            .navbar-collapse {
                padding: 16px 0;
            }

        }
    </style>
    <script>
        (function() {
            const themes = {
                1: { name: "Thứ 2: Cyber Mint", icon: '<i class="fa-solid fa-leaf"></i>', accent: "#00b86b", accentDark: "#00824b", accentSoft: "#e0fbed", pageBg: "#f3fef8", surfaceTint: "#ebfdf3", line: "#bdf5d8", shadow: "0 18px 48px rgba(0, 184, 107, 0.16)", btnShadow: "0 10px 24px rgba(0, 184, 107, 0.28)", borderOutline: "rgba(0, 184, 107, 0.42)", focusRing: "0 0 0 0.22rem rgba(0, 184, 107, 0.22)", surfaceShadow: "0 12px 30px rgba(0, 184, 107, 0.1)", priceBg: "#e0fbed", priceColor: "#00683b", priceBorder: "#94f3c3" },
                2: { name: "Thứ 3: Electric Blue", icon: '<i class="fa-solid fa-bolt"></i>', accent: "#0066ff", accentDark: "#0048b5", accentSoft: "#e5f0ff", pageBg: "#f4f8ff", surfaceTint: "#edf4ff", line: "#cce0ff", shadow: "0 18px 48px rgba(0, 102, 255, 0.16)", btnShadow: "0 10px 24px rgba(0, 102, 255, 0.28)", borderOutline: "rgba(0, 102, 255, 0.42)", focusRing: "0 0 0 0.22rem rgba(0, 102, 255, 0.22)", surfaceShadow: "0 12px 30px rgba(0, 102, 255, 0.1)", priceBg: "#e5f0ff", priceColor: "#00388c", priceBorder: "#a3c9ff" },
                3: { name: "Thứ 4: Neon Orange", icon: '<i class="fa-solid fa-fire"></i>', accent: "#ff5e00", accentDark: "#ba4500", accentSoft: "#ffede5", pageBg: "#fffaf7", surfaceTint: "#fff4ed", line: "#ffd5c2", shadow: "0 18px 48px rgba(255, 94, 0, 0.16)", btnShadow: "0 10px 24px rgba(255, 94, 0, 0.28)", borderOutline: "rgba(255, 94, 0, 0.42)", focusRing: "0 0 0 0.22rem rgba(255, 94, 0, 0.22)", surfaceShadow: "0 12px 30px rgba(255, 94, 0, 0.1)", priceBg: "#ffede5", priceColor: "#9c3600", priceBorder: "#ffb48f" },
                4: { name: "Thứ 5: Cyber Violet", icon: '<i class="fa-solid fa-wand-magic-sparkles"></i>', accent: "#9400d3", accentDark: "#680094", accentSoft: "#f5e5ff", pageBg: "#faf5ff", surfaceTint: "#f7edff", line: "#e8c7ff", shadow: "0 18px 48px rgba(148, 0, 211, 0.16)", btnShadow: "0 10px 24px rgba(148, 0, 211, 0.28)", borderOutline: "rgba(148, 0, 211, 0.42)", focusRing: "0 0 0 0.22rem rgba(148, 0, 211, 0.22)", surfaceShadow: "0 12px 30px rgba(148, 0, 211, 0.1)", priceBg: "#f5e5ff", priceColor: "#58007d", priceBorder: "#d8a1ff" },
                5: { name: "Thứ 6: Passion Pink", icon: '<i class="fa-solid fa-champagne-glasses"></i>', accent: "#ff0055", accentDark: "#b8003d", accentSoft: "#ffe5ed", pageBg: "#fff7f9", surfaceTint: "#fff0f4", line: "#ffc2d4", shadow: "0 18px 48px rgba(255, 0, 85, 0.16)", btnShadow: "0 10px 24px rgba(255, 0, 85, 0.28)", borderOutline: "rgba(255, 0, 85, 0.42)", focusRing: "0 0 0 0.22rem rgba(255, 0, 85, 0.22)", surfaceShadow: "0 12px 30px rgba(255, 0, 85, 0.1)", priceBg: "#ffe5ed", priceColor: "#990033", priceBorder: "#ff99b8" },
                6: { name: "Thứ 7: Vivid Gold", icon: '<i class="fa-solid fa-crown"></i>', accent: "#d68000", accentDark: "#965a00", accentSoft: "#fff5e0", pageBg: "#fffcf5", surfaceTint: "#fff9eb", line: "#ffe3a8", shadow: "0 18px 48px rgba(214, 128, 0, 0.16)", btnShadow: "0 10px 24px rgba(214, 128, 0, 0.28)", borderOutline: "rgba(214, 128, 0, 0.42)", focusRing: "0 0 0 0.22rem rgba(214, 128, 0, 0.22)", surfaceShadow: "0 12px 30px rgba(214, 128, 0, 0.1)", priceBg: "#fff5e0", priceColor: "#7a4900", priceBorder: "#ffd480" },
                0: { name: "Chủ nhật: Coral Flamingo", icon: '<i class="fa-solid fa-heart"></i>', accent: "#e62e6b", accentDark: "#a61c49", accentSoft: "#fde8f0", pageBg: "#fef8fa", surfaceTint: "#fdf2f6", line: "#fbccd8", shadow: "0 18px 48px rgba(230, 46, 107, 0.16)", btnShadow: "0 10px 24px rgba(230, 46, 107, 0.28)", borderOutline: "rgba(230, 46, 107, 0.42)", focusRing: "0 0 0 0.22rem rgba(230, 46, 107, 0.22)", surfaceShadow: "0 12px 30px rgba(230, 46, 107, 0.1)", priceBg: "#fde8f0", priceColor: "#8c143a", priceBorder: "#f9a6c0" }
            };
            const savedDay = localStorage.getItem('leRoyal_overrideDay');
            const todayDay = new Date().getDay();
            const activeDay = (savedDay !== null && savedDay !== undefined) ? parseInt(savedDay) : todayDay;
            const t = themes[activeDay] || themes[1];
            
            const root = document.documentElement;
            root.style.setProperty('--accent', t.accent);
            root.style.setProperty('--accent-dark', t.accentDark);
            root.style.setProperty('--accent-soft', t.accentSoft);
            root.style.setProperty('--page-bg', t.pageBg);
            root.style.setProperty('--surface-tint', t.surfaceTint);
            root.style.setProperty('--line', t.line);
            root.style.setProperty('--shadow', t.shadow);
            root.style.setProperty('--btn-shadow', t.btnShadow);
            root.style.setProperty('--border-outline', t.borderOutline);
            root.style.setProperty('--focus-ring', t.focusRing);
            root.style.setProperty('--surface-shadow', t.surfaceShadow);
            root.style.setProperty('--price-bg', t.priceBg);
            root.style.setProperty('--price-color', t.priceColor);
            root.style.setProperty('--price-border', t.priceBorder);
            
            window.leRoyalTheme = { activeDay, todayDay, themes };
        })();
    </script>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-custom sticky-top">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="MainController?action=home">
            <span class="brand-mark"><i class="fa-solid fa-utensils"></i></span>
            LE ROYAL
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-label="Toggle navigation">
            <i class="fa-solid fa-bars"></i>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mx-auto gap-lg-1">
                <li class="nav-item"><a class="nav-link" href="MainController?action=home"><fmt:message key="nav.home"/></a></li>
                <li class="nav-item"><a class="nav-link" href="MainController?action=menu"><fmt:message key="nav.menu"/></a></li>
                <li class="nav-item"><a class="nav-link" href="MainController?action=booking"><fmt:message key="nav.booking"/></a></li>
            </ul>
            <div class="d-flex align-items-center gap-2">
                <div class="btn-group me-1 language-switcher" role="group" aria-label="Language switcher">
                    <a href="MainController?action=${not empty param.action ? param.action : 'home'}&lang=vi" class="btn btn-sm language-btn ${sessionScope.lang == 'vi' ? 'btn-brand' : 'btn-quiet'} px-2 py-1" style="border-radius: 6px 0 0 6px;">
                        <span class="flag flag-vn" aria-hidden="true"></span>
                        <span>VI</span>
                    </a>
                    <a href="MainController?action=${not empty param.action ? param.action : 'home'}&lang=en" class="btn btn-sm language-btn ${sessionScope.lang == 'en' ? 'btn-brand' : 'btn-quiet'} px-2 py-1" style="border-radius: 0 6px 6px 0;">
                        <span class="flag flag-us" aria-hidden="true"></span>
                        <span>EN</span>
                    </a>
                </div>
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser}">
                        <span class="small muted">
                            <i class="fa-regular fa-user me-1" style="color: var(--accent);"></i>${sessionScope.currentUser.fullName}
                        </span>
                        <a href="MainController?action=logout" class="btn btn-quiet btn-sm px-3"><fmt:message key="nav.logout"/></a>
                    </c:when>
                    <c:otherwise>
                        <a href="MainController?action=login" class="btn btn-brand btn-sm px-4"><fmt:message key="nav.login"/></a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        if (!window.leRoyalTheme) return;
        const { activeDay, todayDay, themes } = window.leRoyalTheme;
        
        function updateThemeUI(day) {
            document.querySelectorAll('.theme-circle-btn').forEach(function(btn) {
                if (btn.getAttribute('data-day') == day) {
                    btn.classList.add('active');
                } else {
                    btn.classList.remove('active');
                }
            });
        }
        
        function applyTheme(day) {
            const t = themes[day] || themes[1];
            const root = document.documentElement;
            root.style.setProperty('--accent', t.accent);
            root.style.setProperty('--accent-dark', t.accentDark);
            root.style.setProperty('--accent-soft', t.accentSoft);
            root.style.setProperty('--page-bg', t.pageBg);
            root.style.setProperty('--surface-tint', t.surfaceTint);
            root.style.setProperty('--line', t.line);
            root.style.setProperty('--shadow', t.shadow);
            root.style.setProperty('--btn-shadow', t.btnShadow);
            root.style.setProperty('--border-outline', t.borderOutline);
            root.style.setProperty('--focus-ring', t.focusRing);
            root.style.setProperty('--surface-shadow', t.surfaceShadow);
            root.style.setProperty('--price-bg', t.priceBg);
            root.style.setProperty('--price-color', t.priceColor);
            root.style.setProperty('--price-border', t.priceBorder);
            updateThemeUI(day);
        }
        
        updateThemeUI(activeDay);
        
        document.querySelectorAll('.theme-circle-btn').forEach(function(item) {
            item.addEventListener('click', function(e) {
                e.preventDefault();
                const selectedDay = this.getAttribute('data-day');
                if (selectedDay == todayDay) {
                    localStorage.removeItem('leRoyal_overrideDay');
                } else {
                    localStorage.setItem('leRoyal_overrideDay', selectedDay);
                }
                applyTheme(selectedDay);
            });
        });
    });
</script>
