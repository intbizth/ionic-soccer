class CompetitionTablePositionTable extends Controller then constructor: (
    $scope, $ionicHistory, $timeout, Und, Chance
) ->
    $scope.position =
        items: [],
        position: 1
        team: 'Chonburi FC'
        hasTeam: false
        next: false
        loadData: ->
            this.position = 1
            this.hasTeam = false
            items = this.fakeItems()
            this.items = items
            this.next = Chance.pick([true, false])
            console.log('position:loadData', this.items.length, JSON.stringify(this.items), this.next)
            return
        doRefresh: ->
            console.log 'position:doRefresh'
            $this = this
            $timeout(->
                console.log 'position:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return
        loadMore: ->
            console.log 'position:loadMore'
            $this = this
            $timeout(->
                console.log 'position:loadMore2'
                items = $this.fakeItems()
                for item in items
                    $this.items.push item
                if $this.items.length > 0
                    $this.next = Chance.pick([true, false])
                else
                    $this.next = false
                console.log('position:loadMore', $this.items.length, JSON.stringify($this.items), $this.next)
                $scope.$broadcast 'scroll.infiniteScrollComplete'
                return
            , 2000)
            return
        fakeItem: (config) ->
            item =
                id: Und.random(1, 9999999)
                template: 'normal'
                position: this.position++
                name: Chance.name()
                play: Und.random(1, 9999)
                goalDifference: Und.random(1, 9999)
                points: Und.random(1, 9999)
            if typeof config isnt 'undefined' and config.team
                item.name = this.team
                item.template = 'highlight'
            return item
        fakeItems: ->
            checkTeam = Chance.pick([true, false])
            items = []
            i = 0
            ii = Und.random(0, 30)
            while i < ii
                if checkTeam and !this.hasTeam
                    this.hasTeam = true
                    item = this.fakeItem({team: true})
                else
                    item = this.fakeItem()
                items.push item
                i++
            items = Und.sortBy(items, 'position')
            return items

    $scope.position.loadData()
