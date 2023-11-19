//
//  EmojiReactionModel.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 23/11/2022.
//

import FirebaseFirestore
import Foundation

class EmojiReactionModel: ObservableObject {
    func uploadReaction(postUID: String, emoji: Emoji) {
        // upload the emoji under post -> reactions -> users uid as the doc name
        let db = Firestore.firestore()
        let userUid = UserDefaults.standard.value(forKey: "uid")
        let emojiWithUser = Emoji(emoji: emoji.emoji, description: emoji.description, username: UserDefaults.standard.value(forKey: "username") as! String)

        // add them to your friends
        do {
            try db.collection("Posts").document(postUID).collection("Reactions").document(userUid as! String).setData(from: emojiWithUser)
            print("reaction added to \(postUID)")
        } catch {
            print("Error writing city to Firestore: \(error)")
        }
    }
}
