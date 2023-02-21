////
////  ChooseProfilePictureView.swift
////  RealMusic
////
////  Created by Joel Wolinsky on 14/12/2022.
////
//
//import Foundation
//import SwiftUI
//
//// View for user to choose there username
//struct ChooseProfileView: View {
//    
//    @State var username = ""
//
//    @StateObject var viewModel: SignInViewModel
//    
//    var email: String
//    var password: String
//    
//    @ObservedObject var userViewModel = UserViewModel()
//    
//    @State var nameTaken = false
//    @State var errorMessage = ""
//    
//    @State private var isAddingPhoto = false
//
//    @State var profilePicture = String()
//    
//    @State var selectedImageData: Data? = nil
//    
//    @State var showEmailError = false
//
//    var body: some View {
//        VStack {
//            Text("RealMusic")
//                .foregroundColor(.white)
//                .font(.system(size:40))
//                .fontWeight(.bold)
//                .padding(.bottom, 10)
//            
//            
//            
//            Button {
//                    isAddingPhoto = true
//                } label: {
//                    VStack {
//                        VStack {
//                            if let selectedImageData,
//                               let uiImage = UIImage(data: selectedImageData) {
//                                Image(uiImage: uiImage)
//                                    .resizable()
//                                    .scaledToFill()
//                                    .clipShape(Circle())
//
//                            }
//                            else {
//                                Circle()
//                                    .foregroundColor(Color("Grey 3"))
//                            }
//                        }
//                        .frame(maxWidth: 100, maxHeight: 100)
//
//                        HStack {
//                            //Text("Choose a Profile Picture")
//                            PhotoPicker(selectedImageData: $selectedImageData, isAddingPhoto: $isAddingPhoto)
//                                //.foregroundColor(.black)
//                                //.padding(5)
//                                //.background(.white)
//                                .frame(maxWidth: 200, maxHeight: 30)
//                                //.cornerRadius(5)
//                        }
//                    }
//                }
//                .padding(.bottom, 10)
//
//            Text("Enter a username")
//                .foregroundColor(.white)
//            
//            VStack {
//                TextField("", text: $username)
//                    .placeholder(when: username.isEmpty) {
//                        Text("Username").foregroundColor(.gray)
//                    }
//                    .background(.white)
//                    .cornerRadius(3)
//                    .foregroundColor(.black)
//                    .autocorrectionDisabled(true)
//                
//                Text(String(errorMessage) ?? "")
//                    .foregroundColor(.red)
//            
//
//            }
//            .frame(maxWidth: 300)
//            .padding(10)
//            if username.count > 5  && selectedImageData != nil && viewModel.auth.currentUser?.uid != nil {
//                Button(action: {
//                    print("username \(username)")
//                    print(viewModel.auth.currentUser?.uid)
//                    
//                    let uid = viewModel.auth.currentUser?.uid ?? ""
//                    
//                    userViewModel.fetchUsers() { users in
//                        self.nameTaken = false
//                        
//                        //print("print usernames")
//                        for user in users {
//                            //print(user.username)
//                            if username == user.username {
//                                self.nameTaken = true
//                                self.errorMessage = "Username is taken"
//                                
//                            }
//                        }
//                        
//                        print("name taken \(nameTaken)")
//                        if nameTaken == false {
//                            print("name taken = false")
//                            userViewModel.fetchProfilePic(uid: uid) { profile in
////                                print("this is the profile url \( profile)")
////                                profilePicture = profile
//                                userViewModel.createUser(uid: uid, username: username, profilePic: profilePicture ?? "no profile pic")
//                                viewModel.signedIn = true
//                                viewModel.welcomeMessage = true
//                            //}
//                            Task {
//                                let data = selectedImageData
//                                print("select photo")
//                                let storage = Storage.storage()
//                                let storageRef = storage.reference()
//                                // Create a reference to the file you want to upload
//                                let riversRef = storageRef.child("images/\(UserDefaults.standard.value(forKey: "uid")!).heic")
//                                print(UserDefaults.standard.value(forKey: "uid"))
//                                // Upload the file to the path "images/rivers.jpg"
//                                let uploadTask = riversRef.putData(data!, metadata: nil) { (metadata, error) in
//                                    guard let metadata = metadata else {
//                                        // Uh-oh, an error occurred
//                                        print(error)
//                                        //                              fatalError()
//                                        return
//                                    }
//                                    
//                                    // Metadata contains file metadata such as size, content-type.
//                                    let size = metadata.size
//                                    // You can also access to download URL after upload.
//                                    riversRef.downloadURL { (url, error) in
//                                        guard let downloadURL = url else {
//                                            // Uh-oh, an error occurred!
//                                            //  fatalError()
//                                            return
//                                        }
//                                    }
//                                }
//                            }
//
//                        }
//                    }
//                }, label: {
//                    Text("Sign Up")
//                        .frame(width: 100, height: 30)
//                        .background(.white)
//                        .cornerRadius(5)
//                        .foregroundColor(.black)
//                        .padding(10)
//                    
//                })
//            } else {
//                Button (action: {
//                    print("show email error")
//                    if selectedImageData == nil {
//                        self.errorMessage = "Please upload a profile picture"
//                    } else {
//                        if username.count > 5 {
//                            self.errorMessage = "Please go back and enter a valid email"
//
//                        } else {
//                            self.errorMessage = "Username must be at least 6 characters long"
//
//                        }
//
//                    }
//                }, label: {
//                    Text("Sign Up")
//                        .frame(width: 100, height: 30)
//                        .background(Color("Grey 3"))
//                        .cornerRadius(5)
//                        .foregroundColor(Color("Grey 1"))
//                        .padding(10)
//                    
//                })
//                //.disabled(true)
//            }
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(.black)
//        .onAppear(perform: {
//            // create user using inputs from previous view
//            viewModel.signUp(email: email, password: password)})
////        .sheet(isPresented: $isAddingPhoto) {
////            PhotoPicker(selectedImageData: $selectedImageData, isAddingPhoto: $isAddingPhoto)
////                }
//        .onChange(of: selectedImageData, perform: { value in
//            if selectedImageData != nil {
//                isAddingPhoto = false
//            }
//        })
//    }
//}
