var fs = require('fs');
var path = require('path');

const constants={
    projectSrcPath : path.join("platforms","ios"),
    pluginID : path.join("com","outsystems","AlviereCaptureCheck"),
    pluginName : "com-outsystems-AlviereCaptureCheck"
}

module.exports = function (context) {
    
    console.log("Start changing Files!");
    var Q = require("q");
    var deferral = new Q.defer();


    const { ConfigParser } = context.requireCordovaModule("cordova-common");
    const appConfig = new ConfigParser(path.resolve(context.opts.projectRoot, "config.xml"));

    const appName = appConfig.name()
    
    var appDelegatePath = path.join(constants.projectSrcPath,appName,"Classes","AppDelegate.m")
    var fileExists = fs.existsSync(appDelegatePath);
    if (!fileExists){
        appDelegatePath = path.join(constants.projectSrcPath,appName,"AppDelegate.m")
    }
    var appDelegateChangerPath = path.join(constants.projectSrcPath,appName,"Plugins",constants.pluginName,"AppDelegateReplace.txt")

    var replacingContent = fs.readFileSync(appDelegateChangerPath, "utf8");

    var content = fs.readFileSync(appDelegatePath, "utf8")

    var regex = new RegExp("return.*didFinishLaunchingWithOptions.*;","g")
    content = content.replace(regex,replacingContent)

    fs.writeFileSync(appDelegatePath,content)
    console.log("Finished changing AppDelegate.m!");
    
    deferral.resolve();

    return deferral.promise;
}