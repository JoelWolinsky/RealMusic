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
    
    @Binding var longPress: Int
    
    @Binding var chosenEmoji: Emoji
    
    @Binding var emojiSelected: Bool
    
    @StateObject var blurModel: BlurModel
    @Binding var disableScroll: Int


    @ObservedObject var emojiReactionModel = EmojiReactionModel()
    
    @StateObject var reactionViewModel: ReactionViewModel

    var body: some View {
        HStack {
            ForEach(emojis) { emoji in
                Button (action: {
                    print("upload \(emoji.name)")
                    emojiReactionModel.uploadReaction(postUID: postUID, emoji: emoji)
                    longPress = 0
                    blurModel.blur = 0
                    disableScroll = 1000
                    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                    impactHeavy.impactOccurred()
                    
                    reactionViewModel.addLocalReaction(reaction: Emoji(emoji: emoji.emoji, name: emoji.name))
                    

                }, label: {
                    Text(emoji.emoji)
                        .font(.system(size: 36))
                })
            }

        }
        .frame(width:300, height: 100)
        .background(Color("Grey 2"))
        .cornerRadius(20)
        //.onAppear()

        
    }
    
//    struct EmojiView_Previews: PreviewProvider {
//        static var previews: some View {
//            EmojiPickerView(postUID: "", )
//            
//        }
//    }
}
