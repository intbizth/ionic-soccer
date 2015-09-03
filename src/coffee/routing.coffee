class Routing extends Config then constructor: (
    $stateProvider, $urlRouterProvider
) ->
    state = $stateProvider.state
    state 'aboutclub',
        url: '/aboutclub'
        templateUrl: 'templates/aboutclub.html',
        controller: 'aboutclubController'

    state 'ads',
        url: '/ads'
        templateUrl: 'templates/ads.html',
        controller: 'adsController'

    state 'feature',
        url: '/feature'
        templateUrl: 'templates/feature.html',
        controller: 'featureController'

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
      $urlRouterProvider.otherwise '/ads'
      return
