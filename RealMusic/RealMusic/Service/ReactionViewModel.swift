//
//  ReactionViewModel.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 28/11/2022.
//

import Foundation
import SwiftUI

class ReactionViewModel: ObservableObject {
    
    var reactions = [Emoji]()
    var distinctReactions = [Emoji]() {
        didSet {
            objectWillChange.send()

        }
    }
    
    @ObservedObject var feedViewModel = FeedViewModel()
        
    var id: String
    
    
    init(id: String) {
        self.id = id
        fetchReactions(id: id)
    }
    
    func fetchReactions(id: String) {

        feedViewModel.fetchReactions(postUID: id) { result in
            self.reactions = result
            self.calculateDistinctReactions()

        }
        
    }
    
    func addLocalReaction(reaction: Emoji) {
        fetchReactions(id: self.id)
    }
    
    func calculateDistinctReactions() {
        var distinct = [Emoji]()
        var duplicate = false
        
        // Limit the number of reactions that can show in the view
        var limit = 5
        var reactionCounter = 0
        for reaction in self.reactions {
            if reactionCounter <= limit {
                for distinctReaction in distinct {
                    if distinctReaction.emoji == reaction.emoji {
                        duplicate = true
                    }
                }
                if duplicate == false {
                    distinct.append(reaction)
                }
            }
            duplicate = false
        }
        self.distinctReactions = distinct
    }
}


