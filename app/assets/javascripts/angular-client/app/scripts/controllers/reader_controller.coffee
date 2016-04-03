angular.module('app.newsReader').controller("ReaderController", ['$scope', 'ArticleService', (scope, ArticleService)->

  scope.allHeadlines = []

  getHeadlines = ->
    ArticleService.getHeadlines().then (response) ->
      if response.status == 200 || response.status == 204
        scope.allHeadlines = response.data
        getArticles()

  getArticles = ->
    ArticleService.getArticles().then (response) ->
      if response.status == 200 || response.status == 204
        saveResponse(response.data)

  saveResponse = (data) ->
    scope.savedHeadlines = data.saved
    scope.newHeadlines = unsavedArticles(data.existing_urls)

  unsavedArticles = (savedUrls) ->
    result = []
    for article in scope.allHeadlines
      if article.url not in savedUrls
        result.push article
    result

  scope.saveArticle = (data) ->
    ArticleService.saveArticle(data).then (response) ->
      if response.status == 201
        saveResponse(response.data)

  scope.deleteArticle = (id) ->
    ArticleService.deleteArticle(id).then (response) ->
      if response.status == 204
        getArticles()

  getHeadlines()

])
