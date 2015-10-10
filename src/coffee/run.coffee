class Run extends Run then constructor: (
    $rootScope, $ionicPlatform, $cordovaKeyboard, Authen, CFG
) ->
    $rootScope.isAndroid = ionic.Platform.isAndroid()
    $rootScope.isIOS = ionic.Platform.isIOS()
    $rootScope.clubId = 28

    Authen.init
        userInfoPath: CFG.API.getUserInfo()

    $ionicPlatform.ready ->
        if window.cordova and window.cordova.plugins and window.cordova.plugins.Keyboard
            $cordovaKeyboard.hideAccessoryBar yes
            $cordovaKeyboard.disableScroll yes
        return
