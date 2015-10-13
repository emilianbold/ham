var cwd = process.cwd();
var PATH = require('path');
var FS = require('fs');

var pathAppConfig = PATH.join(cwd,'/sources/app_config.js');
if (FS.existsSync(pathAppConfig)) {
  require(pathAppConfig); // load config
}

var NI, niFS;
var pathNI = PATH.join(cwd,'/sources/NI.js');
if (FS.existsSync(pathNI)) {
  NI = require(pathNI);
  niFS = require(PATH.join(cwd,'/sources/fs.js'));
}
else {
  NI = require('tkjs-ni');
  niFS = require('tkjs-ni/sources/fs.js');
}

var globalNodeModulesDir = process.env.NODEJS_GLOBAL_MODULES_DIR;
// NI.println("... process.env.NODE_PATH: %s", process.env.NODE_PATH);

var baseDir = cwd;

//======================================================================
// Webpack config
//======================================================================
var WEBPACK;
var ExtractTextPlugin;
var WebpackDevServer;
var hotReloadAll = false;

function lazyLoadWebPack() {
  if (WEBPACK) {
    return;
  }
  WEBPACK = require('webpack');
  ExtractTextPlugin = require("extract-text-webpack-plugin");
  WebpackDevServer = require('webpack-dev-server');
}

//======================================================================
// Front-end
//======================================================================
var configFrontEnd = function(aIsDev,aUseSourceMap) {
  var entry = {};
  var clientFilesDir = PATH.resolve(baseDir, 'sources/client/');
  var clientFiles = niFS.walkSync(clientFilesDir);
  // NI.info("clientFiles: %d", clientFiles.length);
  if (clientFiles.length <= 0) {
    throw NI.Error("No files in client sources directory: " + clientFilesDir);
  }
  NI.forEach(clientFiles, function(file) {
    var name = NI.stringRBefore(NI.stringRAfter(file,'/'),'.');
    // NI.info("clientFile: %s, %s", file, name);
    entry[name] = [ file ]
  });
  NI.log("FrontEnd Entries: %K", entry);

  return {
    resolve: {
      extensions: [ '', '.js', '.jsx', '.ts' ],
      modulesDirectories: [
        "web_modules", "node_modules",
        globalNodeModulesDir,
      ]
    },

    resolveLoader: {
      modulesDirectories: [
        "web_modules", "node_modules",
        globalNodeModulesDir,
      ]
    },

    entry: entry,

    output: {
      path: PATH.resolve(baseDir, 'bin/client_js/'),
      filename: '[name].js'
    },

    module: {
      loaders: [
        { test: /\.jsx$/,
          loader: (aIsDev ? 'react-hot!' : '') + 'jsx-loader',
          exclude: /(node_modules|bower_components)/,
          include: PATH.join(baseDir, 'sources')
        },
        {
          test: /\.ts$/,
          exclude: /(node_modules|bower_components)/,
          loader: (aIsDev ? 'react-hot!' : '') + 'awesome-typescript-loader?emitRequireType=false&forkChecker=true',
          include: PATH.join(baseDir, 'sources')
        },
        { test: /\.css$/, // Only .css files
          loader: (
            aUseSourceMap ?
              ExtractTextPlugin.extract("style-loader", "css-loader?sourceMap&keepSpecialComments=0") :
              ExtractTextPlugin.extract("style-loader", "css-loader?keepSpecialComments=0")
          ),
          include: PATH.join(baseDir, 'sources')
        },
        { test: /\.less$/,
          loader: (
            aUseSourceMap ?
              ExtractTextPlugin.extract("style-loader", "css-loader?sourceMap&keepSpecialComments=0!less-loader?sourceMap") :
              ExtractTextPlugin.extract("style-loader", "css-loader?keepSpecialComments=0!less-loader")
          ),
          include: PATH.join(baseDir, 'sources')
        },
        { test: /\.(otf|eot|woff|woff2|ttf|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
          loader: "file-loader",
          include: PATH.join(baseDir, 'sources')
        },
        // Convert url() statements for images that are 25KB or smaller to a
        // BASE64 string and include in the CSS file where it is defined.  Not
        // completly sure whether this is a good idea, but one major plus is
        // that it will reduce the number of HTTP requests.
        { test: /\.(png|jpg|gif)$/,
          loader: 'url?limit=10000',
          include: PATH.join(baseDir, 'sources')
        },
      ],
      noParse: []
    },

    plugins: [
      new WEBPACK.DefinePlugin({
        __BACKEND__: false,
        __DEV__: aIsDev,
      }),
      // Use the plugin to specify the resulting filename (and add needed
      // behavior to the compiler)
      new ExtractTextPlugin("[name].css"),
      // The common module, assumed to be used by every page in the app.
      new WEBPACK.optimize.CommonsChunkPlugin(
        "common","common.js",Infinity)
    ]
  };
};

//======================================================================
// Webpack Tasks
//======================================================================
function buildOnBuild(done) {
  return function(err, stats) {
    if(err) {
      NI.error("Build error: %s", err);
      NI.log("Build failed.");
    }
    else {
      NI.println(stats.toString());
      NI.log("Build succeeded.");
    }
    if(done) {
      done();
    }
  }
}

function frontendBuild(aParams,aDone) {
  lazyLoadWebPack();
  var myConfig = configFrontEnd(false,true);

  function rmDir(dirPath,aRemoveThisDir) {
    var files = FS.readdirSync(dirPath);
    if (files.length > 0) {
      for (var i = 0; i < files.length; i++) {
        var filePath = dirPath + '/' + files[i];
        if (FS.statSync(filePath).isFile()) {
          FS.unlinkSync(filePath);
        }
        else {
          rmDir(filePath,true);
        }
      }
    }
    if (aRemoveThisDir) {
      FS.rmdirSync(dirPath);
    }
  };

  var outputDir = myConfig.output.path;
  try {
    NI.log("Clearing folder '%s'...", outputDir);
    rmDir(outputDir);
    NI.log("Done.");
  }
  catch (e) {
    NI.warning("Clearing folder '%s' failed: %s", outputDir, e);
  }

  myConfig.devtool = 'source-map';
  myConfig.plugins = myConfig.plugins.concat(
    new WEBPACK.DefinePlugin({
      "process.env": {
        // This has effect on the react lib size
        "NODE_ENV": JSON.stringify("production")
      }
    })
    , new WEBPACK.optimize.OccurenceOrderPlugin()
    , new WEBPACK.optimize.DedupePlugin()
    , new WEBPACK.optimize.UglifyJsPlugin({
      comments: /$a/, // doesnt match anything so that all comments are removed
    })
  );

  NI.log("Started webpack build...");
  WEBPACK(myConfig).run(buildOnBuild(aDone));
}
exports.frontendBuild = frontendBuild;

var webpackServer = undefined;
function frontendWatch(aParams) {
  lazyLoadWebPack();
  var useSourceMap = NI.selectn("useSourceMap",aParams);

  var myConfig = configFrontEnd(true,useSourceMap);

  // Use 'eval', its *much* faster than source-map
  myConfig.devtool = useSourceMap ? 'source-map' : 'eval';

  // For hot module reloading
  myConfig.entry.common.push('webpack-dev-server/client?http://localhost:'+global.bundlePort);

  // NOTE: Hot reloading fully seems to work well enought, if you change a
  //       react component it'll reload only that, if you change a .css or
  //       other resource it'll refresh the whole browser.
  if (hotReloadAll) {
    // hot reload when any client side changes
    myConfig.entry.common.push('webpack/hot/dev-server');
  }
  else {
    // hot reload react component only
    myConfig.entry.common.push('webpack/hot/only-dev-server');
  }
  myConfig.plugins.push(new WEBPACK.HotModuleReplacementPlugin());
  myConfig.plugins.push(new WEBPACK.NoErrorsPlugin());

  // Setup the public output path
  myConfig.output.publicPath = 'http://localhost:'+global.bundlePort+'/bin/';

  webpackServer = new WebpackDevServer(WEBPACK(myConfig), {
    publicPath: '/bin/',
    hot: true,
    quiet: false,
    noInfo: true,
    stats: {
      colors: true
    },
    headers: { 'Access-Control-Allow-Origin': '*' }
  });

  webpackServer.listen(global.bundlePort, 'localhost', function (err /*, result*/) {
    if(err) {
      console.log(err);
    }
    else {
      console.log('Webpack dev server listening at localhost:'+global.bundlePort);
    }
  });
}
exports.frontendWatch = frontendWatch;

// $ nodemon -e js,jsx,ts --ignore "sources/*-test.js" --ignore "sources/client.js" --ignore "sources/client/*" --watch sources sources/server.js
function backendWatch(aParams) {
  var nodeEnv = NI.selectn("nodeEnv",aParams) || 'development';
  var NODEMON = require('nodemon');
  NODEMON({
    verbose: true,
    script: 'sources/server.js',
    ext: 'js jsx ts',
    watch: ['sources'],
    ignore: ["*flymake*.*", "*-test.js", "*-test.ts", "sources/client.js", "sources/client/*"],
    env: {
      'NODE_ENV': nodeEnv,
      // this is to make sure that NODE_PATH is 'empty', the same as on the
      // production server
      'NODE_PATH': '~/a_non_existing_path/'
    }
  });
  NODEMON.on('start', function () {
    console.log('... Nodemon server.js has started');
  }).on('quit', function () {
    console.log('... Nodemon server.js has quit');
  }).on('restart', function (files) {
    console.log('... Nodemon server.js restarted due to: ', files);
  });
}
exports.backendWatch = backendWatch;

exports.build = function(aParams) {
  lint(aParams, function() {
    frontendBuild();
  });
}

exports.dev = function() {
  frontendWatch();
  backendWatch();
}

exports.devSourceMap = function() {
  frontendWatch({ useSourceMap: true });
  backendWatch();
}

exports.testServer = function() {
  frontendBuild(undefined, function() {
    backendWatch({ nodeEnv: 'test' });
  });
}

exports.testBackend = function() {
  backendWatch({ nodeEnv: 'test' });
}

var shellProcess;
function shellRun() {
  var cp = require('child_process');
  shellProcess = cp.spawn(
    PATH.join(globalNodeModulesDir, 'electron-prebuilt/dist/electron'),
    ['.'], { detached: false });
  shellProcess.on('exit', function() {
    NI.log("Shell closed.");
    if (webpackServer) {
      webpackServer.invalidate();
    }
    process.exit(0);
  });
}
exports.shellRun = shellRun;

exports.shellDev = function() {
  frontendWatch();
  backendWatch();
  shellRun();
}

exports.test = function(aParams) {
  var pathUNITTEST = PATH.join(cwd,'/sources/unittest.js');
  var UT;
  if (FS.existsSync(pathUNITTEST)) {
    UT = require(pathUNITTEST);
  }
  else {
    UT = require('tkjs-ni/sources/unittest');
  }
  UT.runAllTests(aParams);
}

function lint(aParams,aDone) {
  var exec = require('child_process').exec;
  exec(
    'eslint --ext .js --ext .jsx ./sources',
    function (error, stdout, stderr) {
      console.log(NI.stringTrim(stdout));
      console.log(NI.stringTrim(stderr));
      if (error !== null) {
        // console.log('exec error: ' + error);
        errorExit("Linting failed.");
      }
      else {
        if (aDone) {
          aDone();
        }
      }
    });
}
exports.lint = lint;

function printHelp() {
  NI.println("syntax: node ./webpack.js TARGETS");
  NI.println("  %d target(s) registered:", NI.size(exports));
  NI.forEach(exports,function(v,k) {
    NI.println("  - %s", k);
  });
  NI.println("");
}

function errorExit(aMsg) {
  NI.println(aMsg);
  process.exit(1);
}

function errorHelpExit(aMsg) {
  printHelp();
  errorExit(aMsg);
}

(function(aTargets) {
  var paramObject = {};
  var targets = [];
  var numArgs = process.argv.length;
  for (var i = 2; i < numArgs; ) {
    var param = process.argv[i]
    if (NI.stringStartsWith(param,"--")) {
      paramObject[NI.stringAfter(param,"--")] = process.argv[i+1];
      i += 2;
    }
    else {
      if (!(param in aTargets)) {
        errorHelpExit(NI.format("Target '%s' not registered.", targetName));
      }
      targets.push(param);
      i += 1;
    }
  }

  if (NI.isEmpty(targets)) {
    errorHelpExit("No target specified.");
  }

  // NI.println("... paramObject: %K", paramObject);
  // NI.println("... targets: %K", targets);

  for (var i = 0; i < targets.length; ++i) {
    var targetName = targets[i]
    NI.println("# %s...", targetName);
    aTargets[targetName](paramObject);
  }
}(exports));
