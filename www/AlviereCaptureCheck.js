var exec = require('cordova/exec');

exports.captureCheck = function (success, error) {
    exec(success, error, 'AlviereCaptureCheck', 'captureCheck', []);
};

exports.captureDossier = function (docList,success, error) {
    exec(success, error, 'AlviereCaptureCheck', 'captureDossier', [docList]);
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
