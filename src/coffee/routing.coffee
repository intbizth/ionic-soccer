class Routing extends Config then constructor: (
    $stateProvider, $urlRouterProvider
) ->
    state = $stateProvider.state

    state 'competition-table',
        url: '/competition-table/main'
        controller: 'competitionableMainController'
        templateUrl: 'templates/competition-table/main.html'

#    state 'fanzone',
#        url: '/fanzone'
#        controller: 'fanzoneMainController'
#        templateUrl: 'templates/fanzone/main.html'
#
#    state 'fanzone.main',
#        url: '/fanzone/main'
#        views:
#            product:
#                controller: 'fanzoneProductController'
#                templateUrl: 'templates/fanzone/product.html'
#            wallpaper:
#                controller: 'fanzoneWallpaperController'
#                templateUrl: 'templates/fanzone/wallpaper.html'
#            questionary:
#                controller: 'fanzoneQuestionaryController'
#                templateUrl: 'templates/fanzone/questionary.html'

    state 'feature',
        url: '/feature/main'
        controller: 'featureMainController'
        templateUrl: 'templates/feature/main.html'

    state 'live',
        url: '/live/main'
        controller: 'liveMainController'
        templateUrl: 'templates/live/main.html'

    state 'news',
        url: '/news/detail/:id'
        controller: 'newsDetailController'
        templateUrl: 'templates/news/detail.html'

    state 'timeline-update',
        abstract: true
        url: '/timeline-update'
        controller: 'timelineUpdateMainController'
        templateUrl: 'templates/timeline-update/main.html'

    state 'timeline-update.main',
        url: '/main'
        views:
            timeline:
                controller: 'timelineController'
                templateUrl: 'templates/timeline-update/timeline/main.html'
            update:
                controller: 'updateController'
                templateUrl: 'templates/timeline-update/update/main.html'

    $urlRouterProvider.otherwise '/feature/main'
    return
