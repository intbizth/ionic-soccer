class aboutClubTeam extends Controller then constructor: (
    $scope, $timeout, Und, Chance
) ->
    $scope.headline = 'CHALARMCHON'
    $scope.players =
        items: []
        next: no
        loadData: ->
            @items = @fakeItems()
            @next = if @items.length > 0 then Chance.bool() else no
            console.log('players:loadData', @items.length, JSON.stringify(@items), @next)
            return
        doRefresh: ->
            console.log 'players:doRefresh'
            $this = @
            $timeout(->
                console.log 'players:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return
        loadMore: ->
            console.log 'players:loadMore'
            $this = @
            $timeout(->
                console.log 'players:loadMore2'
                items = $this.fakeItems()
                for item in items
                    $this.items.push item
                if $this.items.length > 0
                    $this.next = Chance.bool()
                else
                    $this.next = no
                console.log('players:loadMore', $this.items.length, JSON.stringify($this.items), $this.next)
                $scope.$broadcast 'scroll.infiniteScrollComplete'
                return
            , 2000)
            return
        fakeItem: ->
            player = Chance.player()
            item =
                position: Chance.pick(['D', 'F', 'G', 'M'])
                photo: player.image.src
                name: Chance.name()
                number: Und.random(1, 31)
            return item
        fakeItems: ->
            items = []
            i = 0
            ii = Und.random(0, 30)
            while i < ii
                items.push @fakeItem()
                i++
            return items

    $scope.players.loadData()
