class Run extends Run then constructor: (
    $cordovaAppVersion, $cordovaKeyboard, $ionicPlatform, $rootScope, CFG, GoogleAnalytics, ImageCache
) ->
    $rootScope.isAndroid = no
    $rootScope.isIOS = no
    $rootScope.version = '0.0.0'

    $ionicPlatform.ready ->
        $rootScope.isAndroid = ionic.Platform.isAndroid()
        $rootScope.isIOS = ionic.Platform.isIOS()

        $cordovaAppVersion.getVersionNumber().then((version) ->
            $rootScope.version = version
            $rootScope.$broadcast 'version', $rootScope.version
        )

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
