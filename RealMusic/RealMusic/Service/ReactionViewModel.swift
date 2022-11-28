//
//  ReactionViewModel.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 28/11/2022.
//

import Foundation
import SwiftUI

class ReactionViewModel: ObservableObject {
    
    @Published var reactions = [Emoji]()
    
    @ObservedObject var feedViewModel = FeedViewModel()
    
    var id: String
    
    
    init(id: String) {
        self.id = id
        fetchReactions(id: id)
    }
    
    func fetchReactions(id: String) {
        feedViewModel.fetchReactions(postUID: id) { result in
            self.reactions = result
        }
        
    }
    
    func addLocalReaction(reaction: Emoji) {
        //let reaction = Emoji(emoji: "🍅", name: "")
        self.reactions.append(reaction)
    }
}
