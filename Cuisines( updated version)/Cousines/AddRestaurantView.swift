import SwiftUI
import MapKit

struct AddRestaurantView: View {
    @State var name: String = ""
    @State var address: String = ""
    @State var description: String = ""
    @State var phone: String = ""
    @State var city: String = ""
    @State var openTime: String = ""
    @State var stars: Int = 1
    @State var tags: [String] = ["","","","",""]
    
    @State var location = Array<Location>()
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var restaurantList: [Restaurant]
                
    var body: some View
    {
        ZStack
        {
            Color("BackgroundColor")
            
            VStack(spacing: 30)
            {
                VStack
                {
                    Image("Placeholder_Restaurant")
                        .resizable()
                        .frame(width: 400, height: 200)
                }
                .frame(width: 400, height: 200)
                
                
                // We crate the stars as buttons, and depending on the number of stars of the current restaurant
                // we fill or not the stars with yellow
                HStack(spacing: 35)
                {
                    Button {
                        stars = 1
                    } label: {
                        Image(systemName:  "star.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.yellow)
                    }
                    Button {
                        stars = 2
                    } label: {
                        Image(systemName: stars >= 2 ? "star.fill" : "star")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(stars >= 2 ? .yellow : .accentColor)
                    }
                    Button {
                        stars = 3
                    } label: {
                        Image(systemName: stars >= 3 ? "star.fill" : "star")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(stars >= 3 ? .yellow : .accentColor)
                    }
                    Button {
                        stars = 4
                    } label: {
                        Image(systemName: stars >= 4 ? "star.fill" : "star")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(stars >= 4 ? .yellow : .accentColor)
                    }
                    Button {
                        stars = 5
                    } label: {
                        Image(systemName: stars >= 5 ? "star.fill" : "star")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(stars >= 5 ? .yellow : .accentColor)
                    }
                }
                                
                VStack(alignment: .leading)
                {
                    TextField("Restaurant Name", text: $name)
                        .frame(height: 50)
                        .padding(.horizontal, 6)
                        .background(.white)
                    
                    TextField("Address", text: $address)
                        .frame(height: 50)
                        .padding(.horizontal, 6)
                        .background(.white)
                    
                    TextField("City", text: $city)
                        .frame(height: 50)
                        .padding(.horizontal, 6)
                        .background(.white)
                    
                    TextField("Description", text: $description)
                        .frame(height: 100)
                        .padding(.horizontal, 6)
                        .background(.white)
                    
                    TextField("Phone number", text: $phone)
                        .frame(height: 50)
                        .padding(.horizontal, 6)
                        .background(.white)
                                    
                    TextField("Open time", text: $openTime)
                        .frame(height: 50)
                        .padding(.horizontal, 6)
                        .background(.white)
                            
                    // Menu to select the tags
                    Menu
                    {
                        // Depending on which tag we selected we assign the information to the array
                        Button {
                            tags[0] = tags[0] == "" ? "Vegetarian" : ""
                        } label: {
                            Text("Vegetarian")
                            Spacer()
                            Image(systemName: tags[0] != "" ? "checkmark.circle.fill" : "")
                        }
                        
                        Button {
                            tags[1] = tags[1] == "" ? "Mexican" : ""
                        } label: {
                            Text("Mexican")
                            Spacer()
                            Image(systemName: tags[1] != "" ? "checkmark.circle.fill" : "")
                        }
                        
                        Button {
                            tags[2] = tags[2] == "" ? "Organic" : ""
                        } label: {
                            Text("Organic")
                            Spacer()
                            Image(systemName: tags[2] != "" ? "checkmark.circle.fill" : "")
                        }
                        
                        Button {
                            tags[3] = tags[3] == "" ? "Italian" : ""
                        } label: {
                            Text("Italian")
                            Spacer()
                            Image(systemName: tags[3] != "" ? "checkmark.circle.fill" : "")
                        }
                        
                        Button {
                            tags[4] = tags[4] == "" ? "Thai" : ""
                        } label: {
                            Text("Thai")
                            Spacer()
                            Image(systemName: tags[4] != "" ? "checkmark.circle.fill" : "")
                        }
                    } label: {
                        Text("Tags: \(tags.joined(separator: " "))")
                        Spacer()
                        Image(systemName: "arrowtriangle.down.fill")
                    }
                    .frame(height: 50)
                    .padding(.horizontal, 6)
                    .background(.white)
                    
                    Button {
                                                
                        let group = DispatchGroup()
                        group.enter()

                            DispatchQueue.main.async {
                                SearchAddress(group: group)
                            }

                            group.notify(queue: .main) {
                                restaurantList.append(Restaurant(name: name, stars: stars, image: "Placeholder_Restaurant", address: "\(address), \(city)", description: description, phone: phone, tags: tags, openTime: openTime, position: CLLocationCoordinate2D(latitude: location[0].latitude, longitude: location[0].longitude)))
                                dismiss()
                            }
                        
                       
                    } label: {
                        Text("Add")
                            .frame(width: 410, height: 60)
                            .foregroundColor(.white)
                            .background(Color("AccentColor"))
                            .cornerRadius(16)
                            .font(.system(size: 25))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                }
                .padding(.horizontal,20)
            }
        }
        .navigationTitle("Add Restaurant")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func SearchAddress(group: DispatchGroup) -> Void
    {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = "\(address), \(city)"
        let search = MKLocalSearch(request: searchRequest)
                
        search.start { response, error in
            guard let response = response else
            {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            

                location.append(Location(id: UUID(), latitude: response.mapItems[0].placemark.coordinate.latitude, longitude: response.mapItems[0].placemark.coordinate.longitude))
                print(location[0])

            group.leave()
        }
    }
    
    struct Location: Identifiable
    {
        let id: UUID
        var latitude: Double
        var longitude: Double
    }

}
