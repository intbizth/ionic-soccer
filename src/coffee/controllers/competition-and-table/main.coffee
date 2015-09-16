class CompetitionAndTableMain extends Controller then constructor: (
    $scope, $ionicHistory, $timeout, Und, Chance
) ->
    $scope.back = ->
        $ionicHistory.goBack -1
        return

    $scope.matchLabel =
        homeClub:
            logo: './img/live/chonburi.png'
            name: 'Chonburi FC'
            score: 1
        awayClub:
            logo: './img/live/suphanburi.png'
            name: 'Suphanburi FC'
            score: 1
        datetime: Chance.date()
