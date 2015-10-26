class FanzoneProducts extends Controller then constructor: (
   $cordovaGoogleAnalytics, $ionicLoading, $ionicPlatform, $rootScope, $scope, Products, Und
) ->
    $ionicPlatform.ready ->
        $cordovaGoogleAnalytics.trackView 'products'

    productStore = new Products null,
        url: Products::url + 'club/' + $rootScope.clubId
        state: pageSize: 20

    options =
        scope: $scope
        productStoreKey: 'productStore'
        collectionKey: 'productCollection'

    $scope.products =
        items: []
        hasMorePage: no
        loadData: ->
            promise = productStore.load options
            promise.finally -> $ionicLoading.hide()
            promise.then ->
                $scope.products.items = Und.map productStore.getCollection(), (item) ->
                    return item.dataTranformToFanzone()
                $scope.products.hasMorePage = productStore.hasMorePage()
        refresh: ->
            options.fetch = yes
            # TODO getFirstPage
            promise = productStore.getFirstPage options
            promise.finally -> $scope.$broadcast 'scroll.refreshComplete'
            promise.then ->
                $scope.products.items = Und.map productStore.getCollection(), (item) ->
                    return item.dataTranformToFanzone()
                $scope.products.hasMorePage = productStore.hasMorePage()
        loadNext: ->
            productStore.prepend = yes
            promise = productStore.getNextPage options
            promise.finally -> $scope.$broadcast 'scroll.infiniteScrollComplete'
            promise.then ->
                items = productStore.getCollection().slice 0, productStore.state.pageSize
                items = Und.map items, (item) ->
                    return item.dataTranformToFanzone()
                $scope.products.items = $scope.products.items.concat items
                $scope.products.hasMorePage = productStore.hasMorePage()

    $scope.products.loadData()

    $ionicLoading.show()
