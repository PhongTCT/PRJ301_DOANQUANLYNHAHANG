const fs = require('fs');
const path = require('path');

function walk(dir) {
    let results = [];
    let list = fs.readdirSync(dir);
    list.forEach(function(file) {
        file = path.join(dir, file);
        let stat = fs.statSync(file);
        if (stat && stat.isDirectory()) {
            results = results.concat(walk(file));
        } else {
            if (file.endsWith('.jsp')) {
                results.push(file);
            }
        }
    });
    return results;
}

let jspFiles = walk('d:/Github_Projects/PRJ301_DOANQUANLYNHAHANG/RestaurantManagement/web');
let fixedCount = 0;
for (let file of jspFiles) {
    let content = fs.readFileSync(file, 'utf8');
    if (content.includes('?') || content.includes('?')) {
        let buffer = Buffer.from(content, 'latin1');
        let fixedContent = buffer.toString('utf8');
        fs.writeFileSync(file, fixedContent, 'utf8');
        console.log("Fixed: " + file);
        fixedCount++;
    }
}
console.log("Total fixed: " + fixedCount);
