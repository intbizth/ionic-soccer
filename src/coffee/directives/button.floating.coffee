class FloatingButton extends Directive then constructor: (
    Und
) ->
    return {
        restrict: 'E'
        transclude: yes
        scope:
            title: '@'
            icon: '@'
        template:
            '<div class="ux-floating-button" ng-class="{open:clicked}">' +
                '<div class="item toggle" ng-click="open()" title="{{title}}">' +
                    '<i class="icon ion-{{icon}}"></i>' +
                '</div>' +
                '<div class="menu" ng-class="{in:isIn, out:isOut}" ng-transclude>' +
                '</div>' +
            '</div>'

        compile: (element, attr) ->
            attr.icon = 'settings' if Und.isUndefined attr.icon
            return

        controller: ($scope) ->
            $scope.clicked = no
            $scope.isIn = no
            $scope.isOut = no

            $scope.open = ->
                $scope.clicked = !$scope.clicked
                $scope.isIn = $scope.clicked
                $scope.isOut = !$scope.clicked

    }
