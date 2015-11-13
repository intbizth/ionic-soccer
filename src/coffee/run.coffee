class Run extends Run then constructor: (
    $rootScope, $ionicPlatform, $cordovaKeyboard, Authen, CFG, GoogleAnalytics, ImageCache
) ->
    Authen.init
        userInfoPath: CFG.API.getUserInfo()

    $ionicPlatform.ready ->
        $rootScope.isAndroid = ionic.Platform.isAndroid()
        $rootScope.isIOS = ionic.Platform.isIOS()

        GoogleAnalytics.startTrackerWithId CFG.GOOGLE.analytics.id
        ImageCache.init((success) ->
            return
        , (error) ->
            return
        )

        if window.cordova and window.cordova.plugins and window.cordova.plugins.Keyboard
            $cordovaKeyboard.hideAccessoryBar yes
            $cordovaKeyboard.disableScroll yes
        return
