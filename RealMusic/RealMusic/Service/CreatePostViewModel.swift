//
//  CreatePostViewModel.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 14/10/2022.
//

import Foundation
import FirebaseFirestore

class CreatePostViewModel: ObservableObject {
    
    var uid: String
    
    init(uid: String) {
        self.uid = uid
        //createPost()
    }
    
    // Add a new post to the db
    func createPost(post: Post) {
        let db = Firestore.firestore()
        //let post = Post(title: "Test Send Post", uid: "test uid")

        do {
            try db.collection("Posts").document(post.id!).setData(from: post)
            print("Post created \(post.id)")
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
    }
}

