//
//  ContentView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 03/10/2022.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SwiftUITrackableScrollView

// This is the main screen of the app which displays the users feed consisting of posts made by other users
struct HomeView: View {
    
    @StateObject var feedViewModel: FeedViewModel
        
    let userUid = "cY51kdkZdHhq6r3lTAd2"
    
    @ObservedObject var createPostModel = CreatePostViewModel(uid: "cY51kdkZdHhq6r3lTAd2")
    
    @ObservedObject var getRequest = SpotifyAPI()
    
    @EnvironmentObject var signInModel: SignInViewModel
    
    @ObservedObject var emojiCatalogue = EmojiCatalogue()
    
    @State var currentlyPlaying = SpotifySong(songID: "", title: "", artist: "", uid: "", cover: "")
    
    @State var friendsToggle = false
    @State var searchToggle = false
    
    @State var profilePic = String()
    
    @State var userViewModel = UserViewModel()
    
    @State var showProfileView = false
    
    @State var longPress = 0
    
    @State var chosenPostID = ""

    @State var chosenEmoji = Emoji(emoji: "", description: "", category: "")
    @State var emojiSelected = false

    @State var blur = 0
    
    @ObservedObject var blurModel = BlurModel(blur: 0)
    
    @State var disableScroll = 1000
    
    @State var showEmojiLibrary = false
    
    @State var showPicker = false
    
    @State var currentSongPosted = false
    
    @State var welcomeMessage: Bool
    
    @State private var scrollViewContentOffset = CGFloat(0)


    var body: some View {
        ScrollViewReader { (proxy: ScrollViewProxy) in
            ZStack {
                //var posts = [Post(title: "This is a test", userID: "This userID test", username: "Woli")]
                NavigationView {
                    ZStack {
                        TrackableScrollView(.vertical, showIndicators: false, contentOffset: $scrollViewContentOffset) {
                            VStack{
                                HStack {
                                    Text("Currently Listening To:")
                                        .foregroundColor(.white)
                                        .blur(radius:CGFloat(blur))
                                    Spacer()
                                    
//                                    HStack {
//                                        Image(systemName: "magnifyingglass")
//                                        Text("Search")
//                                    }
//                                    .padding(10)
//                                    .foregroundColor(.white)
//                                    .background(Color("Grey 2"))
//                                    .cornerRadius(10)
//                                    .onTapGesture {
//                                        print("search")
//                                        withAnimation() {
//                                            searchToggle.toggle()
//                                        }
//
//                                    }
                                    
                                }
                                .offset(y: 40)
                                VStack {
                                    
                                    CurrentlyPlayingView(song: currentlyPlaying, createPostModel: createPostModel, searchToggle: $searchToggle, currentSongPosted: $currentSongPosted)
                                }
                                .frame(width: 350, height: 100)
                                .padding(.top, 40)
                                .padding(.bottom, 20)
                                .blur(radius:CGFloat(blur))
                                
                                
                                ForEach(feedViewModel.posts) { post in
                                    VStack {
                                        PostView(post: post, reactionViewModel: ReactionViewModel(id: post.id ?? ""), longPress: $longPress, chosenPostID: $chosenPostID, blur: $blur, disableScroll: $disableScroll, emojiCatalogue: emojiCatalogue, showPicker: showPicker, userViewModel: userViewModel, scrollViewContentOffset: $scrollViewContentOffset)
                                        
                                        
                                        
                                    }
                                    .id(post.id)
                                }
                            }
                            .padding()
                        }
                        .simultaneousGesture(DragGesture(minimumDistance: CGFloat(disableScroll)))
                        //.scrollDisabled(true)
                        //                        /.disableScrolling(disabled: disableScroll)
                        .refreshable {
                            print("Refreshing")
                            feedViewModel.fetchPosts()
                            //feedViewModel.fetchReactions()
                            
                            
                            getRequest.getCurrentPlaying() { (result) in
                                switch result {
                                case .success(let data) :
                                    print("success playing now \(data)")
                                    let song = data[0]
                                    currentlyPlaying = SpotifySong(id: song.id, songID: song.songID, title: song.title, artist: song.artist, uid: song.uid, cover: song.cover, preview_url: song.preview_url)
                                case .failure(let error) :
                                    print("fail recent")
                                    // print(error)
                                }
                            }
                            
                            userViewModel.fetchProfilePic(uid: (UserDefaults.standard.value(forKey: "uid") ?? "placeholder") as! String ) { profile in
                                print("fetching profile for \(profile)")
                                profilePic = profile
                            }
                            
                        }
                        .onChange(of: chosenPostID) { target in
                            withAnimation {
                                proxy.scrollTo(chosenPostID, anchor: .center)
                                chosenPostID = ""
                            }
                            
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
                            
                            Button {
                                withAnimation {
                                    friendsToggle.toggle()
                                    print("friendsToggle.showView \(friendsToggle)")
                                }
                            } label: {
                                Image(systemName: "person.2.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size:20))
                            }
                            
                            
                            Spacer()
                            //                        NavigationLink(destination: SearchView()) {
                            //                            Text("RealMusic")
                            //                                .foregroundColor(.white)
                            //                                .font(.system(size:25))
                            //                                .fontWeight(.bold)
                            //                        }
                            
                            Button {
                                withAnimation {
                                    proxy.scrollTo(feedViewModel.posts[0].id, anchor: .bottom)
                                }
                            } label: {
                                Text("RealMusic")
                                    .foregroundColor(.white)
                                    .font(.system(size:25))
                                    .fontWeight(.bold)
                                    .blur(radius: 0)
                            }
                            
                            Spacer()
                            
                            
                            Button {
                                withAnimation {
                                    showProfileView.toggle()
                                }
                            } label: {
                                AsyncImage(url: URL(string: profilePic)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                    
                                } placeholder: {
                                    Image("ProfilePicPlaceholder")
                                }
                                .frame(width: 30, height: 30)
                                .cornerRadius(15)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        .blur(radius:CGFloat(blurModel.blur))
                        
                        
                        
                        
                    }
                    .background(.black)
                    .onAppear(perform: {print(Date());
                        getRequest.search(input: "Ivy") { (result) in
                            switch result {
                            case .success(let data) :
                                print("success \(data)")
                                //createPostModel.createPost(post: data[0])
                                
                            case .failure(let error) :
                                print()
                            }
                        }
                        
                        getRequest.getCurrentPlaying() { (result) in
                            print("get currently pllay")
                            switch result {
                            case .success(let data) :
                                print("success playing now \(data)")
                                let song = data[0]
                                currentlyPlaying = SpotifySong(id: song.id, songID: song.songID, title: song.title, artist: song.artist, uid: song.uid, cover: song.cover, preview_url: song.preview_url)
                            case .failure(let error) :
                                print("fail recent")
                                // print(error)
                            }
                        }
                        
                        userViewModel.fetchProfilePic(uid: (UserDefaults.standard.value(forKey: "uid") ?? "placeholder") as! String ) { profile in
                            print("fetching profile for \(profile)")
                            profilePic = profile
                        }
                        
                    })
                }
                
                if friendsToggle {
                    AddFriendsView(friendsToggle: $friendsToggle)
                        .zIndex(1)
                        .transition(.slideLeft)
                        .ignoresSafeArea(.keyboard)
                    
                    
                }
                
                if searchToggle {
                    SearchView(searchToggle: $searchToggle)
                        .zIndex(1)
                        .transition(.slideRight)
                    
                    
                }
                
                
                if showProfileView {
                    ProfileView(signInModel: signInModel, profilePic: profilePic ?? "no profile", showProfileView: $showProfileView, feedViewModel: feedViewModel, splitByDate: SplitByDate(posts: feedViewModel.myPosts))
                        .zIndex(1)
                        .transition(.slideRight)
                    
                }
                
            }
            .onChange(of: searchToggle, perform: { value in
                
                if searchToggle == false {
                    print("Refreshing")
                    feedViewModel.fetchPosts()
                    //feedViewModel.fetchReactions()
                    
                    
                    getRequest.getCurrentPlaying() { (result) in
                        switch result {
                        case .success(let data) :
                            print("success playing now \(data)")
                            let song = data[0]
                            currentlyPlaying = SpotifySong(id: song.id, songID: song.songID, title: song.title, artist: song.artist, uid: song.uid, cover: song.cover, preview_url: song.preview_url)
                        case .failure(let error) :
                            print("fail recent")
                            // print(error)
                        }
                    }
                }
            })
            .onChange(of: currentSongPosted, perform: { value in
                
                if searchToggle == false {
                    print("Refreshing")
                    feedViewModel.fetchPosts()
                    //feedViewModel.fetchReactions()
                }
            })
            .onChange(of: welcomeMessage, perform: { value in
                userViewModel.fetchProfilePic(uid: (UserDefaults.standard.value(forKey: "uid") ?? "placeholder") as! String ) { profile in
                    print("fetching profile for \(profile)")
                    profilePic = profile
                }
                
            })
            
            .background(.black)
            .environment(\.colorScheme, .dark)
            
        }
//       
    }
    
    
//    struct HomeView_Previews: PreviewProvider {
//        static var previews: some View {
//            HomeView(feedViewModel: FeedViewModel())
//            
//        }
//    }
    
    
}


