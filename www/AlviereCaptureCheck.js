var exec = require('cordova/exec');

exports.captureCheck = function (success, error) {
    exec(success, error, 'AlviereCaptureCheck', 'captureCheck', []);
};

exports.captureDosier = function (docList,success, error) {
    exec(success, error, 'AlviereCaptureCheck', 'captureDosier', [docList]);
};

exports.requestPermission = function (success, error) {
    exec(success, error, 'AlviereCaptureCheck', 'requestPermission', []);
};
exports.checkPermission = function (success, error) {
    exec(success, error, 'AlviereCaptureCheck', 'checkPermission', []);
};

exports.setCheckCallbacks = function (success, error) {
    exec(success, error, 'AlviereCaptureCheck', 'setCheckCallbacks', []);
};

exports.setDosierCallbacks = function (success, error) {
    exec(success, error, 'AlviereCaptureCheck', 'setDosierCallbacks', []);
}

exports.hideNavigationBar = function (success, error) {
    exec(success, error, 'AlviereCaptureCheck', 'hideNavigationBar', []);
}
