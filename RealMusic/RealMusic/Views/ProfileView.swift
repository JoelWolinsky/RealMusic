//
//  ProfileView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 20/11/2022.
//

import FirebaseStorage
import Foundation
import SwiftUI
import WebKit

struct ProfileView: View {
    @StateObject var signInModel: SignInViewModel
    @State var profilePic: String
    @Binding var showProfileView: Bool
    @ObservedObject var analyticsModel = AnalyticsModel()
    @StateObject var feedViewModel: FeedViewModel
    @State var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @ObservedObject var getDateModel = GetDateModel()
    @State var splitByDate: SplitByDate
    @State private var isAddingPhoto = false
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
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            VStack {
                Text("Profile")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                if let url = URL(string: profilePic) {
                    CacheAsyncImage(url: url) { phase in
                        switch phase {
                        case let .success(image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case let .failure(error):
                            Text("fail")
                        case .empty:
                            Color.black
                        }
                    }
                    .frame(width: 130, height: 130)
                    .cornerRadius(80)
                    .padding(20)
                }
                if UserDefaults.standard.value(forKey: "username") != nil {
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
                                                        case let .success(image):
                                                            image
                                                                .resizable()
                                                                .scaledToFill()
                                                                .cornerRadius(1)
                                                                .padding(.bottom, 5)

                                                        case let .failure(error):
                                                            Text("fail")
                                                        case .empty:
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
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            PhotoPicker(selectedImageData: $selectedImageData, isAddingPhoto: $isAddingPhoto)
                .onChange(of: selectedImageData, perform: { _ in
                    Task {
                        let data = selectedImageData
                        let storage = Storage.storage()
                        let storageRef = storage.reference()
                        // Create a reference to the file you want to upload
                        let riversRef = storageRef.child("images/\(UserDefaults.standard.value(forKey: "uid")!).heic")
                        // Upload the file to the path "images/rivers.jpg"
                        let uploadTask = riversRef.putData(data!, metadata: nil) { metadata, error in
                            guard let metadata = metadata else {
                                return
                            }
                            // Metadata contains file metadata such as size, content-type.
                            let size = metadata.size
                            // You can also access to download URL after upload.
                            riversRef.downloadURL { url, _ in
                                guard let downloadURL = url else {
                                    return
                                }
                            }
                        }
                    }
                })
            Button {
                UserDefaults.resetStandardUserDefaults()
                UserDefaults.standard.set(nil, forKey: "auth")
                // Clears cookies so that user is logged out of their Spotify account and it can't be accessed by the next user
                HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
                WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                    records.forEach { record in
                        WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                    }
                }
                signInModel.signOut()
            } label: {
                Text("Sign out")
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(30)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(.black)
        .onChange(of: showProfileView) { _ in
            gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
            splitByDate = SplitByDate(posts: feedViewModel.myPosts)
        }
    }
}
