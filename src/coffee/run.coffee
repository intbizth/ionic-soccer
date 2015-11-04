class Run extends Run then constructor: (
    $rootScope, $ionicPlatform, $cordovaKeyboard, Authen, CFG, GoogleAnalytics
) ->
    $rootScope.isAndroid = ionic.Platform.isAndroid()
    $rootScope.isIOS = ionic.Platform.isIOS()
    
    Authen.init
        userInfoPath: CFG.API.getUserInfo()

    $ionicPlatform.ready ->
        GoogleAnalytics.startTrackerWithId CFG.GOOGLE.analytics.id

        if window.cordova and window.cordova.plugins and window.cordova.plugins.Keyboard
            $cordovaKeyboard.hideAccessoryBar yes
            $cordovaKeyboard.disableScroll yes
        return
