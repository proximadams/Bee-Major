const fs = require('node:fs');
const readline = require('readline');

const fileStream = fs.createReadStream('./Songs/The Saints Trumpet.mei');

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
    if (line.includes('<mRest')) {
        outputFileContentArr.push('    [0, 1],')
    }
    if (line.includes('<rest')) {
        var durIndex = line.indexOf('dur=') + 5
        var durValue = line[durIndex]
        if (line.includes('dots=')) {
            durValue = String(Number(durValue) + Number(durValue)/2)
        }
        outputFileContentArr.push('    [0, ' + durValue + '],')
    }
    if (line.includes('<note')) {
        var noteCharIndex = line.indexOf('pname=') + 7
        var durIndex = line.indexOf('dur=') + 5
        var durValue = line[durIndex]
        var noteNumberIndex = noteNumberObj[line[noteCharIndex]]
        if (line.includes('dots=')) {
            durValue = String(Number(durValue) + Number(durValue)/2)
        }
        outputFileContentArr.push('    [' + String(noteNumberIndex) + ', ' + durValue + '],')
        prevNoteNumberIndex = noteNumberIndex
        prevDurIndex = durValue
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
