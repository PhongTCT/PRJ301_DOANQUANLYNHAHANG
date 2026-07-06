const fs = require('fs');
let path = "d:/Github_Projects/PRJ301_DOANQUANLYNHAHANG/RestaurantManagement/web/common/booking-step2.jsp";
let content = fs.readFileSync(path, 'utf8');
let idx = content.indexOf(String.fromCharCode(0x18));
if (idx !== -1) {
    let str = content.substring(idx - 5, idx + 5);
    for (let i = 0; i < str.length; i++) {
        console.log(str[i] + ' = ' + str.charCodeAt(i));
    }
} else {
    console.log("No 0x18 found");
}
