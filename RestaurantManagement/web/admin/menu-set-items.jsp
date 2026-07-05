<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/header.jsp" />
<main class="container py-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
            <p class="text-uppercase text-secondary small mb-1">Restaurant Admin</p>
            <h1 class="h3 mb-0">Choose dishes for set menus</h1>
        </div>
        <div class="btn-group">
            <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminMenuSets">Menu sets</a>
            <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminMenuItems">Menu items</a>
        </div>
    </div>
    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
    <c:if test="${param.saved == '1'}"><div class="alert alert-success">Saved successfully. Original set price was recalculated.</div></c:if>
    <div class="row g-4">
        <div class="col-lg-4">
            <form class="border rounded-3 p-4 bg-light" method="post" action="MainController">
                <input type="hidden" name="action" value="saveMenuSetItem">
                <input type="hidden" name="id" value="${editMenuSetItem.id}">
                <h2 class="h5 mb-3">${empty editMenuSetItem ? 'Add item to set' : 'Edit set item'}</h2>
                <label class="form-label">Menu set</label>
                <select class="form-select mb-3" name="menuSetId" required>
                    <c:forEach items="${menuSets}" var="set">
                        <option value="${set.id}" ${(not empty editMenuSetItem && editMenuSetItem.menuSet.id == set.id) || (empty editMenuSetItem && param.menuSetId == set.id) ? 'selected' : ''}>${not empty set.setNameVi ? set.setNameVi : set.setName}</option>
                    </c:forEach>
                </select>
                <label class="form-label">Menu item</label>
                <select class="form-select mb-3" name="menuItemId" required>
                    <c:forEach items="${categories}" var="category">
                        <optgroup label="${category.categoryName}">
                            <c:forEach items="${menuItems}" var="item">
                                <c:if test="${not empty item.category && item.category.id == category.id}">
                                    <option value="${item.id}" ${not empty editMenuSetItem && editMenuSetItem.menuItem.id == item.id ? 'selected' : ''}>${item.itemName}</option>
                                </c:if>
                            </c:forEach>
                        </optgroup>
                    </c:forEach>
                </select>
                <label class="form-label">Default size</label>
                <select class="form-select mb-3" name="defaultSizeId">
                    <option value="">No default size</option>
                    <c:forEach items="${menuItems}" var="item">
                        <optgroup label="${item.itemName}">
                            <c:forEach items="${sizes}" var="size">
                                <c:if test="${not empty size.menuItem && size.menuItem.id == item.id}">
                                    <option value="${size.id}" ${not empty editMenuSetItem && not empty editMenuSetItem.defaultSize && editMenuSetItem.defaultSize.id == size.id ? 'selected' : ''}>${size.sizeName}</option>
                                </c:if>
                            </c:forEach>
                        </optgroup>
                    </c:forEach>
                </select>
                <label class="form-label">Course name (VI, optional)</label>
                <input class="form-control mb-3" name="courseNameVi" value="${editMenuSetItem.courseNameVi}">
                <label class="form-label">Course name (EN, optional)</label>
                <input class="form-control mb-3" name="courseName" value="${editMenuSetItem.courseName}">
                <label class="form-label">Quantity</label>
                <input class="form-control mb-3" name="quantity" type="number" min="1" value="${empty editMenuSetItem ? 1 : editMenuSetItem.quantity}" required>
                <button class="btn btn-dark w-100" type="submit">Save</button>
            </form>
        </div>
        <div class="col-lg-8">
            <div class="table-responsive">
                <table class="table align-middle">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Set</th>
                            <th>Item</th>
                            <th>Default size</th>
                            <th>Qty</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${menuSetItemList}" var="setItem">
                            <tr>
                                <td>${setItem.id}</td>
                                <td><strong>${not empty setItem.menuSet.setNameVi ? setItem.menuSet.setNameVi : setItem.menuSet.setName}</strong></td>
                                <td>${not empty setItem.courseNameVi ? setItem.courseNameVi : (not empty setItem.menuItem.itemNameVi ? setItem.menuItem.itemNameVi : setItem.menuItem.itemName)}</td>
                                <td><c:out value="${empty setItem.defaultSize ? 'None' : setItem.defaultSize.sizeName}" /></td>
                                <td>${setItem.quantity}</td>
                                <td class="text-end">
                                    <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminMenuSetItems&id=${setItem.id}">Edit</a>
                                    <a class="btn btn-outline-danger btn-sm" href="MainController?action=deleteMenuSetItem&id=${setItem.id}" onclick="return confirm('Remove this item from the set?')">Remove</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>
<jsp:include page="/footer.jsp" />
