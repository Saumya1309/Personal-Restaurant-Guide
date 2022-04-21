import SwiftUI

struct SplashView: View
{
    // When true we hide the splash screen elements, false means it's in progress, so we show the UI
    @State var finished = false
    
    var body: some View
    {
        
        ZStack
        {
            if !finished
            {
                Image("HomeBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
                VStack
                {
                    Text("Cuisines To Go")
                        .foregroundColor(.white)
                        .font(.system(size: 60))
                        .bold()
                        .padding(.bottom,200)
                }
            }
            
        }
        .onAppear{
            // Once the screen loads we add a two seconds delay to hide the splash screen
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                finished.toggle()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        SplashView()
    }
}
