'use strict'

###*
 # @ngdoc function
 # @name dalcApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the dalcApp
###
angular.module('dalcApp')
  .controller 'MainCtrl', ($scope, $http) ->

    $scope.itemCost = 109980
    $scope.shippingCost = 6000
    $scope.bankFee = ->
      if $scope.itemCost < 30000 then 500 else 630
    $scope.brokerFee = ->
      cost = $scope.itemCost
      fee = switch
        when cost < 10000 then 1000
        when cost < 35000 then cost * 0.1
        when cost > 50000 then cost * 0.07
        else 3500
      100 * Math.floor(fee/100)
    
    $scope.tyres = 4
    $scope.tyresTotal = ->
      $scope.tyres * 1000
    $scope.weight = 0
    
    $scope.sea = ->
      # return formula(x)
    $scope.surface = ->
      # return formula(x)
    $scope.ems = ->
      # return formula(x)

    $scope.quantity = 0
    
    $scope.handling = 0
    $scope.shippingSea = 35000.00
    $scope.shippingEms = 0
    
    $scope.tot = ->
      ($scope.itemCost + $scope.shippingCost +
       $scope.bankFee() + $scope.brokerFee() +
       $scope.shippingSea + $scope.shippingEms +
       $scope.tyresTotal() + $scope.handling)
    $scope.paypal = ->
      $scope.tot() * 1.04
    $scope.exchangeRate = 92
    $scope.exchangeRateSub = ->
      $scope.exchangeRate - 3.3
      
    $scope.priceAUD = ->
      $scope.tot() / $scope.exchangeRateSub()
    $scope.paypalPriceAUD = ->
      $scope.paypal() / $scope.exchangeRateSub()
    
    $scope.fetching = false
    $scope.fetchYenAUD = ($event) ->
      $event.preventDefault()
      $scope.fetching = true
      url = 'https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22AUDJPY%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback='
      
      $http.get(url).then (response) ->
        $scope.exchangeRate =  Math.round(response.data.query.results.rate["Rate"] * 100) / 100
        $scope.fetching = false
