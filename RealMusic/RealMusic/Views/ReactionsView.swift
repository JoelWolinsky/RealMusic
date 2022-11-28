//
//  ReactionsView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 23/11/2022.
//

import Foundation
import SwiftUI

struct ReactionsView: View {
    
    @StateObject var reactionViewModel: ReactionViewModel
    
    var postUID: String
    
    //@ObservedObject var emojiReactionModel = EmojiReactionModel()
    
    var body: some View {
        HStack {
            ForEach(reactionViewModel.reactions) { emoji in
                Text(emoji.emoji)
            }
//            .padding(10)
            
            Image(systemName: "plus.circle.fill")
                .foregroundColor(.white)
        }
        .frame(maxWidth: CGFloat(reactionViewModel.reactions.count * 25) + 50, maxHeight: 40)
        .background(Color("Grey 3"))
        //.cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black, lineWidth: 5)
                )
        .cornerRadius(20)
        .frame(maxWidth: .infinity, alignment: .leading)



        
    }
        
    
    struct EmojiView_Previews: PreviewProvider {
        static var previews: some View {
            ReactionsView(reactionViewModel: ReactionViewModel(id: ""), postUID: "")
            
        }
    }
}

