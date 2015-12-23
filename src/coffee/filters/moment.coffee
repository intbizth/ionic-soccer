class Moment extends Filter then constructor: (
    Moment
)->
    return (dateString, format) ->
        return Moment(dateString).format(format)
