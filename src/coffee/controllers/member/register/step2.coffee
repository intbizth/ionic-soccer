class memberRegisterStep2 extends Controller then constructor: (
    $cordovaCamera, $document, $scope, $ionicHistory, $ionicPlatform, $timeout, Chance, Moment, Users
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

    $scope.photo =
        isPhoto: no
        fileUri: null
        base64: null
        element: angular.element $document[0].querySelector '.photo img.user'
        getPicture: (args) ->
            $this = @
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
            @element.attr 'src', './img/member/profile.png'
            @element.attr 'srcset', './img/member/profile@2x.png 2x'
            return

    $scope.data =
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
                firstname: @firstname
                lastname: @lastname
                birthday: @birthday

            console.warn 'step2:submit', data

#            data:
#                firstname: @firstname
#                lastname: @lastname
#                email: 'email'

            users = new Users()

            users.$register({}
            , (success) ->
                console.warn '$register:success', success
            , (error) ->
                console.warn '$register:error', error
            )
            return data

    $scope.data.valid()
