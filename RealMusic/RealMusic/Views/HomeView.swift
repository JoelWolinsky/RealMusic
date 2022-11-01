//
//  ContentView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 03/10/2022.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct HomeView: View {
    
    @ObservedObject var viewModel = FeedViewModel()
        
    let userUid = "cY51kdkZdHhq6r3lTAd2"
    
    @ObservedObject var createPostModel = CreatePostViewModel(uid: "cY51kdkZdHhq6r3lTAd2")
    
    @ObservedObject var getRequest = SpotifyAPI()
    
    @EnvironmentObject var signInModel: SignInViewModel
    

    
    var body: some View {
        
        //var posts = [Post(title: "This is a test", userID: "This userID test", username: "Woli")]
        NavigationView {
            ZStack {
                
                ScrollView {
                    VStack{
                        ForEach(viewModel.posts) { post in
                            PostView(post: post)
                        }
                    }
                    .padding()
                }
                .refreshable {
                    print("Refreshing")
                    viewModel.fetchPosts()

                }
                
                VStack {
                    Rectangle()
                        .fill(LinearGradient(colors: [.black, .black.opacity(0.0)],
                                           startPoint: .top,
                                           endPoint: .center))
                        .frame(height: 150)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .offset(y:-60)
                
                HStack {
                    
                    Image(systemName: "person.2.fill")
                        .foregroundColor(.white)
                        .font(.system(size:20))
                    Spacer()
                    NavigationLink(destination: SearchView() ) {
                        Text("RealMusic")
                            .foregroundColor(.white)
                            .font(.system(size:25))
                            .fontWeight(.bold)
                    }
                        
                    Spacer()
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 30)
                        .onTapGesture {
                            signInModel.signOut()
                        }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                
                
            }
            .background(.black)
            .onAppear(perform: {print(Date());getRequest.search(input: "Ivy") { (result) in
                switch result {
                    case .success(let data) :
                    print("success \(data)")
                    //createPostModel.createPost(post: data[0])
                        
                    case .failure(let error) :
                        print()
                    }
                }
            })
        }
        
        
    
//    .overlay(LinearGradient(colors: [.orange, .black.opacity(0)],
//                                     startPoint: .top,
//                            endPoint: .center))
//    .disabled(true)
    }
    
    
    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            HomeView()
            
        }
    }
    
    
}

