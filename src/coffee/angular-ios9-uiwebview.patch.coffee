# angular-ios9-uiwebview.patch.js v1.1.1
# url: https://gist.github.com/IgorMinar/863acd413e3925bf282c
angular.module('ngIOS9UIWebViewPatch', ['ng']).config(['$provide', ($provide) ->
    'use strict'
    $provide.decorator '$browser', ['$delegate', '$window', ($delegate, $window) ->
        isIOS9UIWebView = (userAgent) ->
            return /(iPhone|iPad|iPod).* OS 9_\d/.test(userAgent) and !/Version\/9\./.test(userAgent)
        applyIOS9Shim = (browser) ->
            pendingLocationUrl = null
            originalUrlFn = browser.url
            clearPendingLocationUrl = ->
                pendingLocationUrl = null
                return
            browser.url = ->
                if arguments.length
                    pendingLocationUrl = arguments[0]
                    return originalUrlFn.apply(browser, arguments)
                return pendingLocationUrl or originalUrlFn.apply(browser, arguments)
            window.addEventListener 'popstate', clearPendingLocationUrl, false
            window.addEventListener 'hashchange', clearPendingLocationUrl, false
            return browser
        if isIOS9UIWebView($window.navigator.userAgent)
            return applyIOS9Shim($delegate)
        return $delegate
    ]
    return
])