//
//  PostView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 09/10/2022.
//

import Foundation
import SwiftUI

struct PostView: View {
    let post: Post
    var body: some View {
        
        VStack {
            Text(post.username ?? "")
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(post.title)
            Image("KSG Cover")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .cornerRadius(3)
            
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(.black)
        .foregroundColor(.white)
        


        
        
    }
    
    struct PostView_Previews: PreviewProvider {
        static var previews: some View {
            PostView(post: Post(title: "Biking - Frank Ocean", uid: "This uid test", username: "Joel", cover: "KSG Cover"))
            
        }
    }
}
