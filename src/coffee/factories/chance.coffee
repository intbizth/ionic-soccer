class Chance extends Factory then constructor: (
    Und
)->
    return Und.extend(window.chance,
        profile: ->
            image = chance.integer(
                min: 1
                max: 20
            ) + '.jpg'
            return {
                name: chance.name()
                image:
                    src: './img/fake/profile/' + image
                    css: '../img/fake/profile/' + image
            }
        club: ->
            clubs = [
                'Air Force Central FC'
                'Ang Thong FC'
                'Army United FC'
                'Ayutthaya FC'
                'Bangkok FC'
                'Bangkok United'
                'BBCU'
                'BEC Tero Sasana'
                'BGFC'
                'Buriram United'
                'Chainat Hornbill FC'
                'Chiangmai FC'
                'Chiangrai United'
                # 'Chonburi FC'
                'Khon Kaen FC'
                'Khon Kaen United'
                'Krabi FC'
                'Lamphun Warrior'
                'Loei City'
                'Nakhonpathom United'
                'Nakhon Ratchasima Mazda FC'
                'Navy FC'
                'Osotspa M-150'
                'Pattaya United'
                'Phichit FC'
                'Phitsanulok TSYFC'
                'Phrae United'
                'Phuket FC'
                'Police United'
                'Port FC'
                'Prajuab FC'
                'PTT Rayong'
                'Ratchaburi Mitrphol FC'
                'Roiet United'
                'Samut Songkhram BTUFC'
                'Saraburi FC'
                'SCG Muangthong United'
                'Sisaket FC'
                'Songkhla United'
                'Sriracha FC'
                'Sukhothai FC'
                'Suphanburi FC'
                'Thai Honda'
                'TOTSC'
                'Trat FC'
                'TTMFC'
                'Ubon UMT United'
            ]
            name = chance.pick(clubs)
            space = new RegExp(' ', 'g')
            image = name.replace(space, '') + '.png'
            return {
                name: name
                image:
                    src: './img/fake/club/' + image
                    css: '../img/fake/club/' + image
            }
        user: ->
            image = chance.integer(
                min: 1
                max: 20
            ) + '.jpg'
            return {
                name: chance.name()
                image:
                    src: './img/fake/user/' + image
                    css: '../img/fake/user/' + image
            }
        timeline: ->
            image = chance.integer(
                min: 1
                max: 54
            ) + '.jpg'
            return {
                name: chance.name()
                image:
                    src: './img/fake/timeline/' + image
                    css: '../img/fake/timeline/' + image
            }
        update: ->
            image = chance.integer(
                min: 1
                max: 53
            ) + '.jpg'
            return {
                name: chance.name()
                image:
                    src: './img/fake/update/' + image
                    css: '../img/fake/update/' + image
            }
        product: ->
            image = chance.integer(
                min: 1
                max: 32
            ) + '.jpg'
            return {
                name: chance.name()
                image:
                    src: './img/fake/product/' + image
                    css: '../img/fake/product/' + image
            }
        wallpaper: ->
            image = chance.integer(
                min: 1
                max: 59
            ) + '.jpg'
            return {
                name: chance.name()
                image:
                    src: './img/fake/wallpaper/' + image
                    css: '../img/fake/wallpaper/' + image
            }
        matchHighlight: ->
            image = chance.integer(
                min: 1
                max: 64
            ) + '.jpg'
            return {
                name: chance.name()
                image:
                    src: './img/fake/match/highlight/' + image
                    css: '../img/fake/match/highlight/' + image
            }
        player: ->
            image = chance.integer(
                min: 1
                max: 10
            ) + '.jpg'
            return {
                name: chance.name()
                image:
                    src: './img/fake/player/' + image
                    css: '../img/fake/player/' + image
            }
    );
