//
//  AutomneAxioms.swift
//  Radio Automne
//
//  Created by Aydar Nasibullin on 30.09.2020.
//  Copyright © 2020-2021 Fetch Development. All rights reserved.
//

import Foundation
import SystemConfiguration

class AutomneAxioms{
    public static let firstResponderNoseQueue = "https://automne.aydar.media/get.php?key="
    public static let SCNoseQueue = "https://api.soundcloud.com/"
    public static let SCPlaylistQueue = "playlists/"
    public static let SCDeepWaveQueue = "/related"
    public static let SCTailQueue = "?client_id="
    
    public static let emojis = ["📡", "🎛", "🎚", "🎙", "📻", "📀", "💿", "💽", "🌌", "🎹", "🎧", "🎤", "🍂", "🍁", "🦗", "🌤", "🦊", "🎃", "🌲", "🥘", "🚲", "🚉", "🏕", "🛤", "🗺"]
    public static var messages = [
        "You are loved.",
        "You are not alone.",
        "Я не помню, как я оказался в лесу",
        "These are my friends",
        "Leaves are always yellow in Golovkovo",
        "Smash the government",
        "You always have a chance.",
        "Don't forget who you are",
        "Nature is fascinating",
        "This is from Matilda",
        "We watched the end of the century, compressed on a tiny screen",
        "At every occasion, i'll be ready for the funeral",
        "To see age in a flower, the dawns are speeding up",
        "Life's alright in devil town",
        "Увидимся в Лапшичной",
        "В Хижине на Холме чай пахнет ёлками",
        "Не бросайте своих собак",
        "Ветер воет в форточках Полустанка",
        "Why would dogs avoid these hills?",
        "@phvkha is the best photographer i've ever known",
        "You're welcome anytime in my dreams",
        "Apocalypse",
        "Life is a drink, and love's a drug",
        "I never meant to cause you trouble",
        "Истории Петербурга – одни из лучших историй",
        "You're standing out in the rain tonight",
        "I love my grandparents",
        "TIL I DIE DIE DIE",
        "Nothing's terrible with friends around",
        "Навсегда юность, навсегда смерть",
        "Au sе́maphore ton nom rе́sonne",
        "I used to fit in your arms, like a book in a shelf",
        "Now I sit on the floor, telling jokes to myself",
        "Я снова проспал и проснулся в обед",
        "Прости, я забыл, что тебя нет",
        "I won't hurt you, I won't hurt you",
        "I'll tell you, Fenn, i'll tell you, when",
        "It's now",
        "I love you.",
        "You're always welcome to Pokrovka Dacha",
        "You are valid",
        "Все в порядке, все пройдет",
        "Утро которым мы умрем",
        "You, you feel like Oxford blood",
        "Where goes that path through the woods?",
        "There goes our love again",
        "Я встречусь с тобой осенью восьмого класса",
        "Born in Possum Springs",
        "R.I.P. Grandma",
        "R.I.P. Alec",
        "Ew a furry",
        "Caring is the coolest thing I've seen anyone do.",
        "It was a nice holiday without you",
        "And it's called jazz",
        "It's the colours you have, no need to be sad",
        "Are you ready for the Longest Night?",
        "And I think we'd survive in the wild",
        "Слушать старые пластинки",
        "I only have one thing in my head",
        "Пойдем фоткаться на пленку",
        "Гоу в Балчуг после уроков",
        "Я такой один, мне не нужно притворяться",
        "#038",
        "26.04.2019 – ∞",
        "Please, if you hear me, go away",
        "Все получится",
        "И тебе приснится целый мир без меня",
        "Я заберу тебя танцевать",
        "Знаешь, я так соскучился",
        "Lavender is always running through my blood",
        "Trapped in a club",
        "All we had to do was touch",
        "Spies hide out in every corner",
        "Tears falling down at the party",
        "Saddest little baby in the room",
        "Еще одну бессонную ночь я посвящаю тебе",
        "Поды для джула вкуснее всего в Люберцах",
        "This couldn't happen again",
        "I'd rather dissolve than have you ignore me",
        "I miss the Weird Autumn",
        "Сountryside sceneries hardly change",
        "the holes of my sweater",
        "blood like wine",
        "Вишенку так я и не достал",
        "Хочу Цезарь из Царского Села",
        "В ЦДМ есть Шоколадница",
        "Я смешаю коньяк и Байкал",
        "Two oceans in between us",
        "I left you at the farm",
        "We had a good time, didn't we?",
        "Drink at the casino all night",
        "sunsets i wanna hear your voice",
        "God Bless My Socially Retarded Friends",
        "Лето тупо класс",
        "хочу питсы",
        "Застрять, как зубная нить между собачьими клыками",
        "To the Neon District",
        "Да ну его, это чистое сердце. Шоколад, по моему, гораздо лучше",
        "Старость – самая большая неожиданность в жизни",
        "We missed you a lot",
        "Welcome back",
        "Lester hugs you for using Automne",
        "Радио Осень – всегда в прямом эфире",
        "В мире много бессмыслицы",
        "Что может быть бессмысленнее, чем проснуться утром одному в номере интим-гостиницы?",
        "Апрель – слишком грустная пора, чтобы проводить ее в одиночестве",
        "Одни, скинув тяжелые куртки, беседовали на солнышке",
        "Другие играли в кэтч-бол",
        "Третьи любили",
        "А я был полностью одинок",
        "Вдобавок ко всему, я был влюблен",
        "И любовь эта привела меня в очень непростое место",
        "Неудовлетворенное страстное желание отрочества",
        "Мир просторен",
        "Общаясь с ним, иногда ловишь себя на мысли, что ходишь по кругу",
        "Кассетная камера всегда под рукой",
        "Magic happens when cassettes are being recorded",
        "Hold on, let me find my walkman"
    ]
    
    public static let trackNarratives = [
        ("Now playing", true),
        ("in our broadcast", false),
        ("Let's head to", true),
        ("It's time for", true),
        ("Playing", true),
        ("is playing right now", false),
        ("The following $ is", true),
        ("Coming right up,", true),
        ("And the next one $ is", true),
        ("Especially for you,", true),
        ("Let's listen to", true),
        ("that's the $", false),
        ("is up to your ears", false)
    ]
    public static let specialTimeNarratives = [
        "morning": [
            "Good morning",
            "Autumn wishes you a pleasant morning",
            "Spend your upcoming day as productive as possible",
            "Don't forget to wish your loved ones good morning",
            "Доброе утро, друг",
            "Сделай это утро приятным",
            "Вот оно, утро, с которого надо начинать день"
        ],
        "day": [
            "This day is great, isn't it?",
            "Autumn brings music to your day",
            "Добрый денёчек",
            "Пусть этот день будет лучше, чем вчерашний",
            "Ты красивый сегодня",
            "Уже выходил на улицу?"
        ],
        "evening": [
            "Good evening",
            "Autumn wishes you a great evening",
            "Think about the following day. What would you like it to be?",
            "Never be sad. The day ends, but the life will never.",
            "Добрый вечер, дорогой друг",
            "Не забывай про режим сна, это полезно",
            "Как ты встретил этот закат?",
            "С кем встретил закат?",
            "Разработчик готовится ко сну. И тебе советует!"
        ],
        "night": [
            "Good night",
            "Enjoy the silence",
            "Even if there's no one around, autumn is here this night",
            "Autumn never sleeps",
            "Don't be sad this night",
            "The next day will be great",
            "Let these sounds follow your night",
            "Спокойной ночи. Или продуктивной.",
            "Засыпать одному не страшно. Всегда наступает утро.",
            "Обними друга. Или акулу из икеи.",
            "Найди на небе луну",
            "Звезды этой ночью сияют для тебя",
            "Засыпай, самая лучшая боль"
        ]
    ]
    public static let specialWelcomeNarratives = [
        "Welcome",
        "Welcome back",
        "Glad to see you",
        "Hello my friend",
        "Seeing you is always a pleasure"
    ]
    
    public static func uniq<S : Sequence, T : Equatable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = [T]()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.append(elem)
            }
        }
        return buffer
    }
    public static func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }

        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        if flags.isEmpty {
            return false
        }

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)

        return (isReachable && !needsConnection)
    } 
}
