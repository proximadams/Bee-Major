const fs = require('node:fs');
const readline = require('readline');

const fileStream = fs.createReadStream('./Bee_Major_Jazz_Song.mei');

// load('res://mp3_files/_C4.mp3'),# 1. C
// load('res://mp3_files/_D♭4.mp3'),# 2. D♭
// load('res://mp3_files/_D4.mp3'),# 3. D
// load('res://mp3_files/_E♭4.mp3'),# 4. E♭
// load('res://mp3_files/_E4.mp3'),# 5. E
// load('res://mp3_files/_F4.mp3'),# 6. F
// load('res://mp3_files/_G♭4.mp3'),# 7. G♭
// load('res://mp3_files/_G4.mp3'),# 8. G
// load('res://mp3_files/A♭4.mp3'),# 9. A♭
// load('res://mp3_files/A4.mp3'),# 10. A
// load('res://mp3_files/B♭4.mp3'),# 11. B♭
// load('res://mp3_files/B4.mp3'),# 12. B
// load('res://mp3_files/C5.mp3')# 13. C

// TODO add flats
const noteNumberObj = {
    'a': 10,
    'b': 12,
    'c': 1,
    'd': 3,
    'e': 5,
    'f': 6,
    'g': 8
}

const rl = readline.createInterface({
    input: fileStream,
    crlfDelay: Infinity
});

var outputFileContent = '['

rl.on('line', (line) => {
    if (line.includes('<rest')) {
        var durIndex = line.indexOf('dur=') + 5
        outputFileContent += '\n    [0, ' + line[durIndex] + '],'
    }
    if (line.includes('<note')) {
        // TODO
        // account for next line being one of the following
        // <accid accid="s" />
        // <accid accid="f" />
        var noteCharIndex = line.indexOf('pname=') + 7
        var durIndex = line.indexOf('dur=') + 5
        var noteNumberIndex = noteNumberObj[line[noteCharIndex]]
        outputFileContent += '\n    [' + String(noteNumberIndex) + ', ' + line[durIndex] + '],'
    }
});

rl.on('close', () => {
    outputFileContent += '\n]'

    fs.writeFile('./output.json', outputFileContent, (err) => {
        if(err) {
            return console.log(err);
        }
        console.log("The file was saved!");
    })
})
