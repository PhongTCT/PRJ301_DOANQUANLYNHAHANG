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
    
    // Quick check if the file even needs fixing
    if (!content.includes('?') && !content.includes('?')) {
        continue;
    }

    let newContent = '';
    let regex = /[\x00-\xFF]+/g;
    let lastIndex = 0;
    let match;
    let modified = false;

    while ((match = regex.exec(content)) !== null) {
        newContent += content.substring(lastIndex, match.index);
        
        let buf = Buffer.from(match[0], 'latin1');
        let decoded = buf.toString('utf8');
        
        if (decoded.includes('\uFFFD')) { // Replacement character 
            newContent += match[0];
        } else {
            if (decoded !== match[0]) {
                modified = true;
            }
            newContent += decoded;
        }
        lastIndex = regex.lastIndex;
    }
    newContent += content.substring(lastIndex);
    
    if (modified) {
        fs.writeFileSync(file, newContent, 'utf8');
        console.log("Safely Fixed: " + file);
        fixedCount++;
    }
}
console.log("Total safely fixed: " + fixedCount);
