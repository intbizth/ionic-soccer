class Routing extends Config then constructor: (
    $stateProvider, $urlRouterProvider
) ->
    state = $stateProvider.state
    state 'aboutclub',
        url: '/aboutclub'
        templateUrl: 'templates/aboutclub.html',
        controller: 'aboutclubController'

    state 'ads-main',
        url: '/ads/main'
        templateUrl: 'templates/ads/main.html',
        controller: 'adsMainController'

    state 'feature-main',
        url: '/feature/main'
        templateUrl: 'templates/feature/main.html',
        controller: 'featureMainController'

    state 'live',
        url: '/live'
        templateUrl: 'templates/live.html',
        controller: 'liveController'

    state 'newsdetail',
        url: '/newsdetail'
        templateUrl: 'templates/newsdetail.html',
        controller: 'newsdetailController'

    state 'playerdetail',
        url: '/playerdetail'
        templateUrl: 'templates/playerdetail.html',
        controller: 'playerdetailController'

    state 'timelineandupdate',
        url: '/timelineandupdate'
        templateUrl: 'templates/timelineandupdate.html',
        controller: 'timelineandupdateController'

    # if none of the above states are matched, use this as the fallback
    $urlRouterProvider.otherwise '/ads/main'
    return
