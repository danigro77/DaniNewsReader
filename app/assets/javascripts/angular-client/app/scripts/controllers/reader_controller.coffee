angular.module('app.newsReader').controller("ReaderController", ['$scope', 'NewspaperService', 'ArticleService', (scope, NewspaperService, ArticleService)->

  scope.allHeadlines = []
  scope.selectedNewspaper = {id: 0, name: 'Select a newspaper'}
  scope.allNewspapers = []

  getNewspapers = ->
    NewspaperService.getNewspapers().then (response) ->
      if response.status == 200 || response.status == 204
        scope.allNewspapers = response.data
        if scope.selectedNewspaper.id != 0
          getHeadlines()

  getHeadlines = ->
    ArticleService.getHeadlines(scope.selectedNewspaper.id).then (response) ->
      if response.status == 200 || response.status == 204
        scope.allHeadlines = response.data
        getArticles()

  getArticles = ->
    ArticleService.getArticles(scope.selectedNewspaper.id).then (response) ->
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

  scope.selectNewspaper = (data) ->
    scope.selectedNewspaper = data

  scope.getUrl = (url) ->
    if scope.selectedNewspaper.link_type == "full"
      url
    else
      scope.selectedNewspaper.url + url

  getNewspapers()

  scope.$watch 'selectedNewspaper', (newVal, oldVal) ->
    if newVal != undefined && newVal != oldVal && newVal.id != 0
      getHeadlines()

])
