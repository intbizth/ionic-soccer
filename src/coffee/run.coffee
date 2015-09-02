class Run extends Run then constructor: (
    $rootScope, $ionicPlatform, $location, $cordovaKeyboard, $cordovaToast, LogLine
) ->
    # default spinner icon
    $rootScope.$spinnerIcon = 'ripple'

    LogLine.len(32).startup()
    $ionicPlatform.ready ->
        LogLine.ready()

        # Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
        # for form inputs)
        if window.cordova # native mode
            $cordovaKeyboard.hideAccessoryBar yes
            $cordovaKeyboard.disableScroll yes

        if window.StatusBar
            # org.apache.cordova.statusbar required
            StatusBar.styleDefault()

    #console.log $rootScope
    #$rootScope.$on '$locationChangeStart', (e) ->
    #    console.log e
