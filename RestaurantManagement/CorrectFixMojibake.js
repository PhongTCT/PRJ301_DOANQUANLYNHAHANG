const fs = require('fs');
const path = require('path');

const win1252ToByte = {
    '\u20AC': 0x80, '\u201A': 0x82, '\u0192': 0x83, '\u201E': 0x84, '\u2026': 0x85,
    '\u2020': 0x86, '\u2021': 0x87, '\u02C6': 0x88, '\u2030': 0x89, '\u0160': 0x8A,
    '\u2039': 0x8B, '\u0152': 0x8C, '\u017D': 0x8E, '\u2018': 0x91, '\u2019': 0x92,
    '\u201C': 0x93, '\u201D': 0x94, '\u2022': 0x95, '\u2013': 0x96, '\u2014': 0x97,
    '\u02DC': 0x98, '\u2122': 0x99, '\u0161': 0x9A, '\u203A': 0x9B, '\u0153': 0x9C,
    '\u017E': 0x9E, '\u0178': 0x9F
};

function isWin1252(ch) {
    let code = ch.charCodeAt(0);
    if (code >= 0x80 && code <= 0xFF) return true;
    if (win1252ToByte[ch] !== undefined) return true;
    return false;
}

function getByte(ch) {
    let code = ch.charCodeAt(0);
    if (code <= 0xFF) return code;
    return win1252ToByte[ch];
}

function walk(dir) {
    let results = [];
    let list = fs.readdirSync(dir);
    list.forEach(function(file) {
        file = path.join(dir, file);
        if (fs.statSync(file).isDirectory()) results = results.concat(walk(file));
        else if (file.endsWith('.jsp')) results.push(file);
    });
    return results;
}

let jspFiles = walk('d:/Github_Projects/PRJ301_DOANQUANLYNHAHANG/RestaurantManagement/web');
let fixedCount = 0;

for (let file of jspFiles) {
    let content = fs.readFileSync(file, 'utf8');

    let newContent = '';
    let i = 0;
    let modified = false;

    while (i < content.length) {
        if (isWin1252(content[i])) {
            let start = i;
            while (i < content.length && isWin1252(content[i])) {
                i++;
            }
            let seq = content.substring(start, i);
            let bytes = Buffer.alloc(seq.length);
            for (let j = 0; j < seq.length; j++) {
                bytes[j] = getByte(seq[j]);
            }
            let decoded = bytes.toString('utf8');
            if (decoded.includes('\uFFFD')) {
                newContent += seq;
            } else {
                if (decoded !== seq) {
                    modified = true;
                }
                newContent += decoded;
            }
        } else {
            newContent += content[i];
            i++;
        }
    }

    if (modified) {
        fs.writeFileSync(file, newContent, 'utf8');
        console.log("Fixed: " + file);
        fixedCount++;
    }
}
console.log("Total correctly fixed: " + fixedCount);
