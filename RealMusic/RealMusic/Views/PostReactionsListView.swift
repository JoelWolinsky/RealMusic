//
//  PostReactionsListView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 08/12/2022.
//

import Foundation
import SwiftUI

struct PostReactionsListView: View {
    
    @StateObject var reactionViewModel: ReactionViewModel
    @StateObject var userViewModel: UserViewModel

    
    var body: some View {
        ScrollView {
            VStack {
                Text("Post Reactions")
                    .foregroundColor(.white)
                ForEach(reactionViewModel.reactions) { reaction in
                    PostReactionsListItemView(userViewModel: userViewModel, reaction: reaction)
                        .padding(.top, 10)
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: 1)
                        .foregroundColor(Color("Grey 2"))
                    //.padding(.top, 5)
                        .padding(.leading, 20)
                }
            }
        }
        .padding(.top, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("Grey 3"))
    }
}
