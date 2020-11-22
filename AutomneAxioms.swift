//
//  AutomneAxioms.swift
//  Radio Automne
//
//  Created by Aydar Nasibullin on 30.09.2020.
//  Copyright © 2020 Fetch Development. All rights reserved.
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
    public static var messages = ["You are loved.",
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
                                  "Сountryside sceneries hardly change"]
    
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
