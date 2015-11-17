class Timeago extends Filter then constructor: (
    Moment
) ->
    return (dateString) ->
        return Moment(dateString).fromNow()
