"use strict"

# command line helper
args = require('yargs')
    .usage('Command line tool to build application. Usage: $0 <command>')
    .demand(1)
    .example('$0 sass', 'Builds sass stylesheets')
    .example('$0 coffee', 'Builds coffee scripts')
    .example('$0 jade', 'Builds jade templates')
    .example('$0 build', 'Builds everything')
    .example('$0 watch', 'Watches and builds everything')
    .argv

# Application name
appName = 'soccer'
environment = args.env || 'dev'
replacements = [{
    match: 'environment'
    replacement: environment
}, {
    match: 'proxyPass'
    replacement: environment
}]

$ = require('gulp-load-plugins')(lazy: false)
sh = require 'shelljs'
$run = require 'run-sequence'
gulp = require 'gulp'
bower = require 'bower'
replace = require 'gulp-replace-task'
fixmyjs = require 'gulp-fixmyjs'
autoprefixer = require 'gulp-autoprefixer'
$logger = $.util.log

$logger 'Environment: ' + ($.util.colors.yellow environment)

paths =
    styles: [
        './src/scss/*.scss'
        './src/scss/**.scss'
        './src/scss/**/*.scss'
    ]
    scripts: [
        './src/coffee/app.coffee'
        './src/coffee/toro.coffee'
        './src/coffee/run.coffee'
        './src/coffee/config.coffee'
        './src/coffee/routing.coffee'
        './src/coffee/**/*.coffee'
    ]
    views: [
        './src/jade/**/*.jade'
    ]

gulp.task 'sass', (done) ->
    gulp.src(paths.styles)
        #.pipe($.plumber(errorHandler: $.notify.onError("Error: <%= error.message %>")))
        .pipe($.sass(errLogToConsole: true))
        .pipe(autoprefixer({browsers: ['last 4 versions']}))
        .pipe($.concat('style.css'))
        .pipe(gulp.dest('./www/css'))
        .pipe($.minifyCss(keepSpecialComments: 0))
        .pipe($.rename(extname: '.min.css'))
        .pipe(gulp.dest('./www/css/'))
        .pipe($.size(showFiles: true))
    #.on('end', done)

gulp.task 'coffee', (done) ->
    gulp.src(paths.scripts)
        #.pipe($.plumber(errorHandler: $.notify.onError("Error: <%= error.message %>")))
        .pipe($.ngClassify(appName: appName))
        .pipe($.coffee(bare: no).on('error', $logger))
        .pipe($.jshint(".jshintrc"))
        .pipe($.jshint.reporter('jshint-stylish'))
        .pipe($.concat('app.js'))
        .pipe($.insert.prepend("'use strict';\n"))
        .pipe(replace({patterns: replacements}))
        .pipe(fixmyjs({
            # JSHint settings here
        }))
        .pipe(gulp.dest('./www/js'))
        .pipe($.size(showFiles: true))
        # TODO: jsmin
    #.on('end', done)

gulp.task 'jade', (done) ->
    gulp.src(paths.views)
        #.pipe($.plumber(errorHandler: $.notify.onError("Error: <%= error.message %>")))
        .pipe($.jade())
        # .pipe(gulp.dest('./www/templates')) # uncomment to show compiled html templates
        .pipe($.angularTemplatecache('templates', {standalone:true, root: 'templates/'} ))
        .pipe($.rename(extname: '.js'))
        .pipe(gulp.dest('./www/js'))
        .pipe($.size(showFiles: true))
    #.on('end', done)

gulp.task 'watch', ->
    gulp.watch(paths.styles, ['sass'])
    gulp.watch(paths.scripts, ['coffee'])
    gulp.watch(paths.views, ['jade'])

gulp.task 'build', (callback) ->
    $run("sass", "coffee", "jade", callback)

gulp.task 'install', ['git-check'], ->
    bower.commands.install().on 'log', (data) ->
        $logger('bower', $.util.colors.cyan(data.id), data.message)

gulp.task 'git-check', (done) ->
    if !sh.which('git')
        console.log(
            '  ' + $.util.colors.red('Git is not installed.'),
            '\n  Git, the version control system, is required to download Ionic.',
            '\n  Download git here:', $.util.colors.cyan('http://git-scm.com/downloads') + '.',
            '\n  Once git is installed, run \'' + $.util.colors.cyan('gulp install') + '\' again.'
        )
        process.exit(1)
    done()
