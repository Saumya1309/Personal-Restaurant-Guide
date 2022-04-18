//
//  SingUpView.swift
//  Cousines
//
//  Created by Axel Gonzalez on 31/03/22.
//

import SwiftUI

struct SignUpView: View
{
    @Environment(\.dismiss) var dismiss
    
    @State var email: String = ""
    @State var password: String = ""
    @State var repeatPassword: String = ""
    
    var body: some View
    {
        ZStack
        {
            Color("BackgroundColor")
            
            VStack
            {
                Spacer()
                
                VStack
                {
                    TextField("Email*", text: $email)
                        .frame(height: 50)
                        .padding(.horizontal, 6)
                        .background(.white)
                    
                    TextField("Password*", text: $password)
                        .frame(height: 50)
                        .padding(.horizontal, 6)
                        .background(.white)
                    
                    TextField("Repeat password*", text: $repeatPassword)
                        .frame(height: 50)
                        .padding(.horizontal, 6)
                        .background(.white)
                }
                .padding(.horizontal,20)
                
                Spacer()
                
                VStack
                {
                    Text("By proceeding you also agree to Terms of Service and Privacy Policy")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("Sign up")
                            .frame(width: 250, height: 50)
                            .foregroundColor(.white)
                            .background(Color("AccentColor"))
                            .cornerRadius(16)
                    }
                    
                    NavigationLink(destination: SignInView(), label: {
                        Button {
                            dismiss()
                        } label: {
                            Text("Already have an account? Sign in")
                                .padding()
                        }
                    })
                }
                .padding()
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationTitle("Sign Up")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SignUpView_Previews: PreviewProvider
{
    static var previews: some View
    {
        SignUpView()
    }
}
