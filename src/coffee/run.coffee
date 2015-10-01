class Run extends Run then constructor: (
    $rootScope, $ionicPlatform, $location, $cordovaKeyboard
) ->
    $rootScope.isAndroid = ionic.Platform.isAndroid()
    $rootScope.isIOS = ionic.Platform.isIOS()

    $ionicPlatform.ready ->
        if window.cordova and window.cordova.plugins and window.cordova.plugins.Keyboard # native mode
            $cordovaKeyboard.hideAccessoryBar yes
            $cordovaKeyboard.disableScroll yes

        return
