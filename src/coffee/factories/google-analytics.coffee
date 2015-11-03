class GoogleAnalytics extends Factory then constructor: (
    $cordovaGoogleAnalytics, $ionicPlatform
) ->
    return {
        debugMode: ->
            $ionicPlatform.ready ->
                if ionic.Platform.isWebView()
                    $cordovaGoogleAnalytics.debugMode()
        startTrackerWithId: (id) ->
            $ionicPlatform.ready ->
                if ionic.Platform.isWebView()
                    $cordovaGoogleAnalytics.startTrackerWithId(id)
        setUserId: (id) ->
            $ionicPlatform.ready ->
                if ionic.Platform.isWebView()
                    $cordovaGoogleAnalytics.setUserId(id)
        trackView: (screen) ->
            $ionicPlatform.ready ->
                if ionic.Platform.isWebView()
                    $cordovaGoogleAnalytics.trackView(screen)
        addCustomDimension: (key, value) ->
            $ionicPlatform.ready ->
                if ionic.Platform.isWebView()
                    $cordovaGoogleAnalytics.addCustomDimension(key, value)
        trackEvent: (category, action, label, value) ->
            $ionicPlatform.ready ->
                if ionic.Platform.isWebView()
                    $cordovaGoogleAnalytics.trackEvent(category, action, label, value)
        addTransaction: (transactionId, affiliation, revenue, tax, shipping, currencyCode) ->
            $ionicPlatform.ready ->
                if ionic.Platform.isWebView()
                    $cordovaGoogleAnalytics.addTransaction(transactionId, affiliation, revenue, tax, shipping, currencyCode)
        addTransactionItem: (transactionId, name ,sku, category, price, quantity, currencyCode) ->
            $ionicPlatform.ready ->
                if ionic.Platform.isWebView()
                    $cordovaGoogleAnalytics.addTransactionItem(transactionId, name ,sku, category, price, quantity, currencyCode)
    }
