<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/header.jsp" />
<main class="container py-5">
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
            <p class="text-uppercase text-secondary small mb-1">Restaurant Admin</p>
            <h1 class="h3 mb-0">Menu sets</h1>
        </div>
        <div class="btn-group">
            <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminMenuItems">Menu items</a>
            <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminCategories">Categories</a>
        </div>
    </div>

    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
    <c:if test="${param.saved == '1'}"><div class="alert alert-success">Saved successfully.</div></c:if>

    <c:if test="${empty selectedMenuSet || param.mode == 'details'}">
    <div class="row g-4 mb-4">
        <div class="col-lg-4">
            <form class="border rounded-3 p-4 bg-light h-100" method="post" action="MainController">
                <input type="hidden" name="action" value="saveMenuSet">
                <input type="hidden" name="id" value="${editMenuSet.id}">
                <input type="hidden" name="originalPrice" value="${empty editMenuSet ? 0 : editMenuSet.originalPrice}">
                <input type="hidden" name="discountedPrice" value="${empty editMenuSet ? 0 : editMenuSet.discountedPrice}">
                <h2 class="h5 mb-3">${empty editMenuSet ? 'Create set' : 'Edit set'}</h2>
                <label class="form-label">Set name</label>
                <input id="setNameInput" class="form-control mb-3" name="setName" value="${editMenuSet.setName}" required>
                <label class="form-label">Description</label>
                <textarea id="setDescriptionInput" class="form-control mb-3" name="description" rows="3">${editMenuSet.description}</textarea>
                <label class="form-label">Service period</label>
                <select id="setServiceInput" class="form-select mb-3" name="mealTime">
                    <option value="LUNCH" ${editMenuSet.mealTime == 'LUNCH' ? 'selected' : ''}>Lunch Service</option>
                    <option value="DINNER" ${empty editMenuSet || editMenuSet.mealTime == 'DINNER' || editMenuSet.mealTime == 'BREAKFAST' ? 'selected' : ''}>Dinner Service</option>
                    <option value="ALL_DAY" ${editMenuSet.mealTime == 'ALL_DAY' ? 'selected' : ''}>All Services</option>
                </select>
                <label class="form-label">Image URL</label>
                <input class="form-control mb-3" name="imageUrl" value="${editMenuSet.imageUrl}">
                <div class="form-check form-switch mb-3">
                    <input id="setAvailableInput" class="form-check-input" type="checkbox" name="isAvailable" value="true" ${empty editMenuSet || editMenuSet.isAvailable ? 'checked' : ''}>
                    <label class="form-check-label">Available</label>
                </div>
                <button class="btn btn-dark w-100" type="submit">Save set</button>
            </form>
        </div>

        <div class="col-lg-8">
            <section class="border rounded-3 p-4 h-100">
                <c:choose>
                    <c:when test="${not empty selectedMenuSet}">
                        <div class="d-flex flex-wrap justify-content-between align-items-start gap-3 mb-3">
                            <div>
                                <p class="text-uppercase text-secondary small mb-1">Selected set</p>
                                <h2 id="setPreviewName" class="h4 mb-1">${selectedMenuSet.setName}</h2>
                                <p id="setPreviewDescription" class="text-secondary mb-0">${selectedMenuSet.description}</p>
                            </div>
                            <span id="setPreviewStatus" class="badge ${selectedMenuSet.isAvailable ? 'text-bg-success' : 'text-bg-secondary'}">${selectedMenuSet.isAvailable ? 'Available' : 'Hidden'}</span>
                        </div>
                        <div class="row g-3 mb-4">
                            <div class="col-sm-4">
                                <div class="border rounded-3 p-3">
                                    <div class="small text-secondary">Service</div>
                                    <strong id="setPreviewService"><c:choose><c:when test="${selectedMenuSet.mealTime == 'LUNCH'}">Lunch Service</c:when><c:when test="${selectedMenuSet.mealTime == 'ALL_DAY'}">All Services</c:when><c:otherwise>Dinner Service</c:otherwise></c:choose></strong>
                                </div>
                            </div>
                            <div class="col-sm-4">
                                <div class="border rounded-3 p-3">
                                    <div class="small text-secondary">Suggested</div>
                                    <strong id="setPreviewSuggested"><fmt:formatNumber value="${selectedMenuSet.originalPrice}" pattern="#,##0"/></strong>
                                </div>
                            </div>
                            <div class="col-sm-4">
                                <div class="border rounded-3 p-3">
                                    <div class="small text-secondary">Selling</div>
                                    <strong id="setPreviewSelling"><fmt:formatNumber value="${selectedMenuSet.discountedPrice}" pattern="#,##0"/></strong>
                                </div>
                            </div>
                        </div>
                        <h3 class="h6 mb-3">Tasting menu courses</h3>
                        <c:choose>
                            <c:when test="${empty selectedMenuSetItems}">
                                <p class="text-secondary mb-0">No dishes yet. Build the courses below after saving the set.</p>
                            </c:when>
                            <c:otherwise>
                                <div class="vstack gap-3">
                                    <div class="border rounded-3 p-3">
                                        <div class="small text-uppercase text-secondary mb-2">Course 1 - Appetizer</div>
                                        <c:set var="hasAppetizer" value="false" />
                                        <c:forEach items="${selectedMenuSetItems}" var="setItem">
                                            <c:if test="${not empty setItem.menuItem.category && setItem.menuItem.category.categoryType == 'APPETIZER'}">
                                                <c:set var="hasAppetizer" value="true" />
                                                <div class="d-flex justify-content-between gap-3 py-2 border-top">
                                                    <div><strong>${setItem.menuItem.itemName}</strong><div class="small text-secondary"><c:out value="${empty setItem.defaultSize ? 'No default size' : setItem.defaultSize.sizeName}" /> - Qty ${setItem.quantity}</div></div>
                                                    <a class="btn btn-outline-danger btn-sm align-self-center" href="MainController?action=deleteMenuSetItem&id=${setItem.id}&returnTo=adminMenuSets&menuSetId=${selectedMenuSet.id}" onclick="return confirm('Remove this item from the set?')">Remove</a>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${!hasAppetizer}"><div class="text-secondary small">No appetizer selected.</div></c:if>
                                    </div>
                                    <div class="border rounded-3 p-3">
                                        <div class="small text-uppercase text-secondary mb-2">Course 2 - Soup</div>
                                        <c:set var="hasSoup" value="false" />
                                        <c:forEach items="${selectedMenuSetItems}" var="setItem">
                                            <c:if test="${not empty setItem.menuItem.category && setItem.menuItem.category.categoryType == 'SOUP'}">
                                                <c:set var="hasSoup" value="true" />
                                                <div class="d-flex justify-content-between gap-3 py-2 border-top">
                                                    <div><strong>${setItem.menuItem.itemName}</strong><div class="small text-secondary"><c:out value="${empty setItem.defaultSize ? 'No default size' : setItem.defaultSize.sizeName}" /> - Qty ${setItem.quantity}</div></div>
                                                    <a class="btn btn-outline-danger btn-sm align-self-center" href="MainController?action=deleteMenuSetItem&id=${setItem.id}&returnTo=adminMenuSets&menuSetId=${selectedMenuSet.id}" onclick="return confirm('Remove this item from the set?')">Remove</a>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${!hasSoup}"><div class="text-secondary small">Optional. Leave empty if this menu has no soup course.</div></c:if>
                                    </div>
                                    <div class="border rounded-3 p-3">
                                        <div class="small text-uppercase text-secondary mb-2">Course 3 - Main</div>
                                        <c:set var="hasMain" value="false" />
                                        <c:forEach items="${selectedMenuSetItems}" var="setItem">
                                            <c:if test="${not empty setItem.menuItem.category && setItem.menuItem.category.categoryType == 'MAIN'}">
                                                <c:set var="hasMain" value="true" />
                                                <div class="d-flex justify-content-between gap-3 py-2 border-top">
                                                    <div><strong>${setItem.menuItem.itemName}</strong><div class="small text-secondary"><c:out value="${empty setItem.defaultSize ? 'No default size' : setItem.defaultSize.sizeName}" /> - Qty ${setItem.quantity}</div></div>
                                                    <a class="btn btn-outline-danger btn-sm align-self-center" href="MainController?action=deleteMenuSetItem&id=${setItem.id}&returnTo=adminMenuSets&menuSetId=${selectedMenuSet.id}" onclick="return confirm('Remove this item from the set?')">Remove</a>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${!hasMain}"><div class="text-secondary small">No main course selected.</div></c:if>
                                    </div>
                                    <div class="border rounded-3 p-3">
                                        <div class="small text-uppercase text-secondary mb-2">Course 4 - Dessert</div>
                                        <c:set var="hasDessert" value="false" />
                                        <c:forEach items="${selectedMenuSetItems}" var="setItem">
                                            <c:if test="${not empty setItem.menuItem.category && setItem.menuItem.category.categoryType == 'DESSERT'}">
                                                <c:set var="hasDessert" value="true" />
                                                <div class="d-flex justify-content-between gap-3 py-2 border-top">
                                                    <div><strong>${setItem.menuItem.itemName}</strong><div class="small text-secondary"><c:out value="${empty setItem.defaultSize ? 'No default size' : setItem.defaultSize.sizeName}" /> - Qty ${setItem.quantity}</div></div>
                                                    <a class="btn btn-outline-danger btn-sm align-self-center" href="MainController?action=deleteMenuSetItem&id=${setItem.id}&returnTo=adminMenuSets&menuSetId=${selectedMenuSet.id}" onclick="return confirm('Remove this item from the set?')">Remove</a>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${!hasDessert}"><div class="text-secondary small">No dessert selected.</div></c:if>
                                    </div>
                                    <div class="border rounded-3 p-3">
                                        <div class="small text-uppercase text-secondary mb-2">Optional - Beverage / Add-on</div>
                                        <c:set var="hasDrink" value="false" />
                                        <c:forEach items="${selectedMenuSetItems}" var="setItem">
                                            <c:if test="${not empty setItem.menuItem.category && setItem.menuItem.category.categoryType == 'DRINK'}">
                                                <c:set var="hasDrink" value="true" />
                                                <div class="d-flex justify-content-between gap-3 py-2 border-top">
                                                    <div><strong>${setItem.menuItem.itemName}</strong><div class="small text-secondary"><c:out value="${empty setItem.defaultSize ? 'No default size' : setItem.defaultSize.sizeName}" /> - Qty ${setItem.quantity}</div></div>
                                                    <a class="btn btn-outline-danger btn-sm align-self-center" href="MainController?action=deleteMenuSetItem&id=${setItem.id}&returnTo=adminMenuSets&menuSetId=${selectedMenuSet.id}" onclick="return confirm('Remove this item from the set?')">Remove</a>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${!hasDrink}"><div class="text-secondary small">Optional pairing or beverage can be added later.</div></c:if>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <div class="d-flex flex-wrap justify-content-between align-items-start gap-3 mb-3">
                            <div>
                                <p class="text-uppercase text-secondary small mb-1">Draft set</p>
                                <h2 id="setPreviewName" class="h4 mb-1">Untitled menu set</h2>
                                <p id="setPreviewDescription" class="text-secondary mb-0">No description yet.</p>
                            </div>
                            <span id="setPreviewStatus" class="badge text-bg-success">Available</span>
                        </div>
                        <div class="row g-3 mb-4">
                            <div class="col-sm-4">
                                <div class="border rounded-3 p-3">
                                    <div class="small text-secondary">Service</div>
                                    <strong id="setPreviewService">Dinner Service</strong>
                                </div>
                            </div>
                            <div class="col-sm-4">
                                <div class="border rounded-3 p-3">
                                    <div class="small text-secondary">Suggested</div>
                                    <strong id="setPreviewSuggested">After dishes</strong>
                                </div>
                            </div>
                            <div class="col-sm-4">
                                <div class="border rounded-3 p-3">
                                    <div class="small text-secondary">Selling</div>
                                    <strong id="setPreviewSelling">After dishes</strong>
                                </div>
                            </div>
                        </div>
                        <div class="alert alert-light border mb-0">Save this set first, then the add-dish row will appear here.</div>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>
    </div>
    </c:if>

    <c:if test="${not empty selectedMenuSet && param.mode != 'details'}">
        <section class="border rounded-3 p-4 mb-4">
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-3">
                <div>
                    <p class="text-uppercase text-secondary small mb-1">Choose courses</p>
                    <h2 class="h5 mb-0">${selectedMenuSet.setName}</h2>
                </div>
                <a class="btn btn-outline-dark btn-sm" href="MainController?action=adminMenuSets&id=${selectedMenuSet.id}&mode=details">Back to set details</a>
            </div>
            <div class="row g-3 align-items-end">
                <div class="col-lg-3">
                    <label class="form-label">Course</label>
                    <select id="courseTypeInput" class="form-select">
                        <option value="APPETIZER">Course 1 - Appetizer</option>
                        <option value="SOUP">Course 2 - Soup</option>
                        <option value="MAIN">Course 3 - Main</option>
                        <option value="DESSERT">Course 4 - Dessert</option>
                        <option value="DRINK">Optional - Beverage</option>
                    </select>
                </div>
                <div class="col-lg-4">
                    <label class="form-label">Menu item</label>
                    <select id="courseMenuItemInput" class="form-select" name="menuItemId" required>
                        <c:forEach items="${categories}" var="category">
                            <optgroup label="${category.categoryName}">
                                <c:forEach items="${menuItems}" var="item">
                                    <c:if test="${not empty item.category && item.category.id == category.id}">
                                        <option value="${item.id}" data-course="${item.category.categoryType}">${item.itemName}</option>
                                    </c:if>
                                </c:forEach>
                            </optgroup>
                        </c:forEach>
                    </select>
                    <div id="courseEmptyMessage" class="form-text d-none">No dishes are available for this course. You can leave it empty.</div>
                </div>
                <div class="col-lg-3">
                    <label class="form-label">Default size</label>
                    <select id="courseSizeInput" class="form-select" name="defaultSizeId">
                        <option value="">No default size</option>
                        <c:forEach items="${menuItems}" var="item">
                            <optgroup label="${item.itemName}">
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
                    <label class="form-label">Qty</label>
                    <input id="courseQuantityInput" class="form-control" type="number" min="1" value="1" required>
                </div>
                <div class="col-6 col-lg-2">
                    <button id="addCourseDishButton" class="btn btn-dark w-100" type="button">Add</button>
                </div>
            </div>
            <form id="courseBatchForm" class="mt-4" method="post" action="MainController">
                <input type="hidden" name="action" value="saveMenuSetCourseItems">
                <input type="hidden" name="menuSetId" value="${selectedMenuSet.id}">
                <div class="border rounded-3">
                    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 p-3 border-bottom">
                        <div>
                            <h3 class="h6 mb-1">Selected dishes to save</h3>
                            <div class="small text-secondary">Add courses here first. The page saves them together, so it will not reload after each dish.</div>
                        </div>
                        <button id="saveCourseDishesButton" class="btn btn-outline-dark btn-sm" type="submit" disabled>Save selected dishes</button>
                    </div>
                    <div id="pendingCourseList" class="list-group list-group-flush">
                        <div id="pendingCourseEmpty" class="list-group-item text-secondary">No new dishes selected yet.</div>
                    </div>
                </div>
            </form>
            <hr class="my-4">
            <form id="menuPriceForm" class="row g-3 align-items-end" method="post" action="MainController">
                <input type="hidden" name="action" value="saveMenuSet">
                <input type="hidden" name="id" value="${selectedMenuSet.id}">
                <input type="hidden" name="setName" value="${selectedMenuSet.setName}">
                <input type="hidden" name="description" value="${selectedMenuSet.description}">
                <input type="hidden" name="mealTime" value="${selectedMenuSet.mealTime}">
                <input type="hidden" name="originalPrice" value="${selectedMenuSet.originalPrice}">
                <input type="hidden" name="imageUrl" value="${selectedMenuSet.imageUrl}">
                <c:if test="${selectedMenuSet.isAvailable}">
                    <input type="hidden" name="isAvailable" value="true">
                </c:if>
                <div class="col-lg-4">
                    <label class="form-label">Suggested price</label>
                    <input class="form-control" value="${selectedMenuSet.originalPrice}" readonly>
                    <div class="form-text">Calculated from the dishes in this set.</div>
                </div>
                <div class="col-lg-5">
                    <label class="form-label">Selling price</label>
                    <input id="setSellingInput" class="form-control" name="discountedPrice" type="number" min="0" step="1" value="${selectedMenuSet.discountedPrice}">
                    <div class="form-text">Adjust this after the menu is built.</div>
                </div>
                <div class="col-lg-3">
                    <button id="openMenuPreviewButton" class="btn btn-outline-dark w-100" type="button">Save price</button>
                </div>
            </form>
        </section>
        <section class="border rounded-3 p-4 mb-4">
            <div class="d-flex flex-wrap justify-content-between align-items-start gap-3 mb-3">
                <div>
                    <p class="text-uppercase text-secondary small mb-1">Menu preview</p>
                    <h2 id="setPreviewName" class="h4 mb-1">${selectedMenuSet.setName}</h2>
                    <p id="setPreviewDescription" class="text-secondary mb-0">${selectedMenuSet.description}</p>
                </div>
                <span id="setPreviewStatus" class="badge ${selectedMenuSet.isAvailable ? 'text-bg-success' : 'text-bg-secondary'}">${selectedMenuSet.isAvailable ? 'Available' : 'Hidden'}</span>
            </div>
            <div class="row g-3 mb-4">
                <div class="col-sm-4">
                    <div class="border rounded-3 p-3">
                        <div class="small text-secondary">Service</div>
                        <strong id="setPreviewService"><c:choose><c:when test="${selectedMenuSet.mealTime == 'LUNCH'}">Lunch Service</c:when><c:when test="${selectedMenuSet.mealTime == 'ALL_DAY'}">All Services</c:when><c:otherwise>Dinner Service</c:otherwise></c:choose></strong>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="border rounded-3 p-3">
                        <div class="small text-secondary">Suggested</div>
                        <strong id="setPreviewSuggested"><fmt:formatNumber value="${selectedMenuSet.originalPrice}" pattern="#,##0"/></strong>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="border rounded-3 p-3">
                        <div class="small text-secondary">Selling</div>
                        <strong id="setPreviewSelling"><fmt:formatNumber value="${selectedMenuSet.discountedPrice}" pattern="#,##0"/></strong>
                    </div>
                </div>
            </div>
            <h3 class="h6 mb-3">Tasting menu courses</h3>
            <c:choose>
                <c:when test="${empty selectedMenuSetItems}">
                    <p class="text-secondary mb-0">No saved dishes yet. Choose courses above, then save selected dishes.</p>
                </c:when>
                <c:otherwise>
                    <div class="vstack gap-3">
                        <div class="border rounded-3 p-3">
                            <div class="small text-uppercase text-secondary mb-2">Course 1 - Appetizer</div>
                            <c:set var="hasAppetizerPreview" value="false" />
                            <c:forEach items="${selectedMenuSetItems}" var="setItem">
                                <c:if test="${not empty setItem.menuItem.category && setItem.menuItem.category.categoryType == 'APPETIZER'}">
                                    <c:set var="hasAppetizerPreview" value="true" />
                                    <div class="d-flex justify-content-between gap-3 py-2 border-top">
                                        <div><strong>${setItem.menuItem.itemName}</strong><div class="small text-secondary"><c:out value="${empty setItem.defaultSize ? 'No default size' : setItem.defaultSize.sizeName}" /> - Qty ${setItem.quantity}</div></div>
                                        <a class="btn btn-outline-danger btn-sm align-self-center" href="MainController?action=deleteMenuSetItem&id=${setItem.id}&returnTo=adminMenuSets&menuSetId=${selectedMenuSet.id}" onclick="return confirm('Remove this item from the set?')">Remove</a>
                                    </div>
                                </c:if>
                            </c:forEach>
                            <c:if test="${!hasAppetizerPreview}"><div class="text-secondary small">No appetizer selected.</div></c:if>
                        </div>
                        <div class="border rounded-3 p-3">
                            <div class="small text-uppercase text-secondary mb-2">Course 2 - Soup</div>
                            <c:set var="hasSoupPreview" value="false" />
                            <c:forEach items="${selectedMenuSetItems}" var="setItem">
                                <c:if test="${not empty setItem.menuItem.category && setItem.menuItem.category.categoryType == 'SOUP'}">
                                    <c:set var="hasSoupPreview" value="true" />
                                    <div class="d-flex justify-content-between gap-3 py-2 border-top">
                                        <div><strong>${setItem.menuItem.itemName}</strong><div class="small text-secondary"><c:out value="${empty setItem.defaultSize ? 'No default size' : setItem.defaultSize.sizeName}" /> - Qty ${setItem.quantity}</div></div>
                                        <a class="btn btn-outline-danger btn-sm align-self-center" href="MainController?action=deleteMenuSetItem&id=${setItem.id}&returnTo=adminMenuSets&menuSetId=${selectedMenuSet.id}" onclick="return confirm('Remove this item from the set?')">Remove</a>
                                    </div>
                                </c:if>
                            </c:forEach>
                            <c:if test="${!hasSoupPreview}"><div class="text-secondary small">Optional. Leave empty if this menu has no soup course.</div></c:if>
                        </div>
                        <div class="border rounded-3 p-3">
                            <div class="small text-uppercase text-secondary mb-2">Course 3 - Main</div>
                            <c:set var="hasMainPreview" value="false" />
                            <c:forEach items="${selectedMenuSetItems}" var="setItem">
                                <c:if test="${not empty setItem.menuItem.category && setItem.menuItem.category.categoryType == 'MAIN'}">
                                    <c:set var="hasMainPreview" value="true" />
                                    <div class="d-flex justify-content-between gap-3 py-2 border-top">
                                        <div><strong>${setItem.menuItem.itemName}</strong><div class="small text-secondary"><c:out value="${empty setItem.defaultSize ? 'No default size' : setItem.defaultSize.sizeName}" /> - Qty ${setItem.quantity}</div></div>
                                        <a class="btn btn-outline-danger btn-sm align-self-center" href="MainController?action=deleteMenuSetItem&id=${setItem.id}&returnTo=adminMenuSets&menuSetId=${selectedMenuSet.id}" onclick="return confirm('Remove this item from the set?')">Remove</a>
                                    </div>
                                </c:if>
                            </c:forEach>
                            <c:if test="${!hasMainPreview}"><div class="text-secondary small">No main course selected.</div></c:if>
                        </div>
                        <div class="border rounded-3 p-3">
                            <div class="small text-uppercase text-secondary mb-2">Course 4 - Dessert</div>
                            <c:set var="hasDessertPreview" value="false" />
                            <c:forEach items="${selectedMenuSetItems}" var="setItem">
                                <c:if test="${not empty setItem.menuItem.category && setItem.menuItem.category.categoryType == 'DESSERT'}">
                                    <c:set var="hasDessertPreview" value="true" />
                                    <div class="d-flex justify-content-between gap-3 py-2 border-top">
                                        <div><strong>${setItem.menuItem.itemName}</strong><div class="small text-secondary"><c:out value="${empty setItem.defaultSize ? 'No default size' : setItem.defaultSize.sizeName}" /> - Qty ${setItem.quantity}</div></div>
                                        <a class="btn btn-outline-danger btn-sm align-self-center" href="MainController?action=deleteMenuSetItem&id=${setItem.id}&returnTo=adminMenuSets&menuSetId=${selectedMenuSet.id}" onclick="return confirm('Remove this item from the set?')">Remove</a>
                                    </div>
                                </c:if>
                            </c:forEach>
                            <c:if test="${!hasDessertPreview}"><div class="text-secondary small">No dessert selected.</div></c:if>
                        </div>
                        <div class="border rounded-3 p-3">
                            <div class="small text-uppercase text-secondary mb-2">Optional - Beverage / Add-on</div>
                            <c:set var="hasDrinkPreview" value="false" />
                            <c:forEach items="${selectedMenuSetItems}" var="setItem">
                                <c:if test="${not empty setItem.menuItem.category && setItem.menuItem.category.categoryType == 'DRINK'}">
                                    <c:set var="hasDrinkPreview" value="true" />
                                    <div class="d-flex justify-content-between gap-3 py-2 border-top">
                                        <div><strong>${setItem.menuItem.itemName}</strong><div class="small text-secondary"><c:out value="${empty setItem.defaultSize ? 'No default size' : setItem.defaultSize.sizeName}" /> - Qty ${setItem.quantity}</div></div>
                                        <a class="btn btn-outline-danger btn-sm align-self-center" href="MainController?action=deleteMenuSetItem&id=${setItem.id}&returnTo=adminMenuSets&menuSetId=${selectedMenuSet.id}" onclick="return confirm('Remove this item from the set?')">Remove</a>
                                    </div>
                                </c:if>
                            </c:forEach>
                            <c:if test="${!hasDrinkPreview}"><div class="text-secondary small">Optional pairing or beverage can be added later.</div></c:if>
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
                            <p class="text-uppercase text-secondary small mb-1">Confirm menu</p>
                            <h5 class="modal-title" id="menuPreviewModalTitle">${selectedMenuSet.setName}</h5>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p class="text-secondary">${selectedMenuSet.description}</p>
                        <div class="row g-3 mb-4">
                            <div class="col-sm-4"><div class="border rounded-3 p-3"><div class="small text-secondary">Service</div><strong><c:choose><c:when test="${selectedMenuSet.mealTime == 'LUNCH'}">Lunch Service</c:when><c:when test="${selectedMenuSet.mealTime == 'ALL_DAY'}">All Services</c:when><c:otherwise>Dinner Service</c:otherwise></c:choose></strong></div></div>
                            <div class="col-sm-4"><div class="border rounded-3 p-3"><div class="small text-secondary">Suggested</div><strong><fmt:formatNumber value="${selectedMenuSet.originalPrice}" pattern="#,##0"/></strong></div></div>
                            <div class="col-sm-4"><div class="border rounded-3 p-3"><div class="small text-secondary">Selling</div><strong id="modalSellingPriceText"><fmt:formatNumber value="${selectedMenuSet.discountedPrice}" pattern="#,##0"/></strong></div></div>
                        </div>
                        <div class="vstack gap-2">
                            <div class="border rounded-3 p-3">
                                <div class="small text-uppercase text-secondary mb-2">Course 1 - Appetizer</div>
                                <c:set var="hasModalAppetizer" value="false" />
                                <c:forEach items="${selectedMenuSetItems}" var="setItem"><c:if test="${not empty setItem.menuItem.category && setItem.menuItem.category.categoryType == 'APPETIZER'}"><c:set var="hasModalAppetizer" value="true" /><div>${setItem.menuItem.itemName}</div></c:if></c:forEach>
                                <c:if test="${!hasModalAppetizer}"><div class="text-secondary small">No appetizer selected.</div></c:if>
                            </div>
                            <div class="border rounded-3 p-3">
                                <div class="small text-uppercase text-secondary mb-2">Course 2 - Soup</div>
                                <c:set var="hasModalSoup" value="false" />
                                <c:forEach items="${selectedMenuSetItems}" var="setItem"><c:if test="${not empty setItem.menuItem.category && setItem.menuItem.category.categoryType == 'SOUP'}"><c:set var="hasModalSoup" value="true" /><div>${setItem.menuItem.itemName}</div></c:if></c:forEach>
                                <c:if test="${!hasModalSoup}"><div class="text-secondary small">No soup course.</div></c:if>
                            </div>
                            <div class="border rounded-3 p-3">
                                <div class="small text-uppercase text-secondary mb-2">Course 3 - Main</div>
                                <c:set var="hasModalMain" value="false" />
                                <c:forEach items="${selectedMenuSetItems}" var="setItem"><c:if test="${not empty setItem.menuItem.category && setItem.menuItem.category.categoryType == 'MAIN'}"><c:set var="hasModalMain" value="true" /><div>${setItem.menuItem.itemName}</div></c:if></c:forEach>
                                <c:if test="${!hasModalMain}"><div class="text-secondary small">No main course selected.</div></c:if>
                            </div>
                            <div class="border rounded-3 p-3">
                                <div class="small text-uppercase text-secondary mb-2">Course 4 - Dessert</div>
                                <c:set var="hasModalDessert" value="false" />
                                <c:forEach items="${selectedMenuSetItems}" var="setItem"><c:if test="${not empty setItem.menuItem.category && setItem.menuItem.category.categoryType == 'DESSERT'}"><c:set var="hasModalDessert" value="true" /><div>${setItem.menuItem.itemName}</div></c:if></c:forEach>
                                <c:if test="${!hasModalDessert}"><div class="text-secondary small">No dessert selected.</div></c:if>
                            </div>
                            <div class="border rounded-3 p-3">
                                <div class="small text-uppercase text-secondary mb-2">Optional - Beverage / Add-on</div>
                                <c:set var="hasModalDrink" value="false" />
                                <c:forEach items="${selectedMenuSetItems}" var="setItem"><c:if test="${not empty setItem.menuItem.category && setItem.menuItem.category.categoryType == 'DRINK'}"><c:set var="hasModalDrink" value="true" /><div>${setItem.menuItem.itemName}</div></c:if></c:forEach>
                                <c:if test="${!hasModalDrink}"><div class="text-secondary small">No beverage selected.</div></c:if>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Keep editing</button>
                        <button id="confirmMenuPriceButton" type="button" class="btn btn-dark">Confirm and save</button>
                    </div>
                </div>
            </div>
        </div>
    </c:if>

    <section>
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-3">
            <h2 class="h5 mb-0">All menu sets</h2>
            <span class="text-secondary small">Select a set to edit and add dishes.</span>
        </div>
        <div class="table-responsive">
            <table class="table align-middle">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Set</th>
                        <th>Service</th>
                        <th>Suggested</th>
                        <th>Selling</th>
                        <th>Status</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${menuSetList}" var="set">
                        <tr class="${not empty selectedMenuSet && selectedMenuSet.id == set.id ? 'table-light' : ''}">
                            <td>${set.id}</td>
                            <td>
                                <strong>${set.setName}</strong>
                                <div class="small text-secondary">${set.description}</div>
                            </td>
                            <td><c:choose><c:when test="${set.mealTime == 'LUNCH'}">Lunch Service</c:when><c:when test="${set.mealTime == 'ALL_DAY'}">All Services</c:when><c:otherwise>Dinner Service</c:otherwise></c:choose></td>
                            <td><fmt:formatNumber value="${set.originalPrice}" pattern="#,##0"/></td>
                            <td><fmt:formatNumber value="${set.discountedPrice}" pattern="#,##0"/></td>
                            <td><span class="badge ${set.isAvailable ? 'text-bg-success' : 'text-bg-secondary'}">${set.isAvailable ? 'Available' : 'Hidden'}</span></td>
                            <td class="text-end">
                                <a class="btn btn-outline-primary btn-sm" href="MainController?action=adminMenuSets&id=${set.id}">Select</a>
                                <a class="btn btn-outline-secondary btn-sm" href="MainController?action=toggleMenuSet&id=${set.id}&enabled=${!set.isAvailable}">${set.isAvailable ? 'Hide' : 'Show'}</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </section>
</main>
<script>
    (function () {
        var nameInput = document.getElementById('setNameInput');
        var descriptionInput = document.getElementById('setDescriptionInput');
        var serviceInput = document.getElementById('setServiceInput');
        var suggestedInput = document.getElementById('setSuggestedInput');
        var sellingInput = document.getElementById('setSellingInput');
        var availableInput = document.getElementById('setAvailableInput');
        var previewName = document.getElementById('setPreviewName');
        var previewDescription = document.getElementById('setPreviewDescription');
        var previewService = document.getElementById('setPreviewService');
        var previewSuggested = document.getElementById('setPreviewSuggested');
        var previewSelling = document.getElementById('setPreviewSelling');
        var previewStatus = document.getElementById('setPreviewStatus');
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

        function serviceLabel(value) {
            if (value === 'LUNCH') {
                return 'Lunch Service';
            }
            if (value === 'ALL_DAY') {
                return 'All Services';
            }
            return 'Dinner Service';
        }

        function moneyLabel(value) {
            var number = Number(value || 0);
            if (!isFinite(number)) {
                number = 0;
            }
            return new Intl.NumberFormat('en-US', {maximumFractionDigits: 0}).format(number);
        }

        function updatePreview() {
            if (previewName && nameInput) {
                previewName.textContent = nameInput.value.trim() || 'Untitled menu set';
            }
            if (previewDescription && descriptionInput) {
                previewDescription.textContent = descriptionInput.value.trim() || 'No description yet.';
            }
            if (previewService && serviceInput) {
                previewService.textContent = serviceLabel(serviceInput.value);
            }
            if (previewSuggested && suggestedInput) {
                previewSuggested.textContent = moneyLabel(suggestedInput.value);
            }
            if (previewSelling && sellingInput) {
                previewSelling.textContent = moneyLabel(sellingInput.value);
            }
            if (previewStatus && availableInput) {
                previewStatus.textContent = availableInput.checked ? 'Available' : 'Hidden';
                previewStatus.className = availableInput.checked ? 'badge text-bg-success' : 'badge text-bg-secondary';
            }
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
                return 'Course 1 - Appetizer';
            }
            if (value === 'SOUP') {
                return 'Course 2 - Soup';
            }
            if (value === 'MAIN') {
                return 'Course 3 - Main';
            }
            if (value === 'DESSERT') {
                return 'Course 4 - Dessert';
            }
            return 'Optional - Beverage';
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
            details.innerHTML = '<strong>' + selectedItem.text + '</strong><div class="small text-secondary">' + courseLabel(courseTypeInput.value) + ' - ' + (selectedSize ? selectedSize.text : 'No default size') + ' - Qty ' + quantity + '</div>';
            var remove = document.createElement('button');
            remove.type = 'button';
            remove.className = 'btn btn-outline-danger btn-sm';
            remove.textContent = 'Remove';
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
            if (window.confirm('Review the menu preview. Confirm and save this selling price?')) {
                menuPriceForm.submit();
            }
        }

        [nameInput, descriptionInput, serviceInput, suggestedInput, sellingInput, availableInput].forEach(function (field) {
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
<jsp:include page="/footer.jsp" />
