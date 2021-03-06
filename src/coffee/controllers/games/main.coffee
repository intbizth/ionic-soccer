class GamesMain extends Controller then constructor: (
    $ionicHistory, $ionicPlatform, $sce, $scope, $timeout, Chance, GoogleAnalytics, Und
) ->
    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'games'

    $scope.isIOS = ionic.Platform.isIOS()
    $scope.back = ->
        $ionicHistory.goBack -1
        return

    $scope.data =
        next: no
        doRefresh: ->
            $scope.matchLabel.doRefresh()
            return
        loadMore: ->
            return

    $scope.cover =
        image: null
        loadData: ->
            img = './img/games/games-banner.png'
            this.image = img
            console.log('cover:loadData', this.image.length, JSON.stringify(this.image), this.next)
            return

    $scope.cover.loadData()

    $scope.matchLabel =
        sections: [],
        next: false
        loadData: ->
            sections = this.fakeSections()
            this.sections = sections
            this.next = Chance.pick([true, false])
            console.log('matchLabel:loadData', this.sections.length, JSON.stringify(this.sections), this.next)
            return
        doRefresh: ->
            console.log 'matchLabel:doRefresh'
            $this = this
            $timeout(->
                console.log 'matchLabel:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return
        loadMore: ->
            console.log 'matchLabel:loadMore'
            $this = this
            $timeout(->
                console.log 'matchLabel:loadMore2'
                sections = $this.fakeSections()
                for section in sections
                    $this.sections.push section
                if $this.sections.length > 0
                    $this.next = Chance.pick([true, false])
                else
                    $this.next = false
                console.log('matchLabel:loadMore', $this.sections.length, JSON.stringify($this.sections), $this.next)
                $scope.$broadcast 'scroll.infiniteScrollComplete'
                return
            , 2000)
            return
        fakeSection: (datetime)->
            section =
                id: Und.random(1, 9999999)
                name: 'Thai Premier League'
                week: Und.random(1,12)
                logo: 'http://demo.balltoro.com/media/image/cms/medias/tpl.jpg'
                datetime: Chance.date(datetime)
                items: this.fakeItems(datetime)
            return section
        fakeSections: ->
            sections = []
            i = 0
            ii = Und.random(0, 10)
            month = new Date().getMonth()
            year = new Date().getFullYear()
            while i < ii
                datetime =
                    year: year
                    month: month
                section = this.fakeSection(datetime)
                sections.push section
                i++
                month++
                if month > 12
                    month = 1
                    year++
            sections = Und.sortBy(sections, 'items.datetime')
            return sections
            return
        fakeItem: (datetime) ->
            club = Chance.club()
#            club = Chance.league()
            clubs = [
                logo: './img/logo/match_label@2x.png'
                name: 'Chonburi FC'
                score: Und.random(0, 99)
            ,
                logo: club.image.src
                name: club.name
                score: Und.random(0, 99)
            ]
            item =
                id: Und.random(1, 9999999)
                homeClub: null
                awayClub: null
                datetime: Chance.date(datetime)
                isLive: Chance.bool({
                    likelihood: 30
                })
                progressData: []
                leftValue: null
                rightValue: null
                template: Chance.pick(['before'])
            if item.isLive == true
                randomValue = Und.random(1, 100)
                leftWon = null
                rightWon = null
                item.leftValue = 100 - randomValue
                item.rightValue = randomValue
                if item.leftValue > item.rightValue
                    leftWon = yes
                    rightWon = no
                else
                    leftWon = no
                    rightWon = yes

                item.progressData = [
                    { value:item.leftValue , color:'#FF3B30', won:leftWon, status:'-left' }
                    { value:item.rightValue , color:'#FAAF40', won:rightWon, status:'-right' }
                ]
            if Chance.pick([true, false])
                item.homeClub = clubs[0]
                item.awayClub = clubs[1]
            else
                item.homeClub = clubs[1]
                item.awayClub = clubs[0]
            return item
        fakeItems: (datetime) ->
            items = []
            i = 0
            ii = Und.random(0, 3)
            while i < ii
                item = this.fakeItem(datetime)
                items.push item
                i++
            items = Und.sortBy(items, 'datetime')
            return items

    $scope.matchLabel.loadData()
