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
    @Binding var blur: Int
    @Binding var disableScroll: Int

    @ObservedObject var emojiReactionModel = EmojiReactionModel()
    
    @StateObject var reactionViewModel: ReactionViewModel
    
    @StateObject var emojiCatalogue: EmojiCatalogue
    
    
    @State var expandLibrary = true
    
    @Binding var showEmojiLibrary: Bool
    
    @State private var animatePicker = false
    
    @Binding var showPicker: Bool
    
    var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()),GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        HStack {
            
            ForEach(emojiCatalogue.latest) { emoji in
                Button (action: {
                    withAnimation(.easeIn(duration: 0.2)) {
                        
                        print("upload \(emoji.description) for \(postUID)")
                        
                        emojiReactionModel.uploadReaction(postUID: postUID, emoji: emoji)

                        longPress = 0
                        blur = 0
                        disableScroll = 1000
                        showPicker = false
                        
                        let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                        impactHeavy.impactOccurred()
                        
                        reactionViewModel.addLocalReaction(reaction: Emoji(emoji: emoji.emoji, description: emoji.description))
                    }
                }, label: {
                    Text(emoji.emoji)
                        .font(.system(size: animatePicker ? 27 : 0))
                        .padding(5)
                })
            }
            
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
        .frame(width: animatePicker ? 300 : 0, height: 35)
        .padding(10)
        //.background(Color("Grey 2"))
        .background(.regularMaterial)
        .cornerRadius(50)
        .frame(maxWidth: .infinity, alignment: .leading)
        .sheet(isPresented: $showEmojiLibrary) {
            EmojiLibraryView(emojiCatalogue: emojiCatalogue, emojiReactionModel: emojiReactionModel, reactionViewModel: reactionViewModel, showEmojiLibrary: $showEmojiLibrary, longPress: $longPress, chosenEmoji: $chosenEmoji, emojiSelected: $emojiSelected, blur: $blur, disableScroll: $disableScroll, postUID: postUID, showPicker: $showPicker)
                .presentationDetents([.medium])
            
        
            
            
            
        }
        .offset(x: animatePicker ?  0 : -150)
        .onAppear(perform: {
            withAnimation(.spring(response: 0.45, dampingFraction: 1, blendDuration: 0)) {
                print("animate ist true 2")
                animatePicker = true
            }
        })
    }
    
//    struct EmojiView_Previews: PreviewProvider {
//        static var previews: some View {
//            EmojiPickerView(postUID: "", )
//            
//        }
//    }
}
