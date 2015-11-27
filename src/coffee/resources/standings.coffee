class Standings extends Factory then constructor: (
    $cacheFactory, $resource, CFG, Clubs, Helper
) ->
    timeout = 60000
    cache = $cacheFactory 'resourceStandingsCache'

    url = CFG.API.getPath('standings/')
    paramDefaults = {}
    actions =
        getPositionTable:
            url: CFG.API.getPath('standings/fixtures/:competitionCode')
            method: 'GET'
            params:
                page: 1
                limit: 50
                id: '@competitionCode'
            responseType: 'json'
            cache: cache
            transformResponse: (data, headersGetter) ->
                clubs = new Clubs()
                newData = angular.copy data
                fields =
                    limit: 'limit'
                    page: 'page'
                    pages: 'pages'
                    total: 'total'
                    items: '_embedded.items'
                newData = Helper.traverseProperties newData, fields
                angular.forEach newData.items, (value, key) ->
                    fields =
                        id: 'id'
                        season: 'season'
                        club: 'club'
                        overallPosition: 'overall_position'
                        overallPlayed: 'overall_played'
                        overallWins: 'overall_wins'
                        overallDraws: 'overall_draws'
                        overallLosses: 'overall_losses'
                        overallGoalsFor: 'overall_goals_for'
                        overallGoalsAgainst: 'overall_goals_against'
                        overallGoalsDifference: 'overall_goals_difference'
                        overallPoints: 'overall_points'
                        homePosition: 'home_position'
                        homePlayed: 'home_played'
                        homeWins: 'home_wins'
                        homeDraws: 'home_draws'
                        homeLosses: 'home_losses'
                        homeGoalsFor: 'home_goals_for'
                        homeGoalsAgainst: 'home_goals_against'
                        homeGoalsDifference: 'home_goals_difference'
                        homePoints: 'home_points'
                        awayPosition: 'away_position'
                        awayPlayed: 'away_played'
                        awayWins: 'away_wins'
                        awayDraws: 'away_draws'
                        awayLosses: 'away_losses'
                        awayGoalsFor: 'away_goals_for'
                        awayGoalsAgainst: 'away_goals_against'
                        awayGoalsDifference: 'away_goals_difference'
                        awayPoints: 'away_points'
                    item = Helper.traverseProperties value, fields
                    item.club = clubs.transformItemData(item.club)
                    item.me = (item.club.id == CFG.clubId)
                    newData.items[key] = item
                return newData
            then: (resolve) ->
                if !angular.isUndefined @params and !angular.isUndefined @params.flush
                    if @params.flush
                        cache.removeAll()
                    delete @params.flush
                @then = null
                resolve @
            timeout: timeout
    options = {}
    extend = {}

    resource = $resource url, paramDefaults, actions, options
    resource.prototype = angular.extend extend, resource.prototype
    return resource
