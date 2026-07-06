const fs = require('fs');
let path = "d:/Github_Projects/PRJ301_DOANQUANLYNHAHANG/RestaurantManagement/web/customer/my-reservations.jsp";
let content = fs.readFileSync(path, 'utf8');
let lines = content.split('\n');
for (let i = 56; i <= 58; i++) {
    console.log(lines[i]);
}
