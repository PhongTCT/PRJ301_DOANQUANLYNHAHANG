const fs = require('fs');
let path = "d:/Github_Projects/PRJ301_DOANQUANLYNHAHANG/RestaurantManagement/build/web/common/booking-step2.jsp";
let content = fs.readFileSync(path, 'utf8');
console.log("Contains 0x18? " + (content.indexOf(String.fromCharCode(0x18)) !== -1));
