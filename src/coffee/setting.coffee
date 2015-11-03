class Setting extends Config then constructor: (
    CFG, $httpProvider, OAuthProvider, $resourceProvider
) ->
    $resourceProvider.defaults.stripTrailingSlashes = no
    OAuthProvider.configure CFG.OAuth.getConfig()
