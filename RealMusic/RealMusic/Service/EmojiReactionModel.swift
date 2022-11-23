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
            //UserDefaults.standard.setValue(username, forKey: "Username")
            print("reaction added to \(postUID)")
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
        
    }
    
    func fetchReactions(postUID: String, completion: @escaping([Emoji]) -> Void ) {
//        var emojis = [Emoji]()
//        let db = Firestore.firestore()
//        
//        db.collection("Posts")
//            .document(postUID)
//            .collection("Reactions")
//            .getDocuments() { (querySnapshot, err) in
//                guard let documents = querySnapshot?.documents else { return }
//                documents.forEach{ emoji in
//                    guard let emoji = try? emoji.data(as: Emoji.self) else { return }
//                    emojis.append(emoji)
//                }
//                completion(emojis)
//            }
    }
    
}
