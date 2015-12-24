class ProductDetail extends Controller then constructor: (
    $ionicHistory, $scope, $stateParams, $timeout, GoogleAnalytics, LoadingOverlay, Products
) ->
    $scope.back = ->
        # TODO request abort
        $ionicHistory.goBack -1
        $timeout(->
            LoadingOverlay.hide 'product-detail'
        , 200)
        return

    $scope.title = ''

    productId = $stateParams.id || ''
    products = new Products()

    $scope.product =
        item: {}
        loaded: no
        loadData: (args) ->
            $this = @
            pull = if args && args.pull then args.pull else no
            flush = if args && args.flush then args.flush else no
            if !pull
                $this.loaded = no
            products.$getId(
                id: productId
                flush: flush
            , (success) ->
                $this.loaded = yes
                $this.item = success
                $scope.title = $this.item.name
                GoogleAnalytics.trackView 'product-detail ' + $this.item.name
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    LoadingOverlay.hide 'product-detail'
            , (error) ->
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    LoadingOverlay.hide 'product-detail'
            )
        refresh: ->
            if @loaded
                @loadData(flush: yes, pull: yes)
            else
                $scope.$broadcast 'scroll.refreshComplete'

    $scope.product.loadData()
    LoadingOverlay.show 'product-detail'
