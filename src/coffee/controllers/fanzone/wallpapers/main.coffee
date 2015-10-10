class FanzoneWallpapers extends Controller then constructor: (
    $scope, $timeout, Und, Chance
) ->
    $scope.wallpapers =
        items: []
        next: no
        loadData: ->
            @items = @fakeItems()
            $scope.next = @next = if @items.length > 0 then Chance.bool() else no
            console.log('wallpapers:loadData', @items.length, JSON.stringify(@items), @next)
            return
        doRefresh: ->
            console.log 'wallpapers:doRefresh'
            $this = @
            $timeout(->
                console.log 'wallpapers:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return
        loadMore: ->
            console.log 'wallpapers:loadMore'
            $this = @
            $timeout(->
                console.log 'wallpapers:loadMore2'
                items = $this.fakeItems()
                for item in items
                    $this.items.push item
                $scope.next = $this.next =  if $this.items.length > 0 then Chance.bool() else no
                console.log('wallpapers:loadMore', $this.items.length, JSON.stringify($this.items), $this.next)
                $scope.$broadcast 'scroll.infiniteScrollComplete'
                return
            , 2000)
            return
        fakeItem: ->
            wallpaper = Chance.wallpaper()
            item =
                id: Und.random(1, 9999999)
                image: wallpaper.image.src
                datetime: Chance.date()
            return item
        fakeItems: ->
            items = []
            i = 0
            ii = Und.random(0, 20)
            while i < ii
                items.push @fakeItem()
                i++
            items = Und.sortBy(items, 'datetime')
            return items

    $scope.wallpapers.loadData()

    $scope.next = no
    $scope.refresh = ->
        $scope.wallpapers.refresh()
        return
    $scope.loadMore = ->
        $scope.wallpapers.loadMore()
        return
