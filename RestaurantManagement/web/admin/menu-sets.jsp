<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setLocale value="${sessionScope.lang == 'vi' ? 'vi_VN' : 'en_US'}" />
<fmt:setBundle basename="i18n.messages" />
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="${sessionScope.lang}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><fmt:message key="admin.menusets.title" /> - Le Royal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Marcellus&family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-royal.css?v=menu-confirm-compact">
</head>
<body class="admin-royal">
<div class="d-flex">
    <jsp:include page="/admin/sidebar.jsp">
        <jsp:param name="active" value="menu-sets"/>
    </jsp:include>
    <main class="flex-grow-1">
        <div class="admin-shell py-4">
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
            <p class="text-uppercase text-secondary small mb-1"><fmt:message key="admin.dashboard.workspace.title" /></p>
            <h1 class="h3 mb-0"><fmt:message key="admin.menusets.title" /></h1>
        </div>
        <div class="btn-group">
            <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminMenuItems"><fmt:message key="admin.menuitems.title" /></a>
            <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminCategories"><fmt:message key="admin.categories.title" /></a>
            <button class="btn btn-dark btn-sm" type="button" data-bs-toggle="collapse" data-bs-target="#setFormPanel" aria-expanded="${not empty editMenuSet ? 'true' : 'false'}">
                <i class="fa-solid fa-plus me-2"></i><fmt:message key="admin.menusets.btn.add" />
            </button>
        </div>
    </div>

    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
    <c:if test="${param.saved == '1'}"><div class="alert alert-success"><fmt:message key="admin.common.saved.success" /></div></c:if>

    <c:if test="${empty selectedMenuSet || param.mode == 'details'}">
    <section id="setFormPanel" class="collapse ${not empty editMenuSet ? 'show' : ''} mb-4">
        <form id="setEditorForm" class="card" method="post" action="MainController" enctype="multipart/form-data">
            <div class="card-body p-4">
                <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-3">
                    <div>
                        <div class="admin-section-label"><fmt:message key="admin.menusets.editor.title" /></div>
                        <h2 class="h5 mb-0">
                            <c:choose>
                                <c:when test="${empty editMenuSet}"><fmt:message key="admin.menusets.editor.create" /></c:when>
                                <c:otherwise><fmt:message key="admin.menusets.editor.edit" /></c:otherwise>
                            </c:choose>
                        </h2>
                    </div>
                    <c:if test="${not empty editMenuSet}">
                        <a class="btn btn-outline-secondary btn-sm" href="MainController?action=adminMenuSets"><fmt:message key="admin.menusets.editor.clear" /></a>
                    </c:if>
                </div>
                <input type="hidden" name="action" value="saveMenuSet">
                <input type="hidden" name="id" value="${editMenuSet.id}">
                <input type="hidden" name="originalPrice" value="${empty editMenuSet ? 0 : editMenuSet.originalPrice}">
                <input type="hidden" name="discountedPrice" value="${empty editMenuSet ? 0 : editMenuSet.discountedPrice}">
                <div class="row g-4 align-items-start">
                    <div class="col-lg-8">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label"><fmt:message key="admin.menusets.label.name.vi" /></label>
                        <input id="setNameInput" class="form-control" name="setNameVi" value="${not empty editMenuSet.setNameVi ? editMenuSet.setNameVi : editMenuSet.setName}" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label"><fmt:message key="admin.menusets.label.name.en" /></label>
                        <input class="form-control" name="setName" value="${editMenuSet.setName}">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label"><fmt:message key="admin.menusets.label.desc.vi" /></label>
                        <textarea id="setDescriptionInput" class="form-control" name="descriptionVi" rows="3">${not empty editMenuSet.descriptionVi ? editMenuSet.descriptionVi : editMenuSet.description}</textarea>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label"><fmt:message key="admin.menusets.label.desc.en" /></label>
                        <textarea class="form-control" name="description" rows="3">${editMenuSet.description}</textarea>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label"><fmt:message key="admin.menusets.label.service" /></label>
                        <input id="setServiceInput" class="form-control" value="<fmt:message key="admin.menusets.label.service.dinner" />" readonly>
                        <input type="hidden" name="mealTime" value="DINNER">
                        <div class="form-text"><fmt:message key="admin.menusets.label.service.dinner.note" /></div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label"><fmt:message key="admin.menusets.label.image" /></label>
                        <input id="setImageInput" class="form-control" name="imageUrl" value="${editMenuSet.imageUrl}">
                        <div class="form-text"><fmt:message key="admin.menusets.label.image.help" /></div>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label"><fmt:message key="admin.menusets.label.upload" /></label>
                        <input id="setImageFileInput" class="form-control" name="imageFile" type="file" accept="image/*">
                        <div class="form-text"><fmt:message key="admin.menusets.label.upload.help" /></div>
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <div class="form-check form-switch mb-2">
                            <input id="setAvailableInput" class="form-check-input" type="checkbox" name="isAvailable" value="true" ${empty editMenuSet || editMenuSet.isAvailable ? 'checked' : ''}>
                            <label class="form-check-label"><fmt:message key="admin.common.available" /></label>
                        </div>
                    </div>
                    <div class="col-12 d-flex justify-content-end">
                        <button class="btn btn-dark px-4" type="submit"><fmt:message key="admin.common.save" /></button>
                    </div>
                </div>
                    </div>
                    <div class="col-lg-4">
                        <aside class="admin-draft-preview rounded-3 p-3">
                            <div id="setDraftImageWrap" class="admin-draft-placeholder rounded-3 d-flex align-items-center justify-content-center mb-3">
                                <i class="fa-solid fa-layer-group fa-2x"></i>
                            </div>
                            <p class="text-uppercase text-secondary small mb-1"><fmt:message key="admin.menusets.preview.title" /></p>
                            <h3 id="setDraftName" class="h5 mb-1"><fmt:message key="admin.menusets.preview.untitled" /></h3>
                            <p id="setDraftDescription" class="text-secondary mb-3"><fmt:message key="admin.menusets.preview.nodesc" /></p>
                            <div class="d-flex flex-wrap gap-2">
                                <span id="setDraftService" class="badge text-bg-light border text-dark"><fmt:message key="admin.menusets.label.service.dinner" /></span>
                                <span id="setDraftStatus" class="badge text-bg-success"><fmt:message key="admin.common.available" /></span>
                            </div>
                        </aside>
                    </div>
                </div>
            </div>
        </form>
    </section>

    <c:if test="${not empty selectedMenuSet}">
    <div class="row g-4 mb-4">
        <div class="col-12">
            <section class="border rounded-3 p-4 h-100">
                        <div class="d-flex flex-wrap justify-content-between align-items-start gap-3 mb-3">
                            <div>
                                <p class="text-uppercase text-secondary small mb-1"><fmt:message key="admin.menusets.label.selected" /></p>
                                <h2 id="setPreviewName" class="h4 mb-1">${sessionScope.lang == 'vi' ? (not empty selectedMenuSet.setNameVi ? selectedMenuSet.setNameVi : selectedMenuSet.setName) : (not empty selectedMenuSet.setName ? selectedMenuSet.setName : selectedMenuSet.setNameVi)}</h2>
                                <p id="setPreviewDescription" class="text-secondary mb-0">${not empty selectedMenuSet.descriptionVi ? selectedMenuSet.descriptionVi : selectedMenuSet.description}</p>
                            </div>
                            <span id="setPreviewStatus" class="badge ${selectedMenuSet.isAvailable ? 'text-bg-success' : 'text-bg-secondary'}"><c:choose><c:when test="${selectedMenuSet.isAvailable}"><fmt:message key="admin.common.available"/></c:when><c:otherwise><fmt:message key="admin.common.hidden"/></c:otherwise></c:choose></span>
                        </div>
                        <div class="row g-3 mb-4">
                            <div class="col-sm-4">
                                <div class="border rounded-3 p-3">
                                    <div class="small text-secondary"><fmt:message key="admin.menusets.label.service.label" /></div>
                                    <strong id="setPreviewService"><fmt:message key="admin.menusets.label.service.dinner" /></strong>
                                </div>
                            </div>
                            <div class="col-sm-4">
                                <div class="border rounded-3 p-3">
                                    <div class="small text-secondary"><fmt:message key="admin.menusets.label.suggested" /></div>
                                    <strong id="setPreviewSuggested"><fmt:formatNumber value="${selectedMenuSet.originalPrice}" pattern="#,##0"/></strong>
                                </div>
                            </div>
                            <div class="col-sm-4">
                                <div class="border rounded-3 p-3">
                                    <div class="small text-secondary"><fmt:message key="admin.menusets.label.selling" /></div>
                                    <strong id="setPreviewSelling"><fmt:formatNumber value="${selectedMenuSet.discountedPrice}" pattern="#,##0"/></strong>
                                </div>
                            </div>
                        </div>
                        <h3 class="h6 mb-3"><fmt:message key="admin.menusets.section.courses" /></h3>
                        <c:choose>
                            <c:when test="${empty selectedMenuSetItems}">
                                <p class="text-secondary mb-0"><fmt:message key="admin.menusets.courses.empty" /></p>
                            </c:when>
                            <c:otherwise>
                                <div class="vstack gap-3">
                                    <div class="border rounded-3 p-3">
                                        <div class="small text-uppercase text-secondary mb-2"><fmt:message key="admin.menusets.courses.course1" /></div>
                                        <c:set var="hasAppetizer" value="false" />
                                        <c:forEach items="${selectedMenuSetItems}" var="setItem">
                                            <c:if test="${not empty setItem.menuItem.category && setItem.menuItem.category.categoryType == 'APPETIZER'}">
                                                <c:set var="hasAppetizer" value="true" />
                                                <div class="d-flex justify-content-between gap-3 py-2 border-top">
                                                    <div><strong>${not empty setItem.courseNameVi ? setItem.courseNameVi : (not empty setItem.menuItem.itemNameVi ? setItem.menuItem.itemNameVi : (not empty setItem.courseName ? setItem.courseName : setItem.menuItem.itemName))}</strong><div class="small text-secondary"><c:choose><c:when test="${empty setItem.defaultSize}"><fmt:message key="admin.menusets.courses.nodesize"/></c:when><c:otherwise><c:out value="${setItem.defaultSize.sizeName}"/></c:otherwise></c:choose> - <fmt:message key="admin.menusets.coursesetup.qty" /> ${setItem.quantity}</div></div>
                                                    <a class="btn btn-outline-danger btn-sm align-self-center" href="MainController?action=deleteMenuSetItem&id=${setItem.id}&returnTo=adminMenuSets&menuSetId=${selectedMenuSet.id}" onclick="return confirm('<fmt:message key="admin.menusets.courses.remove"/>')"><fmt:message key="admin.menusets.courses.remove" /></a>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${!hasAppetizer}"><div class="text-secondary small"><fmt:message key="admin.menusets.courses.empty1" /></div></c:if>
                                    </div>
                                    <div class="border rounded-3 p-3">
                                        <div class="small text-uppercase text-secondary mb-2"><fmt:message key="admin.menusets.courses.course2" /></div>
                                        <c:set var="hasSoup" value="false" />
                                        <c:forEach items="${selectedMenuSetItems}" var="setItem">
                                            <c:if test="${not empty setItem.menuItem.category && setItem.menuItem.category.categoryType == 'SOUP'}">
                                                <c:set var="hasSoup" value="true" />
                                                <div class="d-flex justify-content-between gap-3 py-2 border-top">
                                                    <div><strong>${not empty setItem.courseNameVi ? setItem.courseNameVi : (not empty setItem.menuItem.itemNameVi ? setItem.menuItem.itemNameVi : (not empty setItem.courseName ? setItem.courseName : setItem.menuItem.itemName))}</strong><div class="small text-secondary"><c:choose><c:when test="${empty setItem.defaultSize}"><fmt:message key="admin.menusets.courses.nodesize"/></c:when><c:otherwise><c:out value="${setItem.defaultSize.sizeName}"/></c:otherwise></c:choose> - <fmt:message key="admin.menusets.coursesetup.qty" /> ${setItem.quantity}</div></div>
                                                    <a class="btn btn-outline-danger btn-sm align-self-center" href="MainController?action=deleteMenuSetItem&id=${setItem.id}&returnTo=adminMenuSets&menuSetId=${selectedMenuSet.id}" onclick="return confirm('<fmt:message key="admin.menusets.courses.remove"/>')"><fmt:message key="admin.menusets.courses.remove" /></a>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${!hasSoup}"><div class="text-secondary small"><fmt:message key="admin.menusets.courses.note2" /></div></c:if>
                                    </div>
                                    <div class="border rounded-3 p-3">
                                        <div class="small text-uppercase text-secondary mb-2"><fmt:message key="admin.menusets.courses.course3" /></div>
                                        <c:set var="hasMain" value="false" />
                                        <c:forEach items="${selectedMenuSetItems}" var="setItem">
                                            <c:if test="${not empty setItem.menuItem.category && setItem.menuItem.category.categoryType == 'MAIN'}">
                                                <c:set var="hasMain" value="true" />
                                                <div class="d-flex justify-content-between gap-3 py-2 border-top">
                                                    <div><strong>${not empty setItem.courseNameVi ? setItem.courseNameVi : (not empty setItem.menuItem.itemNameVi ? setItem.menuItem.itemNameVi : (not empty setItem.courseName ? setItem.courseName : setItem.menuItem.itemName))}</strong><div class="small text-secondary"><c:choose><c:when test="${empty setItem.defaultSize}"><fmt:message key="admin.menusets.courses.nodesize"/></c:when><c:otherwise><c:out value="${setItem.defaultSize.sizeName}"/></c:otherwise></c:choose> - <fmt:message key="admin.menusets.coursesetup.qty" /> ${setItem.quantity}</div></div>
                                                    <a class="btn btn-outline-danger btn-sm align-self-center" href="MainController?action=deleteMenuSetItem&id=${setItem.id}&returnTo=adminMenuSets&menuSetId=${selectedMenuSet.id}" onclick="return confirm('<fmt:message key="admin.menusets.courses.remove"/>')"><fmt:message key="admin.menusets.courses.remove" /></a>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${!hasMain}"><div class="text-secondary small"><fmt:message key="admin.menusets.courses.empty3" /></div></c:if>
                                    </div>
                                    <div class="border rounded-3 p-3">
                                        <div class="small text-uppercase text-secondary mb-2"><fmt:message key="admin.menusets.courses.course4" /></div>
                                        <c:set var="hasDessert" value="false" />
                                        <c:forEach items="${selectedMenuSetItems}" var="setItem">
                                            <c:if test="${not empty setItem.menuItem.category && setItem.menuItem.category.categoryType == 'DESSERT'}">
                                                <c:set var="hasDessert" value="true" />
                                                <div class="d-flex justify-content-between gap-3 py-2 border-top">
                                                    <div><strong>${not empty setItem.courseNameVi ? setItem.courseNameVi : (not empty setItem.menuItem.itemNameVi ? setItem.menuItem.itemNameVi : (not empty setItem.courseName ? setItem.courseName : setItem.menuItem.itemName))}</strong><div class="small text-secondary"><c:choose><c:when test="${empty setItem.defaultSize}"><fmt:message key="admin.menusets.courses.nodesize"/></c:when><c:otherwise><c:out value="${setItem.defaultSize.sizeName}"/></c:otherwise></c:choose> - <fmt:message key="admin.menusets.coursesetup.qty" /> ${setItem.quantity}</div></div>
                                                    <a class="btn btn-outline-danger btn-sm align-self-center" href="MainController?action=deleteMenuSetItem&id=${setItem.id}&returnTo=adminMenuSets&menuSetId=${selectedMenuSet.id}" onclick="return confirm('<fmt:message key="admin.menusets.courses.remove"/>')"><fmt:message key="admin.menusets.courses.remove" /></a>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${!hasDessert}"><div class="text-secondary small"><fmt:message key="admin.menusets.courses.empty4" /></div></c:if>
                                    </div>
                                    <div class="border rounded-3 p-3">
                                        <div class="small text-uppercase text-secondary mb-2"><fmt:message key="admin.menusets.courses.course5" /></div>
                                        <c:set var="hasDrink" value="false" />
                                        <c:forEach items="${selectedMenuSetItems}" var="setItem">
                                            <c:if test="${not empty setItem.menuItem.category && setItem.menuItem.category.categoryType == 'DRINK'}">
                                                <c:set var="hasDrink" value="true" />
                                                <div class="d-flex justify-content-between gap-3 py-2 border-top">
                                                    <div><strong>${not empty setItem.courseNameVi ? setItem.courseNameVi : (not empty setItem.menuItem.itemNameVi ? setItem.menuItem.itemNameVi : (not empty setItem.courseName ? setItem.courseName : setItem.menuItem.itemName))}</strong><div class="small text-secondary"><c:choose><c:when test="${empty setItem.defaultSize}"><fmt:message key="admin.menusets.courses.nodesize"/></c:when><c:otherwise><c:out value="${setItem.defaultSize.sizeName}"/></c:otherwise></c:choose> - <fmt:message key="admin.menusets.coursesetup.qty" /> ${setItem.quantity}</div></div>
                                                    <a class="btn btn-outline-danger btn-sm align-self-center" href="MainController?action=deleteMenuSetItem&id=${setItem.id}&returnTo=adminMenuSets&menuSetId=${selectedMenuSet.id}" onclick="return confirm('<fmt:message key="admin.menusets.courses.remove"/>')"><fmt:message key="admin.menusets.courses.remove" /></a>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${!hasDrink}"><div class="text-secondary small"><fmt:message key="admin.menusets.courses.note5" /></div></c:if>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
            </section>
        </div>
    </div>
    </c:if>
    </c:if>

    <c:if test="${not empty selectedMenuSet && param.mode == 'build'}">
        <section class="border rounded-3 p-4 mb-4">
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-3">
                <div>
                    <p class="text-uppercase text-secondary small mb-1"><fmt:message key="admin.menusets.coursesetup" /></p>
                    <h2 class="h5 mb-0">${sessionScope.lang == 'vi' ? (not empty selectedMenuSet.setNameVi ? selectedMenuSet.setNameVi : selectedMenuSet.setName) : (not empty selectedMenuSet.setName ? selectedMenuSet.setName : selectedMenuSet.setNameVi)}</h2>
                </div>
                <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminMenuSets&id=${selectedMenuSet.id}&mode=details"><fmt:message key="admin.menusets.coursesetup.back" /></a>
            </div>
            <div class="row g-3 align-items-end">
                <div class="col-lg-3">
                    <label class="form-label"><fmt:message key="admin.menusets.coursesetup.course" /></label>
                    <select id="courseTypeInput" class="form-select">
                        <option value="APPETIZER"><fmt:message key="admin.menusets.courses.course1" /></option>
                        <option value="SOUP"><fmt:message key="admin.menusets.courses.course2" /></option>
                        <option value="MAIN"><fmt:message key="admin.menusets.courses.course3" /></option>
                        <option value="DESSERT"><fmt:message key="admin.menusets.courses.course4" /></option>
                        <option value="DRINK"><fmt:message key="admin.menusets.courses.course5" /></option>
                    </select>
                </div>
                <div class="col-lg-4">
                    <label class="form-label"><fmt:message key="admin.menusets.coursesetup.item" /></label>
                    <select id="courseMenuItemInput" class="form-select" name="menuItemId" required>
                        <c:forEach items="${categories}" var="category">
                            <c:set var="categoryDisplayName" value="${sessionScope.lang == 'en' ? (empty category.categoryName ? category.categoryNameVi : category.categoryName) : (empty category.categoryNameVi ? category.categoryName : category.categoryNameVi)}" />
                            <optgroup label="${categoryDisplayName}">
                                <c:forEach items="${menuItems}" var="item">
                                    <c:if test="${not empty item.category && item.category.id == category.id}">
                                        <c:set var="courseItemDisplayName" value="${sessionScope.lang == 'en' ? (empty item.itemName ? item.itemNameVi : item.itemName) : (empty item.itemNameVi ? item.itemName : item.itemNameVi)}" />
                                        <option value="${item.id}" data-course="${item.category.categoryType}">${courseItemDisplayName}</option>
                                    </c:if>
                                </c:forEach>
                            </optgroup>
                        </c:forEach>
                    </select>
                    <div id="courseEmptyMessage" class="form-text d-none"><fmt:message key="admin.menusets.coursesetup.noitems" /></div>
                </div>
                <div class="col-lg-3">
                    <label class="form-label"><fmt:message key="admin.menusets.coursesetup.size" /></label>
                    <select id="courseSizeInput" class="form-select" name="defaultSizeId">
                        <option value=""><fmt:message key="admin.menusets.courses.nodesize" /></option>
                        <c:forEach items="${menuItems}" var="item">
                            <c:set var="sizeItemDisplayName" value="${sessionScope.lang == 'en' ? (empty item.itemName ? item.itemNameVi : item.itemName) : (empty item.itemNameVi ? item.itemName : item.itemNameVi)}" />
                            <optgroup label="${sizeItemDisplayName}">
                                <c:forEach items="${sizes}" var="size">
                                    <c:if test="${not empty size.menuItem && size.menuItem.id == item.id}">
                                        <option value="${size.id}" data-menu-item="${item.id}">${size.sizeName}</option>
                                    </c:if>
                                </c:forEach>
                            </optgroup>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-6 col-lg-1">
                    <label class="form-label"><fmt:message key="admin.menusets.coursesetup.qty" /></label>
                    <input id="courseQuantityInput" class="form-control" type="number" min="1" value="1" required>
                </div>
                <div class="col-6 col-lg-2">
                    <button id="addCourseDishButton" class="btn btn-dark w-100" type="button"><fmt:message key="admin.menusets.coursesetup.add" /></button>
                </div>
            </div>
            <form id="courseBatchForm" class="mt-4" method="post" action="MainController">
                <input type="hidden" name="action" value="saveMenuSetCourseItems">
                <input type="hidden" name="menuSetId" value="${selectedMenuSet.id}">
                <div class="border rounded-3">
                    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 p-3 border-bottom">
                        <div>
                            <h3 class="h6 mb-1"><fmt:message key="admin.menusets.coursesetup.selected" /></h3>
                            <div class="small text-secondary"><fmt:message key="admin.menusets.coursesetup.placeholder" /></div>
                        </div>
                        <button id="saveCourseDishesButton" class="btn btn-outline-dark btn-sm" type="submit" disabled><fmt:message key="admin.menusets.coursesetup.save" /></button>
                    </div>
                    <div id="pendingCourseList" class="list-group list-group-flush">
                        <div id="pendingCourseEmpty" class="list-group-item text-secondary"><fmt:message key="admin.menusets.coursesetup.empty" /></div>
                    </div>
                </div>
            </form>
            <hr class="my-4">
            <form id="menuPriceForm" class="row g-3 align-items-end" method="post" action="MainController">
                <input type="hidden" name="action" value="saveMenuSet">
                <input type="hidden" name="id" value="${selectedMenuSet.id}">
                <input type="hidden" name="setNameVi" value="${sessionScope.lang == 'vi' ? (not empty selectedMenuSet.setNameVi ? selectedMenuSet.setNameVi : selectedMenuSet.setName) : (not empty selectedMenuSet.setName ? selectedMenuSet.setName : selectedMenuSet.setNameVi)}">
                <input type="hidden" name="setName" value="${selectedMenuSet.setName}">
                <input type="hidden" name="descriptionVi" value="${selectedMenuSet.descriptionVi}">
                <input type="hidden" name="description" value="${selectedMenuSet.description}">
                <input type="hidden" name="mealTime" value="${selectedMenuSet.mealTime}">
                <input type="hidden" name="originalPrice" value="${selectedMenuSet.originalPrice}">
                <input type="hidden" name="imageUrl" value="${selectedMenuSet.imageUrl}">
                <input type="hidden" name="finalize" value="true">
                <c:if test="${selectedMenuSet.isAvailable}">
                    <input type="hidden" name="isAvailable" value="true">
                </c:if>
                <div class="col-lg-4">
                    <label class="form-label"><fmt:message key="admin.menusets.pricing.suggested" /></label>
                    <input class="form-control" value="${selectedMenuSet.originalPrice}" readonly>
                    <div class="form-text"><fmt:message key="admin.menusets.pricing.suggested.desc" /></div>
                </div>
                <div class="col-lg-5">
                    <label class="form-label"><fmt:message key="admin.menusets.pricing.selling" /></label>
                    <input id="setSellingInput" class="form-control" name="discountedPrice" type="number" min="0" step="1" value="${selectedMenuSet.discountedPrice}">
                    <div class="form-text"><fmt:message key="admin.menusets.pricing.selling.desc" /></div>
                </div>
                <div class="col-lg-3">
                    <button id="openMenuPreviewButton" class="btn btn-outline-dark w-100" type="button"><fmt:message key="admin.menusets.pricing.save" /></button>
                </div>
            </form>
        </section>
        <section class="border rounded-3 p-4 mb-4">
            <div class="d-flex flex-wrap justify-content-between align-items-start gap-3 mb-3">
                <div>
                    <p class="text-uppercase text-secondary small mb-1"><fmt:message key="admin.menusets.preview.title" /></p>
                    <h2 id="setPreviewName" class="h4 mb-1">${sessionScope.lang == 'vi' ? (not empty selectedMenuSet.setNameVi ? selectedMenuSet.setNameVi : selectedMenuSet.setName) : (not empty selectedMenuSet.setName ? selectedMenuSet.setName : selectedMenuSet.setNameVi)}</h2>
                    <p id="setPreviewDescription" class="text-secondary mb-0">${not empty selectedMenuSet.descriptionVi ? selectedMenuSet.descriptionVi : selectedMenuSet.description}</p>
                </div>
                <span id="setPreviewStatus" class="badge ${selectedMenuSet.isAvailable ? 'text-bg-success' : 'text-bg-secondary'}"><c:choose><c:when test="${selectedMenuSet.isAvailable}"><fmt:message key="admin.common.available"/></c:when><c:otherwise><fmt:message key="admin.common.hidden"/></c:otherwise></c:choose></span>
            </div>
            <div class="row g-3 mb-4">
                <div class="col-sm-4">
                    <div class="border rounded-3 p-3">
                        <div class="small text-secondary"><fmt:message key="admin.menusets.label.service.label" /></div>
                        <strong id="setPreviewService"><fmt:message key="admin.menusets.label.service.dinner" /></strong>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="border rounded-3 p-3">
                        <div class="small text-secondary"><fmt:message key="admin.menusets.label.suggested" /></div>
                        <strong id="setPreviewSuggested"><fmt:formatNumber value="${selectedMenuSet.originalPrice}" pattern="#,##0"/></strong>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="border rounded-3 p-3">
                        <div class="small text-secondary"><fmt:message key="admin.menusets.label.selling" /></div>
                        <strong id="setPreviewSelling"><fmt:formatNumber value="${selectedMenuSet.discountedPrice}" pattern="#,##0"/></strong>
                    </div>
                </div>
            </div>
            <h3 class="h6 mb-3"><fmt:message key="admin.menusets.section.courses" /></h3>
            <c:choose>
                <c:when test="${empty selectedMenuSetItems}">
                    <p class="text-secondary mb-0"><fmt:message key="admin.menusets.preview.nodesc" /></p>
                </c:when>
                <c:otherwise>
                    <div class="vstack gap-3">
                        <div class="border rounded-3 p-3">
                            <div class="small text-uppercase text-secondary mb-2"><fmt:message key="admin.menusets.courses.course1" /></div>
                            <c:set var="hasAppetizerPreview" value="false" />
                            <c:forEach items="${selectedMenuSetItems}" var="setItem">
                                <c:if test="${not empty setItem.menuItem.category && setItem.menuItem.category.categoryType == 'APPETIZER'}">
                                    <c:set var="hasAppetizerPreview" value="true" />
                                    <div class="d-flex justify-content-between gap-3 py-2 border-top">
                                        <div><strong>${not empty setItem.courseNameVi ? setItem.courseNameVi : (not empty setItem.menuItem.itemNameVi ? setItem.menuItem.itemNameVi : (not empty setItem.courseName ? setItem.courseName : setItem.menuItem.itemName))}</strong><div class="small text-secondary"><c:choose><c:when test="${empty setItem.defaultSize}"><fmt:message key="admin.menusets.courses.nodesize"/></c:when><c:otherwise><c:out value="${setItem.defaultSize.sizeName}"/></c:otherwise></c:choose> - <fmt:message key="admin.menusets.coursesetup.qty" /> ${setItem.quantity}</div></div>
                                        <a class="btn btn-outline-danger btn-sm align-self-center" href="MainController?action=deleteMenuSetItem&id=${setItem.id}&returnTo=adminMenuSets&menuSetId=${selectedMenuSet.id}" onclick="return confirm('<fmt:message key="admin.menusets.courses.remove"/>')"><fmt:message key="admin.menusets.courses.remove" /></a>
                                    </div>
                                </c:if>
                            </c:forEach>
                            <c:if test="${!hasAppetizerPreview}"><div class="text-secondary small"><fmt:message key="admin.menusets.courses.empty1" /></div></c:if>
                        </div>
                        <div class="border rounded-3 p-3">
                            <div class="small text-uppercase text-secondary mb-2"><fmt:message key="admin.menusets.courses.course2" /></div>
                            <c:set var="hasSoupPreview" value="false" />
                            <c:forEach items="${selectedMenuSetItems}" var="setItem">
                                <c:if test="${not empty setItem.menuItem.category && setItem.menuItem.category.categoryType == 'SOUP'}">
                                    <c:set var="hasSoupPreview" value="true" />
                                    <div class="d-flex justify-content-between gap-3 py-2 border-top">
                                        <div><strong>${not empty setItem.courseNameVi ? setItem.courseNameVi : (not empty setItem.menuItem.itemNameVi ? setItem.menuItem.itemNameVi : (not empty setItem.courseName ? setItem.courseName : setItem.menuItem.itemName))}</strong><div class="small text-secondary"><c:choose><c:when test="${empty setItem.defaultSize}"><fmt:message key="admin.menusets.courses.nodesize"/></c:when><c:otherwise><c:out value="${setItem.defaultSize.sizeName}"/></c:otherwise></c:choose> - <fmt:message key="admin.menusets.coursesetup.qty" /> ${setItem.quantity}</div></div>
                                        <a class="btn btn-outline-danger btn-sm align-self-center" href="MainController?action=deleteMenuSetItem&id=${setItem.id}&returnTo=adminMenuSets&menuSetId=${selectedMenuSet.id}" onclick="return confirm('<fmt:message key="admin.menusets.courses.remove"/>')"><fmt:message key="admin.menusets.courses.remove" /></a>
                                    </div>
                                </c:if>
                            </c:forEach>
                            <c:if test="${!hasSoupPreview}"><div class="text-secondary small"><fmt:message key="admin.menusets.courses.note2" /></div></c:if>
                        </div>
                        <div class="border rounded-3 p-3">
                            <div class="small text-uppercase text-secondary mb-2"><fmt:message key="admin.menusets.courses.course3" /></div>
                            <c:set var="hasMainPreview" value="false" />
                            <c:forEach items="${selectedMenuSetItems}" var="setItem">
                                <c:if test="${not empty setItem.menuItem.category && setItem.menuItem.category.categoryType == 'MAIN'}">
                                    <c:set var="hasMainPreview" value="true" />
                                    <div class="d-flex justify-content-between gap-3 py-2 border-top">
                                        <div><strong>${not empty setItem.courseNameVi ? setItem.courseNameVi : (not empty setItem.menuItem.itemNameVi ? setItem.menuItem.itemNameVi : (not empty setItem.courseName ? setItem.courseName : setItem.menuItem.itemName))}</strong><div class="small text-secondary"><c:choose><c:when test="${empty setItem.defaultSize}"><fmt:message key="admin.menusets.courses.nodesize"/></c:when><c:otherwise><c:out value="${setItem.defaultSize.sizeName}"/></c:otherwise></c:choose> - <fmt:message key="admin.menusets.coursesetup.qty" /> ${setItem.quantity}</div></div>
                                        <a class="btn btn-outline-danger btn-sm align-self-center" href="MainController?action=deleteMenuSetItem&id=${setItem.id}&returnTo=adminMenuSets&menuSetId=${selectedMenuSet.id}" onclick="return confirm('<fmt:message key="admin.menusets.courses.remove"/>')"><fmt:message key="admin.menusets.courses.remove" /></a>
                                    </div>
                                </c:if>
                            </c:forEach>
                            <c:if test="${!hasMainPreview}"><div class="text-secondary small"><fmt:message key="admin.menusets.courses.empty3" /></div></c:if>
                        </div>
                        <div class="border rounded-3 p-3">
                            <div class="small text-uppercase text-secondary mb-2"><fmt:message key="admin.menusets.courses.course4" /></div>
                            <c:set var="hasDessertPreview" value="false" />
                            <c:forEach items="${selectedMenuSetItems}" var="setItem">
                                <c:if test="${not empty setItem.menuItem.category && setItem.menuItem.category.categoryType == 'DESSERT'}">
                                    <c:set var="hasDessertPreview" value="true" />
                                    <div class="d-flex justify-content-between gap-3 py-2 border-top">
                                        <div><strong>${not empty setItem.courseNameVi ? setItem.courseNameVi : (not empty setItem.menuItem.itemNameVi ? setItem.menuItem.itemNameVi : (not empty setItem.courseName ? setItem.courseName : setItem.menuItem.itemName))}</strong><div class="small text-secondary"><c:choose><c:when test="${empty setItem.defaultSize}"><fmt:message key="admin.menusets.courses.nodesize"/></c:when><c:otherwise><c:out value="${setItem.defaultSize.sizeName}"/></c:otherwise></c:choose> - <fmt:message key="admin.menusets.coursesetup.qty" /> ${setItem.quantity}</div></div>
                                        <a class="btn btn-outline-danger btn-sm align-self-center" href="MainController?action=deleteMenuSetItem&id=${setItem.id}&returnTo=adminMenuSets&menuSetId=${selectedMenuSet.id}" onclick="return confirm('<fmt:message key="admin.menusets.courses.remove"/>')"><fmt:message key="admin.menusets.courses.remove" /></a>
                                    </div>
                                </c:if>
                            </c:forEach>
                            <c:if test="${!hasDessertPreview}"><div class="text-secondary small"><fmt:message key="admin.menusets.courses.empty4" /></div></c:if>
                        </div>
                        <div class="border rounded-3 p-3">
                            <div class="small text-uppercase text-secondary mb-2"><fmt:message key="admin.menusets.courses.course5" /></div>
                            <c:set var="hasDrinkPreview" value="false" />
                            <c:forEach items="${selectedMenuSetItems}" var="setItem">
                                <c:if test="${not empty setItem.menuItem.category && setItem.menuItem.category.categoryType == 'DRINK'}">
                                    <c:set var="hasDrinkPreview" value="true" />
                                    <div class="d-flex justify-content-between gap-3 py-2 border-top">
                                        <div><strong>${not empty setItem.courseNameVi ? setItem.courseNameVi : (not empty setItem.menuItem.itemNameVi ? setItem.menuItem.itemNameVi : (not empty setItem.courseName ? setItem.courseName : setItem.menuItem.itemName))}</strong><div class="small text-secondary"><c:choose><c:when test="${empty setItem.defaultSize}"><fmt:message key="admin.menusets.courses.nodesize"/></c:when><c:otherwise><c:out value="${setItem.defaultSize.sizeName}"/></c:otherwise></c:choose> - <fmt:message key="admin.menusets.coursesetup.qty" /> ${setItem.quantity}</div></div>
                                        <a class="btn btn-outline-danger btn-sm align-self-center" href="MainController?action=deleteMenuSetItem&id=${setItem.id}&returnTo=adminMenuSets&menuSetId=${selectedMenuSet.id}" onclick="return confirm('<fmt:message key="admin.menusets.courses.remove"/>')"><fmt:message key="admin.menusets.courses.remove" /></a>
                                    </div>
                                </c:if>
                            </c:forEach>
                            <c:if test="${!hasDrinkPreview}"><div class="text-secondary small"><fmt:message key="admin.menusets.courses.note5" /></div></c:if>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
        <div class="modal fade" id="menuPreviewModal" tabindex="-1" aria-labelledby="menuPreviewModalTitle" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-scrollable">
                <div class="modal-content">
                    <div class="modal-header">
                        <div>
                            <p class="text-uppercase text-secondary small mb-1"><fmt:message key="admin.menusets.modal.confirm" /></p>
                            <h5 class="modal-title" id="menuPreviewModalTitle">${sessionScope.lang == 'vi' ? (not empty selectedMenuSet.setNameVi ? selectedMenuSet.setNameVi : selectedMenuSet.setName) : (not empty selectedMenuSet.setName ? selectedMenuSet.setName : selectedMenuSet.setNameVi)}</h5>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="<fmt:message key="admin.common.close" />"></button>
                    </div>
                    <div class="modal-body">
                        <c:set var="modalSetImage" value="${empty selectedMenuSet.imageUrl ? 'assets/img/le-royal/menu/lotus-stem-salad.jpg' : selectedMenuSet.imageUrl}" />
                        <div class="menu-confirm-summary mb-3">
                            <div class="menu-confirm-hero" style="width:280px; height:110px; max-width:100%; margin:0 auto;">
                                <c:choose>
                                    <c:when test="${fn:startsWith(modalSetImage, 'http') || fn:startsWith(modalSetImage, '/')}">
                                        <img style="width:100%; height:100%; object-fit:cover;" src="${modalSetImage}" alt="${sessionScope.lang == 'vi' ? (not empty selectedMenuSet.setNameVi ? selectedMenuSet.setNameVi : selectedMenuSet.setName) : (not empty selectedMenuSet.setName ? selectedMenuSet.setName : selectedMenuSet.setNameVi)}">
                                    </c:when>
                                    <c:otherwise>
                                        <img style="width:100%; height:100%; object-fit:cover;" src="${pageContext.request.contextPath}/${modalSetImage}" alt="${sessionScope.lang == 'vi' ? (not empty selectedMenuSet.setNameVi ? selectedMenuSet.setNameVi : selectedMenuSet.setName) : (not empty selectedMenuSet.setName ? selectedMenuSet.setName : selectedMenuSet.setNameVi)}">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <p class="text-secondary mb-0">${not empty selectedMenuSet.descriptionVi ? selectedMenuSet.descriptionVi : selectedMenuSet.description}</p>
                        </div>
                        <div class="row g-3 mb-4">
                            <div class="col-sm-4"><div class="border rounded-3 p-3"><div class="small text-secondary"><fmt:message key="admin.menusets.label.service.label" /></div><strong><fmt:message key="admin.menusets.label.service.dinner" /></strong></div></div>
                            <div class="col-sm-4"><div class="border rounded-3 p-3"><div class="small text-secondary"><fmt:message key="admin.menusets.label.suggested" /></div><strong><fmt:formatNumber value="${selectedMenuSet.originalPrice}" pattern="#,##0"/></strong></div></div>
                            <div class="col-sm-4"><div class="border rounded-3 p-3"><div class="small text-secondary"><fmt:message key="admin.menusets.label.selling" /></div><strong id="modalSellingPriceText"><fmt:formatNumber value="${selectedMenuSet.discountedPrice}" pattern="#,##0"/></strong></div></div>
                        </div>
                        <div class="vstack gap-2">
                            <div class="border rounded-3 p-3">
                                <div class="small text-uppercase text-secondary mb-2"><fmt:message key="admin.menusets.courses.course1" /></div>
                                <c:set var="hasModalAppetizer" value="false" />
                                <c:forEach items="${selectedMenuSetItems}" var="setItem"><c:if test="${not empty setItem.menuItem.category && setItem.menuItem.category.categoryType == 'APPETIZER'}"><c:set var="hasModalAppetizer" value="true" /><div>${sessionScope.lang == 'vi' ? (not empty setItem.courseNameVi ? setItem.courseNameVi : (not empty setItem.menuItem.itemNameVi ? setItem.menuItem.itemNameVi : (not empty setItem.courseName ? setItem.courseName : setItem.menuItem.itemName))) : (not empty setItem.courseName ? setItem.courseName : (not empty setItem.menuItem.itemName ? setItem.menuItem.itemName : (not empty setItem.courseNameVi ? setItem.courseNameVi : setItem.menuItem.itemNameVi)))}</div></c:if></c:forEach>
                                <c:if test="${!hasModalAppetizer}"><div class="text-secondary small"><fmt:message key="admin.menusets.courses.empty1" /></div></c:if>
                            </div>
                            <div class="border rounded-3 p-3">
                                <div class="small text-uppercase text-secondary mb-2"><fmt:message key="admin.menusets.courses.course2" /></div>
                                <c:set var="hasModalSoup" value="false" />
                                <c:forEach items="${selectedMenuSetItems}" var="setItem"><c:if test="${not empty setItem.menuItem.category && setItem.menuItem.category.categoryType == 'SOUP'}"><c:set var="hasModalSoup" value="true" /><div>${sessionScope.lang == 'vi' ? (not empty setItem.courseNameVi ? setItem.courseNameVi : (not empty setItem.menuItem.itemNameVi ? setItem.menuItem.itemNameVi : (not empty setItem.courseName ? setItem.courseName : setItem.menuItem.itemName))) : (not empty setItem.courseName ? setItem.courseName : (not empty setItem.menuItem.itemName ? setItem.menuItem.itemName : (not empty setItem.courseNameVi ? setItem.courseNameVi : setItem.menuItem.itemNameVi)))}</div></c:if></c:forEach>
                                <c:if test="${!hasModalSoup}"><div class="text-secondary small"><fmt:message key="admin.menusets.courses.empty2" /></div></c:if>
                            </div>
                            <div class="border rounded-3 p-3">
                                <div class="small text-uppercase text-secondary mb-2"><fmt:message key="admin.menusets.courses.course3" /></div>
                                <c:set var="hasModalMain" value="false" />
                                <c:forEach items="${selectedMenuSetItems}" var="setItem"><c:if test="${not empty setItem.menuItem.category && setItem.menuItem.category.categoryType == 'MAIN'}"><c:set var="hasModalMain" value="true" /><div>${sessionScope.lang == 'vi' ? (not empty setItem.courseNameVi ? setItem.courseNameVi : (not empty setItem.menuItem.itemNameVi ? setItem.menuItem.itemNameVi : (not empty setItem.courseName ? setItem.courseName : setItem.menuItem.itemName))) : (not empty setItem.courseName ? setItem.courseName : (not empty setItem.menuItem.itemName ? setItem.menuItem.itemName : (not empty setItem.courseNameVi ? setItem.courseNameVi : setItem.menuItem.itemNameVi)))}</div></c:if></c:forEach>
                                <c:if test="${!hasModalMain}"><div class="text-secondary small"><fmt:message key="admin.menusets.courses.empty3" /></div></c:if>
                            </div>
                            <div class="border rounded-3 p-3">
                                <div class="small text-uppercase text-secondary mb-2"><fmt:message key="admin.menusets.courses.course4" /></div>
                                <c:set var="hasModalDessert" value="false" />
                                <c:forEach items="${selectedMenuSetItems}" var="setItem"><c:if test="${not empty setItem.menuItem.category && setItem.menuItem.category.categoryType == 'DESSERT'}"><c:set var="hasModalDessert" value="true" /><div>${sessionScope.lang == 'vi' ? (not empty setItem.courseNameVi ? setItem.courseNameVi : (not empty setItem.menuItem.itemNameVi ? setItem.menuItem.itemNameVi : (not empty setItem.courseName ? setItem.courseName : setItem.menuItem.itemName))) : (not empty setItem.courseName ? setItem.courseName : (not empty setItem.menuItem.itemName ? setItem.menuItem.itemName : (not empty setItem.courseNameVi ? setItem.courseNameVi : setItem.menuItem.itemNameVi)))}</div></c:if></c:forEach>
                                <c:if test="${!hasModalDessert}"><div class="text-secondary small"><fmt:message key="admin.menusets.courses.empty4" /></div></c:if>
                            </div>
                            <div class="border rounded-3 p-3">
                                <div class="small text-uppercase text-secondary mb-2"><fmt:message key="admin.menusets.courses.course5" /></div>
                                <c:set var="hasModalDrink" value="false" />
                                <c:forEach items="${selectedMenuSetItems}" var="setItem"><c:if test="${not empty setItem.menuItem.category && setItem.menuItem.category.categoryType == 'DRINK'}"><c:set var="hasModalDrink" value="true" /><div>${sessionScope.lang == 'vi' ? (not empty setItem.courseNameVi ? setItem.courseNameVi : (not empty setItem.menuItem.itemNameVi ? setItem.menuItem.itemNameVi : (not empty setItem.courseName ? setItem.courseName : setItem.menuItem.itemName))) : (not empty setItem.courseName ? setItem.courseName : (not empty setItem.menuItem.itemName ? setItem.menuItem.itemName : (not empty setItem.courseNameVi ? setItem.courseNameVi : setItem.menuItem.itemNameVi)))}</div></c:if></c:forEach>
                                <c:if test="${!hasModalDrink}"><div class="text-secondary small"><fmt:message key="admin.menusets.courses.empty5" /></div></c:if>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal"><fmt:message key="admin.menusets.modal.keep" /></button>
                        <button id="confirmMenuPriceButton" type="button" class="btn btn-dark"><fmt:message key="admin.menusets.modal.save" /></button>
                    </div>
                </div>
            </div>
        </div>
    </c:if>

    <section>
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-3">
            <h2 class="h5 mb-0"><fmt:message key="admin.menusets.library.title" /></h2>
            <span class="text-secondary small"><fmt:message key="admin.menusets.library.sub" /></span>
        </div>
        <div class="card mb-3">
            <div class="card-body p-3">
                <div class="row g-2 align-items-center">
                    <div class="col-lg-6">
                        <div class="input-group">
                            <span class="input-group-text"><i class="fa-solid fa-magnifying-glass"></i></span>
                            <input id="setSearch" class="form-control" type="search" placeholder="<fmt:message key="admin.menusets.search" />">
                        </div>
                    </div>
                    <input id="setServiceFilter" type="hidden" value="">
                    <div class="col-sm-6 col-lg-2">
                        <select id="setStatusFilter" class="form-select">
                            <option value=""><fmt:message key="admin.common.filter.all.status" /></option>
                            <option value="available"><fmt:message key="admin.common.available" /></option>
                            <option value="hidden"><fmt:message key="admin.common.hidden" /></option>
                        </select>
                    </div>
                </div>
            </div>
        </div>
        <div class="table-responsive">
            <table class="table align-middle">
                <thead>
                    <tr>
                            <th><fmt:message key="admin.menusets.col.image" /></th>
                            <th><fmt:message key="admin.menusets.col.id" /></th>
                        <th><fmt:message key="admin.menusets.col.set" /></th>
                        <th><fmt:message key="admin.menusets.col.service" /></th>
                        <th><fmt:message key="admin.menusets.col.suggested" /></th>
                        <th><fmt:message key="admin.menusets.col.selling" /></th>
                        <th><fmt:message key="admin.menusets.col.status" /></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody id="setRows">
                    <c:forEach items="${menuSetList}" var="set">
                        <tr data-set-row
                            data-search="${set.setNameVi} ${set.setName} ${set.descriptionVi} ${set.description}"
                            data-service="${set.mealTime}"
                            data-status="${set.isAvailable ? 'available' : 'hidden'}"
                            class="${not empty selectedMenuSet && selectedMenuSet.id == set.id ? 'table-light' : ''}">
                            <td>
                                <c:set var="setImage" value="${empty set.imageUrl ? 'assets/img/le-royal/menu/lotus-stem-salad.jpg' : set.imageUrl}" />
                                <c:choose>
                                    <c:when test="${fn:startsWith(setImage, 'http') || fn:startsWith(setImage, '/')}">
                                        <img class="admin-menu-thumb rounded-2" src="${setImage}" alt="${sessionScope.lang == 'vi' ? (not empty set.setNameVi ? set.setNameVi : set.setName) : (not empty set.setName ? set.setName : set.setNameVi)}">
                                    </c:when>
                                    <c:otherwise>
                                        <img class="admin-menu-thumb rounded-2" src="${pageContext.request.contextPath}/${setImage}" alt="${sessionScope.lang == 'vi' ? (not empty set.setNameVi ? set.setNameVi : set.setName) : (not empty set.setName ? set.setName : set.setNameVi)}">
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${set.id}</td>
                            <td>
                                <c:set var="mainSetName" value="${sessionScope.lang == 'vi' ? (not empty set.setNameVi ? set.setNameVi : set.setName) : (not empty set.setName ? set.setName : set.setNameVi)}" />
                                <c:set var="subSetName" value="${sessionScope.lang == 'vi' ? set.setName : set.setNameVi}" />
                                <c:set var="mainSetDesc" value="${sessionScope.lang == 'vi' ? (not empty set.descriptionVi ? set.descriptionVi : set.description) : (not empty set.description ? set.description : set.descriptionVi)}" />
                                <strong>${mainSetName}</strong>
                                <c:if test="${not empty subSetName}"><div class="small text-secondary">${subSetName}</div></c:if>
                                <div class="small text-secondary">${mainSetDesc}</div>
                            </td>
                            <td><fmt:message key="admin.menusets.label.service.dinner" /></td>
                            <td><fmt:formatNumber value="${set.originalPrice}" pattern="#,##0"/></td>
                            <td><fmt:formatNumber value="${set.discountedPrice}" pattern="#,##0"/></td>
                            <td><span class="badge ${set.isAvailable ? 'text-bg-success' : 'text-bg-secondary'}"><c:choose><c:when test="${set.isAvailable}"><fmt:message key="admin.common.available"/></c:when><c:otherwise><fmt:message key="admin.common.hidden"/></c:otherwise></c:choose></span></td>
                            <td class="text-end">
                                <a class="btn btn-outline-primary btn-sm" href="MainController?action=adminMenuSets&id=${set.id}&mode=build"><fmt:message key="admin.menusets.btn.edit" /></a>
                                <a class="btn btn-outline-secondary btn-sm" href="MainController?action=toggleMenuSet&id=${set.id}&enabled=${!set.isAvailable}"><c:choose><c:when test="${set.isAvailable}"><fmt:message key="admin.common.hide"/></c:when><c:otherwise><fmt:message key="admin.common.restore"/></c:otherwise></c:choose></a>
                            </td>
                        </tr>
                    </c:forEach>
                    <tr id="setEmpty" class="d-none"><td colspan="8" class="text-center text-secondary py-5"><fmt:message key="admin.menusets.empty" /></td></tr>
                </tbody>
            </table>
        </div>
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mt-3">
            <div id="setPaginationText" class="small text-secondary"></div>
            <div id="setPagination" class="btn-group btn-group-sm" role="group" aria-label="<fmt:message key="admin.menusets.library.title" />"></div>
        </div>
    </section>
</div>
</main>
<script>
    (function () {
        var rows = Array.prototype.slice.call(document.querySelectorAll('[data-set-row]'));
        var search = document.getElementById('setSearch');
        var service = document.getElementById('setServiceFilter');
        var status = document.getElementById('setStatusFilter');
        var empty = document.getElementById('setEmpty');
        var pagination = document.getElementById('setPagination');
        var paginationText = document.getElementById('setPaginationText');
        var pageSize = 8;
        var currentPage = 1;

        function normalized(value) { return (value || '').toLowerCase(); }
        function filteredRows() {
            var q = normalized(search && search.value);
            var serviceValue = service ? service.value : '';
            var statusValue = status ? status.value : '';
            return rows.filter(function (row) {
                return (!q || normalized(row.getAttribute('data-search')).indexOf(q) !== -1)
                        && (!serviceValue || row.getAttribute('data-service') === serviceValue)
                        && (!statusValue || row.getAttribute('data-status') === statusValue);
            });
        }
        function renderPagination(totalPages) {
            if (!pagination) return;
            pagination.innerHTML = '';
            for (var i = 1; i <= totalPages; i++) {
                var button = document.createElement('button');
                button.type = 'button';
                button.className = 'btn ' + (i === currentPage ? 'btn-dark' : 'btn-outline-secondary');
                button.textContent = i;
                button.setAttribute('data-page', i);
                button.addEventListener('click', function () {
                    currentPage = Number(this.getAttribute('data-page'));
                    render();
                });
                pagination.appendChild(button);
            }
        }
        function render() {
            var visibleRows = filteredRows();
            var totalPages = Math.max(1, Math.ceil(visibleRows.length / pageSize));
            if (currentPage > totalPages) currentPage = totalPages;
            rows.forEach(function (row) { row.classList.add('d-none'); });
            var start = (currentPage - 1) * pageSize;
            visibleRows.slice(start, start + pageSize).forEach(function (row) { row.classList.remove('d-none'); });
            if (empty) empty.classList.toggle('d-none', visibleRows.length > 0);
            if (paginationText) {
                var end = Math.min(start + pageSize, visibleRows.length);
                paginationText.textContent = visibleRows.length ? ((start + 1) + '-' + end + ' / ' + visibleRows.length) : '<fmt:message key="admin.common.pagination.no.items"/>';
            }
            renderPagination(totalPages);
        }
        [search, service, status].forEach(function (field) {
            if (!field) return;
            field.addEventListener('input', function () { currentPage = 1; render(); });
            field.addEventListener('change', function () { currentPage = 1; render(); });
        });
        render();
    })();

    (function () {
        var nameInput = document.getElementById('setNameInput');
        var descriptionInput = document.getElementById('setDescriptionInput');
        var serviceInput = document.getElementById('setServiceInput');
        var imageInput = document.getElementById('setImageInput');
        var imageFileInput = document.getElementById('setImageFileInput');
        var suggestedInput = document.getElementById('setSuggestedInput');
        var sellingInput = document.getElementById('setSellingInput');
        var availableInput = document.getElementById('setAvailableInput');
        var previewName = document.getElementById('setPreviewName');
        var previewDescription = document.getElementById('setPreviewDescription');
        var previewService = document.getElementById('setPreviewService');
        var previewSuggested = document.getElementById('setPreviewSuggested');
        var previewSelling = document.getElementById('setPreviewSelling');
        var previewStatus = document.getElementById('setPreviewStatus');
        var draftImageWrap = document.getElementById('setDraftImageWrap');
        var draftName = document.getElementById('setDraftName');
        var draftDescription = document.getElementById('setDraftDescription');
        var draftService = document.getElementById('setDraftService');
        var draftStatus = document.getElementById('setDraftStatus');
        var courseTypeInput = document.getElementById('courseTypeInput');
        var courseMenuItemInput = document.getElementById('courseMenuItemInput');
        var courseSizeInput = document.getElementById('courseSizeInput');
        var courseEmptyMessage = document.getElementById('courseEmptyMessage');
        var addCourseDishButton = document.getElementById('addCourseDishButton');
        var courseQuantityInput = document.getElementById('courseQuantityInput');
        var courseBatchForm = document.getElementById('courseBatchForm');
        var pendingCourseList = document.getElementById('pendingCourseList');
        var pendingCourseEmpty = document.getElementById('pendingCourseEmpty');
        var saveCourseDishesButton = document.getElementById('saveCourseDishesButton');
        var menuPriceForm = document.getElementById('menuPriceForm');
        var openMenuPreviewButton = document.getElementById('openMenuPreviewButton');
        var confirmMenuPriceButton = document.getElementById('confirmMenuPriceButton');
        var menuPreviewModal = document.getElementById('menuPreviewModal');
        var modalSellingPriceText = document.getElementById('modalSellingPriceText');
        var setUploadPreviewUrl = '';

        function serviceLabel(value) {
            return '<fmt:message key="admin.menusets.label.service.dinner"/>';
        }

        function moneyLabel(value) {
            var number = Number(value || 0);
            if (!isFinite(number)) {
                number = 0;
            }
            return new Intl.NumberFormat('en-US', {maximumFractionDigits: 0}).format(number);
        }

        function imageSrc(value) {
            value = (value || '').trim();
            if (!value) {
                return '';
            }
            return (/^(https?:)?\/\//i.test(value) || value.charAt(0) === '/') ? value : '${pageContext.request.contextPath}/' + value;
        }

        function updatePreview() {
            var nameText = nameInput ? (nameInput.value.trim() || '<fmt:message key="admin.menusets.preview.untitled"/>') : '<fmt:message key="admin.menusets.preview.untitled"/>';
            var descriptionText = descriptionInput ? (descriptionInput.value.trim() || '<fmt:message key="admin.menusets.preview.nodesc"/>') : '<fmt:message key="admin.menusets.preview.nodesc"/>';
            var serviceText = serviceInput ? serviceLabel(serviceInput.value) : '<fmt:message key="admin.menusets.label.service.dinner"/>';
            if (previewName && nameInput) {
                previewName.textContent = nameText;
            }
            if (previewDescription && descriptionInput) {
                previewDescription.textContent = descriptionText;
            }
            if (previewService && serviceInput) {
                previewService.textContent = serviceText;
            }
            if (previewSuggested && suggestedInput) {
                previewSuggested.textContent = moneyLabel(suggestedInput.value);
            }
            if (previewSelling && sellingInput) {
                previewSelling.textContent = moneyLabel(sellingInput.value);
            }
            if (previewStatus && availableInput) {
                previewStatus.textContent = availableInput.checked ? '<fmt:message key="admin.common.available"/>' : '<fmt:message key="admin.common.hidden"/>';
                previewStatus.className = availableInput.checked ? 'badge text-bg-success' : 'badge text-bg-secondary';
            }
            if (draftName) draftName.textContent = nameText;
            if (draftDescription) draftDescription.textContent = descriptionText;
            if (draftService) draftService.textContent = serviceText;
            if (draftStatus && availableInput) {
                draftStatus.textContent = availableInput.checked ? '<fmt:message key="admin.common.available"/>' : '<fmt:message key="admin.common.hidden"/>';
                draftStatus.className = availableInput.checked ? 'badge text-bg-success' : 'badge text-bg-secondary';
            }
            if (draftImageWrap) {
                var src = setUploadPreviewUrl || (imageInput ? imageSrc(imageInput.value) : '');
                draftImageWrap.innerHTML = src
                        ? '<img class="rounded-3" src="' + src + '" alt="">'
                        : '<i class="fa-solid fa-layer-group fa-2x"></i>';
            }
        }
        if (imageFileInput) {
            imageFileInput.addEventListener('change', function () {
                if (setUploadPreviewUrl) {
                    URL.revokeObjectURL(setUploadPreviewUrl);
                }
                setUploadPreviewUrl = this.files && this.files[0] ? URL.createObjectURL(this.files[0]) : '';
                updatePreview();
            });
        }

        function syncCourseBuilder() {
            if (!courseTypeInput || !courseMenuItemInput) {
                return;
            }
            var selectedCourse = courseTypeInput.value;
            var visibleCount = 0;
            Array.prototype.forEach.call(courseMenuItemInput.options, function (option) {
                var visible = option.getAttribute('data-course') === selectedCourse;
                option.hidden = !visible;
                option.disabled = !visible;
                if (visible) {
                    visibleCount++;
                }
            });
            var firstVisible = Array.prototype.filter.call(courseMenuItemInput.options, function (option) {
                return !option.hidden;
            })[0];
            if (firstVisible) {
                courseMenuItemInput.value = firstVisible.value;
            }
            if (courseEmptyMessage) {
                courseEmptyMessage.classList.toggle('d-none', visibleCount > 0);
            }
            if (addCourseDishButton) {
                addCourseDishButton.disabled = visibleCount === 0;
            }
            syncSizeOptions();
        }

        function syncSizeOptions() {
            if (!courseMenuItemInput || !courseSizeInput) {
                return;
            }
            var selectedItem = courseMenuItemInput.value;
            Array.prototype.forEach.call(courseSizeInput.options, function (option) {
                if (!option.value) {
                    option.hidden = false;
                    option.disabled = false;
                    return;
                }
                var visible = option.getAttribute('data-menu-item') === selectedItem;
                option.hidden = !visible;
                option.disabled = !visible;
            });
            var selectedSize = courseSizeInput.options[courseSizeInput.selectedIndex];
            if (selectedSize && selectedSize.disabled) {
                courseSizeInput.value = '';
            }
        }

        function courseLabel(value) {
            if (value === 'APPETIZER') {
                return '<fmt:message key="admin.menusets.courses.course1"/>';
            }
            if (value === 'SOUP') {
                return '<fmt:message key="admin.menusets.courses.course2"/>';
            }
            if (value === 'MAIN') {
                return '<fmt:message key="admin.menusets.courses.course3"/>';
            }
            if (value === 'DESSERT') {
                return '<fmt:message key="admin.menusets.courses.course4"/>';
            }
            return '<fmt:message key="admin.menusets.courses.course5"/>';
        }

        function appendHiddenInput(name, value, row) {
            var input = document.createElement('input');
            input.type = 'hidden';
            input.name = name;
            input.value = value || '';
            input.setAttribute('data-pending-row', row);
            courseBatchForm.appendChild(input);
        }

        function updatePendingState() {
            if (!pendingCourseList || !saveCourseDishesButton) {
                return;
            }
            var hasRows = pendingCourseList.querySelectorAll('[data-pending-item]').length > 0;
            if (pendingCourseEmpty) {
                pendingCourseEmpty.classList.toggle('d-none', hasRows);
            }
            saveCourseDishesButton.disabled = !hasRows;
        }

        function addPendingCourseDish() {
            if (!courseBatchForm || !courseMenuItemInput || !courseMenuItemInput.value) {
                return;
            }
            var row = String(Date.now()) + String(Math.floor(Math.random() * 1000));
            var selectedItem = courseMenuItemInput.options[courseMenuItemInput.selectedIndex];
            var selectedSize = courseSizeInput && courseSizeInput.value ? courseSizeInput.options[courseSizeInput.selectedIndex] : null;
            var quantity = courseQuantityInput && Number(courseQuantityInput.value) > 0 ? courseQuantityInput.value : '1';
            appendHiddenInput('menuItemId', courseMenuItemInput.value, row);
            appendHiddenInput('defaultSizeId', selectedSize ? courseSizeInput.value : '', row);
            appendHiddenInput('quantity', quantity, row);

            var item = document.createElement('div');
            item.className = 'list-group-item d-flex justify-content-between align-items-start gap-3';
            item.setAttribute('data-pending-item', row);
            var details = document.createElement('div');
            details.innerHTML = '<strong>' + selectedItem.text + '</strong><div class="small text-secondary">' + courseLabel(courseTypeInput.value) + ' - ' + (selectedSize ? selectedSize.text : '<fmt:message key="admin.menusets.courses.nodesize"/>') + ' - <fmt:message key="admin.menusets.coursesetup.qty"/> ' + quantity + '</div>';
            var remove = document.createElement('button');
            remove.type = 'button';
            remove.className = 'btn btn-outline-danger btn-sm';
            remove.textContent = '<fmt:message key="admin.menusets.courses.remove"/>';
            remove.addEventListener('click', function () {
                Array.prototype.forEach.call(courseBatchForm.querySelectorAll('[data-pending-row="' + row + '"]'), function (input) {
                    input.remove();
                });
                item.remove();
                updatePendingState();
            });
            item.appendChild(details);
            item.appendChild(remove);
            pendingCourseList.appendChild(item);
            updatePendingState();
        }

        function openMenuPreview() {
            if (modalSellingPriceText && sellingInput) {
                modalSellingPriceText.textContent = moneyLabel(sellingInput.value);
            }
            if (window.bootstrap && menuPreviewModal) {
                window.bootstrap.Modal.getOrCreateInstance(menuPreviewModal).show();
                return;
            }
            if (window.confirm('<fmt:message key="admin.menusets.modal.save"/>')) {
                menuPriceForm.submit();
            }
        }

        [nameInput, descriptionInput, serviceInput, imageInput, suggestedInput, sellingInput, availableInput].forEach(function (field) {
            if (field) {
                field.addEventListener('input', updatePreview);
                field.addEventListener('change', updatePreview);
            }
        });
        if (courseTypeInput) {
            courseTypeInput.addEventListener('change', syncCourseBuilder);
        }
        if (courseMenuItemInput) {
            courseMenuItemInput.addEventListener('change', syncSizeOptions);
        }
        if (addCourseDishButton) {
            addCourseDishButton.addEventListener('click', addPendingCourseDish);
        }
        if (openMenuPreviewButton) {
            openMenuPreviewButton.addEventListener('click', openMenuPreview);
        }
        if (confirmMenuPriceButton && menuPriceForm) {
            confirmMenuPriceButton.addEventListener('click', function () {
                menuPriceForm.submit();
            });
        }
        updatePreview();
        syncCourseBuilder();
        updatePendingState();
    })();
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</div>
</body>
</html>
