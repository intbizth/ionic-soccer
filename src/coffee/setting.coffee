class Setting extends Config then constructor: (
    CFG, $httpProvider, OAuthProvider, $resourceProvider
) ->
    $httpProvider.defaults.paramSerializer = '$httpParamSerializerJQLike'
    OAuthProvider.configure CFG.OAuth.getConfig()
    $resourceProvider.defaults.stripTrailingSlashes = no