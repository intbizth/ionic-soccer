class Run extends Run then constructor: (
    $rootScope, $ionicPlatform, $cordovaKeyboard
) ->
    $rootScope.isAndroid = ionic.Platform.isAndroid()
    $rootScope.isIOS = ionic.Platform.isIOS()

    $ionicPlatform.ready ->
        if window.cordova and window.cordova.plugins and window.cordova.plugins.Keyboard
            $cordovaKeyboard.hideAccessoryBar yes
            $cordovaKeyboard.disableScroll yes
        return
