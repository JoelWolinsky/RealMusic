//
//  ProfileView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 20/11/2022.
//

import Foundation
import SwiftUI
import WebKit

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
                    .foregroundColor(.white)
                    .font(.system(size:20))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                AsyncImage(url: URL(string: profilePic)) { image in
                    image
                          .resizable()
                          .aspectRatio(contentMode: .fill)
                          
                } placeholder: {
                    Color.black
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
                signInModel.signOut()
                UserDefaults.resetStandardUserDefaults()
                
                // Clears cookies so that user is logged out of their Spotify account and it can't be accessed by the next user
                HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
                WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                            records.forEach { record in
                                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                                print("[WebCacheCleaner] Record \(record) deleted")
                            }
                        }
                
            } label: {
                Text("Sign out")
                    .foregroundColor(.white)
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
