'use strict'

angular.module('app.newsReader').service "NewspaperService", [ '$http', (http) ->

  @getNewspapers = ->
    http.get '/api/newspapers/all'

  @getCurrentNewspaper = ->
    http.get '/api/newspapers/current'

  @updateCurrentNewspaper = (newspaperId) ->
    http.put '/api/newspapers/save_current/' + newspaperId

  @
]
