//
//  EmojiReactionModel.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 23/11/2022.
//

import Foundation
import FirebaseFirestore

class EmojiReactionModel: ObservableObject {
    
    
    func uploadReaction(postUID: String, emoji: Emoji) {
        // upload the emoji under post -> reactions -> users uid as the doc name
    
        let db = Firestore.firestore()
        
        let userUid = UserDefaults.standard.value(forKey: "uid")
        
        // add them to your friends
        do {
            try db.collection("Posts").document(postUID).collection("Reactions").document(userUid as! String).setData(from: emoji)
            print("reaction added to \(postUID)")
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
        
    }
    

    
}
