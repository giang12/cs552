var PartList = require('./partlist.js');


new PartList([
    "modules/shifter.v",
    "-path"
], function(list, err) {
    if (err) {
        console.log(err)
        return;
    }
    console.log(list);
});