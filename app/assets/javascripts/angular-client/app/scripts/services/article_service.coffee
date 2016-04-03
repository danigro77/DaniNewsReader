'use strict'

angular.module('app.newsReader').service "ArticleService", [ '$http', (http) ->

  @getArticles = (newspaperId) ->
    http.get '/api/articles/all/' + newspaperId

  @getHeadlines = (newspaperId) ->
    http.get '/api/articles/headlines/' + newspaperId

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
