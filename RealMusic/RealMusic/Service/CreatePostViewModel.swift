//
//  CreatePostViewModel.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 14/10/2022.
//

import FirebaseFirestore
import Foundation

class CreatePostViewModel: ObservableObject {
    var uid: String

    init(uid: String) {
        self.uid = uid
    }

    // Add a new post to the db
    func createPost(post: Post) {
        let db = Firestore.firestore()

        do {
            try db.collection("Posts").document(post.id!).setData(from: post)
            print("Post created \(post.id)")
        } catch {
            print("Error writing city to Firestore: \(error)")
        }
    }
}
