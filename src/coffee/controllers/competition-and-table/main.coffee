class CompetitionAndTableMain extends Controller then constructor: (
    $scope, $ionicHistory
) ->
    $scope.back = ->
        $ionicHistory.goBack -1
        return

    $scope.matches = [
        { id: 0, text:'Inwdragon' },
        { id: 1, text:'YokYukYiK'  },
        { id: 2, text:'BeerLao' },
        { id: 3, text:'Spykane' },
        { id: 4, text:'Robin' }
    ]
