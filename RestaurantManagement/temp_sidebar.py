import re

with open('d:/Github_Projects/PRJ301_DOANQUANLYNHAHANG/RestaurantManagement/web/admin/sidebar.jsp', 'r', encoding='utf-8', errors='ignore') as f:
    content = f.read()

content = re.sub(r"\$\{sidebarIsEn \? 'Areas' : '[^']*'\}", "\", content)
content = re.sub(r"\$\{sidebarIsEn \? 'Rooms' : '[^']*'\}", "\", content)

with open('d:/Github_Projects/PRJ301_DOANQUANLYNHAHANG/RestaurantManagement/web/admin/sidebar.jsp', 'w', encoding='utf-8') as f:
    f.write(content)
