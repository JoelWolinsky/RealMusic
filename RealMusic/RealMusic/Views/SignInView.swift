//
//  SignInView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 30/10/2022.
//

import FirebaseStorage
import Foundation
import PhotosUI
import SwiftUI

// View for users to sign in the app
struct SignInView: View {
    @State var email = ""
    @State var password = ""
    @StateObject var signInViewModel = SignInViewModel()
    @ObservedObject var userViewModel = UserViewModel()
    @State var signInResult = true
    
    var body: some View {
        NavigationView {
            VStack {
                Text("RealMusic")
                    .foregroundColor(.white)
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                Text("Sign In")
                    .foregroundColor(.white)
                VStack {
                    TextField("", text: $email)
                        .placeholder(when: email.isEmpty) {
                            Text("Email address").foregroundColor(.gray)
                        }
                        .background(.white)
                        .cornerRadius(3)
                        .foregroundColor(.black)
                    SecureField("", text: $password)
                        .placeholder(when: password.isEmpty) {
                            Text("Password").foregroundColor(.gray)
                        }
                        .background(.white)
                        .cornerRadius(3)
                        .foregroundColor(.black)
                    if signInResult == false {
                        Text("Either your email or password is incorrect")
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: 300)
                .padding(10)
                Button(action: {
                    signInViewModel.signIn(email: email, password: password) { result in
                        switch result {
                        case true:
                            signInResult = true
                        case false:
                            signInResult = false
                        }
                    }
                }, label: {
                    Text("Sign In")
                        .frame(width: 100, height: 30)
                        .background(.white)
                        .cornerRadius(5)
                        .foregroundColor(.black)
                        .padding(10)

                })
                VStack {
                    Text("Don't already have an account?")
                        .foregroundColor(Color("Grey 1"))
                    NavigationLink(destination: SignUpView(signInViewModel: signInViewModel)) {
                        Text("Create Account")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
        }
    }
    struct SignInView_Previews: PreviewProvider {
        static var previews: some View {
            SignInView()
        }
    }
}

// View for users to sign up
struct SignUpView: View {
    @State var email = ""
    @State var password = ""
    @StateObject var signInViewModel: SignInViewModel
    @State var inputNotValid = false

    var body: some View {
        VStack {
            Text("RealMusic")
                .foregroundColor(.white)
                .font(.system(size: 40))
                .fontWeight(.bold)
                .padding(.bottom, 10)
            Text("Create an Account")
                .foregroundColor(.white)
            VStack {
                TextField("", text: $email)
                    .placeholder(when: email.isEmpty) {
                        Text("Email address").foregroundColor(.gray)
                    }
                    .background(.white)
                    .cornerRadius(3)
                    .foregroundColor(.black)
                SecureField("", text: $password)
                    .placeholder(when: password.isEmpty) {
                        Text("Password").foregroundColor(.gray)
                    }
                    .foregroundColor(.black)
                    .background(.white)
                    .cornerRadius(3)
            }
            .frame(maxWidth: 300)
            .padding(10)
            Text("Please enter a valid email address and password. Passwords must be at least 6 characters long")
                .foregroundColor(inputNotValid ? .red : .black)
                .multilineTextAlignment(.center)
            if password.count > 5 {
                NavigationLink(destination: CreateUserNameView(signInViewModel: signInViewModel, email: email, password: password)) {
                    Text("Next")
                        .frame(width: 100, height: 30)
                        .background(.white)
                        .cornerRadius(5)
                        .foregroundColor(.black)
                        .padding(10)
                }
            } else {
                Text("Next")
                    .frame(width: 100, height: 30)
                    .background(Color("Grey 3"))
                    .cornerRadius(5)
                    .foregroundColor(Color("Grey 1"))
                    .padding(10)
                    .onTapGesture {
                        inputNotValid = true
                    }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
    }
    struct SignInView_Previews: PreviewProvider {
        static var previews: some View {
            SignInView()
        }
    }
}

// View for user to choose there username
struct CreateUserNameView: View {
    @State var username = ""
    @StateObject var signInViewModel: SignInViewModel
    var email: String
    var password: String
    @ObservedObject var userViewModel = UserViewModel()
    @State var nameTaken = false
    @State var errorMessage = ""
    @State private var isAddingPhoto = false
    @State var profilePicture = String()
    @State var selectedImageData: Data? = nil
    @State var showEmailError = false

    var body: some View {
        VStack {
            Text("RealMusic")
                .foregroundColor(.white)
                .font(.system(size: 40))
                .fontWeight(.bold)
                .padding(.bottom, 10)
            Button {
            } label: {
                VStack {
                    VStack {
                        if let selectedImageData,
                           let uiImage = UIImage(data: selectedImageData)
                        {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .foregroundColor(Color("Grey 3"))
                        }
                    }
                    .frame(maxWidth: 100, maxHeight: 100)
                    HStack {
                        PhotoPicker(selectedImageData: $selectedImageData, isAddingPhoto: $isAddingPhoto)
                            .frame(maxWidth: 200, maxHeight: 30)
                    }
                    .padding(5)
                }
            }
            .padding(.bottom, 30)
            Text("Enter a username")
                .foregroundColor(.white)
            VStack {
                TextField("", text: $username)
                    .placeholder(when: username.isEmpty) {
                        Text("Username").foregroundColor(.gray)
                    }
                    .background(.white)
                    .cornerRadius(3)
                    .foregroundColor(.black)
                    .autocorrectionDisabled(true)

                Text(String(errorMessage) ?? "")
                    .foregroundColor(.red)
            }
            .frame(maxWidth: 300)
            .padding(10)
            if username.count > 5 && selectedImageData != nil && signInViewModel.auth.currentUser?.uid != nil {
                Button(action: {
                    let uid = signInViewModel.auth.currentUser?.uid ?? ""
                    userViewModel.fetchUsers { users in
                        self.nameTaken = false
                        for user in users {
                            if username == user.username {
                                self.nameTaken = true
                                self.errorMessage = "Username is taken"
                            }
                        }
                        if nameTaken == false {
                            userViewModel.createUser(uid: uid, username: username, profilePic: profilePicture ?? "no profile pic")
                            signInViewModel.signedIn = true
                            signInViewModel.welcomeMessage = true
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
                        }
                    }
                }, label: {
                    Text("Sign Up")
                        .frame(width: 100, height: 30)
                        .background(.white)
                        .cornerRadius(5)
                        .foregroundColor(.black)
                        .padding(10)
                })
            } else {
                Button(action: {
                    if selectedImageData == nil {
                        self.errorMessage = "Please upload a profile picture"
                    } else {
                        if username.count > 5 {
                            self.errorMessage = "Please go back and enter a valid email"
                        } else {
                            self.errorMessage = "Username must be at least 6 characters long"
                        }
                    }
                }, label: {
                    Text("Sign Up")
                        .frame(width: 100, height: 30)
                        .background(Color("Grey 3"))
                        .cornerRadius(5)
                        .foregroundColor(Color("Grey 1"))
                        .padding(10)

                })
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .onAppear(perform: {
            // create user using inputs from previous view
            signInViewModel.signUp(email: email, password: password)
        })
        .onChange(of: selectedImageData, perform: { _ in
            if selectedImageData != nil {
                isAddingPhoto = false
            }
        })
    }
}
