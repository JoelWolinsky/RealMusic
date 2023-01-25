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
    
    
    var post: Post
    
    //@ObservedObject var emojiReactionModel = EmojiReactionModel()
    
    @State var emojiSize: CGFloat
    
    var body: some View {
        HStack {
            ForEach(reactionViewModel.distinctReactions) { emoji in
                if emoji.docID == ("\(UserDefaults.standard.value(forKey: "uid") ?? "")") {
                    Text(emoji.emoji)
                        .font(.system(size: emojiSize))
                } else {
                    Text(emoji.emoji)
                        .font(.system(size: emojiSize))
                        .onAppear(perform:{
                            //print("user uid saved \(UserDefaults.standard.value(forKey: "uid") as! String)")

                        })
                }
//                    .onAppear {
////                        cancellable = reactionViewModel.objectWillChange.sink{ _ in
////                            print("object changed")
////                        }
//                        let baseAnimation = Animation.easeInOut(duration: 0.4)
//                        let repeated = baseAnimation.repeatCount(3, autoreverses: true)
//
//                        withAnimation(repeated) {
//                            emojiSize = 20.0
//                        }
//                    }//
                
            }
            //.padding(10)

            if reactionViewModel.distinctReactions.count != reactionViewModel.reactions.count {
                    Text(String(reactionViewModel.reactions.count))
                        .foregroundColor(.white)
                
            }

        }
        //.frame(maxWidth: CGFloat(reactionViewModel.reactions.count * 25) + 50, maxHeight: 40)
        .frame(minWidth: reactionViewModel.distinctReactions.isEmpty ? 0 : 20)
        .padding(reactionViewModel.distinctReactions.isEmpty ? 0 : emojiSize/2)
        .background(Color("Grey 3"))
        //.cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 40)
                .stroke(Color.black, lineWidth: 5)
                )
        .cornerRadius(40)
        .frame(maxWidth: .infinity, alignment: .leading)
        .onReceive(reactionViewModel.objectWillChange, perform: {
            print("number of emojis has changed for post \(post.title)")
            let temp = emojiSize
            if !reactionViewModel.reactions.isEmpty {
                emojiSize = 2.0
                withAnimation(.spring(response: 0.6, dampingFraction: 0.5, blendDuration: 1)) {
                    emojiSize = temp
                }
            }
        })
        


        
    }
        
    
//    struct EmojiView_Previews: PreviewProvider {
//        static var previews: some View {
//            //ReactionsView(reactionViewModel: ReactionViewModel(id: ""), post: "")
//            
//        }
//    }
}

