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

$ = require('gulp-load-plugins')(lazy: no)
sh = require 'shelljs'
$run = require 'run-sequence'
gulp = require 'gulp'
bower = require 'bower'
del = require 'del'
replace = require 'gulp-replace-task'
fixmyjs = require 'gulp-fixmyjs'
autoprefixer = require 'gulp-autoprefixer'
yamlFlatten = require './yaml-flatten'
fs = require 'fs'
yaml = require 'js-yaml'
minifyHTML = require 'gulp-minify-html'
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
        './src/coffee/setting.coffee'
        './src/coffee/run.coffee'
        './src/coffee/config.coffee'
        './src/coffee/routing.coffee'
        './src/coffee/**/*.coffee'
    ]
    views: [
        './src/jade/**/*.jade'
    ]
    trans: [
        './src/trans/**/*.yml'
    ]
    index: './src/index/index.jade'

gulp.task 'sass', (done) ->
    if environment == 'dev'
        gulp.src(paths.styles)
            .pipe($.sass(errLogToConsole: yes))
            .pipe(autoprefixer({browsers: ['last 4 versions']}))
            .pipe($.concat('style.css'))
            .pipe(gulp.dest('./www/css'))
            .pipe($.size(showFiles: yes))
    else
        gulp.src(paths.styles)
            .pipe($.sass(errLogToConsole: yes))
            .pipe(autoprefixer({browsers: ['last 4 versions']}))
            .pipe($.concat('style.css'))
            .pipe($.minifyCss(keepSpecialComments: 0))
            .pipe($.rename(suffix: '.min'))
            .pipe(gulp.dest('./www/css/'))
            .pipe($.size(showFiles: yes))

gulp.task 'coffee', (done) ->
    if environment == 'dev'
        gulp.src(paths.scripts)
            .pipe($.ngClassify(appName: appName))
            .pipe($.coffee(bare: no).on('error', $logger))
            .pipe($.jshint(".jshintrc"))
            .pipe($.jshint.reporter('jshint-stylish'))
            .pipe($.concat('app.js'))
            .pipe($.insert.prepend("'use strict';\n"))
            .pipe(replace(patterns: replacements))
            .pipe(fixmyjs())
            .pipe(gulp.dest('./www/js'))
            .pipe($.size(showFiles: yes))
    else
        gulp.src(paths.scripts)
            .pipe($.ngClassify(appName: appName))
            .pipe($.coffee(bare: no).on('error', $logger))
            .pipe($.jshint(".jshintrc"))
            .pipe($.jshint.reporter('jshint-stylish'))
            .pipe($.concat('app.js'))
            .pipe($.insert.prepend("'use strict';\n"))
            .pipe(replace(patterns: replacements))
            .pipe(fixmyjs())
            .pipe($.uglify())
            .pipe($.rename(suffix: '.min'))
            .pipe(gulp.dest('./www/js'))
            .pipe($.size(showFiles: yes))

gulp.task 'jade', (done) ->
    if environment == 'dev'
        gulp.src(paths.views)
            .pipe(replace(patterns: replacements))
            .pipe($.jade(pretty: yes))
            .pipe(gulp.dest('./www/templates'))
            .pipe($.size(showFiles: yes))
    else
        gulp.src(paths.views)
            .pipe(replace(patterns: replacements))
            .pipe($.jade(pretty: no))
            .pipe(gulp.dest('./www/templates'))
            .pipe($.size(showFiles: yes))

gulp.task 'trans', (done) ->
    gulp.src(paths.trans)
        .pipe(yamlFlatten())
        .pipe($.rename(extname: '.json'))
        .pipe(gulp.dest('./www/translations'))
        .pipe($.size(showFiles: yes))

gulp.task 'index', (done) ->
    if environment == 'dev'
        file = './src/index/dev.yml'
        sources = yaml.safeLoad(fs.readFileSync(file, 'utf8'))
        sources = sources.style.concat(sources.script)
        sources = gulp.src(sources, read: no)
        gulp.src(paths.index)
            .pipe($.jade(pretty: yes))
            .pipe(gulp.dest('./www'))
            .pipe($.size(showFiles: yes))
            .on('end', ->
                gulp.src('./www/index.html')
                    .pipe($.inject(sources), relative: yes)
                    .pipe($.replace('/www/', ''))
                    .pipe($.replace('/src/index/', ''))
                    .pipe(gulp.dest('./www'))
                    .pipe($.size(showFiles: yes))
            )
    else
        file = './src/index/prod.yml'
        sources = yaml.safeLoad(fs.readFileSync(file, 'utf8'))
        sources = sources.style.concat(sources.script)
        sources = gulp.src(sources, read: no)
        gulp.src(paths.index)
            .pipe($.jade(pretty: yes))
            .pipe(gulp.dest('./www'))
            .pipe($.size(showFiles: yes))
            .on('end', ->
                gulp.src('./www/index.html')
                    .pipe($.inject(sources), relative: yes)
                    .pipe($.replace('/www/', ''))
                    .pipe($.replace('/src/index/', ''))
                    .pipe(minifyHTML())
                    .pipe(gulp.dest('./www'))
                    .pipe($.size(showFiles: yes))
            )

gulp.task 'watch', ->
    gulp.watch(paths.styles, ['sass'])
    gulp.watch(paths.scripts, ['coffee'])
    gulp.watch(paths.views, ['jade'])
    gulp.watch(paths.trans, ['trans'])
    gulp.watch(paths.index, ['index'])

gulp.task 'build', (callback) ->
    $run('sass', 'coffee', 'jade', 'trans', 'index', callback)

gulp.task 'remove', (done) ->
    del([
        './www/css/*'
        './www/js/*'
        './www/templates/*'
        './www/translations/*'
        './www/index.html'
    ])

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
