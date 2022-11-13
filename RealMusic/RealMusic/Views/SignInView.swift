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
                    TextField("Email address", text: $email)
                        .background(.white)
                        .cornerRadius(3)
                    SecureField("Password", text: $password)
                        .background(.white)
                        .cornerRadius(3)
                }
                .frame(maxWidth: 300)
                .padding(10)
               
                
                Button(action: {
                    viewModel.signIn(email: email, password: password)
                    
                    
                }, label: {
                    Text("Sign In")
                        .frame(width: 100, height: 30)
                        .background(.green)
                        .cornerRadius(5)
                        .foregroundColor(.black)
                        .padding(10)
                    
                })
            
                    
                NavigationLink (destination: SignUpView(viewModel: viewModel)) {
                    Text("Create Account")
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
                    TextField("Email address", text: $email)
                        .background(.white)
                        .cornerRadius(3)
                    SecureField("Password", text: $password)
                        .background(.white)
                        .cornerRadius(3)
                }
                .frame(maxWidth: 300)
                .padding(10)
               
                NavigationLink(destination: CreatUserNameView(viewModel: viewModel, email: email, password: password)) {
                    Text("Next")
                        .frame(width: 100, height: 30)
                        .background(.green)
                        .cornerRadius(5)
                        .foregroundColor(.black)
                        .padding(10)
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


    var body: some View {
        VStack {
            Text("RealMusic")
                .foregroundColor(.white)
                .font(.system(size:40))
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            Text("Enter Your Username")
                .foregroundColor(.white)
            
            VStack {
                TextField("Username", text: $username)
                    .background(.white)
                    .cornerRadius(3)

            }
            .frame(maxWidth: 300)
            .padding(10)
              
                Button(action: {
                    print("username \(username)")
                    print(viewModel.auth.currentUser?.uid)
                    
                    let uid = viewModel.auth.currentUser?.uid ?? ""
                    
                    userViewModel.createUser(uid: uid, username: username)
                    
                    viewModel.signedIn = true
                    
                    
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
    }
}
