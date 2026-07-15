const fs = require('fs');
let content = fs.readFileSync('d:/Github_Projects/PRJ301_DOANQUANLYNHAHANG/RestaurantManagement/web/admin/sidebar.jsp', 'utf8');
content = content.replace(/\$\{sidebarIsEn \? 'Areas' : '.*?'\}/g, "\");
content = content.replace(/\$\{sidebarIsEn \? 'Rooms' : '.*?'\}/g, "\");
fs.writeFileSync('d:/Github_Projects/PRJ301_DOANQUANLYNHAHANG/RestaurantManagement/web/admin/sidebar.jsp', content, 'utf8');
