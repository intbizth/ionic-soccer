class Seasons extends Factory then constructor: (
    NgBackboneCollection, Season
) ->
    # backbone need to return its self when construct.
    return NgBackboneCollection.extend
        model: Season

        # using url same as model's url.
        url: Season::url

        # defind alias name to refer to this collection in application wide
        # eg. $rootScope.$seasons
        alias: 'seasons'

class Season extends Factory then constructor: (
    CFG, NgBackboneModel, Competition, $rootScope
) ->
    return NgBackboneModel.extend
        # root url for single model.
        url: CFG.API.getPath 'seasons/'

        relations: [
            type: 'HasOne'
            key: 'competition'
            relatedModel: Competition
        ]

        getCompetition: ->
            competition = @get 'competition'
            return competition if competition

            # need to load compettions before.
            competitions = $rootScope.$competitions
            return unless competitions

            link = @_links.competition.href
            seps = link.split('/')
            id = seps[seps.length-1]
            competition = competitions.get id

            @set 'competition', competition
            return competition if competition

            # TODO
            #new competition({id: id}).fetch()
            #new competition().find id

