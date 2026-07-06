const fs = require('fs');
let content = fs.readFileSync("d:/Github_Projects/PRJ301_DOANQUANLYNHAHANG/RestaurantManagement/web/common/booking-step2.jsp", 'utf8');
let fixed = content.replace(/\uFFFD\x18/g, '?').replace(/\uFFFD\x11/g, '?');
fs.writeFileSync("d:/Github_Projects/PRJ301_DOANQUANLYNHAHANG/RestaurantManagement/web/common/booking-step2.jsp", fixed, 'utf8');
console.log("Replaced 0x18 and 0x11 in booking-step2.jsp");
