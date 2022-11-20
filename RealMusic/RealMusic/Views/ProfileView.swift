//
//  ProfileView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 20/11/2022.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    
    @StateObject var signInModel: SignInViewModel
    
    @State var profilePic: URL
    
    @Binding var showProfileView: Bool
    
    var body: some View {
        
        VStack {
            
            Button {
                withAnimation {
                    showProfileView.toggle()
                }
            } label: {
                Text("Back")
                    .foregroundColor(.green)
                    .font(.system(size:20))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                AsyncImage(url: profilePic) { image in
                    image
                          .resizable()
                          .aspectRatio(contentMode: .fill)
                          
                } placeholder: {
                    Color.orange
                }
                .frame(width: 100, height: 100)
                .cornerRadius(50)
                .onTapGesture {
                    signInModel.signOut()
                    UserDefaults.resetStandardUserDefaults()
                    
                }
         
                Text(UserDefaults.standard.value(forKey: "username") as! String)
                    .foregroundColor(Color("Grey"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        
            Spacer()
            Button {
                signInModel.signOut()
                UserDefaults.resetStandardUserDefaults()
            } label: {
                Text("Sign out")
                    .foregroundColor(.orange)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            
            
        }
        .padding(30)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(.black)
//        .scaledToFill()
//        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

    }
}
