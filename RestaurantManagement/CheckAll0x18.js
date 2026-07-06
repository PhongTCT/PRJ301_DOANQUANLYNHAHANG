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

for (let file of jspFiles) {
    let content = fs.readFileSync(file, 'utf8');
    let idx = content.indexOf(String.fromCharCode(0x18));
    if (idx !== -1) {
        console.log("Corrupted (0x18): " + file);
    }
}
