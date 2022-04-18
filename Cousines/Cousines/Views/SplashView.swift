//
//  ContentView.swift
//  Cousines
//
//  Created by Axel Gonzalez on 31/03/22.
//

import SwiftUI

struct SplashView: View
{
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
