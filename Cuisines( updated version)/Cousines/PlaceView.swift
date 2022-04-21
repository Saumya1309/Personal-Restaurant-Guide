import SwiftUI
import GoogleMaps

// This view is for showing the location of the restaurant in google maps
struct PlaceView: View
{
    // Reference to the current restaurant
    @State var restaurant: Restaurant
    
    var body: some View
    {
        VStack
        {
            ZStack
            {
                // Current map
                MapView(place: $restaurant)
                
                // We use a geometry reader to correctly place the start route button as we
                // are using a ZStack so it's crucial to assign the position of the button based on the device
                // screen size
                GeometryReader { geometry in
                    // Loads the route view
                    NavigationLink(destination: RouteView(restaurant: restaurant), label: {
                        Text("Start")
                            .frame(width: 110, height: 50)
                            .foregroundColor(.white)
                            .background(Color("AccentColor"))
                            .cornerRadius(16)
                    })
                    .position(x: geometry.size.width-geometry.size.width/6, y: geometry.size.height-geometry.size.height/15)
                }
                
            }
            
            Spacer()
            
            HStack
            {
                VStack(alignment: .leading, spacing: 20)
                {
                    Text("Name:")
                    Text("Phone:")
                    Text("Address:")
                    Text("Rating:")
                    Text("Hours:")
                }
                .foregroundColor(.accentColor)
                
                VStack(alignment: .leading, spacing: 20)
                {
                    Text(restaurant.name)
                    Text(restaurant.phone)
                    Text(restaurant.address)
                    Text("\(restaurant.stars) of 5")
                    Text("Open till \(restaurant.openTime)")
                }
            }
            .padding()
        }
    }
}

struct MapView: UIViewRepresentable
{
    typealias UIViewType = GMSMapView
    
    @Binding var place: Restaurant
    
    func makeUIView(context: Context) -> GMSMapView
    {
        // Moves the camera to the restaurant position
        let camera = GMSCameraPosition.camera(withLatitude: place.position.latitude, longitude: place.position.longitude, zoom: 6)
        print(place.position)
        
        // We create the map and go to the camera location
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.delegate = context.coordinator
        
        return mapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context)
    {
        // Add the marker of the restaurant location
        context.coordinator.addMarker(mapView: uiView)
    }
    
    func makeCoordinator() -> Coordinator
    {
        return Coordinator(place)
    }
}

class Coordinator: NSObject
{
    private let place: Restaurant
    
    init(_ place: Restaurant)
    {
        self.place = place
    }
    
    func addMarker(mapView: GMSMapView)
    {
        // Asign the data from the restarant to the new marker
        let marker = GMSMarker()
        marker.position = place.position
        marker.title = place.name
        marker.snippet = place.address
        marker.map = mapView
    }
}

extension Coordinator: GMSMapViewDelegate
{
    // Executes once the map has loaded
    func mapViewSnapshotReady(_ mapView: GMSMapView)
    {
        // Animates the movement of the camera from zero to the restaurant location
        mapView.moveCamera(GMSCameraUpdate.setCamera(GMSCameraPosition.init(latitude: place.position.latitude, longitude: place.position.longitude, zoom: 15)))
    }
}

struct PlaceView_Previews: PreviewProvider
{
    static var previews: some View
    {
        PlaceView(restaurant: Restaurant(name: "Crazy taco",
                                         stars: 1,
                                         image: "placeholder",
                                         address: "Taco Bell, 10th Street, Great Bend",
                                         description: "Great tacos",
                                         phone: "12345",
                                         tags: ["","Mexican","Organic","",""],
                                         openTime: "09:30 PM",
                                         position: CLLocationCoordinate2D(latitude: 19.4509921, longitude: -99.1371576)))
    }
}
