var fs = require('fs');

var DEFAULT_DIRECTORY = '../Source/';
var DEFAULT_FILE = '.swift$';

fs.readdir(process.argv[2] || DEFAULT_DIRECTORY, function(error, files) {
   if (error) throw error;

   if (process.argv[3]) {
       parseFile(process.argv[3]);
   } else {
       for (var file in files) {
           file = files[file];
           if (/.swift$/.test(file)) {
               parseFile(file);
           }
           break;
       }
   }
});

function parseFile(file) {
    fs.readFile(DEFAULT_DIRECTORY + file, function (error, data) {
      if (error) { throw error; }
      data = data.toString();
      var comments = data.match(/(\/\*\*(?:(?!\*\/).|[\n\r])*\*\/)\n(.*\{)/g);
      for (var i = comments.length - 1; 0 <= i; --i) {
          comments[i] = comments[i].replace(/(\/\*\*)/, '').replace(/(\*\/)/, '');
          var description = comments[i].replace(/^\s+|\s+$/g, '').split('\n');
          comments[i] = '### ' + description.shift() + '\n';

          var declaration = description.pop();
          declaration = declaration.split(' ');
          declaration.pop();

          for (var j = description.length - 1; 0 <= j; --j) {
              description[j] = description[j].replace(/^\s+|\s+$/g, '');
          }
          comments[i] += description.join(' ');
          comments[i] += '\n```swift\n' + declaration.join(' ').replace(/^\s+|\s+$/g, '') + '\n```';
      }
      comments.shift();
      console.log(comments.join('\n'));
    });
}
