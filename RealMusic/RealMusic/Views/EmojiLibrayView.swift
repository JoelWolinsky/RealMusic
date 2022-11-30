//
//  EmojiLibrayView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 29/11/2022.
//

import Foundation
import SwiftUI


struct EmojiLibraryView: View {
    
    @StateObject var emojiCatalogue = EmojiCatalogue()
    @StateObject var emojiReactionModel: EmojiReactionModel
    @StateObject var reactionViewModel: ReactionViewModel

    
    @Binding var showEmojiLibrary: Bool
    
    @Binding var longPress: Int
    @Binding var chosenEmoji: Emoji
    @Binding var emojiSelected: Bool
    @StateObject var blurModel: BlurModel
    @Binding var disableScroll: Int
    
    let postUID: String 


    
    var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()),GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: gridItemLayout) {
                    Text(String(emojiCatalogue.latest.count))
                        .foregroundColor(.orange)
                    Text(String(emojiCatalogue.library.count))
                        .foregroundColor(.orange)
                    
                    ForEach(emojiCatalogue.library) { emoji in
                        Button (action: {
                            showEmojiLibrary.toggle()
                            
                            print("upload \(emoji.description)")
                            emojiReactionModel.uploadReaction(postUID: postUID, emoji: emoji)
                            longPress = 0
                            blurModel.blur = 0
                            disableScroll = 1000
                            let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                            impactHeavy.impactOccurred()
                            
                            reactionViewModel.addLocalReaction(reaction: Emoji(emoji: emoji.emoji, description: emoji.description))

                            
                        }, label: {
                            Text(emoji.emoji)
                                .font(.system(size: 30))
                        })
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    
                    
                    
//                    
//                    Image(systemName: "plus.circle.fill")
//                        .foregroundColor(.white)
//                        .font(.system(size: 30))
//                        .onTapGesture {
//                            print("see more emojis")
//                            withAnimation {
//                            }
//                            
//                        }
                    
                    
                }
            }
        }
        //.frame(maxWidth: .infinity)
        .background(.white)
        .onAppear(perform: {
            print("showing library")
        })
    }
}
