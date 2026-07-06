const fs = require('fs');
const files = [
    "my-invoices.jsp",
    "my-reservations.jsp",
    "my-reviews.jsp",
    "my-vouchers.jsp"
];
for (let file of files) {
    let path = "d:/Github_Projects/PRJ301_DOANQUANLYNHAHANG/RestaurantManagement/web/customer/" + file;
    let content = fs.readFileSync(path, 'utf8');
    let buffer = Buffer.from(content, 'latin1');
    let fixedContent = buffer.toString('utf8');
    
    fs.writeFileSync(path, fixedContent, 'utf8');
    console.log("Fixed: " + file);
}
