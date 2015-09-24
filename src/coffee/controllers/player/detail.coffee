class playerDetail extends Controller then constructor: (
    $scope, $ionicHistory, $timeout, Und, Chance
) ->
    $scope.back = ->
        $ionicHistory.goBack -1
        return

    $scope.player =
        items: {},
        loadData: ->
            item = this.fakeItem()
            this.item =  item
            console.log('player:loadData', JSON.stringify(this.item))
            return
        doRefresh: ->
            console.log 'player:doRefresh'
            $this = this
            $timeout(->
                console.log 'player:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 1000)
            return
        fakeItem: ->
            item =
                fname: Chance.first()
                lname: Chance.last()
                number: Und.random(1, 30)
                score:
                    yellow: Und.random(1, 999)
                    red: Und.random(1, 999)
                    goal: Und.random(1, 999)
                born:
                    birthdate: chance.birthday()
                    age: Chance.age()
                    province: Chance.province({full: true})
                    country: Chance.country({ full: true })
                position: Chance.pick(['Goalkeeper', 'Forword', 'Defender', 'Midfield'])
                previous:
                    name: Chance.word({length: 10})
                    year: Chance.year({min: 1900, max: 2015})
                signed: Chance.year({min: 1900, max: 2015})
                bio:Chance.paragraph({sentences: 2})
            return item

    $scope.player.loadData()

