const fs = require('fs');
let content = fs.readFileSync("d:/Github_Projects/PRJ301_DOANQUANLYNHAHANG/RestaurantManagement/web/common/booking-confirmation.jsp", 'utf8');
if (content.match(/[\x80-\xFF]/)) {
    console.log("Still has Latin1 chars");
} else {
    console.log("Clean");
}
