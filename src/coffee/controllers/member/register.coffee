class MemberRegisterMain extends Controller then constructor: (
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
        email: ''
        password: ''
        confirmPassword: ''
        fake: ->
            @username = Chance.first()  + '.' + Chance.last().toLowerCase()
            @email = Chance.email()
            @password = @confirmPassword = Chance.string()
        reset: ->
            @username = @email = @password = @confirmPassword = ''
