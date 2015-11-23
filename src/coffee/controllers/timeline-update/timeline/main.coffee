class Timeline extends Controller then constructor: (
    $cordovaSocialSharing, $ionicLoading, $ionicPlatform, $rootScope, $scope, Chance, GoogleAnalytics, MicroChats
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
        loadData: (args) ->
            $this = @
            pull = if args && args.pull then args.pull else no
            flush = if args && args.flush then args.flush else no
            microChats.$getPage(
                page: 1
                limit: pageLimit
                flush: flush
            , (success) ->
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
            @message = Chance.paragraph()
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
            data = {}

            $ionicLoading.show()
            $ionicLoading.hide()

    $scope.microChats.loadData()
    $ionicLoading.show()

    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'timeline'

    $rootScope.$on 'event:auth-stateChange', (event, data) ->
        $scope.isLoggedin = data
