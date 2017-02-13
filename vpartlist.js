return require.main === module ?
    (new vPartList(process.argv.slice(2) /**slice [node, scriptpath,]**/ , function(list, err) {
        if (err) {
            return console.log(err)
        }
        console.log(list.join(" "));
    })) : (module.exports = vPartList);

/*
vpartlist.js

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
function vPartList(args, callback) {

    var _log = require.main === module ? console.log : (function() {});

    var fs = require('fs');
    var path = require('path');

    var PError = function(err) {
        if (require.main === module) {
            _log(err);
            process.exit(1);
        } else {
            throw new Error(err);
        }
    };

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

    var ZeroTrigger = function() {
        this.count = 0;
    }
    ZeroTrigger.prototype.add = function() {
        this.count++;
    }
    ZeroTrigger.prototype.remove = function(trigger) {
        this.count--;
        if (this.count < 1) {
            this.count = 0;//reset
            return trigger(); //shit
        }
    }

    var part_path = args[0];
    var part_dir = path.dirname(part_path);
    var part_ext = path.extname(part_path);

    if (args.length < 1) {
        _log("node vpartlist.js help! for more info");
        return new PError("usage: node vpartlist.js modules/moduleToGetPartListOf.v");
    }
    if (part_path.toLowerCase() === "help") {

        _log("flags: -p(all) include full path to components");
        return new PError("usage: node vpartlist.js modules/moduleToGetPartListOf.v -p(ath)");
    }

    var flags = {
        "p": false
    };

    if (!fs.existsSync(part_path)) {
        return new PError("Error: Can't find `" + part_path + "`, what's you smoking?");
    }
    if (part_ext.toLowerCase() !== ".v") {
        return new PError("Error: Only `.v` yo! what's you drinking?");
    }

    for (var i = 0; i < args.length; i++) {
        if (args[i] === "-p" || args[i] === "-path") {
            flags.p = true;
        }
    }

    var thatstick = new ZeroTrigger(); //lock
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
        _log("compiling part list for`", part_path, "`from", modules.length, "components...");
        //_log(modules);
        return yoZ_GetNextPart();
    });


    function white_iverson(data) {
        var barrel = data.split(/\s+/g); //any white space and tabs
        for (var x = 0; x < barrel.length; x++) {
            var token = barrel[x] + ".v";
            //_log(token, modules.contains(token) && !list.has(mod_loco[token]))
            if (modules.contains(token) && !list.has(token) && !tocheck.contains(mod_loco[token])) {
                //_log(mod_loco[token]);
                tocheck.push(mod_loco[token]);
            }
        }
    }
    //main
    function yoZ_GetNextPart() {

        if (check_count < tocheck.length) {
            var checking = tocheck[check_count++]; //fullpath
            _log("checking", checking);
            list.add(checking);
            var input = fs.createReadStream(checking);
            readLines(input, white_iverson, yoZ_GetNextPart);
            return;
        }

        var winnerwinnderchickendinner = tocheck.length === list.parts.length;
        if (winnerwinnderchickendinner) {
            _log("-----" + part_path, "Part List (" + tocheck.length + "/" + list.parts.length + ")-----");
            return callback(list.parts);
        }

        var missing = tocheck.filter(function(x) {
            return !list.has(x)
        });
        return callback(null, "ERROR: missing " + missing.length + "/" + tocheck.length + "\n" + missing);
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
        //_log('Starting from dir '+startPath+'/');

        if (!fs.existsSync(startPath)) {
            return new PError("no dir " + startPath);
        }
        thatstick.add(); //!important

        var files = fs.readdirSync(startPath);
        for (var i = 0; i < files.length; i++) {
            var filename = path.join(startPath, files[i]);
            var stat = fs.lstatSync(filename);
            if (stat.isDirectory()) {

                getModulesfromDir(filename, filter, callback, done); //recurse
            } else if (filter.test(filename)) callback(filename);
        };
        thatstick.remove(done); //!important
    }
}