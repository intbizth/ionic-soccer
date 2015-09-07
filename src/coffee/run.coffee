class Run extends Run then constructor: (
    $rootScope, $ionicPlatform, $location, $cordovaKeyboard, $cordovaToast
) ->
    # default spinner icon
    $rootScope.$spinnerIcon = 'ripple'

    $ionicPlatform.ready ->
        # Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
        # for form inputs)
        if window.cordova and window.cordova.plugins and window.cordova.plugins.Keyboard # native mode
            $cordovaKeyboard.hideAccessoryBar yes
            $cordovaKeyboard.disableScroll yes

        if window.StatusBar
            # org.apache.cordova.statusbar required
            StatusBar.styleDefault()

        return

    #console.log $rootScope
    #$rootScope.$on '$locationChangeStart', (e) ->
    #    console.log e
