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
             var comments = data.match(/(\/\*\*(?:(?!\*\/).|[\n\r])*\*\/)\n(.*\{)/g);
             for (var i = comments.length - 1; 0 <= i; --i) {
                 comments[i] = comments[i].replace(/(\/\*\*)/, '').replace(/(\*\/)/, '');
                 var description = comments[i].replace(/^\s+|\s+$/g, '').split('\n');
                 comments[i] = '### ' + description.shift() + '\n';

                 var declaration = description.pop();
                 declaration = declaration.split(' ');
                 declaration.pop();

                 comments[i] += description.join('\n').replace(/^\s+|\s+$/g, '');
                 comments[i] += '\n```swift\n' + declaration.join(' ').replace(/^\s+|\s+$/g, '') + '\n```';
             }
             comments.shift();
             console.log(comments.join('\n'));
            //  var classes = data.match(/(extension|override|convenience|public|internal|private)+\s*(var|let|func|class|protocol|convenience)+\s*([a-zA-Z0-9_<,>:==]|init|subscript)*\s*(\(.*\)|.*<.*>)*\s*(->)*\s*([a-zA-Z])*/g);
            //  if (classes) {
            //      for (var i = classes.length - 1; 0 <= i; --i) {
            //          classes[i] = (comments[i] || '') + '\n```swift\n' + classes[i] + '\n```';
            //      }
            //      console.log(classes.join('\n'));
            //  }

             /*var comments = data.match(/\/\*(.|\n)*\*\//g);
             console.log(comments.join(' '));*/
           });
       }
       break;
   }
});
