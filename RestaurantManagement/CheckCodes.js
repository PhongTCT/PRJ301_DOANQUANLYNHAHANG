const fs = require('fs');
let path = "d:/Github_Projects/PRJ301_DOANQUANLYNHAHANG/RestaurantManagement/web/customer/my-reservations.jsp";
let content = fs.readFileSync(path, 'utf8');
let idx = content.indexOf('reserve-title mb-3">') + 20;
let str = content.substring(idx, idx + 10);
for (let i = 0; i < str.length; i++) {
    console.log(str[i] + ' = ' + str.charCodeAt(i));
}
