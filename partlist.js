/*
partlist.js

get part list of module X under modules/

tocheck = [X.v]
modules=[get all filename under modules/]
list = []
whileToCheck not empty
	checking = tocheck.slice();
	list.add(checking );
	for each token X in "checking" 
		if in [modules] and not in list[]
			tocheck.add(X)
		endif
	endfor
endwhile
output X.v a.v a.v a.v
 */
var fs = require('fs');
var path = require('path');
Array.prototype.contains = function(obj) {
    var i = this.length;
    while (i--) {
        if (this[i] === obj) {
            return true;
        }
    }
    return false;
}
var List = function() {
    this.parts = [];
}
List.prototype.add = function(part) {
    if (!this.has(part)) {
        this.parts.push(flags.p ? part : path.basename(part));
        return true;
    }
    return false;
}

List.prototype.has = function(part) {

    return this.parts.contains((flags.p ? part : path.basename(part)));
}

var args = process.argv;

if (args.length < 3) {

    console.log("usage: node partlist.js modules/moduleToGetPartListOf.v");
    console.log("node partlist.js help! for more info");
    process.exit(1);
}
if (args[2].toLowerCase() === "help") {

    console.log("usage: node partlist.js modules/moduleToGetPartListOf.v -p(ath) -s(ave) -c(opy)");
    console.log("flags: -s(ave) ./partlists/module_partlist.txt");
    console.log("       -p(all) include full path to components");
    console.log("       -c(opy) to copy to clipboard");
    process.exit(1);
}

var flags = {
    "p": false,
    "s": false,
    "c": false
};

var part_path = args[2];
var part_dir = path.dirname(part_path);
var part_ext = path.extname(part_path);
var thatstick = 0; //lock

if (!fs.existsSync(part_path)) {
    console.error("Error: Can't find `", part_path, "`, what's you smoking?");
    process.exit(1);
}
if (part_ext.toLowerCase() !== ".v") {
    console.error("Error: Only `.v` yo! what's you drinking?");
    process.exit(1);
}
var tocheck = [part_path];
var check_count = 0;

var modules = [];
var mod_loco = {};



var list = new List();

getModulesfromDir(part_dir, /\.v$/, function(filename) {
    var mod = path.basename(filename);

    if (!modules.contains(mod)) {
        modules.push(mod);
        mod_loco[mod] = filename;
    }
}, function() {
    console.log("compiling part list for`", part_path, "`from", modules.length, "components...");
    //console.log(modules);
    return yoZ_GetNextPart();
});


function white_iverson(data) {
    var barrel = data.split(/\s+/g); //any white space and tabs
    for (var x = 0; x < barrel.length; x++) {
        var token = barrel[x] + ".v";
        //console.log(token, modules.contains(token) && !list.has(mod_loco[token]))
        if (modules.contains(token) && !list.has(token) && !tocheck.contains(mod_loco[token])) {
            //console.log(mod_loco[token]);
            tocheck.push(mod_loco[token]);
        }
    }
}

function yoZ_GetNextPart() {


    if (check_count < tocheck.length) {
        var checking = tocheck[check_count++]; //fullpath
        console.log("checking", checking);
        list.add(checking);
        var input = fs.createReadStream(checking);
        readLines(input, white_iverson, yoZ_GetNextPart);
        return;
    }

    var winnerwinnderchickendinner = tocheck.length === list.parts.length;
    if (winnerwinnderchickendinner) {
        console.log("-----" + part_path, "Part List (" + tocheck.length + "/" + list.parts.length + ")-----");
        console.log(list.parts.join(" "));
        process.exit(0);
    }

    var missing = tocheck.filter(function(x) {
        return !list.has(x)
    });
    console.log("ERROR: missing", missing.length + "/" + tocheck.length + "\n", missing);
    process.exit(1);
}

//http://stackoverflow.com/questions/6831918/node-js-read-a-text-file-into-an-array-each-line-an-item-in-the-array
function readLines(input, func, endfunc) {
    var remaining = '';

    input.on('data', function(data) {
        remaining += data;
        var index = remaining.indexOf('\n');
        var last = 0;
        while (index > -1) {
            var line = remaining.substring(last, index);
            last = index + 1;
            func(line);
            index = remaining.indexOf('\n', last);
        }

        remaining = remaining.substring(last);
    });

    input.on('end', function() {
        if (remaining.length > 0) {
            func(remaining);
        }
        endfunc();
    });
}

function getModulesfromDir(startPath, filter, callback, done) {
    //console.log('Starting from dir '+startPath+'/');

    if (!fs.existsSync(startPath)) {
        console.log("no dir ", startPath);
        process.exit(1);
    }
    thatstick++;

    var files = fs.readdirSync(startPath);
    for (var i = 0; i < files.length; i++) {
        var filename = path.join(startPath, files[i]);
        var stat = fs.lstatSync(filename);
        if (stat.isDirectory()) {
            //tat++;
            getModulesfromDir(filename, filter, callback); //recurse
        } else if (filter.test(filename)) callback(filename);
    };

    thatstick--;
    if (thatstick < 1) {
        return done(); //shit
    }
};
