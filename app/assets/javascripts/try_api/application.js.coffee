#= require try_api/bower_components/jquery/dist/jquery.js
#= require try_api/bower_components/bootstrap/dist/js/bootstrap.min.js
#= require try_api/bower_components/jquery-slimscroll/jquery.slimscroll.min.js
#= require try_api/bower_components/highlightjs/highlight.pack.min.js
#= require try_api/bower_components/angular/angular.js
#= require try_api/bower_components/angular-bootstrap/ui-bootstrap-tpls.js
#= require try_api/bower_components/angular-highlightjs/src/angular-highlightjs.min.js

$ ->
  $('pre code').each (i, block) ->
    hljs.highlightBlock(block)


  $('.try-api-sidebar-menu').slimScroll
    height: '100%'

TryApiApp = angular.module('TryApiApp', [
  'ui.bootstrap'
#    'formInput.images'
#    'formInput.image'
#    'formInput.file'
  'hljs'
])
TryApiApp.config [
  '$httpProvider'
  'hljsServiceProvider'
  ($httpProvider, hljsServiceProvider) ->
    hljsServiceProvider.setOptions
      tabReplace: '  '
]
TryApiApp.run [
  '$http'
  '$rootScope'
  ($http, $rootScope) ->
]

TryApiApp.controller 'HomeController', [
  '$scope'
  '$timeout'
  '$sce'
  '$http'
  ($scope, $timeout, $sce, $http) ->

    $scope.getStatusCodeClass = (code) ->
      switch true
        when code >= 200 && code < 300
          return 'text-success'
        when code >= 300 && code < 400
          return 'text-warning'
        when code >= 400 && code < 500
          return 'text-danger'
        when code >= 500
          return 'text-danger'
        else
          return 'text-info'

    $scope.headers = []
    $scope.params = []

]

TryApiApp.controller 'HomeController', [
  '$scope'
  '$timeout'
  '$sce'
  '$http'
  ($scope, $timeout, $sce, $http) ->

    $scope.getStatusCodeClass = (code) ->
      switch true
        when code >= 200 && code < 300
          return 'text-success'
        when code >= 300 && code < 400
          return 'text-warning'
        when code >= 400 && code < 500
          return 'text-danger'
        when code >= 500
          return 'text-danger'
        else
          return 'text-info'

    $scope.headers = []
    $scope.params = []
    
    $http.get('/developers/projects').success (data) ->
      console.log(data)
      index = 0
      $.each data.project.categories, () ->
        category = this
        $.each category.menu_items, () ->
          menu_item = this
          index = index + 1
          $.each menu_item.second_level_menu_items, ()->
            method = this
            index = index + 1

            ui_index = index
            $scope.params[ui_index] = {}
            $scope.headers[ui_index] = {}

            $scope['responseHandler' + ui_index] = (data, status, headers, config) ->
              $scope['response' + ui_index ] =
                data: JSON.stringify(data, null, 2)
                headers: JSON.stringify(config.headers, null, 2)
                status: status

            $scope['submitForm' + ui_index] = ->
              headers = {'Content-Type': undefined}
              path = data.project.api_prefix + method.path

              $.each method.headers, (i)->
                header = this
                headers[header.name] = $scope.headers[ui_index][i]

              switch method.method.toLowerCase()
                when 'post'
                  fd = new FormData

                  $.each method.parameters, (i) ->
                    parameter = this
                    fd.append parameter.name, $scope.params[ui_index][i] || ''

                  $http.post path, fd,
                    transformRequest: angular.identity
                    headers: headers
                  .success $scope['responseHandler' + ui_index]
                  .error $scope['responseHandler' + ui_index]
                when 'delete'
                  $http.delete path,
                    transformRequest: angular.identity
                    headers: headers
                  .success $scope['responseHandler' + ui_index]
                  .error $scope['responseHandler' + ui_index]
                when 'get'
                  fd = ''

                  $.each method.parameters, (i) ->
                    parameter = this
                    fd = fd + parameter.name + '=' + ($scope.params[ui_index][i] || '') + '&'

                  $http.get path + '?' + fd,
                    transformRequest: angular.identity
                    headers: headers
                  .success $scope['responseHandler' + ui_index]
                  .error $scope['responseHandler' + ui_index]

]