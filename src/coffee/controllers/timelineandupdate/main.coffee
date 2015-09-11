class timelineAndUpdateMain extends Controller then constructor: (
    $scope, $ionicHistory, $timeout, Und, Chance
) ->
    $scope.back = ->
        $ionicHistory.goBack -1
        return

    $scope.timeline =
        isLive : false
        items : []
        next : false
        loadData : ->
            $scope.timeline.isLive = Chance.pick([true, false])
            $scope.timeline.items = $scope.timeline.fakeItems();

            console.log JSON.stringify($scope.timeline.items)

            if $scope.timeline.items.length > 0
                $scope.timeline.next = Chance.pick([true, false])
            else
                $scope.timeline.next = false
            return

        doRefresh : ->
            console.log 'doRefresh'

            $timeout(->
                console.log 'doRefresh2'
                $scope.timeline.loadData()

                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return

        loadMore : ->
            console.log 'loadMore'

            $timeout(->
                console.log 'loadMore2'
#                items = $scope.timeline.fakeItems()
#                $scope.timeline.items.concat(items)
#
#                console.log JSON.stringify($scope.timeline.items)

#                if $scope.timeline.items.length > 0
#                    $scope.timeline.next = Chance.pick([true, false])
#                else
#                    $scope.timeline.next = false

                $scope.$broadcast 'scroll.infiniteScrollComplete'
                return
            , 2000)
            return

        fakeItem : ->
            item =
                template: Chance.pick(['default', 'hightlight'])
                datetime: Chance.date()
                images : []
                description: Chance.paragraph(
                    sentences: Und.random(1, 20)
                )
                user:
                    name: Chance.name()
                    photo: 'https://placeimg.com/46/46/people?time=' + Chance.timestamp()

            i = 0
            ii = Und.random(0, 4)
            while i < ii
                item.images.push 'https://placeimg.com/640/640/any?time=' + Chance.timestamp()
                i++

            return item

        fakeItems : ->
            items = []

            i = 0
            ii = Und.random(0, 10)
            while i < ii
                items.push $scope.timeline.fakeItem()
                i++

            return items

    $scope.timeline.loadData()
