"use strict";

var gulp = require('gulp');
//gulp flow control
var gulpif = require('gulp-if');
var sync = require('gulp-sync')(gulp);
//build tools
var del = require('del');
var debug = require('gulp-debug');
var sass = require('gulp-sass');
var sourcemaps = require('gulp-sourcemaps');
var replace = require('gulp-replace');
//dist minifiction
var useref = require('gulp-useref');
var uglify = require('gulp-uglify');
var cssMin = require('gulp-clean-css');
var htmlMin = require('gulp-htmlmin');
//runtime tools
var browserSync = require('browser-sync').create();


//location to place out source code
var srcPath = "client/src";
//where any processed code or vendor files gets placed for use in development
var buildPath = "client/build";
//location to place vendor files for use in development
var vendorBuildPath = buildPath + "/vendor";
//where the final web application is placed
var distPath = "public/client";
//location of vendor packages
var bowerPath = "bower_components";

var cfg = {
  //client application source code src globs and build paths
  root_html: { src: srcPath + "/index.html", bld: buildPath },
  css: { src: srcPath + "/stylesheets/**/*.css", bld: buildPath + "/stylesheets" },
  js: { src: srcPath + "/javascripts/**/*.js" },
  html: { src: [srcPath + "/**/*.html", "!" + srcPath + "/*.html"] },

  //vendor csssrc globs
  bootstrap_sass: { src: bowerPath + "/bootstrap-sass/assets/stylessheets/" },

  //vendor fonts src globs
  bootstrap_fonts: { src: bowerPath + "/bootstrap-sass/assets/fonts/**/*" },

  //vendor jsscr blobs
  jquery: { src: bowerPath + "/jquery/jquery.js" },
  bootstrap_js: { src: bowerPath + "/bootstrap-sass/assets/javascripts/bootstrap.js" },
  angular: { src: bowerPath + "/angular/angular.js" },
  angular_ui_router: { src: bowerPath + "/angular-ui-router/release/angular-ui-router.js" },
  angular_resource: { src: bowerPath + "/angular-resourece/angular-resouce.js" },
  
  //vendor build locations
  vendor_js: { bld: vendorBuildPath + "/javascrips" },
  vendor_css: { bld: vendorBuildPath + "/stylesheets" },
  vendor_fonts: {bld: vendorBuildPath + "/stylesheets/fonts" },
  //application URL
  apiUrl: {
    dev: "http:localhost:3000",
    prd: "https://warm-woodland-56181.herokuapp.com"
  },
};

//files with these paths will beserved as root level resources in this priority order
var devResoucePath = [
  cfg.verndor_js.bld,
  cfg.vendor_scc.bld,
  buildPath + "/javascripts",
  buildPath + "/stylesheets",
  srcPath,
  srcPath + "/javascripts",
  srcPath + "/stylesheets",
];

