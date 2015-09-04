class Feature extends Controller then constructor: (
        $scope, $state
) ->
     $scope.back = ->
        $state.go 'ads'

     $scope.fullname = 'Jackson Matinez'