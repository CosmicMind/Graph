var fs = require('fs');

var DEFAULT_DIRECTORY = '../Source/';
var DEFAULT_FILE = '.swift$';

fs.readdir(DEFAULT_DIRECTORY, function(error, files) {
     if (error) throw error;

     for (var filename in files) {
         filename = files[filename];
         if (/.swift$/.test(filename)) {
             parseFile(filename, process.argv[2] == 'jade' ? formatToJade : formatToMd);
         }
     }
});

function parseFile(filename, callback) {
        fs.readFile(DEFAULT_DIRECTORY + filename, function (error, data) {
            if (error) { throw error; }
            data = data.toString();
            var result = [];
            var comments = data.match(/(\/\*\*(?:(?!\*\/).|[\n\r])*\*\/)([\n\r])*(.*\{)/g);
            for (var i = comments.length - 1; 0 <= i; --i) {
                    comments[i] = comments[i].replace(/(\/\*\*)/, '').replace(/(\*\/)/, '');
                    var description = comments[i].replace(/^\s+|\s+$/g, '').split('\n');
                    var dataObject = {};
                    dataObject.title = description.shift();

                    var declaration = description.pop();
                    declaration = declaration.split(' ');
                    declaration.pop();
                    for (var j = description.length - 1; 0 <= j; --j) {
                            description[j] = description[j].replace(/^\s+|\s+$/g, '');
                    }

                    dataObject.description = description.join(' ')
                    dataObject.declaration = declaration.join(' ').replace(/^\s+|\s+$/g, '');
                    result.push(dataObject);
            }
            callback(filename, result);
        });
}

function formatToMd(filename, data) {
    var output = '';
    for (var i = data.length -1; 0 <= i; --i) {
        output += '### ' + data[i].title + '\n';
        output += data[i].description + '\n';
        output += '```swift\n' + data[i].declaration + '\n```\n';
    }
    fs.writeFile('../../swift.wiki/' + filename.replace(/swift$/g, 'md'), output, {encoding: 'utf8'}, function(error) {});
}

function formatToJade(filename, data) {
    var output = '';
    for (var i = data.length -1; 0 <= i; --i) {
        output += 'h1 ' + data[i].title + '\n';
        output += 'p ' + data[i].description + '\n';
        output += 'p ' + data[i].declaration + '\n';
    }
    fs.writeFile('../../../graphkit.io/app/views/docs/' + filename.replace(/swift$/g, 'jade').toLowerCase(), output, {encoding: 'utf8'}, function(error) {});
}
