class Run extends Run then constructor: (
    $rootScope, $ionicPlatform, $cordovaKeyboard
) ->
    $ionicPlatform.ready ->
        if window.cordova and window.cordova.plugins and window.cordova.plugins.Keyboard
            $cordovaKeyboard.hideAccessoryBar yes
            $cordovaKeyboard.disableScroll yes
        return
