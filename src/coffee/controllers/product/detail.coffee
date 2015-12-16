class ProductDetail extends Controller then constructor: (
    $ionicHistory, $ionicLoading, $scope, $stateParams, GoogleAnalytics, Products
) ->
    $scope.back = ->
        $ionicHistory.goBack -1
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
                    $ionicLoading.hide()
            , (error) ->
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    $ionicLoading.hide()
            )
        refresh: ->
            @loadData(flush: yes, pull: yes)

    $scope.product.loadData()
    $ionicLoading.show()
