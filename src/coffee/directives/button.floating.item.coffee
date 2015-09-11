class FloatingButtonItem extends Directive then constructor: ->
    return {
        restrict: 'E'
        scope:
            title: '@'
            icon: '@'
        template:
            '<div class="item" title="{{title}}">' +
                '<i class="icon ion-{{icon}}"></i>' +
            '</div>'
    }
