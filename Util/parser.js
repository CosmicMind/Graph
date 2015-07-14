var fs = require('fs');

var DEFAULT_DIRECTORY = '../Source/';

fs.readdir(process.argv[2] || DEFAULT_DIRECTORY, function(error, files) {
   if (error) throw error;

   for (var file in files) {
       file = files[file];
       if (/.swift$/.test(file)) {
           fs.readFile(DEFAULT_DIRECTORY + file, function (error, data) {
             if (error) { throw error; }
             data = data.toString();
             var comments = data.match(/\/\*\*(.)*\*\//g);
             console.log(comments);
             var classes = data.match(/(public|internal|private)+\s*(var|let|func|class|protocol)+\s*([a-zA-Z0-9_<,>:])+(\(.*\))*\s*(->)*\s*([a-zA-Z])*/g);
             if (classes) {
                 for (var i = classes.length - 1; 0 <= i; --i) {
                     classes[i] = '```swift\n' + classes[i] + '\n```';
                 }
                 console.log(classes.join('\n'));
             }

             /*var comments = data.match(/\/\*(.|\n)*\*\//g);
             console.log(comments.join(' '));*/
           });
       }
       break;
   }
});
