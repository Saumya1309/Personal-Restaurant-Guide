//
//  AboutUsView.swift
//  Cousines
//
//  Created by Axel Gonzalez on 31/03/22.
//

import SwiftUI

struct AboutUsView: View
{
    let users: [AboutUser] = [AboutUser(name: "Karan Sharma", id: 101196374, avatar: "placeholder"),
                              AboutUser(name: "Vatsal Bhimani", id: 101282605, avatar: "placeholder"),
                              AboutUser(name: "Saumyakumar Mistry", id: 101242624, avatar: "placeholder"),
                              AboutUser(name: "Vraj Soni", id: 101247932, avatar: "placeholder")]
    
    var body: some View
    {
        ZStack
        {
            Color("BackgroundColor")
            
            List
            {
                ForEach(0...3, id: \.self) {index in
                    AboutCell(user: users[index])
                }
            }
            .listStyle(SidebarListStyle())
        }
        .navigationTitle("About Us")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutUsView_Previews: PreviewProvider
{
    static var previews: some View
    {
        AboutUsView()
    }
}

struct AboutUser
{
    let name: String
    let id: Int
    let avatar: String
}

struct AboutCell: View
{
    let user: AboutUser
    
    var body: some View
    {
        ZStack
        {
            Color("White")
            
            HStack
            {
                VStack(alignment: .leading)
                {
                    Text(user.name)
                        .font(.title2)
                        .padding(.bottom, 10)
                    
                    Text(String(user.id))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(user.avatar)
                    .resizable()
                    .frame(width: 70, height: 70)
                    .background(Color("AccentColor"))
                
            }
            .padding()
        }
        .frame(height: 150)
    }
}
