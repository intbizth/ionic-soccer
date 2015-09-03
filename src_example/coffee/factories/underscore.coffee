class Und extends Factory then constructor: ->
    return window._.extend window._,
        isDefined: angular.isDefined
