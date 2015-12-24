class FanzoneProducts extends Controller then constructor: (
   $ionicPlatform, $rootScope, $scope, GoogleAnalytics, LoadingOverlay, Products
) ->
    pageLimit = 20
    products = new Products()

    $scope.products =
        items: []
        next: null
        loaded: no
        loadData: (args) ->
            $this = @
            pull = if args && args.pull then args.pull else no
            flush = if args && args.flush then args.flush else no
            if !pull
                $this.loaded = no
            products.$getPage(
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
                    LoadingOverlay.hide 'fanzone-products'
            , (error) ->
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    LoadingOverlay.hide 'fanzone-products'
            )
        refresh: ->
            if @loaded
                @loadData(flush: yes, pull: yes)
            else
                $scope.$broadcast 'scroll.refreshComplete'
        loadNext: ->
            $this = @
            products.$getPage(
                page: $this.next
                limit: pageLimit
            , (success) ->
                $this.next = if success.next then success.next else null
                $this.items = $this.items.concat success.items
                $scope.$broadcast 'scroll.infiniteScrollComplete'
            , (error) ->
                $scope.$broadcast 'scroll.infiniteScrollComplete'
            )

    $scope.products.loadData()
    LoadingOverlay.show 'fanzone-products'

    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'products'
