class timelineAndUpdateMain extends Controller then constructor: (
    $scope, $ionicHistory, $timeout, Und, Chance
) ->
    $scope.back = ->
        $ionicHistory.goBack -1
        return

    $scope.tab = {
        name : 'timeline'
        selected : (tabName) ->
            console.log(tabName)
            this.name = tabName
            return
    }

    $scope.timeline =
        isLive : false
        items : []
        next : false
        loadData : ->
            this.isLive = Chance.pick([true, false])
            this.items = this.fakeItems();

            if this.items.length > 0
                this.next = Chance.pick([true, false])
            else
                this.next = false

            console.log('loadData', this.items.length, this.next)

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

            $this = this

            $timeout(->
                console.log 'loadMore2'
                items = $this.fakeItems()

                for item in items
                    $this.items.push item

                if $this.items.length > 0
                    $this.next = Chance.pick([true, false])
                else
                    $this.next = false

                console.log('loadMore', $this.items.length, $this.next)

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
