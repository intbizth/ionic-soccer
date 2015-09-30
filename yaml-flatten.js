var yaml = require('js-yaml');
var extend = require('extend');
var through = require('through2');
var gutil = require('gulp-util');
var BufferStreams = require('bufferstreams');
var PluginError = gutil.PluginError;
var PLUGIN_NAME = 'gulp-yaml-flatten';

function yaml2json(buffer, options) {
    var contents = buffer.toString('utf8'),
        ymlDocument = options.safe ? yaml.safeLoad(contents) : yaml.load(contents);
    ymlDocument = flatten(ymlDocument);
    return new Buffer(JSON.stringify(ymlDocument, options.replacer, options.space));
}

var flatten;

flatten = function(obj, prev) {
    var k, key, ret, v;
    if (prev == null) {
        prev = '';
    }
    ret = {};
    for (k in obj) {
        v = obj[k];
        if (prev === '') {
            key = k;
        } else {
            key = k ? prev + "." + k : prev;
        }
        if ('object' === typeof v) {
            extend(true, ret, flatten(v, key));
        } else {
            ret[key] = v;
        }
    }
    return ret;
};

module.exports = function(options) {
    options = extend({ safe: false, replacer: null, space: 2 }, options);

    return through.obj(function(file, enc, callback) {
        var self = this;

        if (file.isBuffer()) {
            if (file.contents.length === 0) {
                this.emit('error', new PluginError(PLUGIN_NAME, 'File ' + file.path +
                    ' is empty. YAML loader cannot load empty content'));
                return callback();
            }
            try {
                file.contents = yaml2json(file.contents, options);
                file.path = gutil.replaceExtension(file.path, '.json');
            }
            catch (error) {
                this.emit('error', new PluginError(PLUGIN_NAME, error.message));
                return callback();
            }
        }
        else if (file.isStream()) {
            file.contents = file.contents.pipe(new BufferStreams(function(err, buf, cb) {
                if (err) {
                    self.emit('error', new PluginError(PLUGIN_NAME, err.message));
                }
                else {
                    if (buf.length === 0) {
                        var error = new PluginError(PLUGIN_NAME, 'File ' + file.path +
                            ' is empty. YAML loader cannot load empty content');
                        self.emit('error', error);
                        cb(error);
                    }
                    else {
                        try {
                            file.path = gutil.replaceExtension(file.path, '.json');
                            cb(null, yaml2json(buf, options));
                        }
                        catch (error) {
                            self.emit('error', new PluginError(PLUGIN_NAME, error.message));
                            cb(error);
                        }
                    }
                }
            }));
        }

        this.push(file);
        return callback();
    });
}
