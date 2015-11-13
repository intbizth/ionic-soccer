class Helper extends Factory then constructor: (
) ->
    return {
        traverseProperties: (object, items) ->
            for key of items
                if angular.isObject(items[key])
                    @traverseProperties(object, items[key])
                else
                    items[key] = @getProperty(object, items[key])
            return items
        getProperty: (object, string) ->
            output = null
            try
                explodedString = string.split('.')
                for key in explodedString
                    object = object[key]
                output = object
            catch e
            return output
    }
