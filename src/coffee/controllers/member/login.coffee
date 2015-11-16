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
        isPass: no
        username: ''
        password: ''
        fake: ->
            username = Chance.pick([Chance.first()  + '.' + Chance.last(), Chance.email()])
            @username = username.toLowerCase()
            @password = Chance.string()
            @valid()
        reset: ->
            @username = @password = ''
            @valid()
        valid: ->
            pass = yes
            if not @username?.length
                pass = no
            if not @password?.length
                pass = no
            @isPass = pass

    $scope.data.valid()
