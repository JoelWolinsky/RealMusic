//
//  HomeView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 03/10/2022.
//

import FirebaseAuth

// import FirebaseCore
import FirebaseFirestore
import SwiftUI
import SwiftUITrackableScrollView

// This is the main screen of the app which displays the users feed consisting of posts made by other users
struct HomeView: View {
    @EnvironmentObject var signInModel: SignInViewModel
    @State var welcomeMessage: Bool
    @Binding var showWebView: Bool
    @ObservedObject var createPostModel = CreatePostViewModel(uid: "cY51kdkZdHhq6r3lTAd2")
    @ObservedObject var getRequest = SpotifyAPI()
    @ObservedObject var emojiCatalogue = EmojiCatalogue()
    @ObservedObject var feedViewModel = FeedViewModel()
    @ObservedObject var friendsViewModel = FriendsViewModel()
    @ObservedObject var blurModel = BlurModel(blur: 0)
    @State var currentlyPlaying = SpotifySong(songID: "", title: "", artist: "", uid: "", cover: "")
    @State var friendsToggle = true
    @State var searchToggle = false
    @State var profilePic = String()
    @State var userViewModel = UserViewModel()
    @State var showProfileView = true
    @State var longPress = 0
    @State var chosenPostID = ""
    @State var chosenEmoji = Emoji(emoji: "", description: "", category: "")
    @State var emojiSelected = false
    @State var blur = 0
    @State var disableScroll = 1000
    @State var showEmojiLibrary = false
    @State var showPicker = false
    @State var currentSongPosted = false
    @State private var scrollViewContentOffset = CGFloat(0)
    @State private var myFriends = true
    @State var friendNames = [String]()
    @State var showUserDropDown = false
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    let userUid = "cY51kdkZdHhq6r3lTAd2"

    var body: some View {
        ScrollViewReader { (proxy: ScrollViewProxy) in
            ZStack {
                NavigationView {
                    ZStack {
                        if myFriends {
                            TrackableScrollView(.vertical, showIndicators: false, contentOffset: $scrollViewContentOffset) {
                                VStack {
                                    VStack {
                                        if feedViewModel.todaysPost.count > 0 {
                                            YourPostView(post: feedViewModel.todaysPost[0], reactionViewModel: ReactionViewModel(id: feedViewModel.todaysPost[0].id ?? ""), userViewModel: userViewModel)
                                                .frame(maxWidth: 200, maxHeight: 150)
                                                .id(0)
                                        }
                                        Text("Currently Listening To:")
                                            .foregroundColor(.white)
                                            .blur(radius: CGFloat(blur))
                                        VStack {
                                            CurrentlyPlayingView(song: currentlyPlaying, createPostModel: createPostModel, searchToggle: $searchToggle, currentSongPosted: $currentSongPosted)
                                        }
                                        .frame(width: 350, height: 100)
                                        .padding(.bottom, 40)
                                        .blur(radius: CGFloat(blur))
                                    }
                                    .padding(.top, 110)
                                    ZStack {
                                        Text("No post today yet. Try checking out the Discovery page.")
                                            .foregroundColor(.white)
                                            .padding(20)
                                            .frame(maxWidth: 300)
                                            .multilineTextAlignment(.center)
                                            .background(.thinMaterial)
                                            .cornerRadius(5)
                                        LazyVStack {
                                            ForEach(feedViewModel.posts) { post in
                                                if friendsViewModel.friendsNames.contains(post.username ?? "") {
                                                    PostView(post: post, reactionViewModel: ReactionViewModel(id: post.id ?? ""), longPress: $longPress, chosenPostID: $chosenPostID, blur: $blur, disableScroll: $disableScroll, emojiCatalogue: emojiCatalogue, showPicker: showPicker, userViewModel: userViewModel, scrollViewContentOffset: $scrollViewContentOffset, showUserDropDown: $showUserDropDown, following: true)
                                                        .id(post.id)
                                                }
                                            }
                                        }
                                        .background(.black)
                                        .onChange(of: chosenPostID) { _ in
                                            withAnimation {
                                                proxy.scrollTo(chosenPostID, anchor: .center)
                                            }
                                        }
                                    }
                                }
                                .refreshable {
                                    feedViewModel.fetchPosts()
                                    getRequest.getCurrentPlaying { result in
                                        switch result {
                                        case let .success(data):
                                            let song = data[0]
                                            currentlyPlaying = SpotifySong(id: song.id, songID: song.songID, title: song.title, artist: song.artist, uid: song.uid, cover: song.cover, preview_url: song.preview_url)
                                        case let .failure(error):
                                            print(error)
                                        }
                                    }
                                    userViewModel.fetchProfilePic(uid: (UserDefaults.standard.value(forKey: "uid") ?? "placeholder") as! String) { profile in
                                        profilePic = profile
                                    }
                                }
                            }
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
                                        // TODO: check if this is needed
                                        Text("")
                                            .frame(maxHeight: 1)
                                            .id(0)
                                        ForEach(feedViewModel.posts) { post in
                                            if !friendsViewModel.friendsNames.contains(post.username ?? "") {
                                                PostView(post: post, reactionViewModel: ReactionViewModel(id: post.id ?? ""), longPress: $longPress, chosenPostID: $chosenPostID, blur: $blur, disableScroll: $disableScroll, emojiCatalogue: emojiCatalogue, showPicker: showPicker, userViewModel: userViewModel, scrollViewContentOffset: $scrollViewContentOffset, showUserDropDown: $showUserDropDown, following: false)
                                                    .id(post.id)
                                            }
                                        }
                                    }
                                    .background(.black)
                                    .padding(.top, 100)
                                    .onChange(of: chosenPostID) { _ in
                                        withAnimation {
                                            proxy.scrollTo(chosenPostID, anchor: .center)
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .simultaneousGesture(DragGesture(minimumDistance: CGFloat(disableScroll)))
                            }
                            .zIndex(1)
                            .transition(.slideRight)
                        }
                        VStack {
                            Rectangle()
                                .fill(LinearGradient(colors: [.black, .black.opacity(0.0)],
                                                     startPoint: .top,
                                                     endPoint: .center))
                                .frame(height: 150)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .offset(y: -60)
                        VStack {
                            HStack {
                                Button {
                                    withAnimation {
                                        friendsToggle.toggle()
                                    }
                                } label: {
                                    Image(systemName: "person.2.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                }
                                Spacer()
                                Button {
                                    if blur == 0 {
                                        withAnimation {
                                            proxy.scrollTo(0, anchor: .center)
                                        }
                                    }
                                } label: {
                                    Text("RealMusic")
                                        .foregroundColor(.white)
                                        .font(.system(size: 25))
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
                                            case let .success(image):
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)

                                            case let .failure(error):
                                                Rectangle()
                                                    .background(.black)
                                                    .foregroundColor(.black)
                                                    .frame(width: 30, height: 30)
                                            case .empty:
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
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                            .blur(radius: CGFloat(blurModel.blur))
                            HStack {
                                Button {
                                    withAnimation {
                                        myFriends = true
                                    }
                                } label: {
                                    Text("Following")
                                        .foregroundColor(myFriends ? .white : Color("Grey 1"))
                                        .font(.system(size: 17))
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
                                        .foregroundColor(!myFriends ? .white : Color("Grey 1"))
                                        .font(.system(size: 17))
                                        .fontWeight(.bold)
                                        .blur(radius: 0)
                                }
                            }
                        }
                        .frame(maxHeight: .infinity, alignment: .top)
                        .zIndex(2)
                    }
                    .background(.black)
                    .onAppear(perform: {
                        // TODO: is this needed
                        getRequest.search(input: "Ivy") { result in
                            switch result {
                            case let .success(data):
                                print("success \(data)")
                            case let .failure(error):
                                print()
                            }
                        }
                        getRequest.getCurrentPlaying { result in
                            switch result {
                            case let .success(data):
                                let song = data[0]
                                currentlyPlaying = SpotifySong(id: song.id, songID: song.songID, title: song.title, artist: song.artist, uid: song.uid, cover: song.cover, preview_url: song.preview_url)
                            case let .failure(error):
                                print("fail recent")
                            }
                        }
                        userViewModel.fetchProfilePic(uid: (UserDefaults.standard.value(forKey: "uid") ?? "placeholder") as! String) { profile in
                            profilePic = profile
                        }
                    })
                }
                if friendsToggle {
                    AddFriendsView(friendsViewModel: friendsViewModel, friendsToggle: $friendsToggle)
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
            .onChange(of: searchToggle, perform: { _ in
                if searchToggle == false {
                    feedViewModel.fetchPosts()
                    getRequest.getCurrentPlaying { result in
                        switch result {
                        case let .success(data):
                            let song = data[0]
                            currentlyPlaying = SpotifySong(id: song.id, songID: song.songID, title: song.title, artist: song.artist, uid: song.uid, cover: song.cover, preview_url: song.preview_url)
                        case let .failure(error):
                            print("fail recent")
                        }
                    }
                }
            })
            .onChange(of: currentSongPosted, perform: { _ in
                if searchToggle == false {
                    feedViewModel.fetchPosts()
                    feedViewModel.fetchMyPosts()
                }
            })
            .onChange(of: welcomeMessage, perform: { _ in
                userViewModel.fetchProfilePic(uid: (UserDefaults.standard.value(forKey: "uid") ?? "placeholder") as! String) { profile in
                    profilePic = profile
                }
            })
            .onChange(of: showWebView, perform: { _ in
                feedViewModel.fetchPosts()
                feedViewModel.fetchMyPosts()
                getRequest.getCurrentPlaying { result in
                    switch result {
                    case let .success(data):
                        let song = data[0]
                        currentlyPlaying = SpotifySong(id: song.id, songID: song.songID, title: song.title, artist: song.artist, uid: song.uid, cover: song.cover, preview_url: song.preview_url)
                    case let .failure(error):
                        print("fail recent")
                    }
                }
            })
            .background(.black)
            .environment(\.colorScheme, .dark)
        }
        .onAppear(perform: {
            feedViewModel.fetchMyPosts()
            friendsToggle = false
            showProfileView = false
        })
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            UIApplication.shared.applicationIconBadgeNumber = 0
            self.getRequest.token = UserDefaults.standard.value(forKey: "auth") ?? ""
            friendsViewModel.fetchFriends()
            feedViewModel.fetchMyPosts()
            SpotifyAPI.shared.checkTokenExpiry { result in
                switch result {
                case true:
                    showWebView = false
                    feedViewModel.fetchPosts()
                case false:
                    showWebView = true
                }
            }
            getRequest.getCurrentPlaying { result in
                switch result {
                case let .success(data):
                    let song = data[0]
                    currentlyPlaying = SpotifySong(id: song.id, songID: song.songID, title: song.title, artist: song.artist, uid: song.uid, cover: song.cover, preview_url: song.preview_url)
                case let .failure(error):
                    print("fail recent")
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
            feedViewModel.todaysPost = []
            feedViewModel.myPosts = []
            feedViewModel.posts = []
        }
        .onReceive(timer) { _ in
            getRequest.getCurrentPlaying { result in
                switch result {
                case let .success(data):
                    let song = data[0]
                    self.currentlyPlaying = SpotifySong(id: song.id, songID: song.songID, title: song.title, artist: song.artist, uid: song.uid, cover: song.cover, preview_url: song.preview_url)
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
}
