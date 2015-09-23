class aboutClubTeam extends Controller then constructor: (
    $scope, $timeout, Und, Chance
) ->
    $scope.headline = 'CHALARMCHON'
    $scope.players =
        items: []
        next: false
        loadData: ->
            items = this.fakeItems()
            this.items =  items
            if this.items.length > 0
                this.next = Chance.pick([true, false])
            else
                this.next = false
            console.log('players:loadData', this.items.length, JSON.stringify(this.items), this.next)
            return
        doRefresh: ->
            console.log 'players:doRefresh'
            $this = this
            $timeout(->
                console.log 'players:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return
        loadMore: ->
            console.log 'players:loadMore'
            $this = this
            $timeout(->
                console.log 'players:loadMore2'
                items = $this.fakeItems()
                for item in items
                    $this.items.push item
                if $this.items.length > 0
                    $this.next = Chance.pick([true, false])
                else
                    $this.next = false
                console.log('players:loadMore', $this.items.length, JSON.stringify($this.items), $this.next)
                $scope.$broadcast 'scroll.infiniteScrollComplete'
                return
            , 2000)
            return
        fakeItem: ->
            item =
                position: Chance.pick(['D', 'F', 'G', 'M'])
                photo: 'https://placeimg.com/46/46/people?time=' + Chance.hash()
                name: Chance.name()
                number: Und.random(1, 31)
            return item
        fakeItems: ->
            items = []
            i = 0
            ii = Und.random(0, 30)
            while i < ii
                items.push this.fakeItem()
                i++
            return items

    $scope.players.loadData()
