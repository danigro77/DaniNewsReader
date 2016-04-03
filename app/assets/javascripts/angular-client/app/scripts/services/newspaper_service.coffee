'use strict'

angular.module('app.newsReader').service "NewspaperService", [ '$http', (http) ->

  @getNewspapers = ->
    http.get '/api/newspapers/all'

  @
]
