//
//  SignInView.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 27/10/2022.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: SignInViewModel
    
    var body: some View {
        
        VStack {
            if viewModel.signedIn {
                HomeView()
                    .environmentObject(viewModel)
                    
            } else {
                SignInView()
            }
            
        }.onAppear( perform: {
            viewModel.signedIn = viewModel.isSignedIn
            }
        )

    }
        
}

struct SignInView: View {
    
    @State var email = ""
    @State var password = ""
    
    @EnvironmentObject var viewModel: SignInViewModel
     
    var body: some View {
        NavigationView {
            VStack {
                Text("Sign In")
                
                TextField("Email address", text: $email)
                SecureField("Email address", text: $password)
                
                Button(action: {
                    viewModel.signIn(email: email, password: password)
                }, label: {
                    Text("Sign in")
                })
            
                    
                NavigationLink (destination: SignUpView()) {
                    Text("Create Account")
                }
            }
            
        }
       
        
        
    }
}

struct SignUpView: View {
    
    @State var email = ""
    @State var password = ""
    
    @EnvironmentObject var viewModel: SignInViewModel
     
    var body: some View {
        VStack {
            Text("Sign Up")
            
            TextField("Email address", text: $email)
            SecureField("Email address", text: $password)
            
            Button(action: {
                viewModel.signUp(email: email, password: password)
            }, label: {
                Text("Sign Up")
            })
        }
        
        
        
    }
}
