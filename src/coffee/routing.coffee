class Routing extends Config then constructor: ($stateProvider, $urlRouterProvider) ->
    state = $stateProvider.state

    state 'about-club',
        url: '/about-club'
        controller: 'aboutClubMainController'
        templateUrl: 'templates/about-club/main.html'

    state 'about-club.main',
        url: '/main'
        views:
            info:
                controller: 'aboutClubInfoController'
                templateUrl: 'templates/about-club/info/main.html'
            team:
                controller: 'aboutClubTeamController'
                templateUrl: 'templates/about-club/team/main.html'

    state 'competition-table',
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

    state 'feature',
        url: '/feature/main'
        controller: 'featureMainController'
        templateUrl: 'templates/feature/main.html'

    state 'games',
        url: '/games'
        controller: 'gamesMainController'
        templateUrl: 'templates/games/main.html'

    state 'games-detail',
        url: '/games-detail'
        controller: 'gamesDetailMainController'
        templateUrl: 'templates/games-detail/main.html'

    state 'games-detail.main',
        url: '/main'
        views:
            prediction:
                controller: 'gamesDetailPredictionController'
                templateUrl: 'templates/games-detail/prediction/main.html'
            coacher11:
                controller: 'gamesDetailCoacher11Controller'
                templateUrl: 'templates/games-detail/coacher11/main.html'
            ranking:
                controller: 'gamesDetailRankingController'
                templateUrl: 'templates/games-detail/ranking/main.html'
            live:
                controller: 'gamesDetailLiveController'
                templateUrl: 'templates/games-detail/live/main.html'

    state 'live',
        url: '/live/main'
        controller: 'liveMainController'
        templateUrl: 'templates/live/main.html'

    state 'match',
        url: '/match'
        controller: 'matchMainController'
        templateUrl: 'templates/match/main.html'

    state 'match.detail',
        url: 'match/detail/:id'
        views:
            view:
                controller: 'matchViewController'
                templateUrl: 'templates/match/view/main.html'
            highlight:
                controller: 'matchHighlightController'
                templateUrl: 'templates/match/highlight/main.html'
            lineups:
                controller: 'matchLineupsController'
                templateUrl: 'templates/match/lineups/main.html'

    state 'member',
        url: '/member/main'
        controller: 'memberMainController'
        templateUrl: 'templates/member/main.html'

    state 'member-picture',
        url: '/member/picture'
        controller: 'memberPictureMainController'
        templateUrl: 'templates/member/picture.html'

    state 'member-login',
        url: '/member/login'
        controller: 'memberLoginMainController'
        templateUrl: 'templates/member/login.html'

    state 'member-register-step1',
        url: '/member/register/step1'
        controller: 'memberRegisterStep1Controller'
        templateUrl: 'templates/member/register/step1.html'

    state 'member-register-step2',
        url: '/member/register/step2'
        controller: 'memberRegisterStep2Controller'
        templateUrl: 'templates/member/register/step2.html'

    state 'news-detail',
        url: '/news/detail/:id'
        controller: 'newsDetailController'
        templateUrl: 'templates/news/detail.html'

    state 'personal-detail',
        url: '/personal/detail/:id'
        controller: 'personalDetailController'
        templateUrl: 'templates/personal/detail.html'

    state 'product-detail',
        url: '/product/detail/:id'
        controller: 'productDetailController'
        templateUrl: 'templates/product/detail.html'

    state 'ranking',
        url: '/ranking'
        controller: 'rankingMainController'
        templateUrl: 'templates/ranking/main.html'

    state 'ranking-detail',
        url: '/ranking-detail'
        controller: 'rankingDetailController'
        templateUrl: 'templates/ranking/detail.html'

    state 'ranking-player-detail',
        url: '/ranking-player-detail'
        controller: 'rankingPlayerDetailController'
        templateUrl: 'templates/ranking/player-detail.html'

    state 'ranking.main',
        url: '/main'
        views:
            prediction:
                controller: 'rankingPredictionController'
                templateUrl: 'templates/ranking/prediction/main.html'
            score:
                controller: 'rankingScoreController'
                templateUrl: 'templates/ranking/score/main.html'
            player:
                controller: 'rankingPlayerController'
                templateUrl: 'templates/ranking/player/main.html'

    state 'ticket-membership',
        url: '/ticket-membership'
        controller: 'ticketMembershipMainController'
        templateUrl: 'templates/ticket-membership/main.html'

    state 'ticket-membership.main',
        url: '/main'
        views:
            ticket:
                controller: 'ticketController'
                templateUrl: 'templates/ticket-membership/ticket/main.html'
            membership:
                controller: 'membershipController'
                templateUrl: 'templates/ticket-membership/membership/main.html'

    state 'timeline-update',
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

    state 'lineup',
        url: '/lineup/main'
        controller: 'lineupMainController'
        templateUrl: 'templates/lineup/main.html'

    $urlRouterProvider.otherwise '/feature/main'
    return
