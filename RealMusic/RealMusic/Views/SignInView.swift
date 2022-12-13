//
//  SignInView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 30/10/2022.
//

import Foundation
import SwiftUI

// View for users to sign in the app
struct SignInView: View {
    
    @State var email = ""
    @State var password = ""
    
    @StateObject var viewModel = SignInViewModel()
    @ObservedObject var userViewModel = UserViewModel()
    
    @State var signInResult = true

    
     
    var body: some View {
        NavigationView {
            VStack {
                Text("RealMusic")
                    .foregroundColor(.white)
                    .font(.system(size:40))
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
                   
                    viewModel.signIn(email: email, password: password) { (result) in
                        switch result{
                        case true:
                            signInResult = true
                        case false:
                            signInResult = false
                            
                        }
                    }
                    
                    
                }, label: {
                    Text("Sign In")
                        .frame(width: 100, height: 30)
                        .background(.green)
                        .cornerRadius(5)
                        .foregroundColor(.black)
                        .padding(10)
                    
                })
            
                VStack {
                    Text("Don't already have an account?")
                        .foregroundColor(Color("Grey 1"))
                    NavigationLink (destination: SignUpView(viewModel: viewModel)) {
                        Text("Create Account")
                        .foregroundColor(.green)                    }
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
    
    @StateObject var viewModel: SignInViewModel
    
    @State var inputNotValid = false
     
    var body: some View {
            VStack {
                Text("RealMusic")
                    .foregroundColor(.white)
                    .font(.system(size:40))
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
                    NavigationLink(destination: CreatUserNameView(viewModel: viewModel, email: email, password: password)) {
                        Text("Next")
                            .frame(width: 100, height: 30)
                            .background(.green)
                            .cornerRadius(5)
                            .foregroundColor(.black)
                            .padding(10)
                    }
                } else  {
                    Text("Next")
                        .frame(width: 100, height: 30)
                        .background(.green)
                        .cornerRadius(5)
                        .foregroundColor(.black)
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
struct CreatUserNameView: View {
    
    @State var username = ""

    @StateObject var viewModel: SignInViewModel
    
    var email: String
    var password: String
    
    @ObservedObject var userViewModel = UserViewModel()
    
    @State var nameTaken = false
    @State var errorMessage = ""
    
    @State private var isAddingPhoto = false

    @State var profilePicture = String()

    var body: some View {
        VStack {
            Text("RealMusic")
                .foregroundColor(.white)
                .font(.system(size:40))
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            Button {
                    isAddingPhoto = true
                } label: {
                    HStack {
                        Text("Upload Profile Picture")
                            .foregroundColor(.white)
                        
                        Image(systemName: "plus")
                            .foregroundColor(.green)
                    }
                }
                .padding(.bottom, 10)

            Text("Enter Your Username")
                .foregroundColor(.white)
            
            VStack {
                TextField("", text: $username)
                    .placeholder(when: username.isEmpty) {
                        Text("Username").foregroundColor(.gray)
                    }
                    .background(.white)
                    .cornerRadius(3)
                    .foregroundColor(.black)
                
                Text(String(errorMessage) ?? "")
                    .foregroundColor(.red)

            }
            .frame(maxWidth: 300)
            .padding(10)
              
                Button(action: {
                    print("username \(username)")
                    print(viewModel.auth.currentUser?.uid)
                    
                    let uid = viewModel.auth.currentUser?.uid ?? ""
 
                    userViewModel.fetchUsers() { users in
                        self.nameTaken = false

                        print("print usernames")
                        for user in users {
                            print(user.username)
                            if username == user.username {
                                self.nameTaken = true
                                self.errorMessage = "Username is taken"
                                
                            }
                        }
                        
                        
                        print("name taken \(nameTaken)")
                        if nameTaken == false {
                            
  
                            userViewModel.fetchProfilePic(uid: uid) { profile in
                                print("this is the profile url \( profile)")
                                profilePicture = profile
                                
                                userViewModel.createUser(uid: uid, username: username, profilePic: profilePicture ?? "no profile pic")
                                viewModel.signedIn = true
                                viewModel.welcomeMessage = true
                            }
       
                           

                        }
                        //nameTaken = true
                    }
                    
                    //print("name taken \(nameTaken)")

                    
                    //viewModel.signedIn = true
                    
                    
                }, label: {
                    Text("Sign Up")
                        .frame(width: 100, height: 30)
                        .background(.green)
                        .cornerRadius(5)
                        .foregroundColor(.black)
                        .padding(10)

                })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .onAppear(perform: {
            // create user using inputs from previous view
            viewModel.signUp(email: email, password: password)})
        .sheet(isPresented: $isAddingPhoto) {
            PhotoPicker(isAddingPhoto: $isAddingPhoto)
                }
    }
}
