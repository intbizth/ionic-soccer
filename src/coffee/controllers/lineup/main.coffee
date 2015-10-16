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
    $scope.footballField = footballField[0]
    $scope.footballField.centerX = $scope.footballField.offsetWidth / 2
    $scope.footballField.centerY = $scope.footballField.offsetHeight / 2

    console.warn '$scope.footballField', typeof $scope.footballField, $scope.footballField
    console.warn '$scope.footballField', typeof $scope.footballField, $scope.footballField
    console.warn '$scope.footballField.offsetWidth', typeof $scope.footballField.offsetWidth, $scope.footballField.offsetWidth
    console.warn '$scope.footballField.offsetHeight', typeof $scope.footballField.offsetHeight, $scope.footballField.offsetHeight
    console.warn '$scope.footballField.centerX', typeof $scope.footballField.centerX, $scope.footballField.centerX
    console.warn '$scope.footballField.centerY', typeof $scope.footballField.centerY, $scope.footballField.centerY
