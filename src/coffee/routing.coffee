class Routing extends Config then constructor: (
    $stateProvider, $urlRouterProvider
) ->
    state = $stateProvider.state

    state 'competition-table',
        url: '/competition-table/main'
        controller: 'competitionableMainController'
        templateUrl: 'templates/competition-table/main.html'

    state 'fanzone',
        abstract: true
        url: '/fanzone'
        controller: 'fanzoneMainController'
        templateUrl: 'templates/fanzone/main.html'

    state 'fanzone.main',
        url: '/main'
        views:
            products:
                controller: 'fanzoneProductsController'
                templateUrl: 'templates/fanzone/products/main.html'
            wallpapers:
                controller: 'fanzoneWallpapersController'
                templateUrl: 'templates/fanzone/wallpapers/main.html'
            questionary:
                controller: 'fanzoneQuestionaryController'
                templateUrl: 'templates/fanzone/questionary/main.html'

    state 'fanzone-product',
         url: '/fanzone/product/:id'
         controller: 'fanzoneProductShowController'
         templateUrl: 'templates/fanzone/products/show.html'

    state 'fanzone.wallpaper',
         url: '/wallpaper/:id'
         controller: 'fanzoneWallpaperShowController'
         templateUrl: 'templates/fanzone/wallpaper/show.html'

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
