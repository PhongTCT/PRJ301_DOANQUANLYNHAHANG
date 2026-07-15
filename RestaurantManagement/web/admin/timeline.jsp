<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang == 'vi' ? 'vi_VN' : 'en_US'}" />
<fmt:setBundle basename="i18n.messages" />
<!DOCTYPE html>
<html lang="${sessionScope.lang == 'en' ? 'en' : 'vi'}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Le Royal - <fmt:message key="admin.timeline.title"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Marcellus&family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/admin-royal.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/main.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.js"></script>
    <style>
        .fc .fc-toolbar-title { font-family: 'Marcellus', serif; font-weight: 600; font-size: 1.75rem; color: #1a1d20; }
        .fc-theme-standard .fc-scrollgrid { border-radius: 8px; overflow: hidden; }
        .fc .fc-button-primary { background-color: #1a1d20; border-color: #1a1d20; }
        .fc .fc-button-primary:hover { background-color: #d4af37; border-color: #d4af37; color: #1a1d20; }
        .fc .fc-button-primary:not(:disabled).fc-button-active { background-color: #d4af37; border-color: #d4af37; color: #1a1d20; }
    </style>
</head>
<body class="admin-royal">
    <div class="container-fluid p-0">
        <div class="d-flex">
            <jsp:include page="/admin/sidebar.jsp">
                <jsp:param name="active" value="timeline"/>
            </jsp:include>

            <!-- Main Content -->
            <div class="flex-grow-1 p-5 bg-light">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h2 class="fw-bold mb-0"><fmt:message key="admin.timeline.title"/></h2>
                        <p class="text-muted"><fmt:message key="admin.timeline.desc"/></p>
                    </div>
                    <div class="d-flex align-items-center">
                        <label for="datePicker" class="form-label mb-0 me-3 fw-bold text-muted"><fmt:message key="admin.timeline.jump"/></label>
                        <input type="date" id="datePicker" class="form-control shadow-sm border-0" style="width: 200px; padding: 0.5rem 1rem;">
                    </div>
                </div>

                <div class="card shadow-sm border-0 mb-4 rounded-4">
                    <div class="card-body p-4 bg-white">
                        <div id="calendar"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var calendarEl = document.getElementById('calendar');
            var calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'timeGridWeek',
                firstDay: 1, // Start on Monday
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'timeGridWeek,timeGridDay'
                },
                slotMinTime: '16:00:00', // Operations start late afternoon
                slotMaxTime: '23:00:00',
                height: 700,
                allDaySlot: false,
                nowIndicator: true,
                events: ${eventsJson != null ? eventsJson : '[]'},
                datesSet: function(dateInfo) {
                    var d = calendar.getDate();
                    var month = '' + (d.getMonth() + 1);
                    var day = '' + d.getDate();
                    var year = d.getFullYear();
                    if (month.length < 2) month = '0' + month;
                    if (day.length < 2) day = '0' + day;
                    document.getElementById('datePicker').value = [year, month, day].join('-');
                }
            });
            calendar.render();
            
            document.getElementById('datePicker').addEventListener('change', function(e) {
                if (e.target.value) {
                    calendar.gotoDate(e.target.value);
                }
            });
        });
    </script>
</body>
</html>
