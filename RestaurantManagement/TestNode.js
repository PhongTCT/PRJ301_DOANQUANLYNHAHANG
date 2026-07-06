const fs = require('fs');
let path = "d:/Github_Projects/PRJ301_DOANQUANLYNHAHANG/RestaurantManagement/web/customer/my-reservations.jsp";
let content = fs.readFileSync(path, 'utf8');
let buffer = Buffer.from(content, 'latin1');
let fixedContent = buffer.toString('utf8');
console.log(fixedContent.substring(fixedContent.indexOf('reserve-title mb-3">') + 20, fixedContent.indexOf('</h1>')));
