class Routing extends Config then constructor: (
    $stateProvider, $urlRouterProvider
) ->
    state = $stateProvider.state

    state 'competition-and-table-main',
        url: '/competition-and-table/main'
        templateUrl: 'templates/competition-and-table/main.html',
        controller: 'competitionAndTableMainController'

    state 'feature-main',
        url: '/feature/main',
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
        url: '/timeline-and-update/main',
        templateUrl: 'templates/timeline-and-update/main.html',
        controller: 'timelineAndUpdateMainController'

    state 'fanzone',
        url: '/fanzone'
        abstract: yes
        controller: 'fanzoneMainController'
        templateUrl: 'templates/fanzone/main.html'

    state 'fanzone.product',
        url: '/product'
        views:
            'product':
                controller: 'productController'
                templateUrl: 'templates/fanzone/products.html'

    state 'fanzone.wallpaper',
        url: '/wallpaper'
        views:
            'wallpaper':
                controller: 'wallpaperController'
                templateUrl: 'templates/fanzone/wallpapers.html'

    state 'fanzone.questionary',
        url: '/questionary'
        views:
            'questionary':
                controller: 'questionaryController'
                templateUrl: 'templates/fanzone/questionarys.html'

    $urlRouterProvider.otherwise '/feature/main'
    return
