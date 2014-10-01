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

    $scope.weight = 300
    $scope.quantity = 1

    $scope.shippingTypes = [
      "Sea",
      "Surface",
      "EMS"
    ]
    $scope.countries = ["AU/NZ", "Europe"]

    $scope.country = $scope.countries[0]
    $scope.shippingType = $scope.shippingTypes[0]

    # $scope.currencies = ["AUD", "USD", "EUR"]
    $scope.currencies = 
      AUD: "$"
      USD: "$"
      EUR: "€"
    $scope.currCountries = Object.keys $scope.currencies
    $scope.myCurrency = 'AUD'

    $scope.shipping = ->
      weight = $scope.weight
      type = $scope.shippingType
      cost = switch
        when type is "Sea" then $scope.sea weight
        when type is "Surface" then $scope.surface weight
        when type is "EMS" then $scope.ems weight, $scope.country
      cost * $scope.quantity

    $scope.sea = (weight) ->
      [init, increment, finalIncrement] = [1800, 550, 350]
      val = switch
        when weight <= 10000 then init + (increment * (Math.ceil(weight/1000)-1))
        when weight >  10000 then init + (increment * 9) + (finalIncrement * (Math.ceil(weight/1000)-10))

    $scope.surface = (weight) ->
      [init, increment, finalIncrement] = [2700, 1050, 700]
      val = switch
        when weight <= 5000 then init + (1150 * (Math.ceil(weight/1000)-1))
        when weight <= 10000 then 7300 + (increment * (Math.ceil(weight/1000)-5))
        when weight <= 12000 then init + (increment * 9) + (finalIncrement * (Math.floor(weight/1000)-10))
        when weight <= 14000 then 14350
        when weight <= 15000 then 16050
        when weight >  15000 then 16050 + (finalIncrement * (Math.ceil(weight/1000)-15))

    $scope.ems = (weight, country) ->
      [init, incrOne, incrTwo, incrThree, finalIncrement] = switch
        when country is "Australia" then  [1200, 180, 400, 700, 1100]
        when country is "Europe"    then  [1500, 200, 450, 800, 1300]
      ems = switch
        when weight <= 300  then init
        when weight <= 500  then init + 300
        when weight <= 1000 then init + 300 + (incrOne * (Math.ceil(weight/100)-5))
        when weight <= 2000 then init + 300 + (incrOne * 5)  + (incrTwo * (Math.ceil(weight/250)-4))
        when weight <= 6000 then init + 300 + (incrOne * 5)  + (incrTwo * 4) + (incrThree * (Math.ceil(weight/500)-4))
        when weight >  6000 then init + 300 + (incrOne * 5)  + (incrTwo * 4) + (incrThree * 8) + (finalIncrement * (Math.ceil(weight/1000)-6))
    
    $scope.handling = 0
    # $scope.shippingSea = 35000.00
    # $scope.shippingEms = 0

    $scope.totWithoutShipping = ->
      ($scope.itemCost + $scope.shippingCost +
       $scope.bankFee() + $scope.brokerFee() +
       $scope.tyresTotal() + $scope.handling)    
    $scope.tot = ->
      ($scope.itemCost + $scope.shippingCost +
       $scope.bankFee() + $scope.brokerFee() +
       $scope.shipping() +
       $scope.tyresTotal() + $scope.handling)
    $scope.paypal = ->
      $scope.tot() * 1.04

    $scope.exchangeRateDefaults = ->
      $scope.exchangeRate = switch
        when $scope.myCurrency is 'AUD' then 95.5
        when $scope.myCurrency is 'USD' then 109.87
        when $scope.myCurrency is 'EUR' then 138.6

    $scope.exchangeRate = $scope.exchangeRateDefaults()
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
      currency = $scope.myCurrency
      url = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22" + currency + "JPY%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
      $http.get(url).then (response) ->
        $scope.exchangeRate =  Math.round(response.data.query.results.rate["Rate"] * 100) / 100
        $scope.fetching = false
