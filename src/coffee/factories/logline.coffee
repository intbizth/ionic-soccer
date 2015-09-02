class LogLine extends Factory then constructor: ->
    defaultLen = 32
    defaultSymbol = '.'
    appName = 'TORO'
    brandName = 'INTBIZTH'

    return {
            # change default
            appName: (appName) ->
                appName = appName
                return @

            # change default
            brandName: (brandName) ->
                brandName = brandName
                return @

            # change default length
            len: (len) ->
                defaultLen = len
                return @

            # change default symbol
            symbol: (symbol) ->
                defaultSymbol = symbol
                return @

            # short hand to print platform
            platform: ->
                @print [ionic.Platform.platform().toUpperCase()], defaultLen, defaultSymbol, defaultSymbol

            # short hand print brand
            brand: ->
                @print brandName + ' - MOBILE', defaultLen, defaultSymbol

            # short hand print app
            app: ->
                @print appName + ' APP STARTED', defaultLen, defaultSymbol

            rockNroll: ->
                @print 'Rock \'n Roll!! READY.', defaultLen, defaultSymbol

            # print footer
            footer: ->
                @print defaultSymbol, defaultLen, defaultSymbol, defaultSymbol

            # startup text
            startup: ->
                @platform()
                @brand()
                @app()

            # ready text
            ready: ->
                @rockNroll()
                @footer()

            ###*
            # Print log text.
            #
            # @param {string|array} text Display text, an array given will add padding aroun text.
            # @param {int} len Block width.
            # @param {string} symbol The symbol text.
            # @param {string} spacing Spacing for print text.
            ###
            print: (text, len, symbol, spacing) ->
                text = ' ' + text[0] + ' ' if typeof text is 'object' # add padding
                symbol = '+' if not symbol
                spacing = ' ' if not spacing

                odd = if text.length % 2 then len else len - 1
                str1 = str2 = Array(Math.ceil((odd - text.length) / 2)).join spacing
                str2 = str2.substr(1) if odd == len

                console.log symbol + str1 + text + str2 + symbol
    }