var gulp = require('gulp'),
    elixir = require('laravel-elixir');

gulp.task('watch-ui', require('./resources/packages/semantic/tasks/watch'));
gulp.task('build-ui', require('./resources/packages/semantic/tasks/build'));
gulp.task('clean-ui', require('./resources/packages/semantic/tasks/clean'));

// Assets
elixir(function (mix) {
    // CSS
    mix.less([
        'styles.less'
    ], 'public/assets/css/app.min.css');

    // JS
    mix.scripts([
        'app/app.module.js',
        'app/index/index.module.js',
        'app/index/index.controller.js',
        'app/index/api.service.js',
        'app/index/app-embed.directive.js',
    ], 'public/assets/js/app.min.js');
});

// Packages
elixir(function (mix) {
    // jQuery
    mix.copy('node_modules/jquery/dist/jquery.min.js', 'public/packages/jquery/js/jquery.min.js');
    mix.copy('node_modules/jquery/dist/jquery.min.map', 'public/packages/jquery/js/jquery.min.map');

    // AngularJS
    mix.copy('node_modules/angular/angular.min.js', 'public/packages/angular/js/angular.min.js');
    mix.copy('node_modules/angular/angular.min.js.map', 'public/packages/angular/js/angular.min.js.map');

    // Semantic UI
    mix.copy('resources/packages/semantic/dist/themes/default', 'public/packages/semantic/css/themes/default');
    mix.copy('resources/packages/semantic/dist/semantic.min.css', 'public/packages/semantic/css/semantic.min.css');
    mix.copy('resources/packages/semantic/dist/semantic.min.js', 'public/packages/semantic/js/semantic.min.js');
});