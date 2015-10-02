class Setting extends Config then constructor: (
    CFG, $httpProvider
) ->
    $httpProvider.defaults.paramSerializer = '$httpParamSerializerJQLike'
