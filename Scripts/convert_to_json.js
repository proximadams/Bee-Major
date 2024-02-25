const fs = require('node:fs');
const readline = require('readline');

const fileStream = fs.createReadStream('./Bee_Major_Jazz_Song.mei');

// TODO add flats/sharps?
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

var outputFileContentArr = ['[']
var prevNoteNumberIndex
var prevDurIndex

rl.on('line', (line) => {
    if (line.includes('<rest')) {
        var durIndex = line.indexOf('dur=') + 5
        outputFileContentArr.push('    [0, ' + line[durIndex] + '],')
    }
    if (line.includes('<note')) {
        // TODO
        // account for next line being one of the following
        // <accid accid="s" />
        // <accid accid="f" />
        var noteCharIndex = line.indexOf('pname=') + 7
        var durIndex = line.indexOf('dur=') + 5
        var noteNumberIndex = noteNumberObj[line[noteCharIndex]]
        outputFileContentArr.push('    [' + String(noteNumberIndex) + ', ' + line[durIndex] + '],')
        prevNoteNumberIndex = noteNumberIndex
        prevDurIndex = line[durIndex]
    }
    if (line.includes('<accid')) {
        if (line.includes('accid="s"')) {
            // sharp
            var newNumberIndex = prevNoteNumberIndex +1
            var newDurIndex = prevDurIndex
            outputFileContentArr[outputFileContentArr.length -1] = '    [' + String(newNumberIndex) + ', ' + newDurIndex + '],'
        } else if (line.includes('accid="f"')) {
            // flat
            var newNumberIndex = prevNoteNumberIndex -1
            var newDurIndex = prevDurIndex
            outputFileContentArr[outputFileContentArr.length -1] = '    [' + String(newNumberIndex) + ', ' + newDurIndex + '],'
        }
    }
});

rl.on('close', () => {
    var arrLen = outputFileContentArr.length
    var lenLastLine = outputFileContentArr[arrLen -1].length
    outputFileContentArr[arrLen -1] = outputFileContentArr[arrLen -1].substring(0, lenLastLine -1)
    outputFileContentArr.push(']')
    var outputFileContentStr = outputFileContentArr.join('\n')

    fs.writeFile('./Songs/output.json', outputFileContentStr, (err) => {
        if(err) {
            return console.log(err);
        }
        console.log("The file was saved!");
    })
})
