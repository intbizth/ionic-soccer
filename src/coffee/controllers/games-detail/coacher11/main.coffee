class GamesDetailCoacher11 extends Controller then constructor: (
    $ionicLoading, $scope, $timeout, Personals, Und, Chance
) ->
    $scope.timeRemain = Und.random(0, 90)

    $scope.data =
        next: no
        doRefresh: ->
            $scope.matchLabel.doRefresh()
            return
        loadMore: ->
            return

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
            , 1000)
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
            , 1000)
            return
        fakeSection: (datetime)->
            section =
                id: Und.random(1, 9999999)
                name: 'Thai Premier League'
                logo: 'http://demo.balltoro.com/media/image/cms/medias/tpl.jpg'
                datetime: Chance.date(datetime)
                items: this.fakeItems(datetime)
            return section
        fakeSections: ->
            sections = []
            i = 0
            ii = 1
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
                endMatch: false
                progressData: []
                leftValue: null
                rightValue: null
                handicap: chance.floating({min: -3, max: 3, fixed: 2})
                template: Chance.pick(['before'])
            if item.isLive == true || item.isLive == false
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
            if item.isLive == false
                item.endMatch = Chance.bool({
                    likelihood: 30
                })
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
            ii = Und.random(1, 1)
            while i < ii
                item = this.fakeItem(datetime)
                items.push item
                i++
            items = Und.sortBy(items, 'datetime')
            return items

    $scope.matchLabel.loadData()

    pageLimit = 100
    personals = new Personals()

    $scope.personals =
        getPositionClass: (shortName)->
            switch shortName
                when 'GK' then '-goalkeeper'
                when 'DF' then '-defender'
                when 'MF' then '-midfielder'
                when 'FW' then '-forwarder'
                else ''
        items: []
        next: null
        loadData: (args) ->
            $this = @
            pull = if args && args.pull then args.pull else no
            personals.$getClubMe(
                page: 1
                limit: pageLimit
            , (success) ->
                $this.next = if success.next then success.next else null
                $this.items = success.items
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    $ionicLoading.hide()
            , (error) ->
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    $ionicLoading.hide()
            )
        refresh: ->
            @loadData(pull: yes)
        loadNext: ->
            $this = @
            papers.$getPage(
                page: $this.next
                limit: pageLimit
            , (success) ->
                $this.next = if success.next then success.next else null
                $this.items = $this.items.concat success.items
                $scope.$broadcast 'scroll.infiniteScrollComplete'
            , (error) ->
                $scope.$broadcast 'scroll.infiniteScrollComplete'
            )

    $scope.personals.loadData()

    $scope.switch = (index) ->
        i = 0
        while i < $scope.personals.length
            i++
        $scope.personals[index] = if $scope.personals[index] != true then true else false
        console.log(index)
        return

    $ionicLoading.show()
