'use strict'

###*
 # @ngdoc function
 # @name dalcApp.controller:AboutCtrl
 # @description
 # # AboutCtrl
 # Controller of the dalcApp
###
angular.module('dalcApp')
  .controller 'AboutCtrl', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
