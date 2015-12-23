class AuthenUI extends Factory then constructor: (
    $cordovaCamera, $cordovaKeyboard, $document, $ionicHistory, $ionicLoading, $ionicModal, $ionicPlatform, $ionicPopup, $ionicSlideBoxDelegate, $rootScope, $timeout, $translate, Authen, Chance, md5, Moment, Users
) ->
    scope = $rootScope.$new()
    scope.translate =
        back: ''
        logout:
            title: '',
            template: ''
            cancelText: ''
            okText: ''

    states = [
        name: 'goToLogin'
        title: ''
        leftButton: 'close'
        func: ->
            $timeout(->
                scope.step1.reset()
            , 500)
    ,
        name: 'goToRegisterStep1'
        title: ''
        leftButton: 'back'
        func: ->
            $timeout(->
                scope.step2.reset()
            , 500)
    ,
        name: 'goToRegisterStep2'
        title: ''
        leftButton: 'back'
    ]

    login = ->
        $ionicModal.fromTemplateUrl(
            'templates/member/modal.html',
            scope: scope
            focusFirstInput: no
            hardwareBackButtonClose: no
        ).then (modal) ->
            scope.modal = modal
            scope.modal.title = states[0].title
            scope.modal.leftButton = 'close'
            scope.slider = $ionicSlideBoxDelegate.$getByHandle 'slider'
            scope.slider.enableSlide no

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
            errorMessage: ''
            fake: ->
                $this = @
                users = new Users()
                users.$testgetlogin({}
                , (success) ->
                    $this.username = success.username
                    $this.password = success.password
                    $this.valid()
                , (error) ->
                    return
                )
            reset: ->
                @username = @password = ''
                @valid()
            valid: ->
                @errorMessage = ''
                pass = yes
                if not @username?.length
                    pass = no
                if not @password?.length
                    pass = no
                @isPass = pass
            submit: ->
                $this = @
                $this.errorMessage = ''
                data =
                    username: $this.username
                    password: $this.password

                $ionicLoading.show()

                promise = Authen.login data.username, data.password
                promise.then(->
                    $ionicLoading.hide()
                , (error) ->
                    $this.errorMessage = error;
                    $ionicLoading.hide()
                , (message) ->
                    $this.errorMessage = message;
                    $ionicLoading.hide()
                )

        scope.step1 =
            isPass: no
            email: ''
            password: ''
            confirmPassword: ''
            errorMessage: ''
            fake: ->
                @email = Chance.email()
                @password = @confirmPassword = md5.createHash(@email).slice 0, 13
                @valid()
            reset: ->
                @email = @password = @confirmPassword = ''
                @valid()
            valid: ->
                pass = yes
                # RFC 5322 http://emailregex.com/
                regExpEmail = new RegExp('^[-a-z0-9~!$%^&*_=+}{\'?]+(\.[-a-z0-9~!$%^&*_=+}{\'?]+)*@([a-z0-9_][-a-z0-9_]*(\.[-a-z0-9_]+)*\.(aero|arpa|biz|com|coop|edu|gov|info|int|mil|museum|name|net|org|pro|travel|mobi|[a-z][a-z])|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,5})?$', 'i')
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
            errorMessage: ''
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
                @errorMessage = ''
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
                $this = @
                $this.errorMessage = ''

                data =
                    email: scope.step1.email
                    user:
                        plainPassword:
                            first: scope.step1.password
                            second: scope.step1.confirmPassword
                    firstName: $this.firstname
                    lastName: $this.lastname
                    birthday: $this.birthday

                $ionicLoading.show()

                users = new Users(data)
                users.$register({}
                , (success) ->
                    promise = Authen.login data.email, data.user.plainPassword.first
                    promise.then(->
                        $ionicLoading.hide()
                    , (error) ->
                        $this.errorMessage = error;
                        $ionicLoading.hide()
                    , (message) ->
                        $this.errorMessage = message;
                        $ionicLoading.hide()
                    )
                , (error) ->
                    if error.data and error.data.message
                        $this.errorMessage = error.data.message
                    else if error.data and error.data.error_description
                        $this.errorMessage = error.data.error_description
                    else
                        $this.errorMessage = error.statusText

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
    logout = ->
        confirmPopup = $ionicPopup.confirm scope.translate.logout
        confirmPopup.then((res) ->
            if res then Authen.logout()
        )

    angular.extend @, {
        login: login
        logout: logout
    }

    $ionicPlatform.onHardwareBackButton(->
        if angular.isFunction scope.back
            scope.back()
    )

    $rootScope.$on 'event:auth-loginRequired', (event, data) ->
        $ionicLoading.hide()
        $ionicHistory.goBack -1

        if scope.modal
            if !Authen.isLoggedin() and !scope.modal.isShown()
                login()
            else if  !Authen.isLoggedin() and scope.modal.isShown()
                $ionicLoading.hide()
        else
            if !Authen.isLoggedin()
                login()

    $rootScope.$on 'event:auth-logout', (event, data) ->
        logout()

    $rootScope.$on 'event:auth-loginConfirmed', (event, data) ->
        scope.modal.hide()

    $translate(
        [
            'common.back'
            'member.login.title'
            'member.register.title1'
            'member.register.title2'
            'member.logout.title'
            'member.logout.detail'
            'member.logout.cancel'
            'member.logout.ok'
        ]
    ).then((translations) ->
        scope.translate.back = translations['common.back']
        states[0].title = translations['member.login.title']
        states[1].title = translations['member.register.title1']
        states[2].title = translations['member.register.title2']
        scope.translate.logout.title = translations['member.logout.title']
        scope.translate.logout.template = translations['member.logout.detail']
        scope.translate.logout.cancelText = translations['member.logout.cancel']
        scope.translate.logout.okText = translations['member.logout.ok']
    )

    return @
