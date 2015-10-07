class personalDetail extends Controller then constructor: (
    $scope, $stateParams, $ionicHistory, $ionicLoading, Personals, Und
) ->
    $scope.back = ->
        $ionicHistory.goBack -1
        return

    personalId = $stateParams.id ||

    promise = null

    options =
        scope: $scope
        key: 'r'

    $scope.personal =
        item: {}
        loadData: ->
            promise = new Personals().find personalId, options
            promise.finally -> $ionicLoading.hide()
            promise.then (model) -> $scope.personal.item = model.dataTranformToDetail()
        refresh: ->
            promise = new Personals().find personalId, options
            promise.finally -> $scope.$broadcast 'scroll.refreshComplete'
            promise.then (model) -> $scope.personal.item = model.dataTranformToDetail()

    $scope.personal.loadData()

    $ionicLoading.show()
