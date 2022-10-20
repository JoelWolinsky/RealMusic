//
//  AlbumView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 13/10/2022.
//

import Foundation
import SwiftUI

struct AlbumView: View {
    
    let album: Album
    
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: album.cover)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .cornerRadius(10)
                    .padding(20)
            } placeholder: {
                Color.orange
            }
            
            Text(album.title)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(20)
                .foregroundColor(.white)
                .font(.system(size: 25))
            Spacer()
            
            ZStack {
                Rectangle()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.black)
                Image(systemName: "play.circle.fill")
                    .font(.system(size:70))
                    .foregroundColor(.green)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .padding(20)
           
        }
        .background(Color("Dark Grey"))
        //.frame(minHeight: 100)
        .cornerRadius(10)
        
        
        
    }
        
        
    
    struct AlbumView_Previews: PreviewProvider {
        static var previews: some View {
            AlbumView(album: Album(title: "Goodie Bag - Still Woozy", cover: "KSG Cover"))
        }
    }
}
