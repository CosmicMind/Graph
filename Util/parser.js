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
               parseFile(file, formatToMd);
           }
       }
   }
});

function parseFile(file, callback) {
    fs.readFile(DEFAULT_DIRECTORY + file, function (error, data) {
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
      callback(result);
    });
}

function formatToMd(array) {
  for (var i = array.length -1; 0 <= i; --i) {
    array[i].title = '### ' + array[i].title + '\n';
    array[i].declaration = '\n```swift\n' + array[i].declaration + '\n```';
  }
  console.log(array);
}
