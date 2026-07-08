<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="header.jsp" />

<main class="auth-page">
    <div class="container py-5">
        <div class="row justify-content-center align-items-center g-5">
            <div class="col-lg-6">
                <div class="auth-story pe-lg-4">
                    <span class="badge text-bg-light border text-dark text-uppercase fw-semibold mb-3"><i class="fa-solid fa-lock"></i> Secure access</span>
                    <h1 class="auth-title mb-3">Welcome Back</h1>
                    <p class="auth-copy mb-4">Sign in to keep your booking draft, manage reservations, and continue the dining plan you started.</p>
                    <figure class="auth-visual shadow-lift mb-0">
                        <img src="${pageContext.request.contextPath}/assets/img/le-royal/seating/dining-room.jpg" alt="Le Royal dining room">
                        <figcaption>
                            <span>Le Royal</span>
                            <small>Quiet dining, seasonal rhythm</small>
                        </figcaption>
                    </figure>
                </div>
            </div>
            <div class="col-md-9 col-lg-5">
                <section class="auth-card">
                    <div class="auth-card-header mb-4">
                        <div>
                            <span class="auth-eyebrow">Member entrance</span>
                            <h2>Access your table</h2>
                        </div>
                        <span class="auth-mark" aria-hidden="true">LR</span>
                    </div>
                    <ul class="nav nav-pills nav-fill auth-tabs mb-4" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link fw-semibold ${not showRegisterForm ? 'active' : ''}" id="loginTab" data-bs-toggle="pill" data-bs-target="#loginPanel" type="button" role="tab">Login</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link fw-semibold ${showRegisterForm ? 'active' : ''}" id="registerTab" data-bs-toggle="pill" data-bs-target="#registerPanel" type="button" role="tab">Register</button>
                        </li>
                    </ul>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger py-2 small">${error}</div>
                </c:if>
                <c:if test="${not empty notice}">
                    <div class="alert alert-info py-2 small">${notice}</div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="alert alert-success py-2 small">${success}</div>
                </c:if>

                <c:choose>
                    <c:when test="${showGoogleInfoForm or not empty sessionScope.pendingGoogleLogin}">
                        <c:set var="pendingGoogle" value="${not empty googleDraft ? googleDraft : sessionScope.pendingGoogleLogin}" />
                        <form action="MainController" method="POST">
                            <input type="hidden" name="action" value="registerGoogle">
                            <div class="auth-account-note p-3 mb-4">
                                <div class="d-flex align-items-center gap-3">
                                    <c:if test="${not empty pendingGoogle.avatarUrl}">
                                        <img src="${pendingGoogle.avatarUrl}" class="rounded-circle" style="width:52px;height:52px;object-fit:cover;" alt="Google account avatar">
                                    </c:if>
                                    <div>
                                        <div class="fw-bold">Complete your Google account</div>
                                        <div class="small text-secondary">${pendingGoogle.email}</div>
                                    </div>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Email</label>
                                <input type="email" class="form-control" value="${pendingGoogle.email}" readonly>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Full name</label>
                                <input type="text" name="fullName" class="form-control" value="${pendingGoogle.fullName}" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Phone</label>
                                <input type="tel" name="phone" class="form-control" placeholder="0901234567" required>
                            </div>
                            <div class="mb-4">
                                <label class="form-label small fw-bold">Date of birth</label>
                                <input type="date" name="dateOfBirth" class="form-control">
                            </div>
                            <button type="submit" class="btn btn-dark w-100 py-2">Create account and continue</button>
                            <div class="text-center mt-3">
                                <a href="MainController?action=login&clearGoogleDraft=1" class="small text-secondary">Use another login method</a>
                            </div>
                        </form>
                    </c:when>
                    <c:when test="${showFacebookInfoForm or not empty sessionScope.pendingFacebookLogin}">
                        <c:set var="pendingFacebook" value="${not empty facebookDraft ? facebookDraft : sessionScope.pendingFacebookLogin}" />
                        <form action="MainController" method="POST">
                            <input type="hidden" name="action" value="registerFacebook">
                            <div class="auth-account-note p-3 mb-4">
                                <div class="d-flex align-items-center gap-3">
                                    <c:if test="${not empty pendingFacebook.avatarUrl}">
                                        <img src="${pendingFacebook.avatarUrl}" class="rounded-circle" style="width:52px;height:52px;object-fit:cover;" alt="Facebook account avatar">
                                    </c:if>
                                    <div>
                                        <div class="fw-bold">Complete your Facebook account</div>
                                        <div class="small text-secondary">${pendingFacebook.email}</div>
                                    </div>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Email</label>
                                <input type="email" class="form-control" value="${pendingFacebook.email}" readonly>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Full name</label>
                                <input type="text" name="fullName" class="form-control" value="${pendingFacebook.fullName}" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Phone</label>
                                <input type="tel" name="phone" class="form-control" placeholder="0901234567" required>
                            </div>
                            <div class="mb-4">
                                <label class="form-label small fw-bold">Date of birth</label>
                                <input type="date" name="dateOfBirth" class="form-control">
                            </div>
                            <button type="submit" class="btn btn-dark w-100 py-2">Create account and continue</button>
                            <div class="text-center mt-3">
                                <a href="MainController?action=login&clearFacebookDraft=1" class="small text-secondary">Use another login method</a>
                            </div>
                        </form>
                    </c:when>
                    <c:otherwise>
                <div class="tab-content">
                    <div class="tab-pane fade ${not showRegisterForm ? 'show active' : ''}" id="loginPanel" role="tabpanel">
                        <form action="MainController" method="POST">
                            <input type="hidden" name="action" value="dologin">
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Username or Email</label>
                                <input type="text" name="username" class="form-control" placeholder="admin / admin@restaurant.com" required>
                            </div>
                            <div class="mb-4">
                                <label class="form-label small fw-bold">Password</label>
                                <input type="password" name="password" class="form-control" placeholder="123456" required>
                            </div>
                            <button type="submit" class="btn btn-dark w-100 py-2">Login</button>
                        </form>

                        <div class="d-flex align-items-center gap-3 my-4">
                            <hr class="flex-grow-1 my-0">
                            <span class="small text-secondary">or</span>
                            <hr class="flex-grow-1 my-0">
                        </div>

                        <button type="button" id="googleLoginButton" class="btn btn-outline-dark w-100 d-flex align-items-center justify-content-center gap-2 py-2 shadow-sm" disabled>
                            <span id="googleLoginSpinner" class="spinner-border spinner-border-sm" aria-hidden="true"></span>
                            <i id="googleLoginIcon" class="fa-brands fa-google text-danger d-none"></i>
                            <span id="googleLoginText" class="fw-bold">Loading Google sign-in...</span>
                        </button>
                        <button type="button" id="facebookLoginButton" class="btn btn-outline-primary w-100 d-flex align-items-center justify-content-center gap-2 py-2 shadow-sm mt-2" disabled>
                            <span id="facebookLoginSpinner" class="spinner-border spinner-border-sm" aria-hidden="true"></span>
                            <i id="facebookLoginIcon" class="fa-brands fa-facebook-f d-none"></i>
                            <span id="facebookLoginText" class="fw-bold">Loading Facebook sign-in...</span>
                        </button>
                        <form id="googleLoginForm" action="MainController" method="POST" class="d-none">
                            <input type="hidden" name="action" value="googleLogin">
                            <input type="hidden" name="accessToken" id="googleAccessToken">
                        </form>
                        <form id="facebookLoginForm" action="MainController" method="POST" class="d-none">
                            <input type="hidden" name="action" value="facebookLogin">
                            <input type="hidden" name="facebookAccessToken" id="facebookAccessToken">
                        </form>

                        <div class="auth-account-note p-3 mt-4 small">
                            <div class="fw-bold mb-2">Quick test accounts</div>
                            <div class="mb-1"><code>admin / 123456</code> (admin)</div>
                            <div class="mb-1"><code>staff / 123456</code> (staff)</div>
                            <div><code>customer / 123456</code> (customer)</div>
                        </div>
                    </div>

                    <div class="tab-pane fade ${showRegisterForm ? 'show active' : ''}" id="registerPanel" role="tabpanel">
                        <form action="MainController" method="POST">
                            <input type="hidden" name="action" value="doregister">
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Username</label>
                                <input type="text" name="username" class="form-control" placeholder="Choose a username" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Email</label>
                                <input type="email" name="email" class="form-control" placeholder="your@email.com" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Full Name</label>
                                <input type="text" name="fullName" class="form-control" placeholder="Your full name" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Phone</label>
                                <input type="tel" name="phone" class="form-control" placeholder="0901234567">
                            </div>
                            <div class="mb-4">
                                <label class="form-label small fw-bold">Password</label>
                                <input type="password" name="password" class="form-control" placeholder="At least 6 characters" required>
                            </div>
                            <button type="submit" class="btn btn-dark w-100 py-2">Create Account</button>
                        </form>
                    </div>
                </div>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>
        </div>
    </div>
</main>

<script async defer crossorigin="anonymous" src="https://connect.facebook.net/en_US/sdk.js"></script>
<script src="https://accounts.google.com/gsi/client" async defer></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const googleButton = document.getElementById("googleLoginButton");
        const googleSpinner = document.getElementById("googleLoginSpinner");
        const googleIcon = document.getElementById("googleLoginIcon");
        const googleText = document.getElementById("googleLoginText");
        const facebookButton = document.getElementById("facebookLoginButton");
        const facebookSpinner = document.getElementById("facebookLoginSpinner");
        const facebookIcon = document.getElementById("facebookLoginIcon");
        const facebookText = document.getElementById("facebookLoginText");

        if (!googleButton || !facebookButton) return;

        function setGoogleButtonState(state) {
            if (state === "ready") {
                googleButton.disabled = false;
                googleButton.classList.remove("btn-secondary");
                googleButton.classList.add("btn-outline-dark");
                googleSpinner.classList.add("d-none");
                googleIcon.classList.remove("d-none");
                googleText.textContent = "Continue with Google";
                return;
            }

            if (state === "loading") {
                googleButton.disabled = true;
                googleSpinner.classList.remove("d-none");
                googleIcon.classList.add("d-none");
                googleText.textContent = "Connecting to Google...";
                return;
            }

            googleButton.disabled = true;
            googleButton.classList.remove("btn-outline-dark");
            googleButton.classList.add("btn-secondary");
            googleSpinner.classList.add("d-none");
            googleIcon.classList.remove("d-none");
            googleText.textContent = "Google sign-in unavailable";
        }

        function setFacebookButtonState(state) {
            if (state === "ready") {
                facebookButton.disabled = false;
                facebookSpinner.classList.add("d-none");
                facebookIcon.classList.remove("d-none");
                facebookText.textContent = "Continue with Facebook";
                return;
            }

            if (state === "loading") {
                facebookButton.disabled = true;
                facebookSpinner.classList.remove("d-none");
                facebookIcon.classList.add("d-none");
                facebookText.textContent = "Connecting to Facebook...";
                return;
            }

            facebookButton.disabled = true;
            facebookSpinner.classList.add("d-none");
            facebookIcon.classList.remove("d-none");
            facebookText.textContent = "Facebook sign-in unavailable";
        }

        let googleInitialized = false;
        let googleLoginPending = false;
        let googleLoginTimer = null;

        function initGoogleLogin() {
            if (googleInitialized) {
                return true;
            }
            if (!window.google || !google.accounts || !google.accounts.oauth2) {
                return false;
            }

            const tokenClient = google.accounts.oauth2.initTokenClient({
                client_id: "421816854411-gjtf8gr3ts2v9r866pk2s4n9mc1tvvs0.apps.googleusercontent.com",
                scope: "openid email profile",
                callback: function(response) {
                    googleLoginPending = false;
                    if (googleLoginTimer) {
                        clearTimeout(googleLoginTimer);
                        googleLoginTimer = null;
                    }
                    if (!response || !response.access_token) {
                        setGoogleButtonState("ready");
                        return;
                    }
                    document.getElementById("googleAccessToken").value = response.access_token;
                    document.getElementById("googleLoginForm").submit();
                },
                error_callback: function() {
                    googleLoginPending = false;
                    if (googleLoginTimer) {
                        clearTimeout(googleLoginTimer);
                        googleLoginTimer = null;
                    }
                    setGoogleButtonState("ready");
                }
            });

            googleInitialized = true;
            setGoogleButtonState("ready");
            googleButton.addEventListener("click", function() {
                if (googleLoginPending) {
                    return;
                }
                googleLoginPending = true;
                setGoogleButtonState("loading");
                tokenClient.requestAccessToken({ prompt: "select_account" });
                googleLoginTimer = setTimeout(function() {
                    if (googleLoginPending) {
                        googleLoginPending = false;
                        googleLoginTimer = null;
                        setGoogleButtonState("ready");
                    }
                }, 30000);
            });
            return true;
        }

        let googleAttempts = 0;
        const googleWaiter = setInterval(function() {
            googleAttempts++;
            if (initGoogleLogin()) {
                clearInterval(googleWaiter);
                return;
            }
            if (googleAttempts >= 40) {
                clearInterval(googleWaiter);
                setGoogleButtonState("unavailable");
            }
        }, 200);

        let facebookInitialized = false;
        let facebookLoginPending = false;

        function initFacebookLogin() {
            if (facebookInitialized || !window.FB) {
                return facebookInitialized;
            }

            FB.init({
                appId: "2848239018885988",
                cookie: true,
                xfbml: false,
                version: "v19.0"
            });

            facebookInitialized = true;
            setFacebookButtonState("ready");
            facebookButton.addEventListener("click", function() {
                if (facebookLoginPending) {
                    return;
                }
                facebookLoginPending = true;
                setFacebookButtonState("loading");
                FB.login(function(response) {
                    facebookLoginPending = false;
                    if (!response || !response.authResponse || !response.authResponse.accessToken) {
                        setFacebookButtonState("ready");
                        return;
                    }
                    document.getElementById("facebookAccessToken").value = response.authResponse.accessToken;
                    document.getElementById("facebookLoginForm").submit();
                }, { scope: "public_profile,email" });
                setTimeout(function() {
                    if (facebookLoginPending) {
                        facebookLoginPending = false;
                        setFacebookButtonState("ready");
                    }
                }, 30000);
            });
            return true;
        }

        window.fbAsyncInit = initFacebookLogin;
        initFacebookLogin();

        setTimeout(function() {
            if (!facebookInitialized) {
                setFacebookButtonState("unavailable");
            }
        }, 5000);

    });
</script>
<jsp:include page="footer.jsp" />
