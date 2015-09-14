class FeatureMain extends Controller then constructor: (
    $scope, $ionicHistory, $ionicModal, $timeout
) ->
    $ionicModal.fromTemplateUrl(
        'templates/feature/ads.html',
         scope: $scope
         animation: 'no-animation'
    ).then (modal) ->
        $scope.modal = modal

        $timeout (->
            $scope.openAds()
            return
        ), 100
        return

    $scope.openAds = ->
        $scope.modal.show()
        return

    $scope.closeAds = ->
        $scope.modal.hide()
        return

    $scope.go =
        live : ->
            $state.go 'live-main'
            return

        timelineAndUpdate : ->
            $state.go 'timeline-and-update-main'
            return

        competitionAndTable : ->
            $state.go 'competition-and-table-main'
            return

        ticketAndMembership : ->
#            $state.go 'ticket-and-membership-main'
            return

        games : ->
#            $state.go 'games-main'
            return

        peopleRanking : ->
#            $state.go 'people-ranking-main'
            return

        manOfTheMatch : ->
#            $state.go 'man-of-the-match-main'
            return

        reward : ->
#            $state.go 'reward-main'
            return

        fanzone : ->
#            $state.go 'fanzone-main'
            return

    $scope.fullname = 'Jackson Matinez'
    $scope.point1 = 9999999
    $scope.point2 = 9999999
