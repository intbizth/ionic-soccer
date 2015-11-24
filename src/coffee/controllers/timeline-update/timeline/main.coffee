class Timeline extends Controller then constructor: (
    $cordovaSocialSharing, $ionicLoading, $ionicPlatform, $rootScope, $scope, CFG, Chance, GoogleAnalytics, MicroChats, Moment
) ->
    $scope.isLoggedin = $rootScope.isLoggedin

    $scope.share = (message, subject, file, link) ->
        message = message || ''
        subject = subject || ''
        file = file || ''
        link = link || ''
        $cordovaSocialSharing.share(message, subject, file, link).then (result) ->
            return
        , (error) ->
            return

    pageLimit = 20
    microChats = new MicroChats()

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
                $this.items = success.items
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    $ionicLoading.hide()
            , (error) ->
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    $ionicLoading.hide()
            )
        refresh: ->
            @errorMessage = ''
            @loadData(flush: yes, pull: yes)
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
        isPass: no
        message: ''
        errorMessage: ''
        fake: ->
            @message = Chance.paragraph sentences: Chance.integer min: 1, max: 20
            @valid()
        reset: ->
            @message = ''
            @valid()
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
                user: $rootScope.user.id
                club: CFG.clubId
                message: $this.message
                publishedDate:
                    date: Moment().format('YYYY-MM-DD')
                    time: Moment().format('HH:mm')

            console.warn 'data', data

            $ionicLoading.show()

            new MicroChats(data).$send({}
            , (success) ->
                $this.reset()
                $this.loadData(flush: yes)
                $ionicLoading.hide()
            , (error) ->
                if error.data and error.data.message
                    $this.errorMessage = error.data.message
                else if error.data and error.data.error_description
                    $this.errorMessage = error.data.error_description
                else
                    $this.errorMessage = error.statusText
                $ionicLoading.hide()
            )

    $scope.microChats.loadData()
    $ionicLoading.show()

    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'timeline'

    $rootScope.$on 'event:auth-stateChange', (event, data) ->
        $scope.isLoggedin = data
