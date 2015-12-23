class Trans extends Filter then constructor: (
    $parse, $translate
) ->
    filter = (translationId, interpolateParams, interpolation) ->
        if !angular.isObject(interpolateParams)
            interpolateParams = $parse(interpolateParams)(@)
        return $translate.instant translationId, interpolateParams, interpolation

    if $translate.statefulFilter()
        filter.$stateful = yes

    return filter

class Translation extends Config then constructor: (
    $translateProvider, $translatePartialLoaderProvider
) ->
    $translateProvider.useLoader '$translatePartialLoader',
        urlTemplate: 'translations/{lang}/{part}.json'

    $translateProvider.preferredLanguage 'th-TH'
    $translateProvider.fallbackLanguage 'th-TH'

    # https://github.com/angular-translate/angular-translate/issues/1101#issuecomment-119295751
    #$translateProvider.useSanitizeValueStrategy 'sanitize'
    $translateProvider.useSanitizeValueStrategy 'sanitizeParameters'

class TranslationRun extends Run then constructor: (
    $translate, $translatePartialLoader
) ->
    $translatePartialLoader

    .addPart 'about_club/info'
    .addPart 'about_club/main'
    .addPart 'about_club/team'
    .addPart 'competition_table/fixture'
    .addPart 'competition_table/main'
    .addPart 'competition_table/position_table'
    .addPart 'directives/date_picker'
    .addPart 'fanzone/main'
    .addPart 'fanzone/products'
    .addPart 'fanzone/wallpapers'
    .addPart 'feature/main'
    .addPart 'live/main'
    .addPart 'personal/detail'
    .addPart 'product/detail'
    .addPart 'product/detail'
    .addPart 'ticket_membership/main'
    .addPart 'ticket_membership/ticket'
    .addPart 'timeline_update/timeline'
    .addPart 'timeline_update/update'
    .addPart 'common'
    .addPart 'member'

    $translate.refresh()
