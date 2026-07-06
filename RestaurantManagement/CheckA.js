const fs = require('fs');
let path = "d:/Github_Projects/PRJ301_DOANQUANLYNHAHANG/RestaurantManagement/web/customer/my-reservations.jsp";
let content = fs.readFileSync(path, 'utf8');
console.log(content.includes('?'));
