const fs = require('fs');
let content = fs.readFileSync("d:/Github_Projects/PRJ301_DOANQUANLYNHAHANG/RestaurantManagement/web/common/booking-step2.jsp", 'utf8');
let invalid = [];
for (let i = 0; i < content.length; i++) {
    let code = content.charCodeAt(i);
    if (code < 0x20 && code !== 0x09 && code !== 0x0A && code !== 0x0D) {
        invalid.push(code);
    }
}
console.log("Invalid XML chars: " + invalid.join(', '));
