var exec = require('cordova/exec');

exports.captureCheck = function (accountUUID, token, success, error) {
    exec(success, error, 'AlviereCaptureCheck', 'captureCheck', [accountUUID, token]);
};

exports.captureDosier = function (accountUUID, docList, token,success, error) {
    exec(success, error, 'AlviereCaptureCheck', 'captureDosier', [docList, accountUUID, token]);
};

exports.setEnvironment = function (environment, success, error) {
    exec(success, error, 'AlviereCaptureCheck', 'setEnvironment', [environment]);
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
