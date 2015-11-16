class memberRegisterStep1 extends Controller then constructor: (
    $scope, $state, $ionicHistory, $ionicPlatform, $timeout, Chance
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
            # RFC 5322 http://emailregex.com/
            regExpEmail = new RegExp('^[-a-z0-9~!$%^&*_=+}{\'?]+(\.[-a-z0-9~!$%^&*_=+}{\'?]+)*@([a-z0-9_][-a-z0-9_]*(\.[-a-z0-9_]+)*\.(aero|arpa|biz|com|coop|edu|gov|info|int|mil|museum|name|net|org|pro|travel|mobi|[a-z][a-z])|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,5})?$', 'i')
            if not @username?.length
                pass = no
            if not @email?.length or not regExpEmail.test(@email)
                pass = no
            if not @password?.length or @password != @confirmPassword
                pass = no
            if not @confirmPassword?.length or @password != @confirmPassword
                pass = no
            @isPass = pass
        submit: ->
            data =
                data:
                    email: @email
                    user:
                        username: @username
                        plainPassword:
                            first: @password
                            second: @confirmPassword

            $state.go 'member-register-step2', data

    $scope.data.valid()

