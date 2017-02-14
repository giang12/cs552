return require.main === module ?
    (new vBuild(process.argv.slice(2) /**slice [node, scriptpath,]**/ , function(list, err) {
        if (err) {
            return console.log(err)
        }
        console.log(list.join(" "));
    })) : (module.exports = vPartList);


function vBuild(args, cb, undefined) {
    require('events').EventEmitter.defaultMaxListeners = 0
    var _log = require.main === module ? console.log : (function() {});
    var vPartList = require('./vpartlist.js');
    var fs = require('fs');
    var path = require('path');
    var dm = require('domain');
    var mkdirp = require('mkdirp');

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

    var part_path, part_ext, part_name, from_dir;
    var thatstick = new ZeroTrigger();
    var part_list;
    //options
    var to_dir = "./bin";
    var flags = {
        "z": false, //zip
        "t": false, //tarbar
    };
    (function _init() {
        new vPartList([
            args[0],
            "-path" //!important
        ], function(list, err) {
            if (err) {
                throw new PError(err);
            }
            part_list = list;
            part_path = path.resolve(args[0]);
            part_ext = path.extname(part_path);
            part_name = path.basename(part_path, part_ext);
            from_dir = path.dirname(part_path);
            to_dir = path.join(to_dir, part_name);

            mkdirp(to_dir, function(err) {
                if (err) throw new PError(err);
                _log("Building module " + part_name + " in " + to_dir);
                _build(list);
            });

        });
    }());

    function _build(_partlist) {
        var d = dm.create();
        d.on('error', _handleAllErrors);
        d.run(function() {
            for (var i = 0; i < _partlist.length; i++) {
                thatstick.add();
                _copy(_partlist[i], to_dir, _check);
            }
        });
    }

    function _check() {
        _log("Sanity Checking module " + part_name + " (" + part_list.length + ") components");
    }

    function _copy(_part, to_dir, next) {
        fs.createReadStream(path.resolve(_part))
            .pipe(fs.createWriteStream(path.join(to_dir, path.basename(_part))))
            .on('close', function(data) {
                _log("Fetched " + _part);
                thatstick.remove(next);
            });
    }

    function _handleAllErrors(err) {
        return new PError(err);
    }
}
