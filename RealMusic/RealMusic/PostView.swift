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
            Text("@" + (post.username ?? ""))
                .frame(maxWidth: .infinity, alignment: .leading)
                
            
            AlbumView(album: Album(title: post.title, cover: "KSG Cover"))
                //.padding(.bottom, 50)
            
        }
        .padding(20)
        //.scaledToFill()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .foregroundColor(.white)
        


        
        
    }
    
    struct PostView_Previews: PreviewProvider {
        static var previews: some View {
            PostView(post: Post(title: "Biking - Frank Ocean", uid: "This uid test", username: "Joel", cover: "KSG Cover"))
            
        }
    }
}
