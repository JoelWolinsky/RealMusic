//
//  EmojiCatalogue.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 23/11/2022.
//

import Foundation
import SwiftUI

class EmojiCatalogue: ObservableObject {
    @State var jsonData = Data()

    @Published var library = [Category]()
    @Published var latest = [Emoji]()
    @Published var emojis = [Emoji]()
    @Published var categories = ["Smileys & Emotion", "People & Body", "Animals & Nature", "Food & Drink", "Travel & Places",
                                 "Activities", "Objects", "Symbols", "Flags"]

    init() {
        getLatest()
        getLibrary()
    }

    func getLatest() {
        latest = [
            Emoji(emoji: "🥵", description: "Exploding Head", category: ""),
            Emoji(emoji: "🍆", description: "Smiling Face with Hearts", category: ""),
            Emoji(emoji: "🤩", description: "Star-Struck", category: ""),
            Emoji(emoji: "🔁", description: "Watermelon", category: ""),
            Emoji(emoji: "🌝", description: "Unicorn", category: ""),
        ]
    }

    func getLibrary() {
        let data = readLocalFile()

        do {
            let decodedData = try? JSONDecoder().decode([LibraryEmoji].self, from: data!)
            for category in categories {
                var emojis = [Emoji]()
                for emoji in decodedData! {
                    if emoji.category == category {
                        let newEmoji = Emoji(emoji: emoji.emoji, description: emoji.description, category: emoji.category, aliases: emoji.aliases, tags: emoji.tags)

                        emojis.append(newEmoji)
                    }
                }
                library.append(Category(name: category, emojis: emojis))
            }

            for emoji in decodedData! {
                let newEmoji = Emoji(emoji: emoji.emoji, description: emoji.description, category: emoji.category, aliases: emoji.aliases, tags: emoji.tags)
                emojis.append(newEmoji)
            }
        } catch {
            print("decode error")
        }
    }

    func readLocalFile() -> Data? {
        do {
            if let filePath = Bundle.main.path(forResource: "EmojiLibrary", ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                return data
            }
        } catch {
            print(error)
        }
        return nil
    }
}

struct EmojiLibray: Codable {
    let emojis: [Emoji]
}
