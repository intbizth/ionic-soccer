class Routing extends Config then constructor: (
    $stateProvider, $urlRouterProvider
) ->
    state = $stateProvider.state

    state 'competition-and-table-main',
        url: '/competitionandtable/main'
        templateUrl: 'templates/competitionandtable/main.html',
        controller: 'competitionAndTableMainController'

    state 'feature-main',
        url: '/feature/main'
        templateUrl: 'templates/feature/main.html',
        controller: 'featureMainController'

    state 'live-main',
        url: '/live/main'
        templateUrl: 'templates/live/main.html',
        controller: 'liveMainController'

    state 'news-detail',
        url: '/news/detail'
        templateUrl: 'templates/news/detail.html',
        controller: 'newsDetailController'

    state 'timeline-and-update-main',
        url: '/live/main'
        templateUrl: 'templates/timeline_and_update/main.html',
        controller: 'timelineAndUpdateMainController'

    # if none of the above states are matched, use this as the fallback
    $urlRouterProvider.otherwise '/competitionandtable/main'
    return
