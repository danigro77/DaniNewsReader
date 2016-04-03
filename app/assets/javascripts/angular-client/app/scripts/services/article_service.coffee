'use strict'

angular.module('app.newsReader').service "ArticleService", [ '$http', (http) ->

  @getArticles = ->
    http.get '/api/articles/all'

  @getHeadlines = ->
    http.get '/api/articles/headlines'

  @saveArticle = (data) ->
    http({
      method: 'post'
      url: '/api/articles/save_article/'
      data: data
    })

  @deleteArticle = (id) ->
    http.delete '/api/articles/delete/' + id

  @
]
