class playerDetail extends Controller then constructor: (
    $scope, Und, Chance
)   ->
    $scope.players =
        fname: Chance.first()
        lname: Chance.last()
        number: Und.random(1, 30)
        score:
            yellow: Und.random(1, 999)
            red: Und.random(1, 999)
            goal: Und.random(1, 999)
