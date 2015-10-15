class LineupMain extends Controller then constructor: (
    $scope, Chance, Und, $document
) ->
    $scope.format = []
    random = Chance.integer(min: 3, max: 4)
    i = 1
    while i <= random
        $scope.format.push 0
        i++
    $scope.format = $scope.format.join '-'

    footballField = angular.element $document[0].body.getElementsByClassName('football-field')

    console.warn 'footballField', typeof footballField, footballField

    console.warn 'footballField[0].offsetWidth', typeof footballField[0].offsetWidth, footballField[0].offsetWidth
    console.warn 'footballField[0].offsetHeight', typeof footballField[0].offsetHeight, footballField[0].offsetHeight
