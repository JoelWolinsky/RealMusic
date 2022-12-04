//
//  EmojiView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 23/11/2022.
//

import Foundation
import SwiftUI

struct EmojiPickerView: View {
    
    var postUID: String
    var cover: String
    
    @Binding var longPress: Int
    @Binding var chosenEmoji: Emoji
    @Binding var emojiSelected: Bool
    @StateObject var blurModel: BlurModel
    @Binding var disableScroll: Int

    @ObservedObject var emojiReactionModel = EmojiReactionModel()
    
    @StateObject var reactionViewModel: ReactionViewModel
    
    @StateObject var emojiCatalogue: EmojiCatalogue
    
    
    @State var expandLibrary = true
    
    @Binding var showEmojiLibrary: Bool
    
    @Binding var showPicker: Bool
    
    var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()),GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        HStack {
            
            ForEach(emojiCatalogue.latest) { emoji in
                Button (action: {
                    print("upload \(emoji.description)")
                    emojiReactionModel.uploadReaction(postUID: postUID, emoji: emoji)
                    longPress = 0
                    blurModel.blur = 0
                    disableScroll = 1000
                    showPicker = false
                    
                    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                    impactHeavy.impactOccurred()
                    
                    reactionViewModel.addLocalReaction(reaction: Emoji(emoji: emoji.emoji, description: emoji.description))
                    
                }, label: {
                    Text(emoji.emoji)
                        .font(.system(size: 27))
                        .padding(5)
                })
            }
            .fixedSize(horizontal: false, vertical: true)
            
            Button (action: {
                print("see more emojis")
                showEmojiLibrary = true
            }, label: {
                VStack {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                }
                //.frame(width: 70, height: 70)
            })
            
            
        }
        .frame(maxWidth: 300, maxHeight: 35)
        .padding(10)
        .background(Color("Grey 2"))
        .cornerRadius(50)
        .sheet(isPresented: $showEmojiLibrary) {
            EmojiLibraryView(emojiCatalogue: emojiCatalogue, emojiReactionModel: emojiReactionModel, reactionViewModel: reactionViewModel, showEmojiLibrary: $showEmojiLibrary, longPress: $longPress, chosenEmoji: $chosenEmoji, emojiSelected: $emojiSelected, blurModel: blurModel, disableScroll: $disableScroll, postUID: postUID, showPicker: $showPicker)
                .presentationDetents([.medium])
            
            
            
        }
    }
    
//    struct EmojiView_Previews: PreviewProvider {
//        static var previews: some View {
//            EmojiPickerView(postUID: "", )
//            
//        }
//    }
}
