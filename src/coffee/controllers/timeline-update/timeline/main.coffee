class Timeline extends Controller then constructor: (
    $interval, $ionicLoading, $ionicPlatform, $q, $rootScope, $scope, CFG, Chance, GoogleAnalytics, Matches, Media, MicroChats, Moment
) ->
    $scope.isLoggedin = $rootScope.isLoggedin

    pageLimit = 50
    microChats = new MicroChats()
    matches = new Matches()

    $scope.matchLabel =
        items: []
        loaded: no
        loadData: (args) ->
            $this = @
            pull = if args && args.pull then args.pull else no
            flush = if args && args.flush then args.flush else no
            if !pull
                $this.loaded = no
            matches.$getToday(
                page: 1
                limit: 1
                flush: flush
            , (success) ->
                $this.loaded = yes
                $this.items = success.items
            , (error) ->
                return
            )
        refresh: ->
            @loadData(flush: yes, pull: yes)

    $scope.microChats =
        items: []
        next: null
        loaded: no
        loadData: (args) ->
            $this = @
            pull = if args && args.pull then args.pull else no
            flush = if args && args.flush then args.flush else no
            if !pull
                $this.loaded = no
            microChats.$getPage(
                page: 1
                limit: pageLimit
                flush: flush
            , (success) ->
                $this.loaded = yes
                $this.next = if success.next then success.next else null
                angular.forEach success.items, (value, key) ->
                    success.items[key].user.me = ($rootScope.user and $rootScope.user.id and value.user.id == $rootScope.user.id)
                $this.items = success.items
                $this.cacheData = angular.copy $this.items
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    $ionicLoading.hide()
                $this.autoFetchData()
                $scope.matchLabel.loadData()
            , (error) ->
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    $ionicLoading.hide()
            )
        refresh: ->
            @errorMessage = ''
            @loadData(flush: yes, pull: yes)
            $scope.matchLabel.refresh()
        loadNext: ->
            $this = @
            microChats.$getPage(
                page: $this.next
                limit: pageLimit
            , (success) ->
                $this.next = if success.next then success.next else null
                $this.items = $this.items.concat success.items
                $scope.$broadcast 'scroll.infiniteScrollComplete'
            , (error) ->
                $scope.$broadcast 'scroll.infiniteScrollComplete'
            )
        timer: null
        cacheData: null
        autoFetchData: ->
            $this = @
            fetch = ->
                microChats.$getPage(
                    page: 1
                    limit: pageLimit
                    flush: yes
                , (success) ->
                    if success.items.length > 0 and $this.cacheData.length > 0 and !angular.equals success.items, $this.cacheData
                        push = yes
                        items = []
                        angular.forEach success.items, (value, key) ->
                            if angular.equals $this.items[0], value
                                push = no

                            if push
                                items.push value
                        items.reverse()
                        angular.forEach items, (value, key) ->
                            $this.items.unshift value
                            $this.cacheData.unshift value
                , (error) ->
                    return
                )

            $interval.cancel $this.timer
            $this.timer = undefined
            $this.timer = $interval(->
                fetch()
            , 15000)
        isPass: no
        message: ''
        errorMessage: ''
        fake: ->
            @message = Chance.paragraph sentences: Chance.integer min: 1, max: 50
            @valid()
        reset: ->
            @message = ''
            @valid()
            $scope.media.remove()
        valid: ->
            @errorMessage = ''
            pass = yes
            if not @message?.length
                pass = no
            @isPass = pass
        submit: ->
            $this = @
            $this.errorMessage = ''
            data =
                club: CFG.clubId
                message: $this.message
                publishedDate:
                    date: Moment().format('YYYY-MM-DD')
                    time: Moment().format('HH:mm')

            $ionicLoading.show()

            new MicroChats(data).$send({}
            , (success) ->
                if $scope.media.isImage and success.id
                    promise = $this.uploadImage(success.id, $scope.media.imageData)
                    promise.then((success2) ->
                        $this.cleanUI()
                    , (error2) ->
                        if error2.data and error2.data.message
                            $this.errorMessage = error2.data.message
                        else if error.data and error2.data.error_description
                            $this.errorMessage = error2.data.error_description
                        else
                            $this.errorMessage = error2.statusText
                        $ionicLoading.hide()
                    )
                else
                    $this.cleanUI()
            , (error) ->
                if error.data and error.data.message
                    $this.errorMessage = error.data.message
                else if error.data and error.data.error_description
                    $this.errorMessage = error.data.error_description
                else
                    $this.errorMessage = error.statusText
                $ionicLoading.hide()
            )
        uploadImage: (id, imageData) ->
            $this = @
            deferred = $q.defer()

            stream = Media.dataStream imageData

            for data in stream.data
                new MicroChats(data).$uploadImage(
                    id: id
                , (success) ->
                    deferred.resolve success
                , (error) ->
                    deferred.reject error
                )
            return deferred.promise
        cleanUI: ->
            @reset()
            @loadData(flush: yes)
            $scope.media.isImage = no
            $scope.media.imageData = null
            $ionicLoading.hide()

    $scope.media =
        isImage: no
        imageData: null
        openGallery: ->
            $this = @
            promise = Media.get(
                allowEdit: yes
                targetWidth: 800
                targetHeight: 800
            )
            promise.then((success) ->
                $this.isImage = yes
                $this.imageData = success
                return
            , (error) ->
                return
            )
        openCamera: ->
            $this = @
            promise = Media.get(
                camera: yes
                allowEdit: yes
                targetWidth: 800
                targetHeight: 800
            )
            promise.then((success) ->
                $this.isImage = yes
                $this.imageData = success
                return
            , (error) ->
                return
            )
        remove: ->
            @isImage = no
            @imageData = null

    $scope.microChats.loadData()

    $ionicLoading.show()

    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'timeline'

    $rootScope.$on 'event:auth-stateChange', (event, data) ->
        $scope.isLoggedin = data
