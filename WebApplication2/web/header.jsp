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
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-main: #111317;
            --bg-panel: #191d24;
            --line: rgba(255, 255, 255, 0.1);
            --gold: #d4af37;
            --gold-soft: #f4df8b;
            --text-main: #edf1f6;
            --text-muted: #aab2c0;
            --green: #35b779;
            --red: #e25563;
        }
        body {
            font-family: 'Outfit', Arial, sans-serif;
            background: var(--bg-main);
            color: var(--text-main);
            letter-spacing: 0;
        }
        .navbar-custom {
            background: rgba(17, 19, 23, 0.96);
            border-bottom: 1px solid rgba(212, 175, 55, 0.22);
        }
        .navbar-brand {
            color: var(--gold) !important;
            font-weight: 700;
            font-size: 1.35rem;
        }
        .nav-link {
            color: var(--text-main) !important;
        }
        .nav-link:hover, .nav-link:focus {
            color: var(--gold-soft) !important;
        }
        .btn-gold {
            background: var(--gold);
            color: #111317;
            border: 0;
            font-weight: 700;
        }
        .btn-gold:hover {
            background: var(--gold-soft);
            color: #111317;
        }
        .surface {
            background: var(--bg-panel);
            border: 1px solid var(--line);
            border-radius: 8px;
        }
        .muted {
            color: var(--text-muted);
        }
        .hero {
            min-height: 520px;
            background:
                linear-gradient(90deg, rgba(17,19,23,0.88), rgba(17,19,23,0.52)),
                url('https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=1800&q=80') center/cover;
            display: flex;
            align-items: center;
        }
        .price-badge {
            background: rgba(212, 175, 55, 0.16);
            color: var(--gold-soft);
            border: 1px solid rgba(212, 175, 55, 0.35);
        }
        .table-code {
            font-size: 1.5rem;
            font-weight: 700;
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-custom sticky-top">
    <div class="container">
        <a class="navbar-brand" href="MainController?action=home">
            <i class="fa-solid fa-utensils me-2"></i>LE ROYAL
        </a>
        <button class="navbar-toggler text-white" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-label="Toggle navigation">
            <i class="fa-solid fa-bars"></i>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mx-auto">
                <li class="nav-item"><a class="nav-link" href="MainController?action=home">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="MainController?action=menu">Menu</a></li>
                <li class="nav-item"><a class="nav-link" href="MainController?action=booking">Booking</a></li>
            </ul>
            <div class="d-flex align-items-center gap-2">
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser}">
                        <span class="small muted">
                            <i class="fa-regular fa-user me-1 text-warning"></i>${sessionScope.currentUser.fullName}
                        </span>
                        <a href="MainController?action=logout" class="btn btn-outline-light btn-sm">Logout</a>
                    </c:when>
                    <c:otherwise>
                        <a href="MainController?action=login" class="btn btn-gold btn-sm">Login</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>
