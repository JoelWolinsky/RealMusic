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
    
    @State var profilePic: String
    
    @Binding var showProfileView: Bool
    
    @ObservedObject var analyticsModel = AnalyticsModel()
    
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
            
            VStack {
                AsyncImage(url: URL(string: profilePic)) { image in
                    image
                          .resizable()
                          .aspectRatio(contentMode: .fill)
                          
                } placeholder: {
                    Color.orange
                }
                .frame(width: 100, height: 100)
                .cornerRadius(50)
                .padding( 20)
                
                VStack {
                    Text(UserDefaults.standard.value(forKey: "username") as! String)
                        .foregroundColor(Color("Grey"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 10)

                    Text("UID: " + (UserDefaults.standard.value(forKey: "uid") as? String ?? ""))
                        .foregroundColor(Color("Grey"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 10)


                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        
            Button {
                analyticsModel.fetchTopArtistsFromAPI() { (result) in
                    switch result {
                    case .success(let data):
                        analyticsModel.uploadToDB(items: data, rankingType: "Top Artists")
                    case .failure(let error):
                        print(error)
                    }
                }
            } label: {
                Text("Get Top Artists")
                    .foregroundColor(.orange)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            
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
