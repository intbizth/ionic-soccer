class Update extends Controller then constructor: (
    $ionicLoading, $ionicPlatform, $rootScope, $scope, GoogleAnalytics, Papers, Und
) ->
    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'update'

    pageLimit = 10
    papers = new Papers()

    $scope.papers =
        items: []
        next: null
        loadData: (args) ->
            pull = if args && args.pull then args.pull else no
            papers.getPage(
                page: 1
                limit: pageLimit
            , (success) ->
                $scope.papers.next = if success.next then success.next else null
                $scope.papers.items = Und.map success.items, (item) ->
                    return papers.dataTranformToLists(item)
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
            $scope.papers.loadData(pull: yes)
        loadNext: ->
            papers.getPage(
                page: $scope.papers.next
                limit: pageLimit
            , (success) ->
                $scope.papers.next = if success.next then success.next else null
                $scope.papers.items = $scope.papers.items.concat(Und.map success.items, (item) ->
                    return papers.dataTranformToLists(item)
                )
                $scope.$broadcast 'scroll.infiniteScrollComplete'
            , (error) ->
                $scope.$broadcast 'scroll.infiniteScrollComplete'
            )

    $scope.papers.loadData()
    $ionicLoading.show()
