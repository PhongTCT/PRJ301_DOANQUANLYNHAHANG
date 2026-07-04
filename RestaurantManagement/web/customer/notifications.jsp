<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="../header.jsp" />

<main class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">Notifications</h3>
            <p class="text-secondary small mb-0">${unreadCount} unread</p>
        </div>
        <c:if test="${unreadCount > 0}">
            <form method="POST" action="${pageContext.request.contextPath}/customer/notifications">
                <input type="hidden" name="action" value="readAll">
                <input type="hidden" name="redirect" value="/customer/notifications">
                <button class="btn btn-sm btn-outline-secondary">Mark all as read</button>
            </form>
        </c:if>
    </div>

    <c:choose>
        <c:when test="${empty notifications}">
            <div class="text-center py-5 text-secondary">
                <i class="fa-regular fa-bell fs-1 mb-3 d-block"></i>
                <p>No notifications yet.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="list-group shadow-sm">
                <c:forEach var="n" items="${notifications}">
                    <div class="list-group-item list-group-item-action d-flex gap-3 py-3 ${not n.isRead ? 'fw-semibold border-start border-3 border-dark' : ''}">
                        <div class="flex-grow-1">
                            <div class="d-flex justify-content-between">
                                <span class="small text-secondary"><fmt:formatDate value="${n.createdAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                                <c:if test="${not n.isRead}">
                                    <form method="POST" action="${pageContext.request.contextPath}/customer/notifications" class="d-inline">
                                        <input type="hidden" name="action" value="read">
                                        <input type="hidden" name="id" value="${n.id}">
                                        <input type="hidden" name="redirect" value="/customer/notifications">
                                        <button class="btn btn-sm btn-link text-secondary p-0 text-decoration-none">Mark read</button>
                                    </form>
                                </c:if>
                            </div>
                            <div class="mb-1">${n.title}</div>
                            <div class="small text-secondary">${n.message}</div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="../footer.jsp" />
