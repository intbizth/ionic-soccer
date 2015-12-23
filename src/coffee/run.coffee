class Run extends Run then constructor: (
    $cordovaAppVersion, $cordovaKeyboard, $ionicPlatform, $rootScope, CFG, GoogleAnalytics, ImageCache, Moment
) ->
    $rootScope.isAndroid = no
    $rootScope.isIOS = no
    $rootScope.version = '0.0.0'

    Moment.locale 'th-TH'

    $ionicPlatform.ready ->
        $rootScope.isAndroid = ionic.Platform.isAndroid()
        $rootScope.isIOS = ionic.Platform.isIOS()

        $cordovaAppVersion.getVersionNumber().then((version) ->
            $rootScope.version = version
            $rootScope.$broadcast 'version', $rootScope.version
        )

        GoogleAnalytics.startTrackerWithId CFG.GOOGLE.analytics.id
        ImageCache.init()

        if window.cordova and window.cordova.plugins and window.cordova.plugins.Keyboard
            $cordovaKeyboard.hideAccessoryBar yes
            $cordovaKeyboard.disableScroll yes
        return
