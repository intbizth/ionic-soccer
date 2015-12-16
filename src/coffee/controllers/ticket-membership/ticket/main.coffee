class Ticket extends Controller then constructor: (
    $ionicLoading, $ionicPlatform, $scope, CFG, ClubTickets, GoogleAnalytics, Matches, TicketMatches
) ->
    clubtickets = new ClubTickets()
    matches = new Matches()
    ticketmatches = new TicketMatches()

    $scope.matchLabel =
        items: []
        loaded: no
        loadData: (args) ->
            $this = @
            pull = if args && args.pull then args.pull else no
            flush = if args && args.flush then args.flush else no
            if !pull
                $this.loaded = no
            matches.$getFixture(
                page: 1
                limit: 1
                flush: flush
            , (success) ->
                $this.loaded = yes
                if success.items.length > 0 and success.items[0].homeClub.id == CFG.clubId
                    $this.items = success.items
                    $scope.clubTickets.loadData(flush: flush, pull: pull)
                else
                    clearUI pull
            , (error) ->
                clearUI pull
            )
        refresh: ->
            @loadData(flush: yes, pull: yes)

    $scope.clubTickets =
        items: []
        loaded: no
        loadData: (args) ->
            $this = @
            pull = if args && args.pull then args.pull else no
            flush = if args && args.flush then args.flush else no
            if !pull
                $this.loaded = no
            clubtickets.$getPage(
                page: 1
                limit: 1
                flush: flush
            , (success) ->
                if success.items.length > 0
                    $this.loaded = yes
                    $this.items = success.items
                    $scope.ticketMatches.id = success.items[0].id
                    $scope.ticketMatches.loadData(flush: flush, pull: pull)
                else
                    clearUI pull
            , (error) ->
                clearUI pull
            )
        refresh: ->
            @loadData(flush: yes, pull: yes)
            $scope.matchLabel.refresh()
            $scope.ticketMatches.refresh()
        getTicketZoneClass: (code) ->
            return 'ticketzone-' + code.toLowerCase()

    $scope.ticketMatches =
        id: null
        items: []
        loaded: no
        loadData: (args) ->
            $this = @
            pull = if args && args.pull then args.pull else no
            flush = if args && args.flush then args.flush else no
            if !pull
                $this.loaded = no
            ticketmatches.$getMatch(
                id: $this.id
                flush: flush
            , (success) ->
                if success.items.length > 0
                    $this.loaded = yes
                    $this.items = success.items
                clearUI pull
            , (error) ->
                clearUI pull
            )
        refresh: ->
            @loadData(flush: yes, pull: yes)
        getTicketMatchesClass: (code) ->
            return 'ticketmatches-' + code.toLowerCase()

    clearUI = (pull) ->
        if pull
            $scope.$broadcast 'scroll.refreshComplete'
        else
            $ionicLoading.hide()

    $scope.matchLabel.loadData()
    $ionicLoading.show()

    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'ticket'
