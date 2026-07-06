const fs = require('fs');
let path = "d:/Github_Projects/PRJ301_DOANQUANLYNHAHANG/RestaurantManagement/build/web/common/booking-step2.jsp";
let content = fs.readFileSync(path, 'utf8');
let buffer = Buffer.from(content, 'latin1');
let fixedContent = buffer.toString('utf8');
let idx = fixedContent.indexOf(String.fromCharCode(0x18));
if (idx !== -1) {
    console.log("Found 0x18 near:");
    console.log(fixedContent.substring(idx - 20, idx + 20));
}
