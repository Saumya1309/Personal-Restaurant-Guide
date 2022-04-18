//
//  SignInView.swift
//  Cousines
//
//  Created by Axel Gonzalez on 31/03/22.
//

import SwiftUI

struct SignInView: View
{
    @State var email: String = ""
    @State var password: String = ""
    
    @State var canContinue: Bool = false
    
    var body: some View
    {
        NavigationView
        {
            ZStack
            {
                Color("BackgroundColor")
                NavigationLink(destination: RestaurantListView(), isActive: $canContinue) { EmptyView() }
                
                
                VStack
                {
                    Spacer()
                    
                    VStack
                    {
                        Text("Welcome")
                            .font(.title2)
                            .padding(.bottom,5)
                        
                        Text("Cuisines to go is one of the best restaurant guide in Canada")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                    
                    VStack
                    {
                        TextField("Email", text: $email)
                            .frame(height: 50)
                            .padding(.horizontal, 6)
                            .background(.white)
                        
                        TextField("Password", text: $password)
                            .frame(height: 50)
                            .padding(.horizontal, 6)
                            .background(.white)
                    }
                    .padding(.horizontal,20)
                    
                    Spacer()
                    
                    Button {
                        if email == "Admin" && password == "1234"
                        {
                            canContinue = true
                        }
                    } label: {
                        Text("Sign in")
                            .frame(width: 250, height: 50)
                            .foregroundColor(.white)
                            .background(Color("AccentColor"))
                            .cornerRadius(16)
                    }
                    
                    Spacer()

                    NavigationLink(destination: SignUpView(), label: {
                        Text("Don't have an account? Sign Up")
                            .foregroundColor(.accentColor)
                            .padding()
                    })
                    
                    Spacer()
                }
            }
            .edgesIgnoringSafeArea(.all)
            .navigationTitle("Sign In")
            .navigationBarTitleDisplayMode(.inline)
        }
        .overlay {
            SplashView()
                .animation(.spring())
        }
    }
}

struct SignInView_Previews: PreviewProvider
{
    static var previews: some View
    {
        SignInView()
    }
}
