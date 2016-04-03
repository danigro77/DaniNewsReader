'use strict';

@app = angular.module('app', [
    'ui.bootstrap',
    'templates',
    'ngAnimate',
    'ngCookies',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ngTouch',
    'app.newsReader'
])

# for compatibility with Rails CSRF protection

@app.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
  provider.defaults.headers.common["X-Requested-With"] = 'XMLHttpRequest';
])
@app.config(['$compileProvider', (provider) ->
  provider.aHrefSanitizationWhitelist(/^\s*/)
])

Controller: {}
Directive: {}
Service: {}

@app.run(['$rootScope', '$location', '$timeout', '$window', '$route', (rootScope, location, timeout, window, route) ->
])
