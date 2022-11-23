//
//  EmojiCatalogue.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 23/11/2022.
//

import Foundation

public struct EmojiCatalogue {
    
    static func all() -> [Emoji] {
        return [
        Emoji(emoji: "👾", name: "Alien Monster"),
        Emoji(emoji: "🤯", name: "Exploding Head"),
        Emoji(emoji: "🥰", name: "Smiling Face with Hearts"),
        Emoji(emoji: "🤩", name: "Star-Struck"),
        Emoji(emoji: "🍉", name: "Watermelon"),
        Emoji(emoji: "🦄", name: "Unicorn")
        
        
        ]
    }
}
