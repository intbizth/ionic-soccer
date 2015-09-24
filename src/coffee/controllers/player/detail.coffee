class playerDetail extends Controller then constructor: (
    $scope, Und, Chance
)   ->
    $scope.name = Chance.name()
    $scope.number = Und.random(1, 30)
    $scope.score =
        yellow: Und.random(1, 999)
        red: Und.random(1, 999)
        goal: Und.random(1, 999)
