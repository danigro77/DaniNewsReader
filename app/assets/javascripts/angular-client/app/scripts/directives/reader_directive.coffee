angular.module('app.newsReader').directive 'reader', ->
  restrict: 'A'
#  scope: {
#    currentUser: '@'
#  }
  controller: 'ReaderController'
  templateUrl: 'views/reader.html'
