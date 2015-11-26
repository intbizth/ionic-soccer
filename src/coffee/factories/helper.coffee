class Helper extends Factory then constructor: (
) ->
    return {
        traverseProperties: (object, items) ->
            getValue = (object, string) ->
                output = null
                try
                    explodedString = string.split '.'
                    for key in explodedString
                        object = object[key]
                    output = object
                catch e
                return output
            for key of items
                if angular.isObject items[key]
                    @traverseProperties object, items[key]
                else
                    items[key] = getValue object, items[key]
            return items
        buildFormData: (items) ->
            data = {}
            getValue = (object, prefix) ->
                angular.forEach object, (value, key) ->
                    if angular.isObject value
                        getValue value, prefix + '[' + key + ']'
                    else
                        data[prefix + '[' + key + ']'] = value
            angular.forEach items, (value, key) ->
                if angular.isObject value
                    getValue value, key
                else
                    data[key] = value
            formData = new FormData()
            angular.forEach data, (value, key) ->
                formData.append key, value
            return formData
    }
