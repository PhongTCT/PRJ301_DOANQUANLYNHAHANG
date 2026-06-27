<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Le Royal - Restaurant Booking</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
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
            --radius: 18px;
        }

        * {
            letter-spacing: 0;
        }

        body {
            font-family: 'Outfit', Arial, sans-serif;
            background:
                linear-gradient(180deg, #f3fbf6 0%, #ffffff 42%, #f7fbf8 100%);
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
            box-shadow: 0 10px 24px rgba(18, 128, 92, 0.22);
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
            border: 1px solid rgba(18, 128, 92, 0.34);
            border-radius: 999px;
            font-weight: 800;
        }

        .btn-outline-brand:hover,
        .btn-outline-brand:focus {
            color: #ffffff;
            background: var(--accent);
            border-color: var(--accent);
        }

        .surface {
            background: var(--surface);
            border: 1px solid var(--line);
            border-radius: var(--radius);
            box-shadow: 0 12px 30px rgba(22, 68, 52, 0.08);
        }

        .surface-soft {
            background: var(--surface-tint);
            border: 1px solid #d2ebde;
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
                linear-gradient(90deg, rgba(247, 251, 248, 0.98) 0%, rgba(247, 251, 248, 0.88) 43%, rgba(247, 251, 248, 0.24) 100%),
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
            background: #fff8df;
            color: #806118;
            border: 1px solid #f3dfa3;
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
            box-shadow: 0 0 0 0.22rem rgba(18, 128, 92, 0.16);
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

        @media (max-width: 767px) {
            .hero {
                min-height: auto;
                padding: 72px 0;
                background:
                    linear-gradient(180deg, rgba(247, 251, 248, 0.98), rgba(247, 251, 248, 0.82)),
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
                <li class="nav-item"><a class="nav-link" href="MainController?action=home">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="MainController?action=menu">Menu</a></li>
                <li class="nav-item"><a class="nav-link" href="MainController?action=booking">Booking</a></li>
            </ul>
            <div class="d-flex align-items-center gap-2">
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser}">
                        <span class="small muted">
                            <i class="fa-regular fa-user me-1 text-success"></i>${sessionScope.currentUser.fullName}
                        </span>
                        <a href="MainController?action=logout" class="btn btn-quiet btn-sm px-3">Logout</a>
                    </c:when>
                    <c:otherwise>
                        <a href="MainController?action=login" class="btn btn-brand btn-sm px-4">Login</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>
