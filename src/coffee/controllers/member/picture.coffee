class MemberPictureMain extends Controller then constructor: (
    $ionicHistory, $ionicLoading, $q, $rootScope, $scope, Media, md5, Users
) ->
    $scope.back = ->
        $ionicHistory.goBack -1
        return

    $scope.errorMessage = ''
    $scope.loadData = ->
        $scope.profile.setDefault()
        if $rootScope.user.profilePicture
            $scope.profile.item.picture = $rootScope.user.profilePicture
            $scope.media.state = 'load'
            $scope.media.isPicture = yes

    $scope.profile =
        item: {}
        itemDefault:
            picture: './img/member/picture@2x.png'
        setDefault: ->
            @item = angular.copy @itemDefault
        uploadPicture: (imageData) ->
            $this = @
            deferred = $q.defer()

            stream = Media.dataStream imageData

            for data in stream.data
                new Users(data).$uploadPicture({}
                , (success) ->
                    if success.url
                        deferred.resolve success
                , (error) ->
                    deferred.reject error
                )
            return deferred.promise
        removePicture: ->
            $ionicLoading.show()
            users = new Users()
            users.$removePicture({})

    $scope.media =
        state: 'blank'
        isPicture: no
        openGallery: ->
            $this = @
            $scope.errorMessage = ''
            promise = Media.get(
                allowEdit: yes
                targetWidth: 400
                targetHeight: 400
            )
            promise.then((success) ->
                $this.state = 'new'
                $this.isPicture = yes
                $scope.profile.item.picture = success

                $ionicLoading.show()

                promise2 = $scope.profile.uploadPicture success

                promise2.then((success2) ->
                    $ionicLoading.hide()
                    $rootScope.$emit 'profile:pictureChange', success2.url
                    $scope.back()
                , (error2) ->
                    $ionicLoading.hide()
                    $scope.errorMessage = error2.statusText
                )
            , (error) ->
                return
            )
        openCamera: ->
            $this = @
            $scope.errorMessage = ''
            promise = Media.get(
                camera: yes
                allowEdit: yes
                targetWidth: 400
                targetHeight: 400
            )
            promise.then((success) ->
                $this.state = 'new'
                $this.isPicture = yes
                $scope.profile.item.picture = success

                $ionicLoading.show()

                promise2 = $scope.profile.uploadPicture success

                promise2.then((success2) ->
                    $ionicLoading.hide()
                    $rootScope.$emit 'profile:pictureChange', success2.url
                    $scope.back()
                , (error2) ->
                    $ionicLoading.hide()
                    $scope.errorMessage = error2.statusText
                )
            , (error) ->
                return
            )
        remove: ->
            $this = @
            $scope.errorMessage = ''
            promise = $scope.profile.removePicture()
            promise.then((success) ->
                $this.state = 'blank'
                $this.isPicture = no
                $ionicLoading.hide()
                $rootScope.$emit 'profile:pictureChange', null
                $scope.back()
            , (error) ->
                $ionicLoading.hide()
                $scope.errorMessage = error.statusText
            )

    $scope.loadData()
