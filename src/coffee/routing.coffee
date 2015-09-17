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
        url: '/news/detail/:id'
        templateUrl: 'templates/news/detail.html',
        controller: 'newsDetailController'

    state 'timeline-and-update-main',
        url: '/timeline-and-update/main',
        templateUrl: 'templates/timeline-and-update/main.html',
        controller: 'timelineAndUpdateMainController'

    state 'fanzone-main',
        url: '/fanzone/main'
        templateUrl: 'templates/fanzone/main.html',
        controller: 'fanzoneMainController'

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
