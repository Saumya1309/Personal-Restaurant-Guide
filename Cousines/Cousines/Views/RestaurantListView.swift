//
//  RestaurantListView.swift
//  Cousines
//
//  Created by Axel Gonzalez on 31/03/22.
//

import SwiftUI
import GoogleMaps

struct RestaurantListView: View
{
    @State var restaurants: [Restaurant] = [
        Restaurant(name: "Crazy taco",
                   stars: 1,
                   image: "placeholder",
                   address: "Taco Bell, 10th Street, Great Bend",
                   description: "Great tacos",
                   phone: "12345",
                   tags: ["","Mexican","Organic","",""],
                   openTime: "10:00 PM",
                   position: CLLocationCoordinate2D(latitude: 19.5394097, longitude: -99.2209503)),
        Restaurant(name: "Le pizza",
                   stars: 5,
                   image: "placeholder",
                   address: "Kiowa Kitchen, East Barton County Road",
                   description: "They don't have pineapple pizza",
                   phone: "54321",
                   tags: ["Vegetarian","","Organic","Italian",""],
                   openTime: "12:00 AM",
                   position: CLLocationCoordinate2D(latitude: 19.3435109, longitude: -99.0700517)),
        Restaurant(name: "Awesome chocolate",
                   stars: 3,
                   image: "placeholder",
                   address: "Starbucks, West 4th Street",
                   description: "Chocolate is chocolate",
                   phone: "56789",
                   tags: ["","","Organic","",""],
                   openTime: "7:30 PM",
                   position: CLLocationCoordinate2D(latitude: 19.6129366, longitude: -99.0338059)),
        Restaurant(name: "Rammen express",
                   stars: 4,
                   image: "placeholder",
                   address: "Warehouse25sixty-five Kitchen + Bar",
                   description: "Clean place",
                   phone: "98765",
                   tags: ["Vegetarian","","","","Thai"],
                   openTime: "05:25 PM",
                   position: CLLocationCoordinate2D(latitude: 19.0786604, longitude: -98.2475948))]
    
    @State var searchText = ""
    
    var body: some View
    {
        ZStack
        {
            Color("BackgroundColor")
            ScrollView
            {
                HStack
                {
                    TextField("Search terms here", text: $searchText)
                }
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(6)
                .padding()
                
                ForEach((1...restaurants.count).filter({
                    
                    if !searchText.isEmpty
                    {
                        print(restaurants[$0-1].tags.contains(searchText))
                        
                        if restaurants[$0-1].name.contains(searchText) ||
                            restaurants[$0-1].tags.contains(where: { (key) -> Bool in
                                key.lowercased().contains(searchText.lowercased())
                            })
                        {
                            return true
                        }
                        else
                        {
                            return false
                        }
                    }
                    else
                    {
                        return true
                    }
                    
                }), id: \.self) {index in
                    NavigationLink(destination: RestaurantDetailsView(restaurant:  $restaurants[index-1]), label: {
                        RestaurantCell(restaurant: restaurants[index-1], index: index-1, restaurants: $restaurants)
                            .padding()
                    })
                }
            }
            .listStyle(SidebarListStyle())
        }
        .navigationTitle("List of restaurants")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                
                NavigationLink(destination: AboutUsView(), label: {
                    Text("About Us")
                        .foregroundColor(.accentColor)
                })
            }
        }
    }
}

struct RestaurantListView_Previews: PreviewProvider
{
    static var previews: some View
    {
        RestaurantListView()
    }
}

struct Restaurant
{
    var name: String
    var stars: Int
    var image: String
    var address: String
    var description: String
    var phone: String
    var tags: [String]
    var openTime: String
    var position: CLLocationCoordinate2D
}

struct RestaurantCell: View
{
    let restaurant: Restaurant
    let index: Int
    
    @Binding var restaurants: [Restaurant]
    
    var body: some View
    {
        ZStack
        {
            Color("White")
            
            VStack
            {
                VStack
                {
                    Image(restaurant.image)
                        .resizable()
                        .frame(width: 90, height: 90)
                }
                .frame(width: 370, height: 190)
                .background(Color("AccentColor"))
                
                HStack
                {
                    VStack(alignment: .leading)
                    {
                        Text(restaurant.name)
                            .font(.title2)
                        
                        Text("Rating: \(restaurant.stars)")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.bottom, 5)
                    
                    Spacer()
                    
                    Button {
                        restaurants.remove(at: index)
                    } label: {
                        Text("Remove")
                            .frame(width: 140, height: 35)
                            .foregroundColor(.white)
                            .background(Color("AccentColor"))
                            .cornerRadius(16)
                    }
                    .buttonStyle(PlainButtonStyle())
                }.padding(.horizontal, 5)
            }
        }
        .frame(height: 250)
    }
}
