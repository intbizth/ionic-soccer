class Routing extends Config then constructor: (
    $stateProvider, $urlRouterProvider
) ->
    state = $stateProvider.state

    state 'competition-and-table-main',
        url: '/competition-and-table/main'
        controller: 'competitionAndTableMainController'
        templateUrl: 'templates/competition-and-table/main.html'

    state 'feature-main',
        url: '/feature/main'
        controller: 'featureMainController'
        templateUrl: 'templates/feature/main.html'

    state 'live-main',
        url: '/live/main'
        controller: 'liveMainController'
        templateUrl: 'templates/live/main.html'

    state 'news-detail',
        url: '/news/detail/:id'
        controller: 'newsDetailController'
        templateUrl: 'templates/news/detail.html'

    state 'timeline-and-update',
        abstract: true
        url: '/timeline-and-update'
        controller: 'timelineAndUpdateMainController'
        templateUrl: 'templates/timeline-and-update/index.html'

    state 'timeline-and-update.main',
        url: '/main'
        views:
            timeline:
                controller: 'timelineController'
                templateUrl: 'templates/timeline-and-update/timeline.html'
            update:
                controller: 'updateController'
                templateUrl: 'templates/timeline-and-update/update.html'

    state 'fanzone-main',
        url: '/fanzone/main'
        controller: 'fanzoneMainController'
        templateUrl: 'templates/fanzone/main.html'

    $urlRouterProvider.otherwise '/feature/main'
    return
