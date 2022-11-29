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
    
    var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()),GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack {
            
            AsyncImage(url: URL(string: cover)) { image in
                image
                    .resizable()
            } placeholder: {
                Color.orange
            }
            .frame(maxWidth: 200, maxHeight: 200)

            ScrollView {
                    LazyVGrid(columns: gridItemLayout) {
//                        Text(String(emojiCatalogue.latest.count))
//                            .foregroundColor(.orange)
//                        Text(String(emojiCatalogue.library.count))
//                            .foregroundColor(.orange)
                        
                        ForEach(emojiCatalogue.latest) { emoji in
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
                                    .font(.system(size: 30))
                            })
                        }
                        .fixedSize(horizontal: false, vertical: true)


                    
                        
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                            .onTapGesture {
                                print("see more emojis")
                                withAnimation {
                                    //expandLibrary.toggle()
                                    showEmojiLibrary = true
                                }
                                
                            }
                        
                        
                    }
//                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                
                .frame(maxWidth: expandLibrary ? 250 : .infinity, maxHeight: expandLibrary ? 35 : 400)
                .padding(10)
                .background(Color("Grey 2"))
                .cornerRadius(expandLibrary ? 50 : 10)



            }
            //.frame(maxWidth: expandLibrary ? 250 : .infinity, maxHeight: expandLibrary ? 35 : 400)
            //.padding(10)
           // .background(Color("Grey 2"))
            //.onAppear()
        }
        .sheet(isPresented: $showEmojiLibrary) {
                    EmojiLibraryView(emojiCatalogue: emojiCatalogue, emojiReactionModel: emojiReactionModel)
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
