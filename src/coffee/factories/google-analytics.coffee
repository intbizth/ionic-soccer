class GoogleAnalytics extends Factory then constructor: (
    $cordovaGoogleAnalytics
) ->
    return {
        debugMode: ->
            if ionic.Platform.isWebView()
                $cordovaGoogleAnalytics.debugMode()
        startTrackerWithId: (id) ->
            if ionic.Platform.isWebView()
                $cordovaGoogleAnalytics.startTrackerWithId(id)
        setUserId: (id) ->
            if ionic.Platform.isWebView()
                $cordovaGoogleAnalytics.setUserId(id)
        trackView: (screen) ->
            if ionic.Platform.isWebView()
                $cordovaGoogleAnalytics.trackView(screen)
        addCustomDimension: (key, value) ->
            if ionic.Platform.isWebView()
                $cordovaGoogleAnalytics.addCustomDimension(key, value)
        trackEvent: (category, action, label, value) ->
            if ionic.Platform.isWebView()
                $cordovaGoogleAnalytics.trackEvent(category, action, label, value)
        addTransaction: (transactionId, affiliation, revenue, tax, shipping, currencyCode) ->
            if ionic.Platform.isWebView()
                $cordovaGoogleAnalytics.addTransaction(transactionId, affiliation, revenue, tax, shipping, currencyCode)
        addTransactionItem: (transactionId, name ,sku, category, price, quantity, currencyCode) ->
            if ionic.Platform.isWebView()
                $cordovaGoogleAnalytics.addTransactionItem(transactionId, name ,sku, category, price, quantity, currencyCode)
    }
