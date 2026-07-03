<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/header.jsp" />
<main class="bg-light py-5" style="min-height:80vh;">
    <div class="container">
        <h2 class="fw-bold mb-4"><i class="fa-solid fa-star me-2 text-warning"></i>Đánh giá của tôi</h2>
        <c:if test="${not empty sessionScope.successMessage}"><div class="alert alert-success">${sessionScope.successMessage}</div><c:remove var="successMessage" scope="session"/></c:if>
        <c:if test="${not empty sessionScope.errorMessage}"><div class="alert alert-danger">${sessionScope.errorMessage}</div><c:remove var="errorMessage" scope="session"/></c:if>

        <div class="row g-4">
            <div class="col-lg-5">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white fw-bold">Gửi đánh giá</div>
                    <div class="card-body">
                        <form method="post" action="${pageContext.request.contextPath}/customer/reviews">
                            <div class="mb-3">
                                <label class="form-label">Đơn đã hoàn thành</label>
                                <select name="reservationId" class="form-select" required>
                                    <option value="">Chọn mã đặt bàn</option>
                                    <c:forEach items="${myReservations}" var="r">
                                        <c:if test="${r.status == 'COMPLETED'}">
                                            <option value="${r.id}">#${r.id} - <fmt:formatDate value="${r.reservationDate}" pattern="dd/MM/yyyy"/></option>
                                        </c:if>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="mb-3"><label class="form-label">Số sao</label><input type="number" name="rating" class="form-control" min="1" max="5" value="5" required></div>
                            <div class="mb-3"><label class="form-label">Hình ảnh URL</label><input name="imageUrl" class="form-control" placeholder="https://..."></div>
                            <div class="mb-3"><label class="form-label">Nội dung</label><textarea name="comment" class="form-control" rows="5" required></textarea></div>
                            <button class="btn btn-primary w-100"><i class="fa-solid fa-paper-plane me-2"></i>Gửi đánh giá</button>
                        </form>
                    </div>
                </div>
            </div>
            <div class="col-lg-7">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white fw-bold">Lịch sử đánh giá</div>
                    <div class="card-body">
                        <c:forEach items="${myReviews}" var="r">
                            <div class="border-bottom pb-3 mb-3">
                                <div class="d-flex justify-content-between">
                                    <strong>Reservation #${r.reservation.id}</strong>
                                    <span class="badge ${r.isVisible ? 'bg-success' : 'bg-secondary'}">${r.isVisible ? 'Đã duyệt' : 'Chờ duyệt'}</span>
                                </div>
                                <div class="text-warning my-1"><c:forEach begin="1" end="${r.rating}"><i class="fa-solid fa-star"></i></c:forEach></div>
                                <p class="mb-1">${r.comment}</p>
                                <div class="small text-muted"><fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm"/></div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty myReviews}"><div class="text-center text-muted py-4">Bạn chưa có đánh giá nào.</div></c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>
<jsp:include page="/footer.jsp" />
