class Chance extends Factory then constructor: ->
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
        'Chonburi FC'
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
    chance.club = ->
        space = new RegExp(' ', 'g')
        name = chance.pick(clubs)
        image = name.replace(space, '') + '.png'
        return {
            name: name
            image: image
            src: './img/team/' + image
            css: '../img/team/' + image
        }
    return chance;
