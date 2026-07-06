const fs = require('fs');
let content = fs.readFileSync("d:/Github_Projects/PRJ301_DOANQUANLYNHAHANG/RestaurantManagement/web/common/booking-step2.jsp", 'utf8');
let idx = content.indexOf('pattern="#,##0"/> ') + 18;
console.log(content.substring(idx, idx + 5));
