class ProductDetail extends Controller then constructor: (
    $ionicHistory, $ionicLoading, $scope, $stateParams, GoogleAnalytics, Products, Und
) ->
    $scope.back = ->
        $ionicHistory.goBack -1
        return

    productId = $stateParams.id || ''
    products = new Products()

    $scope.product =
        item: {}
        loadData: (args) ->
            $this = @
            pull = if args && args.pull then args.pull else no
            products.$getId(id: productId
            , (success) ->
                $this.item = success
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
            @loadData(pull: yes)

    $scope.product.loadData()
    $ionicLoading.show()
