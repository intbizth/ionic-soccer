class Rankings extends Factory then constructor: (
    NgBackboneCollection, Ranking
) ->
    return NgBackboneCollection.extend
        model: Ranking
        url: Ranking::url
        alias: 'Rankings'

class Ranking extends Factory then constructor: (
    CFG, NgBackboneModel, Helper
) ->
    return NgBackboneModel.extend
        url: CFG.API.getPath 'rankings/'
        relations: []
        dataTranformToPostionTable: ->
            item =
                id: 'club.id'
                name: 'club.name'
                play: 'record.total.play'
                goalDifference: 'record.total.goal_difference'
                points: 'record.total.points'
            item = Helper.traverseProperties @, item
            item.template = if item.id == 28 then 'highlight' else 'normal'
            return item
