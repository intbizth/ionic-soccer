class memberRegisterStep1 extends Controller then constructor: (
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
        isPass: no
        username: ''
        email: ''
        password: ''
        confirmPassword: ''
        fake: ->
            @username = Chance.first()  + '.' + Chance.last().toLowerCase()
            @email = Chance.email()
            @password = @confirmPassword = Chance.string()
            @valid()
        reset: ->
            @username = @email = @password = @confirmPassword = ''
            @valid()
        valid: ->
            pass = yes
            if not @username?.length or not @email?.length or not @password?.length or not @confirmPassword?.length
                pass = no
            @isPass = pass

    $scope.data.valid()
