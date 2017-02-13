var vPartList = require('./vpartlist.js');


new vPartList([
    "modules/shifter.v",
    "-path"
], function(list, err) {
    if (err) {
        console.log(err)
        return;
    }
    console.log(list);
});