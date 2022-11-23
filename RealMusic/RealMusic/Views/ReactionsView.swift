//
//  ReactionsView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 23/11/2022.
//

import Foundation
import SwiftUI

struct ReactionsView: View {
    
    @State var emojis: [Emoji]
    
    var postUID: String
    
    @ObservedObject var emojiReactionModel = EmojiReactionModel()
    
    var body: some View {
        HStack {
            ForEach(emojis) { emoji in
                Text(emoji.emoji)
            }

        }
        .frame(width:200, height: 40)
        .background(.green)
        .cornerRadius(20)
//        .onAppear(perform: {
//            emojiReactionModel.fetchReactions(postUID: postUID) { (emojis) in
//                self.emojis = emojis
//            }
//        })

        
    }
        
    
    struct EmojiView_Previews: PreviewProvider {
        static var previews: some View {
            EmojiPickerView(postUID: "")
            
        }
    }
}

