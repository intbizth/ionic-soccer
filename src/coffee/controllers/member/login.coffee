class MemberLoginMain extends Controller then constructor: (
    $ionicHistory, $ionicLoading, $ionicPlatform, $scope, $state, $timeout, Authen, Chance, Users
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
            $this = @
            users = new Users()
            users.$testgetlogin({}
            , (success) ->
                console.warn '$testlogin:success', success
                $this.username = success.username
                $this.password = success.password
                $this.valid()
            , (error) ->
                console.error '$testlogin:error', error
            )
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
        submit: ->
            data =
                username: @username
                password: @password

            $ionicLoading.show()

            promise = Authen.login data.username, data.password
            promise.then(->
                console.warn 'Authen.login:success'
                $state.go 'feature'
                $ionicLoading.hide()
            , ->
                console.error 'Authen.login:error'
                $ionicLoading.hide()
            )
        logout: ->
            @reset()
            Authen.logout()

    $scope.data.valid()
