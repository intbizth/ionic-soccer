class Authen extends Factory then constructor: (
    $cordovaCamera, $cordovaKeyboard, $cordovaSQLite, $document, $ionicLoading, $ionicModal, $ionicPlatform, $ionicPopup, $ionicSlideBoxDelegate, $q, $rootScope, $sessionStorage, $timeout, authService, Chance, md5, Moment, OAuth, OAuthToken, Users
) ->
    scope = $rootScope.$new()

    reset = ->
        delete $sessionStorage.user
        OAuthToken.removeToken()

    getUser = (args) ->
        flush = if args && args.flush then args.flush else no
        if isLoggedin()
            users = new Users()
            users.$info(
                flush: flush
            , (success) ->
                console.warn '$info:success', success
                $sessionStorage.user = success
            , (error) ->
                console.warn '$info:error', error
                somethingWrong error
            )
        else
            deferred = $q.defer()
            deferred.reject()
            return deferred.promise

    somethingWrong = (error) ->
        reset()
        if error.status == 400 then message = error.error_description
        else if error.status == 500 then message = error.statusText
        else message = ''

    login = (username, password) ->
        deferred = $q.defer()

        OAuth.getAccessToken({
            username: username
            password: password
        }).then((success) ->
            console.warn 'OAuth.getAccessToken:success', success
            promise = getUser(flush: yes)
            promise.then((success) ->
                authService.loginConfirmed success, (config) ->
                    return config
                $rootScope.$emit 'event:auth-stateChange', isLoggedin()
                deferred.resolve success
            , (error) ->
                authService.loginCancelled error, (config) ->
                    return config
                deferred.reject error
            )
        , (error) ->
            console.error 'OAuth.getAccessToken:error', error
            authService.loginCancelled error, (config) ->
                return config
            deferred.reject somethingWrong error
        )

        return deferred.promise

    logout = ->
        reset()
        $rootScope.$emit 'event:auth-stateChange', isLoggedin()
        return

    isLoggedin = ->
        OAuth.isAuthenticated()

    ui =
        login: ->
            $ionicModal.fromTemplateUrl(
                'templates/member/modal.html',
                scope: scope
                focusFirstInput: no
                hardwareBackButtonClose: no
            ).then (modal) ->
                scope.modal = modal
                scope.modal.title = 'Login'
                scope.modal.leftButton = 'close'
                scope.slider = $ionicSlideBoxDelegate.$getByHandle 'slider'
                scope.slider.enableSlide no

                states = [
                        name: 'goToLogin'
                        title: 'Login'
                        leftButton: 'close'
                        func: ->
                            $timeout(->
                                scope.step1.reset()
                            , 500)
                    ,
                        name: 'goToRegisterStep1'
                        title: 'Register step1'
                        leftButton: 'back'
                        func: ->
                            $timeout(->
                                scope.step2.reset()
                            , 500)
                    ,
                        name: 'goToRegisterStep2'
                        title: 'Register step2'
                        leftButton: 'back'
                ]

                angular.forEach states, (value, key) ->
                    scope[value.name] = ->
                        scope.slider.slide key
                        scope.modal.title = value.title
                        scope.modal.leftButton = value.leftButton
                        if angular.isFunction value.func then value.func()

                scope.back = ->
                    index = scope.slider.currentIndex() - 1
                    if index == -1
                        scope.modal.hide()
                    else
                        scope[states[index].name]()

                scope.modal.show()

            scope.login =
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

                    promise = login data.username, data.password
                    promise.then(->
                        console.warn 'Authen.login:success'
                        $ionicLoading.hide()
                    , ->
                        console.error 'Authen.login:error'
                        $ionicLoading.hide()
                    )

            scope.step1 =
                isPass: no
                username: ''
                email: ''
                password: ''
                confirmPassword: ''
                fake: ->
                    @username = Chance.first()  + '.' + Chance.last().toLowerCase()
                    @email = Chance.email()
                    @password = @confirmPassword = md5.createHash(@email).slice 0, 13
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
                    scope.goToRegisterStep2()

            scope.step2 =
                isPass: no
                date:
                    min: Moment().add(-160, 'years').startOf('year').format('YYYY-MM-DD')
                    max: Moment().format('YYYY-MM-DD')
                firstname: ''
                lastname: ''
                birthday: ''
                fake: ->
                    @firstname = Chance.first()
                    @lastname = Chance.last()
                    min = Moment(@date.min).unix()
                    max = Moment(@date.max).unix()
                    rand = Chance.integer(min: min, max: max) * 1000
                    @birthday = Moment(rand).format('YYYY-MM-DD')
                    @valid()
                reset: ->
                    @firstname = @lastname = @birthday = ''
                    scope.photo.remove()
                    @valid()
                valid: ->
                    pass = yes
                    regExpDate = new RegExp('^(0000-\\d{2}-\\d{2}|\\d{4}-00-\\d{2}|\\d{4}-\\d{2}-00)$')
                    if not @firstname?.length
                        pass = no
                    if not @lastname?.length
                        pass = no
                    if not @birthday?.length or regExpDate.test(@birthday)
                        pass = no
                    @isPass = pass
                submit: ->
                    data =
                        email: scope.step1.email
                        user:
                            username: scope.step1.username
                            plainPassword:
                                first: scope.step1.password
                                second: scope.step1.confirmPassword
                        firstname: @firstname
                        lastname: @lastname
                        birthday: @birthday

                    console.warn 'data', data

                    $ionicLoading.show()

                    users = new Users(data)
                    users.$register({}
                    , (success) ->
                        console.warn '$register:success', success
                        promise = login data.user.username, data.user.plainPassword.first
                        promise.then(->
                            console.warn 'Authen.login:success'
                            $ionicLoading.hide()
                        , ->
                            console.error 'Authen.login:error'
                            $ionicLoading.hide()
                        )
                    , (error) ->
                        console.warn '$register:error', error
                        $ionicLoading.hide()
                    )

            scope.photo =
                isPhoto: no
                fileUri: null
                base64: null
                element: null
                getPicture: (args) ->
                    $this = @
                    $this.element = angular.element $document[0].querySelector '.member-login .member-form .form .photo img.user'
                    camera = if args && args.camera then args.camera else no
                    options =
                        quality: 100,
                        destinationType: Camera.DestinationType.FILE_URI,
                        sourceType: Camera.PictureSourceType.PHOTOLIBRARY,
                        allowEdit: yes,
                        encodingType: Camera.EncodingType.JPEG,
                        targetWidth: 200,
                        targetHeight: 200,
                        popoverOptions: CameraPopoverOptions,
                        saveToPhotoAlbum: no,
                        correctOrientation: yes

                    if '@@environment' == 'dev'
                        options.destinationType = Camera.DestinationType.DATA_URL

                    if camera
                        options.sourceType = Camera.DestinationType.CAMERA

                    $cordovaCamera.getPicture(options).then((imageData) ->
                        $this.isPhoto = yes
                        if '@@environment' == 'dev'
                            $this.base64 = imageData
                            $this.element.attr 'src', 'data:image/jpeg;base64,' + $this.base64
                            $this.element.removeAttr 'srcset'
                        else
                            $this.fileUri = imageData
                            $this.element.attr 'src', $this.fileUri
                            $this.element.removeAttr 'srcset'
                        return
                    , (error) ->
                        return
                    )

                    $cordovaCamera.cleanup().then(->
                        return
                    )
                openGallery: ->
                    @getPicture()
                openCamera: ->
                    @getPicture(camera: true)
                remove: ->
                    @isPhoto = no
                    @fileUri = null
                    @base64 = null
                    if @element
                        @element.attr 'src', './img/member/photo.png'
                        @element.attr 'srcset', './img/member/photo@2x.png 2x'
                    return
        logout: ->
            confirmPopup = $ionicPopup.confirm
                title: 'Logout',
                template: 'Are you sure you want to logout?'
            confirmPopup.then((res) ->
                if res then logout()
            )

    tokenStore =
        db: null
        init: (db) ->
            @db = db
            deferred = $q.defer()
            @db.transaction((tx) ->
                tx.executeSql 'CREATE TABLE IF NOT EXISTS `token` (`data`)'
            , (error) ->
                deferred.reject error
            , ->
                deferred.resolve()
            )
            return deferred.promise
        get: ->
            deferred = $q.defer()
            @db.transaction((tx) ->
                tx.executeSql 'SELECT `data` FROM `token`', [], (tx, res) ->
                    data = null
                    if res.rows.length > 0
                        data = res.rows.item(0).data
                        if data != null
                            data = angular.fromJson decodeURIComponent data
                    deferred.resolve data
            , (error) ->
                deferred.reject error
            )
            return deferred.promise
        set: (data) ->
            if data != null
                data = encodeURIComponent angular.toJson data
            deferred = $q.defer()
            @db.transaction((tx) ->
                tx.executeSql 'INSERT INTO `token` (`data`) VALUES (?)', [data]
            , (error) ->
                deferred.reject error
            , ->
                deferred.resolve data
            )
            return deferred.promise
        remove: ->
            deferred = $q.defer()
            @db.transaction((tx) ->
                tx.executeSql 'DELETE FROM `token`'
            , (error) ->
                deferred.reject error
            , ->
                deferred.resolve data
            )
            return deferred.promise

    angular.extend @, {
        login: login
        logout: logout
        isLoggedin: isLoggedin
        getUser: getUser
        ui: ui
    }

    $ionicPlatform.ready ->
        tokenStore.init $cordovaSQLite.openDB name: 'database.db', location: 2

        promise = tokenStore.get()
        promise.then((success) ->
            if success != null
                $sessionStorage.token = success
        )

        scope.$watch(->
            return $sessionStorage.token
        , (newValue, oldValue) ->
            if newValue != oldValue
                if angular.isUndefined newValue
                    tokenStore.remove()
                else
                    $sessionStorage.token = newValue
                    tokenStore.set newValue

            $rootScope.$emit 'event:auth-stateChange', isLoggedin()
            tokenStore.get()
        )

    $ionicPlatform.onHardwareBackButton(->
        scope.back()
    )

    $rootScope.isLoggedin = isLoggedin()

    $rootScope.$on 'event:auth-loginRequired', (event, data) ->
        console.warn event, data
        if !isLoggedin() then ui.login()

    $rootScope.$on 'event:auth-forbidden', (event, data) ->
        console.warn event, data
#        OAuth.getRefreshToken().then _getUserInfo , _somethingWrong

    $rootScope.$on 'event:auth-loginConfirmed', (event, data) ->
        console.warn event, data
        scope.modal.hide()

    $rootScope.$on 'event:auth-logout', (event, data) ->
        console.warn event, data
        ui.logout()

    $rootScope.$on 'event:auth-stateChange', (event, data) ->
        $rootScope.isLoggedin = data

    return @
