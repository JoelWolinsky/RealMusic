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
    
    @EnvironmentObject var viewModel: SignInViewModel
     
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
            
                    
                NavigationLink (destination: SignUpView()) {
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
    
    @EnvironmentObject var viewModel: SignInViewModel
     
    var body: some View {
        NavigationView {
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
               
                
                Button(action: {
                    viewModel.signUp(email: email, password: password)
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
            
        }

       
        
        
    }
    
    struct SignInView_Previews: PreviewProvider {
        static var previews: some View {
            SignInView()
        }
    }
}

