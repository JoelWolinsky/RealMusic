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
        Emoji(emoji: "🤯", description: "Exploding Head", category: ""),
        Emoji(emoji: "🥰", description: "Smiling Face with Hearts", category: ""),
        Emoji(emoji: "🤩", description: "Star-Struck", category: ""),
        Emoji(emoji: "🍉", description: "Watermelon", category: ""),
        Emoji(emoji: "🦄", description: "Unicorn", category: "")
        
        
        ]
    }
    func getLibrary() {
        let data = readLocalFile()
        //var library = [Emoji]()
        
        do {
                let decodedData = try? JSONDecoder().decode([LibraryEmoji].self, from: data!)
            for emoji in decodedData! {
                let newEmoji = Emoji(emoji: emoji.emoji, description: emoji.description, category: emoji.category, aliases: emoji.aliases, tags: emoji.tags)
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
