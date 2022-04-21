import SwiftUI

struct SignInView: View
{
    // Variables to store the user information
    @State var email: String = ""
    @State var password: String = ""
    
    // True means the user login information is correct so they can proceed to the next screen
    @State var canContinue: Bool = false
    
    var body: some View
    {
        NavigationView
        {
            ZStack
            {
                Color("BackgroundColor")
                // Navigation link with a empty view(so it doesn't show up)
                // When canContinue is true we load the next screen, the restaurant list
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
                        // As we are not using any database, we assigned a default username and password to login
                        // If they're correct we make canContinue true
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
                    
                    // Navigation link to the sign up screen
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
            // Executes when the screen loads and shows the splash screen on top of this view
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
