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
    
    @Published var library = [Emoji]()
    @Published var latest = [Emoji]()

    
    
    init() {
        self.getLatest()
        self.getLibrary()
    }
    
    func getLatest() {
        self.latest = [
        Emoji(emoji: "🤯", name: "Exploding Head"),
        Emoji(emoji: "🥰", name: "Smiling Face with Hearts"),
        Emoji(emoji: "🤩", name: "Star-Struck"),
        Emoji(emoji: "🍉", name: "Watermelon"),
        Emoji(emoji: "🦄", name: "Unicorn")
        
        
        ]
    }
    func getLibrary() {
        let data = readLocalFile()
        //var library = [Emoji]()
        
        do {
                let decodedData = try? JSONDecoder().decode([LibraryEmoji].self, from: data!)
            for emoji in decodedData! {
                let newEmoji = Emoji(emoji: emoji.emoji, name: emoji.description, category: emoji.category, aliases: emoji.aliases, tags: emoji.tags)
                self.library.append(newEmoji)
                print("added emoji")
            }
            //print(decodedData)
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
