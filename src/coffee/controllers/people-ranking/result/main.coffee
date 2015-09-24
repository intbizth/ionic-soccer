class peopleRankingResult extends Controller then constructor: (
    $scope, $state, $ionicHistory, $timeout, Und, Chance
) ->
    $scope.result =
        items: []
        next: false
        loadData: ->
            this.items = this.fakeItems()
            if this.items.length > 0
                this.next = Chance.pick([true, false])
            else
                this.next = false
            console.log('result:loadData', this.items.length, JSON.stringify(this.items), this.next)
            return
        doRefresh: ->
            console.log 'result:doRefresh'
            $this = this
            $timeout(->
                console.log 'result:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return
        loadMore: ->
            console.log 'result:loadMore'
            $this = this
            $timeout(->
                console.log 'result:loadMore2'
                items = $this.fakeItems()
                for item in items
                    $this.items.push item
                if $this.items.length > 0
                    $this.next = Chance.pick([true, false])
                else
                    $this.next = false
                console.log('result:loadMore', $this.items.length, JSON.stringify($this.items), $this.next)
                $scope.$broadcast 'scroll.infiniteScrollComplete'
                return
            , 2000)
            return
        fakeItem: ->
            profile = Chance.profile()
            item =
                id: Und.random(1, 9999999)
                name: profile.name
                photo: profile.image.src
                hit: Und.random(1, 9999999)
                point: Und.random(1, 9999999)
            return item
        fakeItems: ->
            items = []
            i = 0
            ii = Und.random(0, 20)
            while i < ii
                items.push this.fakeItem()
                i++
            items = Und.sortBy(items, 'point').reverse()
            return items

    $scope.result.loadData()
