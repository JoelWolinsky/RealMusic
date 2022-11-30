//
//  Emoji.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 23/11/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Emoji: Identifiable, Encodable, Decodable {
    
    @DocumentID var docID : String? // document id which is the uid of the user who reacted
    var id = UUID()
    var emoji: String
    var description: String
    var category: String?
    var aliases: [String]?
    var tags: [String]?

}
