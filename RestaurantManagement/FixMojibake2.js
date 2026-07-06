const fs = require('fs');
const files = [
    "notifications.jsp",
    "rank-history.jsp",
    "rank-topup.jsp"
];
for (let file of files) {
    let path = "d:/Github_Projects/PRJ301_DOANQUANLYNHAHANG/RestaurantManagement/web/customer/" + file;
    let content = fs.readFileSync(path, 'utf8');
    if (content.includes('?') || content.includes('?')) {
        let buffer = Buffer.from(content, 'latin1');
        let fixedContent = buffer.toString('utf8');
        fs.writeFileSync(path, fixedContent, 'utf8');
        console.log("Fixed: " + file);
    }
}
