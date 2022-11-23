//
//  EmojiView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 23/11/2022.
//

import Foundation
import SwiftUI

struct EmojiPickerView: View {
    
    var emojis = EmojiCatalogue.all()
    
    var postUID: String
    
    @ObservedObject var emojiReactionModel = EmojiReactionModel()
    
    var body: some View {
        HStack {
            ForEach(emojis) { emoji in
                Button (action: {
                    print("upload \(emoji.name)")
                    emojiReactionModel.uploadReaction(postUID: postUID, emoji: emoji)
                    

                }, label: {
                    Text(emoji.emoji)
                })
            }

        }
        .frame(width:200, height: 40)
        .background(.green)
        .cornerRadius(20)

        
    }
    
    struct EmojiView_Previews: PreviewProvider {
        static var previews: some View {
            EmojiPickerView(postUID: "")
            
        }
    }
}
