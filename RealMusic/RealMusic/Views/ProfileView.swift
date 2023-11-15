//
//  ProfileView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 20/11/2022.
//

import Foundation
import SwiftUI
import WebKit
import FirebaseStorage

struct ProfileView: View {
    
    @StateObject var signInModel: SignInViewModel
    
    @State var profilePic: String
    
    @Binding var showProfileView: Bool
    
    @ObservedObject var analyticsModel = AnalyticsModel()
    
    @StateObject var feedViewModel: FeedViewModel
    
    @State var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()),GridItem(.flexible()), GridItem(.flexible())]
    
    @ObservedObject var getDateModel = GetDateModel()
    
    @State var splitByDate: SplitByDate
    
    @State private var isAddingPhoto = false
//
//    @State var profilePicture = String()
//
    @State var selectedImageData: Data? = nil
    
    
    
    
    var body: some View {
        
        VStack {
            
            Button {
                withAnimation {
                    showProfileView.toggle()
                }
            } label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    //.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                Text("Profile")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                if let url = URL(string: profilePic) {
                    CacheAsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                  .resizable()
                                  .aspectRatio(contentMode: .fill)
                            
                        case .failure(let error):
                            //                    //print(error)
                            Text("fail")
                        case .empty:
                            // preview loader
                            Color.black
                        }
                    }
                    .frame(width: 130, height: 130)
                    .cornerRadius(80)
                    .padding( 20)
                }
                
                


                if (UserDefaults.standard.value(forKey: "username") != nil) {
                    Text(UserDefaults.standard.value(forKey: "username") as! String)
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 10)
                } else {
                    Text("")
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 10)
                }
//                VStack {
//                    Text("UID: " + (UserDefaults.standard.value(forKey: "uid") as? String ?? ""))
//                        .foregroundColor(Color("Grey"))
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding(.bottom, 10)
//                }
                VStack {
                    Text("Memories")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 25))
                    ScrollView {
                        VStack {
                            ForEach(splitByDate.sections) { section in
                                VStack {
                                    Text("\(getDateModel.getMonthYear(datePosted: section.date))")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    LazyVGrid(columns: gridItemLayout) {
                                        ForEach(section.occurrences) { post in
                                            ZStack {
                                                if let url = URL(string: post.cover ?? "") {
                                                    CacheAsyncImage(url: url) { phase in
                                                        switch phase {
                                                        case .success(let image):
                                                            image
                                                                .resizable()
                                                                .scaledToFill()
                                                                .cornerRadius(1)
                                                                .padding(.bottom, 5)
                                                            
                                                        case .failure(let error):
                                                            //                    //print(error)
                                                            Text("fail")
                                                        case .empty:
                                                            // preview loader
                                                            Rectangle()
                                                                .scaledToFill()
                                                                .cornerRadius(1)
                                                                .padding(.bottom, 5)
                                                                .foregroundColor(.black)
                                                        }
                                                    }
                                                }
                                                Text("\(getDateModel.getDay(datePosted: post.datePosted))")
                                                    .foregroundColor(.white)
                                                
                                            }
                                            
                                        }
                                    }
                                }
                            }

                            //
                            //                        ForEach(feedViewModel.myPosts) { post in
                            //                            ZStack {
                            //                                VStack {
                            //
                            ////                                    Text("\(getDateModel.getDay(datePosted: post.datePosted))")
                            ////                                        .foregroundColor(.white)
                            ////                                    Text("\(getDateModel.getMonth(datePosted: post.datePosted))")
                            ////                                        .foregroundColor(.white)
                            //                                }
                            ////                                post.datePosted
                            ////                                formatter.string(from: post.datePosted)
                            ////                                let formatter = DateFormatter()
                            ////                                formatter.dateFormat = "dd MMM yyyy HH:mm:ss"
                            ////                                print(formatter.string(from: Date()))
                            //                            }
                            //                        }
                        }
                        
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        
            
            PhotoPicker(selectedImageData: $selectedImageData, isAddingPhoto: $isAddingPhoto)
                .onChange(of: selectedImageData, perform: { data in
                    
                          
                                Task {
                                    let data = selectedImageData
                                    print("select photo")
                                    let storage = Storage.storage()
                                    let storageRef = storage.reference()
                                    // Create a reference to the file you want to upload
                                    let riversRef = storageRef.child("images/\(UserDefaults.standard.value(forKey: "uid")!).heic")
                                    print(UserDefaults.standard.value(forKey: "uid"))
                                    // Upload the file to the path "images/rivers.jpg"
                                    let uploadTask = riversRef.putData(data!, metadata: nil) { (metadata, error) in
                                        guard let metadata = metadata else {
                                            // Uh-oh, an error occurred
                                            print(error)
                                            //                              fatalError()
                                            return
                                        }
                                        
                                        // Metadata contains file metadata such as size, content-type.
                                        let size = metadata.size
                                        // You can also access to download URL after upload.
                                        riversRef.downloadURL { (url, error) in
                                            guard let downloadURL = url else {
                                                // Uh-oh, an error occurred!
                                                //  fatalError()
                                                return
                                            }
                                        }
                                    }
                                }

                            
                        
                    
                })

            Button {
                UserDefaults.resetStandardUserDefaults()
                UserDefaults.standard.set(nil, forKey: "auth")
                //UserDefaults.standard.set(nil, forKey: "uid")


              


                // Clears cookies so that user is logged out of their Spotify account and it can't be accessed by the next user
                HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
                WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                            records.forEach { record in
                                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                                print("[WebCacheCleaner] Record \(record) deleted")
                            }
                        }
                signInModel.signOut()
                //UserDefaults.standard.set(nil, forKey: "username")

            } label: {
                Text("Sign out")
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            
            
        }
        .padding(30)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(.black)
        .onChange(of: showProfileView) { change in
            print("appear profile")
            gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()),GridItem(.flexible()), GridItem(.flexible())]
            splitByDate = SplitByDate(posts: feedViewModel.myPosts)

        }
//        .scaledToFill()
//        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

    }
    
}
