class Matches extends Factory then constructor: (
    NgBackboneCollection, Match, Moment
) ->
    # backbone need to return its self when construct.
    return NgBackboneCollection.extend
        model: Match

        # using url same as model's url.
        url: Match::url

        # defind alias name to refer to this collection in application wide
        # eg. $rootScope.$matches
        alias: 'matches'

        buildItemStack: (collection) ->
            return unless collection
            _items_ = {}
            _matches_ = []
            # use to keep index order
            # see http://stackoverflow.com/questions/5773950
            _ordered_ = []

            for match in collection
                date = Moment(match.match_day)
                timestamp = date.unix()
                compettion = match.season.getCompetition()

                if !_items_[timestamp]
                    _ordered_.push timestamp
                    _items_[timestamp] =
                        date: date
                        leagues: {}

                if !_items_[timestamp]['leagues'][compettion.code]
                    _items_[timestamp]['leagues'][compettion.code] =
                        compettion: compettion
                        matches: []

                _items_[timestamp]['leagues'][compettion.code]['matches'].push match

            for o in _ordered_
                days = _items_[o]
                _matches_.push
                    type: 'date'
                    value: days.date

                for key, league of days.leagues
                    _matches_.push
                        type: 'league'
                        value: league.compettion

                    for match in league.matches
                        _matches_.push
                            type: 'match'
                            value: match

            # update to scope
            return _matches_

class Match extends Factory then constructor: (
    CFG, NgBackboneModel, Club, Season
) ->
    return NgBackboneModel.extend
        # root url for single model.
        url: CFG.API.getPath 'matches/'

        relations: [
            type: 'HasOne'
            key: 'home_club'
            relatedModel: Club
        ,
            type: 'HasOne'
            key: 'away_club'
            relatedModel: Club
        ,
            type: 'HasOne'
            key: 'season'
            relatedModel: Season
        ]
