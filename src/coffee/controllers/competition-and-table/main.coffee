class CompetitionAndTableMain extends Controller then constructor: (
    $scope, $ionicHistory, $timeout, Und, Chance
) ->
    $scope.back = ->
        $ionicHistory.goBack -1
        return

    $scope.fixtures =
        items : []
        next : false
        loadData : ->
            this.items = this.fakeItems()
            if this.items.length > 0
                this.next = Chance.pick([true, false])
            else
                this.next = false
            console.log('fixtures:loadData', this.items.length, JSON.stringify(this.items), this.next)
            return
        doRefresh : ->
            console.log 'fixtures:doRefresh'
            $this = this
            $timeout(->
                console.log 'fixtures:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return
        loadMore : ->
            console.log 'fixtures:loadMore'
            $this = this
            $timeout(->
                console.log 'fixtures:loadMore2'
                items = $this.fakeItems()
                for item in items
                    $this.items.push item
                if $this.items.length > 0
                    $this.next = Chance.pick([true, false])
                else
                    $this.next = false
                console.log('fixtures:loadMore', $this.items.length, JSON.stringify($this.items), $this.next)
                $scope.$broadcast 'scroll.infiniteScrollComplete'
                return
            , 2000)
            return
        fakeItem : ->
            item =
                id : Chance.integer(
                    min : 1
                    max : 9999999
                )
                template: Chance.pick(['default', 'hightlight'])
                datetime: Chance.date()
                images : []
                description: Chance.paragraph(
                    sentences: Und.random(1, 20)
                )
                user:
                    name: Chance.name()
                    photo: 'https://placeimg.com/46/46/people?time=' + Chance.hash()

            i = 0
            ii = Und.random(0, 4)
            while i < ii
                item.images.push 'https://placeimg.com/640/640/any?time=' + Chance.hash()
                i++
            return item
        fakeItems : ->
            items = []
            i = 0
            ii = Und.random(0, 10)
            while i < ii
                items.push this.fakeItem()
                i++
            return items

    $scope.fixtures.loadData()

    $scope.matchLabel = [
            homeClub:
                logo: './img/live/chonburi.png'
                name: 'Chonburi FC'
                score: 1
            awayClub:
                logo: './img/live/suphanburi.png'
                name: 'Suphanburi FC'
                score: 1
            datetime: Chance.date()
            isEndMatch: 0
        ,
            homeClub:
                logo: './img/live/chonburi.png'
                name: 'Chonburi FC'
                score: 1
            awayClub:
                logo: './img/live/suphanburi.png'
                name: 'Suphanburi FC'
                score: 1
            datetime: Chance.date()
            isEndMatch: 1
        ,
            homeClub:
                logo: './img/live/chonburi.png'
                name: 'Chonburi FC'
                score: 1
            awayClub:
                logo: './img/live/suphanburi.png'
                name: 'Suphanburi FC'
                score: 1
            datetime: Chance.date()
            isEndMatch: 1
        ,
            homeClub:
                logo: './img/live/chonburi.png'
                name: 'Chonburi FC'
                score: 1
            awayClub:
                logo: './img/live/suphanburi.png'
                name: 'Suphanburi FC'
                score: 1
            datetime: Chance.date()
            isEndMatch: 1
    ]
