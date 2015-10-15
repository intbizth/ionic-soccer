class ProductDetail extends Controller then constructor: (
    $scope, $stateParams, $ionicHistory, $ionicLoading, Products, Und
) ->
    $scope.back = ->
        $ionicHistory.goBack -1
        return

    productId = $stateParams.id || ''
    productStore = new Products()
    options =
        scope: $scope
        key: 'r'

    $scope.product =
        item: {}
        loadData: (args) ->
            pull = if !Und.isUndefined(args) and !Und.isUndefined(args.pull) and Und.isBoolean(args.pull) then args.pull else no
            promise = productStore.find productId, options
            promise.finally ->
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    $ionicLoading.hide()
            promise.then (model) -> $scope.product.item = model.dataTranformToDetail()
        refresh: ->
            $scope.product.loadData(pull: yes)

    $scope.product.loadData()

    $ionicLoading.show()
