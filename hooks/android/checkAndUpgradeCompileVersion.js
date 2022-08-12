var fs = require('fs');
const { platform } = require('os');
var path = require('path');

const constants={
    javaSrcPath : path.join("platforms","android","app","src","main","java"),
    kotlinSrcPath : path.join("platforms","android","app","src","main","kotlin"),
    pluginID : path.join("com","outsystems","misnap"),
    newMinSDKVersion : 32
}

module.exports = function (context) {
    
    console.log("Start changing Files!");
    var Q = require("q");
    var deferral = new Q.defer();


    var configPath = path.join("platforms","android","cdv-gradle-config.json")
    
    if (fs.existsSync(configPath)) {
        var content = fs.readFileSync(configPath, "utf8");

        var jsonContent = JSON.parse(content);
        console.log(jsonContent.SDK_VERSION)
        if(jsonContent.SDK_VERSION<constants.newMinSDKVersion){
            console.log(constants.newMinSDKVersion)
            jsonContent.SDK_VERSION = constants.newMinSDKVersion;
            //jsonContent.BUILD_TOOLS_VERSION = constants.newMinSDKVersion+".0.0";
        }
        
        content = JSON.stringify(jsonContent)

        fs.writeFileSync(configPath, content);
        console.log("Finished changing "+path.basename(configPath)+"!");
    }else{
        console.error("Error could not find "+path.basename(configPath)+"!");
    }
    
    deferral.resolve();

    return deferral.promise;
}