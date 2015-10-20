class Draggable extends Directive then constructor: (
    $document, $timeout
) ->
    return (scope, element, attr) ->
        element.on 'dragstart', (event) ->
            event.gesture.preventDefault()
            $document.on 'drag', move

        move = (event) ->
            _x = event.gesture.center.pageX
            _y = event.gesture.center.pageY
            console.warn 'move', event.gesture.center.pageX, event.gesture.center.pageY, _x, _y
            element.css(
                transform: 'matrix3d(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, '+_x+', '+_y+', 0, 1)', 'visibility': 'visible'
                '-webkit-transform': 'matrix3d(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, '+_x+', '+_y+', 0, 1)'
                '-ms-transform': 'matrix(1, 0, 0, 1, '+_x+', '+_y+')'
            )
