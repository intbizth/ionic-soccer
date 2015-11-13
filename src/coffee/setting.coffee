class Setting extends Config then constructor: (
    $httpProvider, $resourceProvider ,CFG, OAuthProvider
) ->
    $resourceProvider.defaults.stripTrailingSlashes = no
    OAuthProvider.configure CFG.OAuth.getConfig()

