class Match extends Controller then constructor: (
    $scope, Matches
) ->
    new Matches().load $scope
