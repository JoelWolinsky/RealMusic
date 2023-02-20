//
//  ContentView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 03/10/2022.
//

import SwiftUI
//import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SwiftUITrackableScrollView

// This is the main screen of the app which displays the users feed consisting of posts made by other users
struct HomeView: View {
    
    //@StateObject var feedViewModel: FeedViewModel
        
    let userUid = "cY51kdkZdHhq6r3lTAd2"
    
    @ObservedObject var createPostModel = CreatePostViewModel(uid: "cY51kdkZdHhq6r3lTAd2")
    
    @ObservedObject var getRequest = SpotifyAPI()
    
    @EnvironmentObject var signInModel: SignInViewModel
    
    @ObservedObject var emojiCatalogue = EmojiCatalogue()
    
    @ObservedObject var feedViewModel = FeedViewModel()
    
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
    
    @Binding var showWebView: Bool
    
    @State private var scrollViewContentOffset = CGFloat(0)
    
    @State private var myFriends = true
    
    @ObservedObject var friendsViewModel = FriendsViewModel()
    
    @State var friendNames = [String]()
    
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
   
    @State var showUserDropDown = false

    //@State var token = UserDefaults.standard.value(forKey: "authorization") ?? ""



    var body: some View {
        ScrollViewReader { (proxy: ScrollViewProxy) in
            ZStack {
                //var posts = [Post(title: "This is a test", userID: "This userID test", username: "Woli")]
                NavigationView {
                    ZStack {
                        if myFriends {
                            TrackableScrollView(.vertical, showIndicators: false, contentOffset: $scrollViewContentOffset) {
                                VStack {
                                    VStack {
                                        //if feedViewModel.myPosts.count == 0 {
//                                        if (UserDefaults.standard.value(forKey: "authorization") != nil) {
//                                            Text(UserDefaults.standard.value(forKey: "authorization") as! String)
//                                                .foregroundColor(.purple)
//                                        }
                                        if (feedViewModel.myPosts.count > 0) {
                                            YourPostView(post: feedViewModel.myPosts[0], reactionViewModel: ReactionViewModel(id: feedViewModel.myPosts[0].id ?? ""),userViewModel: userViewModel)
                                                .frame(maxWidth: 200, maxHeight: 150)
                                                .id(0)
                                            //.offset(y: -120)
                                        }

                                        Text("Currently Listening To:")
                                            .foregroundColor(.white)
                                            .blur(radius:CGFloat(blur))

                                        VStack {

                                            CurrentlyPlayingView(song: currentlyPlaying, createPostModel: createPostModel, searchToggle: $searchToggle, currentSongPosted: $currentSongPosted)
                                        }
                                        .frame(width: 350, height: 100)
                                        //.padding(.top, 40)
                                        .padding(.bottom, 40)
                                        .blur(radius:CGFloat(blur))
                                        //.offset(y:100)
                                    }
                                    .padding(.top, 110)
                                    
                                    //.frame(maxHeight: 300)
                                    ZStack {
                                        
                                        Text("No post today yet. Try checking out the Discovery page.")
                                            .foregroundColor(.white)
                                            .padding(20)
                                            .frame(maxWidth: 300)
                                            .multilineTextAlignment(.center)

                                            
                                            .background(.thinMaterial)
                                            .cornerRadius(5)
                                        //ScrollViewReader { (proxy: ScrollViewProxy) in
                                            
                                            LazyVStack {
                                                ForEach(feedViewModel.posts) { post in
                                                    if friendsViewModel.friendsNames.contains(post.username ?? "") {
                                                        PostView(post: post, reactionViewModel: ReactionViewModel(id: post.id ?? ""), longPress: $longPress, chosenPostID: $chosenPostID, blur: $blur, disableScroll: $disableScroll, emojiCatalogue: emojiCatalogue, showPicker: showPicker, userViewModel: userViewModel, scrollViewContentOffset: $scrollViewContentOffset, showUserDropDown : $showUserDropDown)
                                                            .id(post.id)
                                                    }
                                                }
                                                
                                                
                                            }
                                            .background(.black)
                                            .onChange(of: chosenPostID) { target in
                                                withAnimation {
                                                    proxy.scrollTo(chosenPostID, anchor: .center)
                                                    print("chosen id changed to \(chosenPostID)")
                                                    //chosenPostID = ""
                                                }
                                                
                                                //.offset(y: -70)
                                            }
                                        //}
                                    
                                }
                            }
                            //.simultaneousGesture(DragGesture(minimumDistance: CGFloat(disableScroll)))
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
                            
                                
                            }
                            //.zIndex(1)
                            .transition(.slideLeft)
                            .simultaneousGesture(DragGesture(minimumDistance: CGFloat(disableScroll)))
                            
                        } else {
                            ZStack {
                                Text("No post today yet")
                                    .foregroundColor(.white)
                                    .padding(20)
                                    .background(.thinMaterial)
                                    .cornerRadius(5)
                                
                                TrackableScrollView(.vertical, showIndicators: false, contentOffset: $scrollViewContentOffset) {
                                    LazyVStack {
                                        Text("")
                                            .frame(maxHeight: 1)
                                            .id(0)
                                        ForEach(feedViewModel.posts) { post in
                                            if !friendsViewModel.friendsNames.contains(post.username ?? "") {
                                                PostView(post: post, reactionViewModel: ReactionViewModel(id: post.id ?? ""), longPress: $longPress, chosenPostID: $chosenPostID, blur: $blur, disableScroll: $disableScroll, emojiCatalogue: emojiCatalogue, showPicker: showPicker, userViewModel: userViewModel, scrollViewContentOffset: $scrollViewContentOffset, showUserDropDown : $showUserDropDown)
                                                    .id(post.id)

                                                
                                            }
                                            
                                            
                                            //.id(post.id)
                                        }
                                    }
                                    .background(.black)
                                    .padding(.top, 100)
                                    .onChange(of: chosenPostID) { target in
                                        withAnimation {
                                            proxy.scrollTo(chosenPostID, anchor: .center)
                                            print("chosen id changed to \(chosenPostID)")
                                            //chosenPostID = ""
                                        }
                                        
                                        //.offset(y: -70)
                                    }



                                }
                                .frame(maxWidth: .infinity)
                                .zIndex(1)
                                .transition(.slideRight)
                                .simultaneousGesture(DragGesture(minimumDistance: CGFloat(disableScroll)))

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
                        VStack {
                            
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
                                    if blur == 0 {
                                        withAnimation {
                                            proxy.scrollTo(0, anchor: .center)
                                        }
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
                                    if let url = URL(string: profilePic) {
                                        CacheAsyncImage(url: url) { phase in
                                            switch phase {
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                
                                            case .failure(let error):
                                                //                    //print(error)
                                                Rectangle()
                                                    .background(.black)
                                                    .foregroundColor(.black)
                                                    .frame(width: 30, height: 30)
                                            case .empty:
                                                // preview loader
                                                Rectangle()
                                                    .background(.black)
                                                    .foregroundColor(.black)
                                                    .frame(width: 30, height: 30)
                                                
                                            }
                                        }
                                        .frame(width: 30, height: 30)
                                        .cornerRadius(15)
                                    } else {
                                        Rectangle()
                                            .background(.black)
                                            .foregroundColor(.black)
                                            .frame(width: 30, height: 30)
                                    }
                                }
                            }
                            //.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                            .blur(radius:CGFloat(blurModel.blur))
                            
                            
                            HStack {
                                Button {
                                    withAnimation {
                                        myFriends = true
                                    }
                                } label: {
                                    Text("My Friends")
                                        .foregroundColor(.white)
                                        .font(.system(size:17))
                                        .fontWeight(.bold)
                                        .blur(radius: 0)
                                }
                                .padding(.trailing, 10)
                                
                                Button {
                                    withAnimation {
                                        myFriends = false
                                    }
                                } label: {
                                    Text("Discovery")
                                        .foregroundColor(.white)
                                        .font(.system(size:17))
                                        .fontWeight(.bold)
                                        .blur(radius: 0)
                                }
                            }
                            //.frame(maxHeight: .infinity, alignment: .top)
                        }
                        .frame(maxHeight: .infinity, alignment: .top)
                        .zIndex(2)

                        
                        
                        
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
                    feedViewModel.fetchMyPosts()
                    
                    //feedViewModel.fetchReactions()
                }
            })
            .onChange(of: welcomeMessage, perform: { value in
                userViewModel.fetchProfilePic(uid: (UserDefaults.standard.value(forKey: "uid") ?? "placeholder") as! String ) { profile in
                    print("fetching profile for \(profile)")
                    profilePic = profile
//                    feedViewModel.fetchMyPosts()
//                    feedViewModel.fetchPosts()

                }
                
            })
            .onChange(of: showWebView, perform: { value in
                print("show web view has changed token is: ", UserDefaults.standard.value(forKey: "auth"))
                //feedViewModel.fetchPosts()

                //feedViewModel.fetchMyPosts()
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

                
            })
           
           
        
            

            
//            .onChange(of: ("\(UserDefaults.standard.value(forKey: "token"))") ?? "", perform: { value in
//                print("Token changed")
//                feedViewModel.fetchMyPosts()
//                feedViewModel.fetchPosts()
//
//            })
            
            .background(.black)
            .environment(\.colorScheme, .dark)
            
        }
        .onAppear(perform: {
            feedViewModel.fetchMyPosts()
            print("my post length \(feedViewModel.myPosts.count)")
            //feedViewModel.fetchPosts()

        })
        
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            UIApplication.shared.applicationIconBadgeNumber = 0
            
            print(" App is active token is: ", UserDefaults.standard.value(forKey: "auth"))
            
            self.getRequest.token  = UserDefaults.standard.value(forKey: "auth") ?? ""
            //feedViewModel.fetchPosts()

            //feedViewModel.fetchMyPosts()
            
            SpotifyAPI.shared.checkTokenExpiry { (result) in
                switch result {
                    case true:
                    print("aaaa token valid ")
                    showWebView = false
                    feedViewModel.fetchPosts()
                    //createPostModel.createPost(post: data[0])

                    case false:
                    print("aaaa token expired")
                    showWebView = true
                    }
                }
            
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
        .onReceive(timer) { time in
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
        
       
    }
    
    
//    struct HomeView_Previews: PreviewProvider {
//        static var previews: some View {
//            HomeView(feedViewModel: FeedViewModel())
//            
//        }
//    }
    
    
}


