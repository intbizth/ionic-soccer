class Setting extends Config
    ###*
    # @param {object} $stateProvider
    # @param {object} $urlRouterProvider
    # @param {object} $ionicConfigProvider See http://ionicframework.com/docs/api/provider/$ionicConfigProvider/
    ###
    constructor: (
        CFG, $ionicConfigProvider, $ionicLoadingConfig
    ) ->
        # http://ionicframework.com/docs/api/directive/ionSpinner/
        # ripple,lines
        $ionicLoadingConfig.template = '<ion-spinner icon="lines"></ion-spinner>'
        # TODO:
        # $locationProvider.html5Mode yes
