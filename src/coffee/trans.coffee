class Trans extends Filter
    constructor: ($parse, $translate) ->

        filter = (translationId, interpolateParams, interpolation) ->
            if !angular.isObject(interpolateParams)
                interpolateParams = $parse(interpolateParams)(@)
            return $translate.instant translationId, interpolateParams, interpolation

        if $translate.statefulFilter()
            filter.$stateful = yes

        return filter

class Translation extends Config
    constructor: ($translateProvider, $translatePartialLoaderProvider) ->
        $translateProvider.useLoader '$translatePartialLoader',
            urlTemplate: 'translations/{lang}/{part}.json'

        $translateProvider.preferredLanguage 'th-TH'
        $translateProvider.fallbackLanguage 'th-TH'

        # https://github.com/angular-translate/angular-translate/issues/1101#issuecomment-119295751
        #$translateProvider.useSanitizeValueStrategy 'sanitize'
        $translateProvider.useSanitizeValueStrategy 'sanitizeParameters'

class TranslationRun extends Run
    constructor: ($translate, $translatePartialLoader) ->
        $translatePartialLoader

# add translation packages here
        .addPart 'common'
        .addPart 'match'

        $translate.refresh()
