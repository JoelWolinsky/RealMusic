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
        HStack {
            Image(String(album.cover))
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .cornerRadius(10)
                //.padding(20)
            
            Text(album.title)
                .frame(maxHeight: 150, alignment: .top)
                .padding(20)
            Spacer()
           
        }
        .background(.blue)
        .cornerRadius(10)
        .padding(20)
    }
    
    struct AlbumView_Previews: PreviewProvider {
        static var previews: some View {
            AlbumView(album: Album(title: "Goodie Bag - Still Woozy", cover: "KSG Cover"))
        }
    }
}
