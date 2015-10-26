class personalDetail extends Controller then constructor: (
    $cordovaGoogleAnalytics, $ionicHistory, $ionicLoading, $ionicPlatform, $scope, $state, $stateParams, Personals, Und
) ->
    $ionicPlatform.ready ->
    $cordovaGoogleAnalytics.trackView $state.current.name

    $scope.back = ->
        $ionicHistory.goBack -1
        return

    personalId = $stateParams.id || ''
    personalStore = new Personals()
    options =
        scope: $scope
        key: 'r'

    $scope.personal =
        item: {}
        loadData: (args) ->
            pull = if !Und.isUndefined(args) and !Und.isUndefined(args.pull) and Und.isBoolean(args.pull) then args.pull else no
            promise = personalStore.find personalId, options
            promise.finally ->
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    $ionicLoading.hide()
            promise.then (model) -> $scope.personal.item = model.dataTranformToDetail()
        refresh: ->
            $scope.personal.loadData(pull: true)

    $scope.personal.loadData()

    $ionicLoading.show()
