var exec = require('cordova/exec');

exports.captureCheck = function (success, error) {
    exec(success, error, 'AlviereCaptureCheck', 'captureCheck', []);
};

exports.requestPermission = function (success, error) {
    exec(success, error, 'AlviereCaptureCheck', 'requestPermission', []);
};
exports.checkPermission = function (success, error) {
    exec(success, error, 'AlviereCaptureCheck', 'checkPermission', []);
};
