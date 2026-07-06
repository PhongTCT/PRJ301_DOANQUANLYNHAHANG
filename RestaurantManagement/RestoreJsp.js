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

let buildJspFiles = walk('d:/Github_Projects/PRJ301_DOANQUANLYNHAHANG/RestaurantManagement/build/web');
let restoredCount = 0;
for (let buildFile of buildJspFiles) {
    let relPath = path.relative('d:/Github_Projects/PRJ301_DOANQUANLYNHAHANG/RestaurantManagement/build/web', buildFile);
    let targetFile = path.join('d:/Github_Projects/PRJ301_DOANQUANLYNHAHANG/RestaurantManagement/web', relPath);
    if (fs.existsSync(targetFile)) {
        fs.copyFileSync(buildFile, targetFile);
        restoredCount++;
    }
}
console.log("Total restored: " + restoredCount);
