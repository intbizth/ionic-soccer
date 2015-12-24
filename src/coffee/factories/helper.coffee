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
                for value, index in object
                    if angular.isObject value
                        getValue value, prefix + '[' + index + ']'
                    else
                        if angular.isNumber value
                            value = parseInt value
                        data[prefix + '[' + key + ']'] = value
            for value, index in items
                if angular.isObject value
                    getValue value, index
                else
                    if angular.isNumber value
                        value = parseInt value
                    data[index] = value
            formData = new FormData()
            for value, index in data
                formData.append index, value
            return formData
    }
