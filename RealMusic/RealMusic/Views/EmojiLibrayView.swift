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
    @Binding var showPicker: Bool

    


    
    var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()),GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    
    var body: some View { 
        VStack {
            ScrollView {
                ForEach(emojiCatalogue.library) { category in
                    VStack {

                        Text(category.name)
                            .foregroundColor(Color("Grey"))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        LazyVGrid(columns: gridItemLayout) {
                            ForEach(category.emojis) { emoji in
                               // if emoji.category == category.name {
                                    Button (action: {
                                        showEmojiLibrary.toggle()
                                        
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
                                            .font(.system(size: 30))
                                    })
                                //}
                            }
//                            .fixedSize(horizontal: false, vertical: true)
                            
                        }
                    }
                    .padding(10)
                }
            }
        }
        //.frame(maxWidth: .infinity)
        .background(.white)
        .onAppear(perform: {
            print("showing library")
//            var cat = [String]()
//            for i in emojiCatalogue.library {
//                if !cat.contains(i.category ?? "") {
//                    cat.append(i.category ?? "")
//                }
//            }
//            print("Categories \(cat)")
        })
    }
}
