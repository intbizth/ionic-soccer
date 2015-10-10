class Setting extends Config then constructor: (
    CFG, $httpProvider, OAuthProvider
) ->
    $httpProvider.defaults.paramSerializer = '$httpParamSerializerJQLike'
    OAuthProvider.configure CFG.OAuth.getConfig()
