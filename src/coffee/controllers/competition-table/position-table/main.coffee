class CompetitionTablePositionTable extends Controller then constructor: (
    $scope, $ionicHistory, $timeout, Und, Chance
) ->
    $scope.position =
        items: []
        position: 1
        team: 'Chonburi FC'
        hasTeam: no
        next: no
        loadData: ->
            @position = 1
            @hasTeam = no
            @items = @fakeItems()
            @next = Chance.bool()
            console.log('position:loadData', @items.length, JSON.stringify(@items), @next)
            return
        doRefresh: ->
            console.log 'position:doRefresh'
            $this = @
            $timeout(->
                console.log 'position:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return
        loadMore: ->
            console.log 'position:loadMore'
            $this = @
            $timeout(->
                console.log 'position:loadMore2'
                items = $this.fakeItems()
                for item in items
                    $this.items.push item
                $this.next = if $this.items.length > 0 then Chance.bool() else no
                console.log('position:loadMore', $this.items.length, JSON.stringify($this.items), $this.next)
                $scope.$broadcast 'scroll.infiniteScrollComplete'
                return
            , 2000)
            return
        fakeItem: (config) ->
            item =
                id: Und.random(1, 9999999)
                template: 'normal'
                position: @position++
                name: Chance.name()
                play: Und.random(1, 9999)
                goalDifference: Und.random(1, 9999)
                points: Und.random(1, 9999)
            if typeof config isnt 'undefined' and config.team
                item.name = @team
                item.template = 'highlight'
            return item
        fakeItems: ->
            checkTeam = Chance.bool()
            items = []
            i = 0
            ii = Und.random(0, 30)
            while i < ii
                if checkTeam and !@hasTeam
                    @hasTeam = yes
                    item = @fakeItem(team: yes)
                else
                    item = @fakeItem()
                items.push item
                i++
            items = Und.sortBy(items, 'position')
            return items

    $scope.position.loadData()
