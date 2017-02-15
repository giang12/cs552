return require.main === module ?
    (new vBuild(process.argv.slice(2) /**slice [node, scriptpath,]**/ , function(list, err) {
        if (err) {
            return console.log(err)
        }
        console.log(list.join(" "));
    })) : (module.exports = vPartList);


function vBuild(args, cb, undefined) {

    var _log = require.main === module ? console.log : (function() {});
    var vPartList = require('vpartlist');
    var fs = require('fs');
    var path = require('path');

    var PError = function(err) {
        if (require.main === module) {
            _log(err);
            process.exit(1);
        } else {
            return callback(null, err); //bubble up
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
    var ZeroTrigger = function() {
        this.count = 0;
    }
    ZeroTrigger.prototype.add = function() {
        this.count++;
    }
    ZeroTrigger.prototype.remove = function(trigger) {
        this.count--;
        if (this.count < 1) {
            this.count = 0; //reset
            return trigger(); //shit
        }
    }

    if (args.length < 1) {
        _log("node vbuild.js help! for more info");
        return new PError("usage: node vbuild.js modules/moduleToBuild.v");
    }
    if (args[0].toLowerCase() === "help") {

        _log("flags: -dir built dir, default to ./bin/");
        _log("flags: -z   z zip");
        _log("flags: -t   tarball");

        return new PError("usage: node vbuild.js modules/moduleToGetPartListOf.v -dir ../built/ -z -t");
    }
    //***************************************************************************************//

    var part_path = path.resolve(args[0]),
        part_ext = path.extname(part_path),
        part_name = path.basename(part_path, part_ext),
        from_dir = path.dirname(part_path);

    var to_dir = path.join("./bin/", part_name); //default

    var thatstick = new ZeroTrigger();
    var part_list;
    //options
    var flags = {
        "z": false, //zip
        "t": false, //tarbar
    };
    (function _start() {
        new vPartList(part_path, {
            output: to_dir,
            path: false,
            verbose: true
        }, function(mod, err) {
            if (err) {
                throw new PError(err);
            }
            console.log(mod.name);
            part_list = mod.partlist;
            console.log(part_list.join(" "));
        });
    }());
}