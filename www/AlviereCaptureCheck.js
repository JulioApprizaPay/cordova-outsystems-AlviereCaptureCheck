var exec = require('cordova/exec');

exports.captureCheck = function (accountUUID, token, success, error) {
    exec(success, error, 'AlviereCaptureCheck', 'captureCheck', [accountUUID, token]);
};

exports.captureDossier = function (docList, accountUUID, token,success, error) {
    exec(success, error, 'AlviereCaptureCheck', 'captureDossier', [docList, accountUUID, token]);
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

exports.setDossierCallbacks = function (success, error) {
    exec(success, error, 'AlviereCaptureCheck', 'setDossierCallbacks', []);
}

exports.hideNavigationBar = function (success, error) {
    exec(success, error, 'AlviereCaptureCheck', 'hideNavigationBar', []);
}
