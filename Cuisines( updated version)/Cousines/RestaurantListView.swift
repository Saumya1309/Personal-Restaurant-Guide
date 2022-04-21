import SwiftUI
import GoogleMaps

struct RestaurantListView: View
{
    // Pre populate the list so it's not empty
    @State var restaurants: [Restaurant] = [
        Restaurant(name: "Crazy taco",
                   stars: 1,
                   image: "CrazyTaco",
                   address: "Taco Bell, 10th Street, Great Bend",
                   description: "Great tacos",
                   phone: "12345",
                   tags: ["","Mexican","Organic","",""],
                   openTime: "10:00 PM",
                   position: CLLocationCoordinate2D(latitude: 19.5394097, longitude: -99.2209503)),
        Restaurant(name: "Le pizza",
                   stars: 5,
                   image: "LePizza",
                   address: "Kiowa Kitchen, East Barton County Road",
                   description: "They don't have pineapple pizza",
                   phone: "54321",
                   tags: ["Vegetarian","","Organic","Italian",""],
                   openTime: "12:00 AM",
                   position: CLLocationCoordinate2D(latitude: 19.3435109, longitude: -99.0700517)),
        Restaurant(name: "Awesome chocolate",
                   stars: 3,
                   image: "Chocolate",
                   address: "Starbucks, West 4th Street",
                   description: "Chocolate is chocolate",
                   phone: "56789",
                   tags: ["","","Organic","",""],
                   openTime: "7:30 PM",
                   position: CLLocationCoordinate2D(latitude: 19.6129366, longitude: -99.0338059)),
        Restaurant(name: "Ramen express",
                   stars: 4,
                   image: "Ramen",
                   address: "Warehouse25sixty-five Kitchen + Bar",
                   description: "Clean place",
                   phone: "98765",
                   tags: ["Vegetarian","","","","Thai"],
                   openTime: "05:25 PM",
                   position: CLLocationCoordinate2D(latitude: 19.0786604, longitude: -98.2475948))]
    
    // Variable to store the text of what's the user looking for
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
                    TextField("Search", text: $searchText)
                }
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(6)
                .padding()
                
                // Foreach element in the restaurant list
                ForEach((1...restaurants.count).filter({
                    // This part of the code if the filter in case of the user is looking for a specific name
                    // or tag
                    
                    // T
                    if !searchText.isEmpty
                    {
                        // If the current restaurant name or tags contains the search terms
                        // we return true, meaning that it'll show up in the list
                        if restaurants[$0-1].name.contains(searchText) ||
                            restaurants[$0-1].tags.contains(where: { (key) -> Bool in // As the tag is an string array, we look in every element
                                key.lowercased().contains(searchText.lowercased())    // of the array
                            })
                        {
                            return true
                        }
                        else
                        {
                            return false
                        }
                    }
                    else // If the search terms are empty then we return true for every item, meaning all of them
                    {    // will show up in the list
                        return true
                    }
                    
                }), id: \.self) {index in
                    // Navigation link to the restaurant details view, passing the current index-1
                    NavigationLink(destination: RestaurantDetailsView(restaurant:  $restaurants[index-1]), label: {
                        RestaurantCell(restaurant: restaurants[index-1], index: index-1, restaurantList: $restaurants)
                            .padding()
                    })
                }
            }
            .listStyle(SidebarListStyle())
        }
        .navigationTitle("List of restaurants")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // Add the About Us text in the toolbar
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AboutUsView(), label: {
                    Text("About Us")
                        .foregroundColor(.accentColor)
                })
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddRestaurantView(restaurantList: $restaurants), label: {
                    Text("Add")
                        .foregroundColor(.accentColor)
                })
            }
        }
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
    
    // Reference to the restaurant list
    @Binding var restaurantList: [Restaurant]
    
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
                        .frame(width: 395, height: 190)
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
                    
                    // Removes the current restaurant from the list
                    Button {
                        restaurantList.remove(at: index)
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

struct RestaurantListView_Previews: PreviewProvider
{
    static var previews: some View
    {
        RestaurantListView()
    }
}
