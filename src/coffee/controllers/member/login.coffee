class MemberLoginMain extends Controller then constructor: (
    $scope, $ionicHistory, $ionicPlatform, $timeout, Chance
) ->
    $ionicPlatform.onHardwareBackButton(->
        $scope.back()
    )

    $scope.back = ->
        $ionicHistory.goBack -1

        $timeout(->
            $scope.data.reset()
        , 200)
        return

    $scope.data =
        username: ''
        password: ''
        fake: ->
            username = Chance.pick([Chance.first()  + '.' + Chance.last(), Chance.email()])
            @username = username.toLowerCase()
            @password = Chance.string()
        reset: ->
            @username = @password = ''
