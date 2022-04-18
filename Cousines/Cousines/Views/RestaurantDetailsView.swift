//
//  RestaurantDetailsView.swift
//  Cousines
//
//  Created by Axel Gonzalez on 31/03/22.
//

import SwiftUI
import UIKit
import MessageUI
import FBSDKShareKit
import FacebookShare

struct RestaurantDetailsView: View
{
    @State var name: String = ""
    @State var address: String = ""
    @State var description: String = ""
    @State var phone: String = ""
    @State var tags: String = ""
    
    @State var stars: Int = 1
    @State var tagsArray: [String] = ["","","","",""]
    
    @Binding var restaurant: Restaurant
    
    @State private var showSheet = false
    
    @State var result: Result<MFMailComposeResult, Error>? = nil
    
    var body: some View
    {
        ZStack
        {
            Color("BackgroundColor")
            
            VStack(spacing: 30)
            {
                VStack
                {
                    Image(restaurant.image)
                        .resizable()
                        .frame(width: 90, height: 90)
                }
                .frame(width: 400, height: 200)
                .background(Color("AccentColor"))
                
                HStack(spacing: 35)
                {
                    Button {
                        restaurant.stars = 1
                    } label: {
                        Image(systemName:  "star.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.yellow)
                    }
                    Button {
                        restaurant.stars = 2
                    } label: {
                        Image(systemName: restaurant.stars >= 2 ? "star.fill" : "star")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(restaurant.stars >= 2 ? .yellow : .accentColor)
                    }
                    Button {
                        restaurant.stars = 3
                    } label: {
                        Image(systemName: restaurant.stars >= 3 ? "star.fill" : "star")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(restaurant.stars >= 3 ? .yellow : .accentColor)
                    }
                    Button {
                        restaurant.stars = 4
                    } label: {
                        Image(systemName: restaurant.stars >= 4 ? "star.fill" : "star")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(restaurant.stars >= 4 ? .yellow : .accentColor)
                    }
                    Button {
                        restaurant.stars = 5
                    } label: {
                        Image(systemName: restaurant.stars >= 5 ? "star.fill" : "star")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(restaurant.stars >= 5 ? .yellow : .accentColor)
                    }
                }
                
                HStack
                {
                    NavigationLink(destination: PlaceView(restaurant: restaurant), label: {
                        Text("Get Directions")
                            .frame(width: 180, height: 45)
                            .foregroundColor(.white)
                            .background(Color("AccentColor"))
                            .cornerRadius(16)
                    })
                    
                    Menu
                    {
                        Button {
                            if MFMailComposeViewController.canSendMail()
                            {
                                showSheet = true
                            }
                            else
                            {
                                print("Error sending email check your device")
                            }
                            
                        } label: {
                            Text("Mail")
                        }
                    }label: {
                        Text("Share")
                            .frame(width: 180, height: 45)
                            .foregroundColor(.white)
                            .background(Color("AccentColor"))
                            .cornerRadius(16)
                    }
                }
                
                VStack(alignment: .leading)
                {
                    TextField("Restaurant Name", text: $restaurant.name)
                        .frame(height: 50)
                        .padding(.horizontal, 6)
                        .background(.white)
                    
                    TextField("Address", text: $restaurant.address)
                        .frame(height: 50)
                        .padding(.horizontal, 6)
                        .background(.white)
                    
                    TextField("Description", text: $restaurant.description)
                        .frame(height: 100)
                        .padding(.horizontal, 6)
                        .background(.white)
                    
                    TextField("Phone number", text: $restaurant.phone)
                        .frame(height: 50)
                        .padding(.horizontal, 6)
                        .background(.white)
                    
                    Menu
                    {
                        Button {
                            restaurant.tags[0] = restaurant.tags[0] == "" ? "Vegetarian" : ""
                        } label: {
                            Text("Vegetarian")
                            Spacer()
                            Image(systemName: restaurant.tags[0] != "" ? "checkmark.circle.fill" : "")
                        }
                        
                        Button {
                            restaurant.tags[1] = restaurant.tags[1] == "" ? "Mexican" : ""
                        } label: {
                            Text("Mexican")
                            Spacer()
                            Image(systemName: restaurant.tags[1] != "" ? "checkmark.circle.fill" : "")
                        }
                        
                        Button {
                            restaurant.tags[2] = restaurant.tags[2] == "" ? "Organic" : ""
                        } label: {
                            Text("Organic")
                            Spacer()
                            Image(systemName: restaurant.tags[2] != "" ? "checkmark.circle.fill" : "")
                        }
                        
                        Button {
                            restaurant.tags[3] = restaurant.tags[3] == "" ? "Italian" : ""
                        } label: {
                            Text("Italian")
                            Spacer()
                            Image(systemName: restaurant.tags[3] != "" ? "checkmark.circle.fill" : "")
                        }
                        
                        Button {
                            restaurant.tags[4] = restaurant.tags[4] == "" ? "Thai" : ""
                        } label: {
                            Text("Thai")
                            Spacer()
                            Image(systemName: restaurant.tags[4] != "" ? "checkmark.circle.fill" : "")
                        }
                    } label: {
                        Text("Tags: \(restaurant.tags.joined(separator: " "))")
                        Spacer()
                        Image(systemName: "arrowtriangle.down.fill")
                    }
                    .frame(height: 50)
                    .padding(.horizontal, 6)
                    .background(.white)
                    
                }
                .padding(.horizontal,20)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationTitle("Restaurant Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showSheet) {
            MailView(result: $result, restaurant: restaurant)
        }
    }
}
