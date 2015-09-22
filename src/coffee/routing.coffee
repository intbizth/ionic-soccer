class Routing extends Config then constructor: (
    $stateProvider, $urlRouterProvider
) ->
    state = $stateProvider.state

    state 'competition-table',
        abstract: true
        url: '/competition-table/main'
        controller: 'competitionTableMainController'
        templateUrl: 'templates/competition-table/main.html'

    state 'competition-table.main',
        url: '/main'
        views:
            fixture:
                controller: 'competitionTableFixtureController'
                templateUrl: 'templates/competition-table/fixture/main.html'
            results:
                controller: 'competitionTableResultController'
                templateUrl: 'templates/competition-table/results/main.html'
            'position-table':
                controller: 'competitionTablePositionTableController'
                templateUrl: 'templates/competition-table/position-table/main.html'

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

    state 'about-chonburi',
        url: '/about-club/about-chonburi'
        templateUrl: 'templates/about-club/about-chonburi.html'
        controller: 'aboutChonburiMainController'

    state 'first-team',
        url: '/about-club/first-team'
        templateUrl: 'templates/about-club/first-team.html'
        controller: 'firstTeamMainController'

    $urlRouterProvider.otherwise '/about-club/first-team'
    return
