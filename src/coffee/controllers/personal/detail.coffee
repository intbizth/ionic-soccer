class personalDetail extends Controller then constructor: (
    $ionicHistory, $ionicLoading, $scope, $stateParams, GoogleAnalytics, Personals, Und
) ->

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
            promise.then (model) ->
                $scope.personal.item = model.dataTranformToDetail()
                GoogleAnalytics.trackView 'personal-detail ' + $scope.personal.item.fullname

        refresh: ->
            $scope.personal.loadData(pull: true)

    $scope.personal.loadData()

    $ionicLoading.show()
